import 'dart:ui';
import 'package:flutter/foundation.dart';

/// Represents the data type of a spreadsheet cell.
enum CellDataType {
  text,
  number,
  date,
  time,
  boolean,
  formula,
  empty,
}

/// Represents the selection state within a spreadsheet grid.
@immutable
class SpreadsheetSelection {
  const SpreadsheetSelection._({
    this.selectedRow,
    this.selectedColumn,
    this.isEntireRow = false,
    this.isEntireColumn = false,
    this.isEntireSheet = false,
  });

  const SpreadsheetSelection.none() : this._();

  const SpreadsheetSelection.cell(int row, int column)
      : this._(
          selectedRow: row,
          selectedColumn: column,
        );

  const SpreadsheetSelection.row(int row)
      : this._(
          selectedRow: row,
          isEntireRow: true,
        );

  const SpreadsheetSelection.column(int column)
      : this._(
          selectedColumn: column,
          isEntireColumn: true,
        );

  const SpreadsheetSelection.all()
      : this._(
          isEntireSheet: true,
        );

  final int? selectedRow;
  final int? selectedColumn;
  final bool isEntireRow;
  final bool isEntireColumn;
  final bool isEntireSheet;

  bool get hasSelection =>
      isEntireSheet ||
      isEntireRow ||
      isEntireColumn ||
      (selectedRow != null && selectedColumn != null);

  bool isCellSelected(int row, int column) {
    if (isEntireSheet) return true;
    if (isEntireRow) return selectedRow == row;
    if (isEntireColumn) return selectedColumn == column;
    return selectedRow == row && selectedColumn == column;
  }

  bool isRowHeaderSelected(int row) {
    if (isEntireSheet) return true;
    if (isEntireRow) return selectedRow == row;
    return selectedRow == row;
  }

  bool isColumnHeaderSelected(int column) {
    if (isEntireSheet) return true;
    if (isEntireColumn) return selectedColumn == column;
    return selectedColumn == column;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SpreadsheetSelection &&
        other.selectedRow == selectedRow &&
        other.selectedColumn == selectedColumn &&
        other.isEntireRow == isEntireRow &&
        other.isEntireColumn == isEntireColumn &&
        other.isEntireSheet == isEntireSheet;
  }

  @override
  int get hashCode => Object.hash(
        selectedRow,
        selectedColumn,
        isEntireRow,
        isEntireColumn,
        isEntireSheet,
      );
}

/// Coordinate representing (row, column) in zero-based indexing.
@immutable
class CellCoordinate {
  const CellCoordinate(this.row, this.column);

  final int row;
  final int column;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CellCoordinate &&
          other.row == row &&
          other.column == column;

  @override
  int get hashCode => Object.hash(row, column);

  @override
  String toString() => '($row, $column)';
}

/// Represents a rectangular merged range of cells.
@immutable
class MergedCellRange {
  const MergedCellRange({
    required this.startRow,
    required this.startColumn,
    required this.rowSpan,
    required this.columnSpan,
  });

  final int startRow;
  final int startColumn;
  final int rowSpan;
  final int columnSpan;

  bool contains(int row, int col) {
    return row >= startRow &&
        row < startRow + rowSpan &&
        col >= startColumn &&
        col < startColumn + columnSpan;
  }

  bool isOrigin(int row, int col) => row == startRow && col == startColumn;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MergedCellRange &&
          other.startRow == startRow &&
          other.startColumn == startColumn &&
          other.rowSpan == rowSpan &&
          other.columnSpan == columnSpan;

  @override
  int get hashCode =>
      Object.hash(startRow, startColumn, rowSpan, columnSpan);
}

/// Style attributes of an individual spreadsheet cell.
@immutable
class CellStyleData {
  const CellStyleData({
    this.isBold = false,
    this.isItalic = false,
    this.fontColor,
    this.backgroundColor,
    this.fontSize,
    this.numberFormat,
    this.textAlign = TextAlign.start,
  });

  final bool isBold;
  final bool isItalic;
  final Color? fontColor;
  final Color? backgroundColor;
  final int? fontSize;
  final String? numberFormat;
  final TextAlign textAlign;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CellStyleData &&
          other.isBold == isBold &&
          other.isItalic == isItalic &&
          other.fontColor == fontColor &&
          other.backgroundColor == backgroundColor &&
          other.fontSize == fontSize &&
          other.numberFormat == numberFormat &&
          other.textAlign == textAlign;

  @override
  int get hashCode => Object.hash(
        isBold,
        isItalic,
        fontColor,
        backgroundColor,
        fontSize,
        numberFormat,
        textAlign,
      );
}

/// Model representing a single cell's data and styling.
@immutable
class SpreadsheetCell {
  const SpreadsheetCell({
    required this.rawValue,
    this.formula,
    this.type = CellDataType.text,
    this.style,
  });

  final String rawValue;
  final String? formula;
  final CellDataType type;
  final CellStyleData? style;

  bool get hasFormula => formula != null && formula!.isNotEmpty;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SpreadsheetCell &&
          other.rawValue == rawValue &&
          other.formula == formula &&
          other.type == type &&
          other.style == style;

  @override
  int get hashCode => Object.hash(rawValue, formula, type, style);
}

/// Model representing a sheet's dimensions, cells, and formatting.
@immutable
class SheetData {
  const SheetData({
    required this.name,
    required this.rowCount,
    required this.columnCount,
    required this.cells,
    this.columnWidths = const {},
    this.rowHeights = const {},
    this.mergedRanges = const [],
    this.isTruncated = false,
    this.totalUncappedRows = 0,
    this.totalUncappedCols = 0,
  });

  final String name;
  final int rowCount;
  final int columnCount;
  final Map<CellCoordinate, SpreadsheetCell> cells;
  final Map<int, double> columnWidths;
  final Map<int, double> rowHeights;
  final List<MergedCellRange> mergedRanges;
  final bool isTruncated;
  final int totalUncappedRows;
  final int totalUncappedCols;

  SpreadsheetCell? cellAt(int row, int col) => cells[CellCoordinate(row, col)];

  MergedCellRange? findMergedRange(int row, int col) {
    for (final range in mergedRanges) {
      if (range.contains(row, col)) return range;
    }
    return null;
  }
}

/// Immutable model representing the decoded workbook.
@immutable
class WorkbookData {
  const WorkbookData({
    required this.fileName,
    required this.sheetNames,
    required this.activeSheetIndex,
    required this.activeSheet,
    this.isTruncated = false,
    this.fileSizeBytes = 0,
  });

  final String fileName;
  final List<String> sheetNames;
  final int activeSheetIndex;
  final SheetData activeSheet;
  final bool isTruncated;
  final int fileSizeBytes;

  String get activeSheetName =>
      sheetNames.isNotEmpty ? sheetNames[activeSheetIndex] : '';

  WorkbookData copyWith({
    int? activeSheetIndex,
    SheetData? activeSheet,
  }) {
    return WorkbookData(
      fileName: fileName,
      sheetNames: sheetNames,
      activeSheetIndex: activeSheetIndex ?? this.activeSheetIndex,
      activeSheet: activeSheet ?? this.activeSheet,
      isTruncated: isTruncated,
      fileSizeBytes: fileSizeBytes,
    );
  }
}

/// Base sealed class for spreadsheet errors.
sealed class SpreadsheetException implements Exception {
  const SpreadsheetException(this.message);
  final String message;

  @override
  String toString() => message;
}

class SpreadsheetPasswordProtectedException extends SpreadsheetException {
  const SpreadsheetPasswordProtectedException([super.message = 'Password-protected files cannot be viewed in the offline reader.']);
}

class SpreadsheetCorruptException extends SpreadsheetException {
  const SpreadsheetCorruptException([super.message = 'The spreadsheet file is corrupted or could not be decoded.']);
}

class SpreadsheetTooLargeException extends SpreadsheetException {
  const SpreadsheetTooLargeException([super.message = 'This file exceeds the 25 MB viewing limit.']);
}

class SpreadsheetTimeoutException extends SpreadsheetException {
  const SpreadsheetTimeoutException([super.message = 'Opening spreadsheet timed out after 20 seconds.']);
}

class SpreadsheetUnsupportedException extends SpreadsheetException {
  const SpreadsheetUnsupportedException([super.message = 'This format is not supported by the spreadsheet viewer.']);
}
