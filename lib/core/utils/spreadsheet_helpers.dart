import 'dart:ui';
import 'package:intl/intl.dart';
import '../../data/models/spreadsheet_data.dart';

/// Converts a zero-based column index to an Excel column letter (e.g. 0 -> 'A', 25 -> 'Z', 26 -> 'AA').
String columnIndexToLetter(int column) {
  if (column < 0) return '';
  var col = column + 1;
  var letter = '';
  while (col > 0) {
    final rem = (col - 1) % 26;
    letter = String.fromCharCode(65 + rem) + letter;
    col = (col - 1) ~/ 26;
  }
  return letter;
}

/// Converts an Excel column letter to a zero-based column index (e.g. 'A' -> 0, 'Z' -> 25, 'AA' -> 26).
int letterToColumnIndex(String letter) {
  final upper = letter.toUpperCase().trim();
  var result = 0;
  for (var i = 0; i < upper.length; i++) {
    final code = upper.codeUnitAt(i);
    if (code < 65 || code > 90) return 0;
    result = result * 26 + (code - 64);
  }
  return result - 1;
}

/// Converts zero-based (row, column) to Excel A1 reference (e.g. row 1, col 2 -> 'C2').
String cellCoordinateToA1(int row, int column) {
  final letter = columnIndexToLetter(column);
  return '$letter${row + 1}';
}

/// Parses an Excel A1 reference into (row, column) zero-based coordinate.
CellCoordinate? parseA1Reference(String ref) {
  final trimmed = ref.trim().toUpperCase();
  final match = RegExp(r'^([A-Z]+)(\d+)$').firstMatch(trimmed);
  if (match == null) return null;
  final colStr = match.group(1)!;
  final rowStr = match.group(2)!;
  final col = letterToColumnIndex(colStr);
  final row = int.tryParse(rowStr);
  if (row == null || row < 1) return null;
  return CellCoordinate(row - 1, col);
}

/// Parses an Excel range string like 'A1:B2' into a [MergedCellRange].
MergedCellRange? parseMergedRange(String rangeStr) {
  final parts = rangeStr.split(':');
  if (parts.length != 2) return null;
  final start = parseA1Reference(parts[0]);
  final end = parseA1Reference(parts[1]);
  if (start == null || end == null) return null;

  final minRow = start.row < end.row ? start.row : end.row;
  final maxRow = start.row > end.row ? start.row : end.row;
  final minCol = start.column < end.column ? start.column : end.column;
  final maxCol = start.column > end.column ? start.column : end.column;

  return MergedCellRange(
    startRow: minRow,
    startColumn: minCol,
    rowSpan: maxRow - minRow + 1,
    columnSpan: maxCol - minCol + 1,
  );
}

/// Formats a [SpreadsheetCell]'s raw value according to its type and the current locale.
String formatCellDisplayValue(SpreadsheetCell cell, Locale locale) {
  final raw = cell.rawValue;
  if (raw.isEmpty) return '';

  switch (cell.type) {
    case CellDataType.number:
      final numValue = num.tryParse(raw);
      if (numValue != null) {
        // Standard formatted number based on current locale
        try {
          return NumberFormat.decimalPattern(locale.toString()).format(numValue);
        } catch (_) {
          return NumberFormat.decimalPattern().format(numValue);
        }
      }
      return raw;

    case CellDataType.date:
      final parsedDate = DateTime.tryParse(raw);
      if (parsedDate != null) {
        try {
          return DateFormat.yMd(locale.toString()).format(parsedDate);
        } catch (_) {
          return DateFormat.yMd().format(parsedDate);
        }
      }
      return raw;

    case CellDataType.time:
      return raw;

    case CellDataType.boolean:
      return raw.toUpperCase();

    case CellDataType.formula:
      return cell.formula ?? raw;

    case CellDataType.text:
    case CellDataType.empty:
      return raw;
  }
}
