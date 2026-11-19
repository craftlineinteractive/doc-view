import 'package:flutter/material.dart';
import 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart';

import '../../../core/extensions/l10n_extension.dart';
import '../../../core/theme/doc_view_tokens.dart';
import '../../../core/theme/doc_view_typography.dart';
import '../../../core/utils/spreadsheet_helpers.dart';
import '../../../data/models/spreadsheet_data.dart';
import '../reader/reader_orientation.dart';
import '../skeletons/shimmer.dart';

/// Interactive virtualized spreadsheet grid viewer built on [TableView.builder].
///
/// Features:
/// - Pinned header row (A, B, C...) and pinned header column (1, 2, 3...).
/// - Merged cell span support via [TableViewCell] rowMerge/columnMerge.
/// - Cell, row, column, and all-sheet selection with Excel-green highlights.
/// - Hairline gridlines and custom cell styling (bold, colors, alignments).
/// - Pinch-to-zoom (50% to 300%) with scroll freeze while 2 pointers are active.
/// - Search match highlighting with active match border.
/// - Screen-reader optimization announcing selected cell coordinates and value.
/// - Text scaling clamped to 1.3x and strictly LTR grid layout.
/// - Skeleton placeholder state via [isLoading] and empty sheet fallback state.
class SpreadsheetGrid extends StatefulWidget {
  final SheetData sheet;
  final SpreadsheetSelection selection;
  final ValueChanged<SpreadsheetSelection> onSelectionChanged;
  final double zoomScale;
  final ValueChanged<double>? onZoomChanged;
  final bool isLoading;
  final bool isTableInverted;
  final CellCoordinate? currentSearchMatch;
  final Set<CellCoordinate>? allSearchMatches;
  final ScrollController? horizontalScrollController;
  final ScrollController? verticalScrollController;

  const SpreadsheetGrid({
    super.key,
    required this.sheet,
    required this.selection,
    required this.onSelectionChanged,
    this.zoomScale = 1.0,
    this.onZoomChanged,
    this.isLoading = false,
    this.isTableInverted = false,
    this.currentSearchMatch,
    this.allSearchMatches,
    this.horizontalScrollController,
    this.verticalScrollController,
  });

  @override
  State<SpreadsheetGrid> createState() => _SpreadsheetGridState();
}

class _SpreadsheetGridState extends State<SpreadsheetGrid> {
  int _activePointerCount = 0;
  double _baseScale = 1.0;

  static const double _kDefaultColWidth = 96.0;
  static const double _kDefaultRowHeight = 34.0;
  static const double _kHeaderColWidth = 48.0;
  static const double _kHeaderRowHeight = 28.0;
  static const double _kMinColWidth = 36.0;
  static const double _kMinRowHeight = 22.0;

  void _onPointerDown(PointerDownEvent event) {
    setState(() {
      _activePointerCount++;
    });
  }

  void _onPointerUp(PointerUpEvent event) {
    setState(() {
      if (_activePointerCount > 0) _activePointerCount--;
    });
  }

  void _onPointerCancel(PointerCancelEvent event) {
    setState(() {
      if (_activePointerCount > 0) _activePointerCount--;
    });
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = context.l10n;
    final scale = widget.zoomScale.clamp(0.5, 3.0);
    final isPinching = _activePointerCount >= 2;

    Widget content;

    if (widget.isLoading) {
      content = _buildSkeletonGrid(context, tokens, scale);
    } else if (widget.sheet.rowCount == 0 && widget.sheet.columnCount == 0) {
      content = _buildEmptyState(context, tokens, l10n);
    } else {
      content = _buildTableView(context, tokens, l10n, scale, isPinching);
    }

    if (widget.isTableInverted) {
      content = ColorFiltered(
        colorFilter: const ColorFilter.matrix(kReaderInvertColorMatrix),
        child: content,
      );
    }

    return MediaQuery.withClampedTextScaling(
      maxScaleFactor: 1.3,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Listener(
          onPointerDown: _onPointerDown,
          onPointerUp: _onPointerUp,
          onPointerCancel: _onPointerCancel,
          child: GestureDetector(
            onScaleStart: (details) {
              _baseScale = widget.zoomScale;
            },
            onScaleUpdate: (details) {
              if (details.pointerCount >= 2 && widget.onZoomChanged != null) {
                final targetScale = (_baseScale * details.scale).clamp(0.5, 3.0);
                widget.onZoomChanged!(targetScale);
              }
            },
            child: content,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    DocViewTokens tokens,
    dynamic l10n,
  ) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        decoration: BoxDecoration(
          color: tokens.surfaceAlt,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: tokens.hairline),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.grid_off_rounded,
              size: 48,
              color: tokens.textSecondary,
            ),
            const SizedBox(height: 12),
            Text(
              l10n.viewerSpreadsheetEmptySheet,
              style: DocViewTypography.bodyMedium.copyWith(
                color: tokens.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeletonGrid(
    BuildContext context,
    DocViewTokens tokens,
    double scale,
  ) {
    return Shimmer(
      child: TableView.builder(
        pinnedRowCount: 1,
        pinnedColumnCount: 1,
        columnCount: 8,
        rowCount: 18,
        columnBuilder: (col) => TableSpan(
          extent: FixedTableSpanExtent(
            col == 0 ? _kHeaderColWidth * scale : _kDefaultColWidth * scale,
          ),
        ),
        rowBuilder: (row) => TableSpan(
          extent: FixedTableSpanExtent(
            row == 0 ? _kHeaderRowHeight * scale : _kDefaultRowHeight * scale,
          ),
        ),
        cellBuilder: (context, vicinity) {
          final isHeader = vicinity.row == 0 || vicinity.column == 0;
          return TableViewCell(
            child: Container(
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: isHeader
                    ? tokens.surfaceAlt
                    : tokens.shimmerBase.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTableView(
    BuildContext context,
    DocViewTokens tokens,
    dynamic l10n,
    double scale,
    bool isPinching,
  ) {
    final sheet = widget.sheet;
    final totalColumns = sheet.columnCount + 1;
    final totalRows = sheet.rowCount + 1;

    final scrollPhysics = isPinching
        ? const NeverScrollableScrollPhysics()
        : const ClampingScrollPhysics();

    return TableView.builder(
      horizontalDetails: ScrollableDetails.horizontal(
        controller: widget.horizontalScrollController,
        physics: scrollPhysics,
      ),
      verticalDetails: ScrollableDetails.vertical(
        controller: widget.verticalScrollController,
        physics: scrollPhysics,
      ),
      pinnedRowCount: 1,
      pinnedColumnCount: 1,
      columnCount: totalColumns,
      rowCount: totalRows,
      diagonalDragBehavior: DiagonalDragBehavior.free,
      columnBuilder: (colIndex) {
        if (colIndex == 0) {
          return TableSpan(
            extent: FixedTableSpanExtent(_kHeaderColWidth * scale),
          );
        }
        final dataCol = colIndex - 1;
        final rawWidth = sheet.columnWidths[dataCol] ?? _kDefaultColWidth;
        final scaledWidth = (rawWidth * scale).clamp(_kMinColWidth * scale, 400.0 * scale);
        return TableSpan(
          extent: FixedTableSpanExtent(scaledWidth),
        );
      },
      rowBuilder: (rowIndex) {
        if (rowIndex == 0) {
          return TableSpan(
            extent: FixedTableSpanExtent(_kHeaderRowHeight * scale),
          );
        }
        final dataRow = rowIndex - 1;
        final rawHeight = sheet.rowHeights[dataRow] ?? _kDefaultRowHeight;
        final scaledHeight = (rawHeight * scale).clamp(_kMinRowHeight * scale, 200.0 * scale);
        return TableSpan(
          extent: FixedTableSpanExtent(scaledHeight),
        );
      },
      cellBuilder: (context, vicinity) {
        final r = vicinity.row;
        final c = vicinity.column;

        // 1. Top-Left Corner (Select All)
        if (r == 0 && c == 0) {
          return TableViewCell(
            child: _buildCornerCell(tokens),
          );
        }

        // 2. Column Header
        if (r == 0 && c > 0) {
          final dataCol = c - 1;
          return TableViewCell(
            child: _buildColumnHeader(context, tokens, dataCol, scale),
          );
        }

        // 3. Row Header
        if (r > 0 && c == 0) {
          final dataRow = r - 1;
          return TableViewCell(
            child: _buildRowHeader(context, tokens, dataRow, scale),
          );
        }

        // 4. Data Cell
        final dataRow = r - 1;
        final dataCol = c - 1;
        final merged = sheet.findMergedRange(dataRow, dataCol);

        if (merged != null) {
          final cell = sheet.cellAt(merged.startRow, merged.startColumn);
          return TableViewCell(
            rowMergeStart: merged.startRow + 1,
            rowMergeSpan: merged.rowSpan,
            columnMergeStart: merged.startColumn + 1,
            columnMergeSpan: merged.columnSpan,
            child: _buildDataCell(
              context: context,
              tokens: tokens,
              l10n: l10n,
              row: dataRow,
              col: dataCol,
              cell: cell,
              scale: scale,
              isMerged: true,
            ),
          );
        }

        final cell = sheet.cellAt(dataRow, dataCol);
        return TableViewCell(
          child: _buildDataCell(
            context: context,
            tokens: tokens,
            l10n: l10n,
            row: dataRow,
            col: dataCol,
            cell: cell,
            scale: scale,
            isMerged: false,
          ),
        );
      },
    );
  }

  Widget _buildCornerCell(DocViewTokens tokens) {
    final isAllSelected = widget.selection.isEntireSheet;
    return GestureDetector(
      onTap: () {
        if (isAllSelected) {
          widget.onSelectionChanged(const SpreadsheetSelection.none());
        } else {
          widget.onSelectionChanged(const SpreadsheetSelection.all());
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: isAllSelected ? tokens.excel.solid : tokens.surfaceAlt,
          border: Border(
            right: BorderSide(color: tokens.hairline, width: 1.0),
            bottom: BorderSide(color: tokens.hairline, width: 1.0),
          ),
        ),
        child: Center(
          child: Icon(
            Icons.select_all_rounded,
            size: 14,
            color: isAllSelected ? Colors.white : tokens.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildColumnHeader(
    BuildContext context,
    DocViewTokens tokens,
    int dataCol,
    double scale,
  ) {
    final isSelected = widget.selection.isColumnHeaderSelected(dataCol);
    final colLetter = columnIndexToLetter(dataCol);

    return GestureDetector(
      onTap: () {
        if (widget.selection.isEntireColumn &&
            widget.selection.selectedColumn == dataCol) {
          widget.onSelectionChanged(const SpreadsheetSelection.none());
        } else {
          widget.onSelectionChanged(SpreadsheetSelection.column(dataCol));
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? tokens.excel.solid : tokens.surfaceAlt,
          border: Border(
            right: BorderSide(color: tokens.hairline, width: 0.5),
            bottom: BorderSide(color: tokens.hairline, width: 1.0),
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          colLetter,
          style: DocViewTypography.labelXs.copyWith(
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
            fontSize: (11.0 * scale).clamp(9.0, 15.0),
            color: isSelected ? Colors.white : tokens.textSecondary,
          ),
          maxLines: 1,
          overflow: TextOverflow.clip,
        ),
      ),
    );
  }

  Widget _buildRowHeader(
    BuildContext context,
    DocViewTokens tokens,
    int dataRow,
    double scale,
  ) {
    final isSelected = widget.selection.isRowHeaderSelected(dataRow);
    final rowNumber = '${dataRow + 1}';

    return GestureDetector(
      onTap: () {
        if (widget.selection.isEntireRow &&
            widget.selection.selectedRow == dataRow) {
          widget.onSelectionChanged(const SpreadsheetSelection.none());
        } else {
          widget.onSelectionChanged(SpreadsheetSelection.row(dataRow));
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? tokens.excel.solid : tokens.surfaceAlt,
          border: Border(
            right: BorderSide(color: tokens.hairline, width: 1.0),
            bottom: BorderSide(color: tokens.hairline, width: 0.5),
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          rowNumber,
          style: DocViewTypography.labelXs.copyWith(
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
            fontSize: (11.0 * scale).clamp(9.0, 15.0),
            color: isSelected ? Colors.white : tokens.textSecondary,
          ),
          maxLines: 1,
          overflow: TextOverflow.clip,
        ),
      ),
    );
  }

  Widget _buildDataCell({
    required BuildContext context,
    required DocViewTokens tokens,
    required dynamic l10n,
    required int row,
    required int col,
    required SpreadsheetCell? cell,
    required double scale,
    required bool isMerged,
  }) {
    final isSelected = widget.selection.isCellSelected(row, col);
    final isSearchMatch = widget.allSearchMatches != null &&
        widget.allSearchMatches!.contains(CellCoordinate(row, col));
    final isCurrentMatch = widget.currentSearchMatch != null &&
        widget.currentSearchMatch!.row == row &&
        widget.currentSearchMatch!.column == col;

    Color cellBg;
    if (isSelected) {
      cellBg = tokens.excel.solid.withValues(alpha: 0.16);
    } else if (isCurrentMatch) {
      cellBg = const Color(0xFFFFD54F);
    } else if (isSearchMatch) {
      cellBg = const Color(0xFFFFF9C4);
    } else if (cell?.style?.backgroundColor != null) {
      cellBg = cell!.style!.backgroundColor!;
    } else {
      cellBg = tokens.surface;
    }

    BoxBorder cellBorder;
    if (isSelected) {
      cellBorder = Border.all(color: tokens.excel.solid, width: 2.0);
    } else if (isCurrentMatch) {
      cellBorder = Border.all(color: Colors.amber.shade900, width: 2.0);
    } else {
      cellBorder = Border(
        right: BorderSide(color: tokens.hairline, width: 0.5),
        bottom: BorderSide(color: tokens.hairline, width: 0.5),
      );
    }

    final locale = Localizations.localeOf(context);
    final displayValue = cell != null ? formatCellDisplayValue(cell, locale) : '';

    final cellWidget = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (isSelected && !widget.selection.isEntireRow && !widget.selection.isEntireColumn && !widget.selection.isEntireSheet) {
          widget.onSelectionChanged(const SpreadsheetSelection.none());
        } else {
          widget.onSelectionChanged(SpreadsheetSelection.cell(row, col));
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: cellBg,
          border: cellBorder,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: (6.0 * scale).clamp(3.0, 12.0),
          vertical: (4.0 * scale).clamp(2.0, 8.0),
        ),
        alignment: _getAlignmentForCell(cell),
        child: displayValue.isEmpty
            ? const SizedBox.shrink()
            : Text(
                displayValue,
                style: TextStyle(
                  color: cell?.style?.fontColor ?? tokens.textPrimary,
                  fontSize: ((cell?.style?.fontSize?.toDouble() ?? 12.5) * scale)
                      .clamp(8.5, 22.0),
                  fontWeight: cell?.style?.isBold == true
                      ? FontWeight.bold
                      : FontWeight.normal,
                  fontStyle: cell?.style?.isItalic == true
                      ? FontStyle.italic
                      : FontStyle.normal,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
      ),
    );

    if (isSelected) {
      final colLetter = columnIndexToLetter(col);
      final spokenVal = displayValue.isEmpty ? l10n.viewerSpreadsheetEmptyCell : displayValue;
      return Semantics(
        label: l10n.viewerSpreadsheetCellSemantics(colLetter, row + 1, spokenVal),
        selected: true,
        child: cellWidget,
      );
    }

    return ExcludeSemantics(child: cellWidget);
  }

  Alignment _getAlignmentForCell(SpreadsheetCell? cell) {
    if (cell == null) return Alignment.centerLeft;
    switch (cell.style?.textAlign) {
      case TextAlign.right:
      case TextAlign.end:
        return Alignment.centerRight;
      case TextAlign.center:
        return Alignment.center;
      default:
        if (cell.type == CellDataType.number) {
          return Alignment.centerRight;
        }
        return Alignment.centerLeft;
    }
  }
}
