import 'dart:io';
import 'dart:ui';
import 'package:excel/excel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:docview/core/utils/spreadsheet_helpers.dart';
import 'package:docview/data/models/spreadsheet_data.dart';
import 'package:docview/data/services/spreadsheet_parser_service.dart';

void main() {
  group('Spreadsheet Helpers Tests', () {
    test('Column index to letter conversions both ways', () {
      expect(columnIndexToLetter(0), equals('A'));
      expect(columnIndexToLetter(25), equals('Z'));
      expect(columnIndexToLetter(26), equals('AA'));
      expect(columnIndexToLetter(27), equals('AB'));
      expect(columnIndexToLetter(51), equals('AZ'));
      expect(columnIndexToLetter(52), equals('BA'));
      expect(columnIndexToLetter(701), equals('ZZ'));

      expect(letterToColumnIndex('A'), equals(0));
      expect(letterToColumnIndex('z'), equals(25));
      expect(letterToColumnIndex('AA'), equals(26));
      expect(letterToColumnIndex('ab'), equals(27));
      expect(letterToColumnIndex('AZ'), equals(51));
      expect(letterToColumnIndex('BA'), equals(52));
      expect(letterToColumnIndex('ZZ'), equals(701));
    });

    test('Cell coordinate and A1 reference conversions', () {
      expect(cellCoordinateToA1(0, 0), equals('A1'));
      expect(cellCoordinateToA1(1, 2), equals('C2'));
      expect(cellCoordinateToA1(99, 25), equals('Z100'));

      final parsed = parseA1Reference('C2');
      expect(parsed, isNotNull);
      expect(parsed!.row, equals(1));
      expect(parsed.column, equals(2));

      expect(parseA1Reference('invalid'), isNull);
      expect(parseA1Reference(''), isNull);
    });

    test('Merged cell range parsing and containment', () {
      final range = parseMergedRange('B2:D4');
      expect(range, isNotNull);
      expect(range!.startRow, equals(1));
      expect(range.startColumn, equals(1));
      expect(range.rowSpan, equals(3));
      expect(range.columnSpan, equals(3));

      expect(range.contains(1, 1), isTrue); // Origin
      expect(range.contains(2, 2), isTrue); // Middle
      expect(range.contains(3, 3), isTrue); // Bottom-right corner
      expect(range.contains(4, 4), isFalse); // Outside
      expect(range.contains(0, 0), isFalse); // Outside
      expect(range.isOrigin(1, 1), isTrue);
      expect(range.isOrigin(1, 2), isFalse);
    });

    test('SpreadsheetSelection model logic', () {
      const none = SpreadsheetSelection.none();
      expect(none.hasSelection, isFalse);
      expect(none.isCellSelected(0, 0), isFalse);

      const cell = SpreadsheetSelection.cell(2, 3);
      expect(cell.hasSelection, isTrue);
      expect(cell.isCellSelected(2, 3), isTrue);
      expect(cell.isCellSelected(2, 4), isFalse);
      expect(cell.isRowHeaderSelected(2), isTrue);
      expect(cell.isColumnHeaderSelected(3), isTrue);
      expect(cell.isRowHeaderSelected(0), isFalse);

      const row = SpreadsheetSelection.row(5);
      expect(row.hasSelection, isTrue);
      expect(row.isEntireRow, isTrue);
      expect(row.isCellSelected(5, 0), isTrue);
      expect(row.isCellSelected(5, 99), isTrue);
      expect(row.isCellSelected(4, 0), isFalse);
      expect(row.isRowHeaderSelected(5), isTrue);

      const col = SpreadsheetSelection.column(4);
      expect(col.hasSelection, isTrue);
      expect(col.isEntireColumn, isTrue);
      expect(col.isCellSelected(0, 4), isTrue);
      expect(col.isCellSelected(100, 4), isTrue);
      expect(col.isCellSelected(0, 3), isFalse);
      expect(col.isColumnHeaderSelected(4), isTrue);

      const all = SpreadsheetSelection.all();
      expect(all.hasSelection, isTrue);
      expect(all.isEntireSheet, isTrue);
      expect(all.isCellSelected(10, 10), isTrue);
      expect(all.isRowHeaderSelected(10), isTrue);
      expect(all.isColumnHeaderSelected(10), isTrue);
    });

    test('Cell display text formatting with active locale', () {
      const numCell = SpreadsheetCell(
        rawValue: '1234567.89',
        type: CellDataType.number,
      );
      final formattedNum = formatCellDisplayValue(numCell, const Locale('en', 'US'));
      expect(formattedNum, equals('1,234,567.89'));

      const dateCell = SpreadsheetCell(
        rawValue: '2026-11-19',
        type: CellDataType.date,
      );
      final formattedDate = formatCellDisplayValue(dateCell, const Locale('en', 'US'));
      expect(formattedDate, contains('2026'));

      const formulaCell = SpreadsheetCell(
        rawValue: '=SUM(A1:B1)',
        formula: '=SUM(A1:B1)',
        type: CellDataType.formula,
      );
      expect(formatCellDisplayValue(formulaCell, const Locale('en')), equals('=SUM(A1:B1)'));
    });
  });

  group('Spreadsheet Parser Service Tests', () {
    const parser = SpreadsheetParserService();
    late Directory tempDir;

    setUp(() {
      tempDir = Directory.systemTemp.createTempSync('doc_view_test_');
    });

    tearDown(() {
      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
      }
    });

    test('Parses generated XLSX with formulas, formats, and merged ranges', () async {
      final excel = Excel.createExcel();
      final sheet = excel[excel.getDefaultSheet()!];

      // Merge A1:B2
      sheet.merge(CellIndex.indexByString('A1'), CellIndex.indexByString('B2'), customValue: TextCellValue('Quarterly Revenue'));

      // Formula in C1
      sheet.cell(CellIndex.indexByString('C1')).value = FormulaCellValue('=SUM(D1:E1)');

      // Numbers & dates
      sheet.cell(CellIndex.indexByString('D1')).value = IntCellValue(1500);
      sheet.cell(CellIndex.indexByString('E1')).value = DoubleCellValue(2500.50);
      sheet.cell(CellIndex.indexByString('A3')).value = DateCellValue(year: 2026, month: 11, day: 19);
      sheet.cell(CellIndex.indexByString('A4')).value = BoolCellValue(true);

      // Custom column width
      sheet.setColumnWidth(2, 35.0);

      final bytes = excel.encode()!;
      final testFile = File('${tempDir.path}/test_report.xlsx');
      testFile.writeAsBytesSync(bytes);

      final workbook = await parser.parseWorkbook(filePath: testFile.path);

      expect(workbook.fileName, equals('test_report.xlsx'));
      expect(workbook.sheetNames, isNotEmpty);
      expect(workbook.activeSheet.rowCount, greaterThanOrEqualTo(4));
      expect(workbook.activeSheet.columnCount, greaterThanOrEqualTo(5));

      // Merged range
      expect(workbook.activeSheet.mergedRanges, isNotEmpty);
      final range = workbook.activeSheet.mergedRanges.first;
      expect(range.startRow, equals(0));
      expect(range.startColumn, equals(0));
      expect(range.rowSpan, equals(2));
      expect(range.columnSpan, equals(2));

      // Formula cell
      final formulaCell = workbook.activeSheet.cellAt(0, 2);
      expect(formulaCell, isNotNull);
      expect(formulaCell!.type, equals(CellDataType.formula));
      expect(formulaCell.formula, equals('=SUM(D1:E1)'));

      // Numbers
      final numCell = workbook.activeSheet.cellAt(0, 3);
      expect(numCell, isNotNull);
      expect(numCell!.type, equals(CellDataType.number));
      expect(numCell.rawValue, equals('1500'));

      // Date
      final dateCell = workbook.activeSheet.cellAt(2, 0);
      expect(dateCell, isNotNull);
      expect(dateCell!.type, equals(CellDataType.date));

      // Boolean
      final boolCell = workbook.activeSheet.cellAt(3, 0);
      expect(boolCell, isNotNull);
      expect(boolCell!.type, equals(CellDataType.boolean));
      expect(boolCell.rawValue, equals('TRUE'));
    });

    test('Parses CSV with comma and semicolon delimiters', () async {
      // Comma CSV
      final csvFile = File('${tempDir.path}/data_comma.csv');
      csvFile.writeAsStringSync('Product,Price,Quantity\nApple,1.25,10\nBanana,0.75,25\nOrange,2.00,15');

      final commaWorkbook = await parser.parseWorkbook(filePath: csvFile.path);
      expect(commaWorkbook.activeSheet.rowCount, equals(4));
      expect(commaWorkbook.activeSheet.columnCount, equals(3));
      expect(commaWorkbook.activeSheet.cellAt(0, 0)?.rawValue, equals('Product'));
      expect(commaWorkbook.activeSheet.cellAt(1, 1)?.rawValue, equals('1.25'));

      // Semicolon CSV (European style)
      final semiCsvFile = File('${tempDir.path}/data_semi.csv');
      semiCsvFile.writeAsStringSync('Name;Role;Department\nAlice;Engineer;Platform\nBob;Designer;Design');

      final semiWorkbook = await parser.parseWorkbook(filePath: semiCsvFile.path);
      expect(semiWorkbook.activeSheet.rowCount, equals(3));
      expect(semiWorkbook.activeSheet.columnCount, equals(3));
      expect(semiWorkbook.activeSheet.cellAt(0, 0)?.rawValue, equals('Name'));
      expect(semiWorkbook.activeSheet.cellAt(0, 1)?.rawValue, equals('Role'));
      expect(semiWorkbook.activeSheet.cellAt(1, 1)?.rawValue, equals('Engineer'));
    });

    test('Parses TSV with tab delimiter', () async {
      final tsvFile = File('${tempDir.path}/metrics.tsv');
      tsvFile.writeAsStringSync('Metric\tValue\tTarget\nCPU\t45\t80\nMemory\t62\t75');

      final tsvWorkbook = await parser.parseWorkbook(filePath: tsvFile.path);
      expect(tsvWorkbook.activeSheet.rowCount, equals(3));
      expect(tsvWorkbook.activeSheet.columnCount, equals(3));
      expect(tsvWorkbook.activeSheet.cellAt(0, 1)?.rawValue, equals('Value'));
      expect(tsvWorkbook.activeSheet.cellAt(1, 1)?.rawValue, equals('45'));
    });

    test('Handles password-protected OOXML file with typed exception', () async {
      // OLE2 header mock
      final encFile = File('${tempDir.path}/locked.xlsx');
      encFile.writeAsBytesSync([0xD0, 0xCF, 0x11, 0xE0, 0xA1, 0xB1, 0x1A, 0xE1, 0x00, 0x00]);

      expect(
        () => parser.parseWorkbook(filePath: encFile.path),
        throwsA(isA<SpreadsheetPasswordProtectedException>()),
      );
    });

    test('Handles corrupted file with typed exception', () async {
      final corruptFile = File('${tempDir.path}/corrupt.xlsx');
      corruptFile.writeAsBytesSync([0x00, 0x01, 0x02, 0x03, 0x04]);

      expect(
        () => parser.parseWorkbook(filePath: corruptFile.path),
        throwsA(isA<SpreadsheetCorruptException>()),
      );
    });

    test('Handles empty sheet cleanly', () async {
      final excel = Excel.createExcel();
      // Keep sheet empty
      final bytes = excel.encode()!;
      final emptyFile = File('${tempDir.path}/empty.xlsx');
      emptyFile.writeAsBytesSync(bytes);

      final workbook = await parser.parseWorkbook(filePath: emptyFile.path);
      expect(workbook.activeSheet.rowCount, equals(0));
      expect(workbook.activeSheet.columnCount, equals(0));
      expect(workbook.activeSheet.cells, isEmpty);
    });
  });
}
