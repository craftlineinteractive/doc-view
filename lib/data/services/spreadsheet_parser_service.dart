import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:csv/csv.dart';
import 'package:excel/excel.dart';
import '../../core/utils/spreadsheet_helpers.dart';
import '../models/spreadsheet_data.dart';

/// Service responsible for parsing XLSX, XLSM, CSV, and TSV spreadsheets in background isolates.
class SpreadsheetParserService {
  const SpreadsheetParserService();

  static const SpreadsheetParserService instance = SpreadsheetParserService();

  /// Maximum file size supported for parsing (25 MB).
  static const int maxFileSizeBytes = 25 * 1024 * 1024;

  /// Hard cap on rendered rows per sheet to prevent memory exhaustion.
  static const int maxRowsPerSheet = 20000;

  /// Hard cap on rendered columns per sheet.
  static const int maxColsPerSheet = 100;

  /// Timeout duration for workbook parsing.
  static const Duration parseTimeout = Duration(seconds: 20);

  /// Parses a spreadsheet file into [WorkbookData].
  Future<WorkbookData> parseWorkbook({
    required String filePath,
    int sheetIndex = 0,
  }) async {
    final file = File(filePath);
    if (!await file.exists()) {
      throw const SpreadsheetCorruptException('File not found on disk');
    }

    final fileLength = await file.length();
    if (fileLength > maxFileSizeBytes) {
      throw const SpreadsheetTooLargeException();
    }

    final fileName = file.uri.pathSegments.isNotEmpty
        ? file.uri.pathSegments.last
        : 'Spreadsheet';

    return await Isolate.run<WorkbookData>(() {
      return _parseWorker(
        filePath: filePath,
        fileName: fileName,
        requestedSheetIndex: sheetIndex,
        fileSizeBytes: fileLength,
      );
    }).timeout(
      parseTimeout,
      onTimeout: () => throw const SpreadsheetTimeoutException(),
    );
  }
}

/// Top-level isolate worker for parsing.
WorkbookData _parseWorker({
  required String filePath,
  required String fileName,
  required int requestedSheetIndex,
  required int fileSizeBytes,
}) {
  final lastDot = filePath.lastIndexOf('.');
  final ext = lastDot != -1
      ? filePath.substring(lastDot + 1).toLowerCase()
      : '';

  if (ext == 'csv' || ext == 'tsv') {
    return _parseDelimitedWorker(
      filePath: filePath,
      fileName: fileName,
      fileSizeBytes: fileSizeBytes,
      isTsv: ext == 'tsv',
    );
  } else if (ext == 'xlsx' || ext == 'xlsm') {
    return _parseExcelWorker(
      filePath: filePath,
      fileName: fileName,
      fileSizeBytes: fileSizeBytes,
      requestedSheetIndex: requestedSheetIndex,
    );
  } else {
    throw const SpreadsheetUnsupportedException();
  }
}

/// Worker for parsing XLSX and XLSM files.
WorkbookData _parseExcelWorker({
  required String filePath,
  required String fileName,
  required int fileSizeBytes,
  required int requestedSheetIndex,
}) {
  final file = File(filePath);
  final bytes = file.readAsBytesSync();

  // Inspect first 8 bytes for OLE2 Compound Document Header (encrypted OOXML package or legacy XLS)
  if (bytes.length >= 8) {
    if (bytes[0] == 0xD0 &&
        bytes[1] == 0xCF &&
        bytes[2] == 0x11 &&
        bytes[3] == 0xE0 &&
        bytes[4] == 0xA1 &&
        bytes[5] == 0xB1 &&
        bytes[6] == 0x1A &&
        bytes[7] == 0xE1) {
      throw const SpreadsheetPasswordProtectedException();
    }
  }

  Excel excel;
  try {
    excel = Excel.decodeBytes(bytes);
  } catch (e) {
    final errStr = e.toString().toLowerCase();
    if (errStr.contains('password') || errStr.contains('encrypted')) {
      throw const SpreadsheetPasswordProtectedException();
    }
    throw SpreadsheetCorruptException('Failed to decode XLSX: $e');
  }

  final sheetNames = excel.tables.keys.toList();
  if (sheetNames.isEmpty) {
    // Empty workbook
    return WorkbookData(
      fileName: fileName,
      sheetNames: const ['Sheet1'],
      activeSheetIndex: 0,
      activeSheet: const SheetData(
        name: 'Sheet1',
        rowCount: 0,
        columnCount: 0,
        cells: {},
      ),
      fileSizeBytes: fileSizeBytes,
    );
  }

  final clampedIndex = requestedSheetIndex.clamp(0, sheetNames.length - 1);
  final activeSheetName = sheetNames[clampedIndex];
  final sheet = excel.tables[activeSheetName]!;

  final totalRows = sheet.maxRows;
  final totalCols = sheet.maxColumns;

  final cappedRows = totalRows > SpreadsheetParserService.maxRowsPerSheet
      ? SpreadsheetParserService.maxRowsPerSheet
      : totalRows;
  final cappedCols = totalCols > SpreadsheetParserService.maxColsPerSheet
      ? SpreadsheetParserService.maxColsPerSheet
      : totalCols;
  final isTruncated = totalRows > SpreadsheetParserService.maxRowsPerSheet ||
      totalCols > SpreadsheetParserService.maxColsPerSheet;

  // Merged cell ranges
  final mergedRanges = <MergedCellRange>[];
  for (final spanStr in sheet.spannedItems) {
    final parsed = parseMergedRange(spanStr);
    if (parsed != null &&
        parsed.startRow < cappedRows &&
        parsed.startColumn < cappedCols) {
      mergedRanges.add(parsed);
    }
  }

  // Column widths and row heights
  final columnWidths = <int, double>{};
  final rawColWidths = sheet.getColumnWidths;
  for (final entry in rawColWidths.entries) {
    if (entry.key < cappedCols) {
      columnWidths[entry.key] = entry.value;
    }
  }

  final rowHeights = <int, double>{};
  final rawRowHeights = sheet.getRowHeights;
  for (final entry in rawRowHeights.entries) {
    if (entry.key < cappedRows) {
      rowHeights[entry.key] = entry.value;
    }
  }

  // Sparse cell store
  final cells = <CellCoordinate, SpreadsheetCell>{};
  final sheetRows = sheet.rows;

  for (var r = 0; r < cappedRows && r < sheetRows.length; r++) {
    final rowList = sheetRows[r];
    for (var c = 0; c < cappedCols && c < rowList.length; c++) {
      final cellData = rowList[c];
      if (cellData == null || cellData.value == null) continue;

      final val = cellData.value!;
      CellDataType type = CellDataType.text;
      String? formulaText;
      String rawString = val.toString();

      if (val is FormulaCellValue) {
        type = CellDataType.formula;
        formulaText = val.formula;
        rawString = val.formula;
      } else if (val is IntCellValue) {
        type = CellDataType.number;
        rawString = val.value.toString();
      } else if (val is DoubleCellValue) {
        type = CellDataType.number;
        rawString = val.value.toString();
      } else if (val is DateCellValue) {
        type = CellDataType.date;
        rawString = '${val.year.toString().padLeft(4, '0')}-${val.month.toString().padLeft(2, '0')}-${val.day.toString().padLeft(2, '0')}';
      } else if (val is TimeCellValue) {
        type = CellDataType.time;
        rawString = '${val.hour.toString().padLeft(2, '0')}:${val.minute.toString().padLeft(2, '0')}';
      } else if (val is BoolCellValue) {
        type = CellDataType.boolean;
        rawString = val.value ? 'TRUE' : 'FALSE';
      } else if (val is TextCellValue) {
        type = CellDataType.text;
        rawString = val.value.text ?? val.toString();
      }

      // Cell style extraction
      CellStyleData? styleData;
      final cs = cellData.cellStyle;
      if (cs != null) {
        Color? fontColor;
        Color? bgColor;

        final fontHex = cs.fontColor.colorHex;
        if (fontHex.isNotEmpty && fontHex.toLowerCase() != 'none') {
          final hex = fontHex.replaceAll('#', '');
          final intVal = int.tryParse(hex, radix: 16);
          if (intVal != null) {
            fontColor = Color(hex.length <= 6 ? 0xFF000000 | intVal : intVal);
          }
        }

        final bgHex = cs.backgroundColor.colorHex;
        if (bgHex.isNotEmpty && bgHex.toLowerCase() != 'none') {
          final hex = bgHex.replaceAll('#', '');
          final intVal = int.tryParse(hex, radix: 16);
          if (intVal != null) {
            bgColor = Color(hex.length <= 6 ? 0xFF000000 | intVal : intVal);
          }
        }

        TextAlign align = TextAlign.start;
        if (cs.horizontalAlignment == HorizontalAlign.Center) {
          align = TextAlign.center;
        } else if (cs.horizontalAlignment == HorizontalAlign.Right) {
          align = TextAlign.end;
        } else if (type == CellDataType.number) {
          align = TextAlign.end;
        } else if (type == CellDataType.boolean) {
          align = TextAlign.center;
        }

        styleData = CellStyleData(
          isBold: cs.isBold,
          isItalic: cs.isItalic,
          fontColor: fontColor,
          backgroundColor: bgColor,
          fontSize: cs.fontSize,
          numberFormat: cs.numberFormat.formatCode,
          textAlign: align,
        );
      } else {
        // Default alignments based on type
        if (type == CellDataType.number) {
          styleData = const CellStyleData(textAlign: TextAlign.end);
        } else if (type == CellDataType.boolean) {
          styleData = const CellStyleData(textAlign: TextAlign.center);
        }
      }

      cells[CellCoordinate(r, c)] = SpreadsheetCell(
        rawValue: rawString,
        formula: formulaText,
        type: type,
        style: styleData,
      );
    }
  }

  final sheetData = SheetData(
    name: activeSheetName,
    rowCount: cappedRows,
    columnCount: cappedCols,
    cells: cells,
    columnWidths: columnWidths,
    rowHeights: rowHeights,
    mergedRanges: mergedRanges,
    isTruncated: isTruncated,
    totalUncappedRows: totalRows,
    totalUncappedCols: totalCols,
  );

  return WorkbookData(
    fileName: fileName,
    sheetNames: sheetNames,
    activeSheetIndex: clampedIndex,
    activeSheet: sheetData,
    isTruncated: isTruncated,
    fileSizeBytes: fileSizeBytes,
  );
}

/// Worker for parsing CSV and TSV files.
WorkbookData _parseDelimitedWorker({
  required String filePath,
  required String fileName,
  required int fileSizeBytes,
  required bool isTsv,
}) {
  final file = File(filePath);
  final bytes = file.readAsBytesSync();

  String text;
  try {
    text = utf8.decode(bytes);
  } catch (_) {
    text = latin1.decode(bytes);
  }

  String delimiter = isTsv ? '\t' : ',';
  if (!isTsv) {
    // Detect ';' if the first line has more ';' than ','
    final firstNewline = text.indexOf('\n');
    final firstLine = firstNewline != -1 ? text.substring(0, firstNewline) : text;
    final semicolonCount = ';'.allMatches(firstLine).length;
    final commaCount = ','.allMatches(firstLine).length;
    if (semicolonCount > commaCount) {
      delimiter = ';';
    }
  }

  final converter = CsvToListConverter(
    fieldDelimiter: delimiter,
    eol: '\n',
    shouldParseNumbers: true,
  );

  final List<List<dynamic>> rows;
  try {
    rows = converter.convert(text);
  } catch (e) {
    throw SpreadsheetCorruptException('Failed to parse delimited file: $e');
  }

  final totalRows = rows.length;
  var totalCols = 0;
  for (final r in rows) {
    if (r.length > totalCols) totalCols = r.length;
  }

  final cappedRows = totalRows > SpreadsheetParserService.maxRowsPerSheet
      ? SpreadsheetParserService.maxRowsPerSheet
      : totalRows;
  final cappedCols = totalCols > SpreadsheetParserService.maxColsPerSheet
      ? SpreadsheetParserService.maxColsPerSheet
      : totalCols;
  final isTruncated = totalRows > SpreadsheetParserService.maxRowsPerSheet ||
      totalCols > SpreadsheetParserService.maxColsPerSheet;

  final cells = <CellCoordinate, SpreadsheetCell>{};
  for (var r = 0; r < cappedRows && r < rows.length; r++) {
    final rowList = rows[r];
    for (var c = 0; c < cappedCols && c < rowList.length; c++) {
      final val = rowList[c];
      if (val == null) continue;
      final rawStr = val.toString().trim();
      if (rawStr.isEmpty) continue;

      CellDataType type = CellDataType.text;
      if (val is num) {
        type = CellDataType.number;
      } else if (val is bool) {
        type = CellDataType.boolean;
      } else if (num.tryParse(rawStr) != null) {
        type = CellDataType.number;
      }

      final align = type == CellDataType.number
          ? TextAlign.end
          : (type == CellDataType.boolean ? TextAlign.center : TextAlign.start);

      cells[CellCoordinate(r, c)] = SpreadsheetCell(
        rawValue: rawStr,
        type: type,
        style: CellStyleData(textAlign: align),
      );
    }
  }

  final cleanSheetName = fileName.contains('.')
      ? fileName.substring(0, fileName.lastIndexOf('.'))
      : fileName;

  final sheetData = SheetData(
    name: cleanSheetName,
    rowCount: cappedRows,
    columnCount: cappedCols,
    cells: cells,
    isTruncated: isTruncated,
    totalUncappedRows: totalRows,
    totalUncappedCols: totalCols,
  );

  return WorkbookData(
    fileName: fileName,
    sheetNames: [cleanSheetName],
    activeSheetIndex: 0,
    activeSheet: sheetData,
    isTruncated: isTruncated,
    fileSizeBytes: fileSizeBytes,
  );
}
