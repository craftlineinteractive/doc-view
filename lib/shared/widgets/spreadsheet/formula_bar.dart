import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/extensions/l10n_extension.dart';
import '../../../core/theme/doc_view_tokens.dart';
import '../../../core/theme/doc_view_typography.dart';
import '../../../core/utils/spreadsheet_helpers.dart';
import '../../../data/models/spreadsheet_data.dart';
import '../sheets/doc_bottom_sheet.dart';

/// Interactive formula and cell content bar placed below the top app bar.
///
/// Features:
/// - Leading chip indicating current selection reference (e.g. "C2", "Col B", "Row 4", "All", "-").
/// - Single-line display with ellipsis showing formula or formatted cell value.
/// - Tap opens bottom sheet inspector for long strings and multi-line content.
/// - Trailing copy button copying cell or TSV range to clipboard (capped at 5,000 cells).
class FormulaBar extends StatelessWidget {
  final SheetData sheet;
  final SpreadsheetSelection selection;

  static const int kMaxCopyCells = 5000;

  const FormulaBar({
    super.key,
    required this.sheet,
    required this.selection,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context);

    final chipText = _getSelectionChipText(context);
    final (displayText, formulaText) = _getCellTexts(locale);

    final activeText = formulaText.isNotEmpty ? formulaText : displayText;

    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: tokens.surfaceAlt,
        border: Border(
          bottom: BorderSide(color: tokens.hairline, width: 1.0),
        ),
      ),
      child: Row(
        children: [
          // 1. Selection Reference Chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: tokens.surface,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: tokens.hairline),
            ),
            child: Text(
              chipText,
              style: DocViewTypography.labelSm.copyWith(
                fontWeight: FontWeight.w700,
                color: tokens.textPrimary,
              ),
            ),
          ),
          const SizedBox(width: 8),

          // 2. Expandable Value / Formula display
          Expanded(
            child: InkWell(
              onTap: activeText.isNotEmpty
                  ? () => _showCellInspectorSheet(context, chipText, displayText, formulaText)
                  : null,
              borderRadius: BorderRadius.circular(6),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                child: Text(
                  activeText,
                  style: DocViewTypography.bodyMedium.copyWith(
                    color: formulaText.isNotEmpty
                        ? tokens.excel.solid
                        : (activeText.isEmpty ? tokens.textSecondary : tokens.textPrimary),
                    fontFamily: formulaText.isNotEmpty ? 'monospace' : null,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),

          // 3. Trailing Quick-Copy Action
          IconButton(
            icon: const Icon(Icons.copy_rounded, size: 18),
            color: activeText.isNotEmpty || selection.hasSelection
                ? tokens.textPrimary
                : tokens.textSecondary.withValues(alpha: 0.5),
            tooltip: l10n.viewerSpreadsheetCopyAction,
            onPressed: activeText.isNotEmpty || selection.hasSelection
                ? () => _copySelectionToClipboard(context)
                : null,
          ),
        ],
      ),
    );
  }

  String _getSelectionChipText(BuildContext context) {
    final l10n = context.l10n;
    if (selection.isEntireSheet) {
      return l10n.viewerSpreadsheetAllCells;
    }
    if (selection.isEntireColumn && selection.selectedColumn != null) {
      final letter = columnIndexToLetter(selection.selectedColumn!);
      return l10n.viewerSpreadsheetColumnLabel(letter);
    }
    if (selection.isEntireRow && selection.selectedRow != null) {
      return l10n.viewerSpreadsheetRowLabel(selection.selectedRow! + 1);
    }
    if (selection.selectedRow != null && selection.selectedColumn != null) {
      return cellCoordinateToA1(selection.selectedRow!, selection.selectedColumn!);
    }
    return l10n.viewerSpreadsheetFormulaBarEmpty;
  }

  (String, String) _getCellTexts(Locale locale) {
    if (selection.selectedRow != null && selection.selectedColumn != null) {
      final cell = sheet.cellAt(selection.selectedRow!, selection.selectedColumn!);
      if (cell != null) {
        final display = formatCellDisplayValue(cell, locale);
        final formula = cell.formula ?? '';
        return (display, formula);
      }
    }
    return ('', '');
  }

  Future<void> _copySelectionToClipboard(BuildContext context) async {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context);

    // Case A: Single cell
    if (selection.selectedRow != null &&
        selection.selectedColumn != null &&
        !selection.isEntireRow &&
        !selection.isEntireColumn &&
        !selection.isEntireSheet) {
      final cell = sheet.cellAt(selection.selectedRow!, selection.selectedColumn!);
      final text = cell != null ? (cell.formula ?? formatCellDisplayValue(cell, locale)) : '';
      await Clipboard.setData(ClipboardData(text: text));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.viewerSpreadsheetCopiedSingle),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      return;
    }

    // Case B: Range / Row / Column / Sheet (Formatted as TSV)
    final buffer = StringBuffer();
    var copiedCells = 0;
    var truncated = false;

    if (selection.isEntireRow && selection.selectedRow != null) {
      final r = selection.selectedRow!;
      final rowParts = <String>[];
      for (var c = 0; c < sheet.columnCount; c++) {
        if (copiedCells >= kMaxCopyCells) {
          truncated = true;
          break;
        }
        final cell = sheet.cellAt(r, c);
        rowParts.add(cell != null ? formatCellDisplayValue(cell, locale) : '');
        copiedCells++;
      }
      buffer.write(rowParts.join('\t'));
    } else if (selection.isEntireColumn && selection.selectedColumn != null) {
      final c = selection.selectedColumn!;
      final colParts = <String>[];
      for (var r = 0; r < sheet.rowCount; r++) {
        if (copiedCells >= kMaxCopyCells) {
          truncated = true;
          break;
        }
        final cell = sheet.cellAt(r, c);
        colParts.add(cell != null ? formatCellDisplayValue(cell, locale) : '');
        copiedCells++;
      }
      buffer.write(colParts.join('\n'));
    } else if (selection.isEntireSheet) {
      final lines = <String>[];
      for (var r = 0; r < sheet.rowCount; r++) {
        if (copiedCells >= kMaxCopyCells) {
          truncated = true;
          break;
        }
        final rowParts = <String>[];
        for (var c = 0; c < sheet.columnCount; c++) {
          if (copiedCells >= kMaxCopyCells) {
            truncated = true;
            break;
          }
          final cell = sheet.cellAt(r, c);
          rowParts.add(cell != null ? formatCellDisplayValue(cell, locale) : '');
          copiedCells++;
        }
        lines.add(rowParts.join('\t'));
      }
      buffer.write(lines.join('\n'));
    }

    await Clipboard.setData(ClipboardData(text: buffer.toString()));

    if (context.mounted) {
      final message = truncated
          ? l10n.viewerSpreadsheetCopyLimitReached
          : l10n.viewerSpreadsheetCopiedCount(copiedCells);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _showCellInspectorSheet(
    BuildContext context,
    String reference,
    String displayValue,
    String formulaValue,
  ) {
    final tokens = context.tokens;
    final l10n = context.l10n;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) {
        return DocBottomSheet(
          title: '$reference • ${l10n.viewerSpreadsheetCellContentTitle}',
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (formulaValue.isNotEmpty) ...[
                Text(
                  formulaValue,
                  style: DocViewTypography.bodyMedium.copyWith(
                    fontFamily: 'monospace',
                    color: tokens.excel.solid,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
              ],
              Container(
                constraints: const BoxConstraints(maxHeight: 280),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: tokens.surfaceAlt,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: tokens.hairline),
                ),
                child: SingleChildScrollView(
                  child: SelectableText(
                    displayValue.isNotEmpty ? displayValue : formulaValue,
                    style: DocViewTypography.bodyMedium,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(bottomSheetContext).pop(),
                    child: Text(l10n.viewerSpreadsheetCloseAction),
                  ),
                  const SizedBox(width: 8),
                  FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: tokens.excel.solid,
                    ),
                    icon: const Icon(Icons.copy_rounded, size: 16),
                    label: Text(l10n.viewerSpreadsheetCopyAction),
                    onPressed: () async {
                      final textToCopy = formulaValue.isNotEmpty ? formulaValue : displayValue;
                      await Clipboard.setData(ClipboardData(text: textToCopy));
                      if (bottomSheetContext.mounted) {
                        Navigator.of(bottomSheetContext).pop();
                      }
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.viewerSpreadsheetCopiedSingle),
                            duration: const Duration(seconds: 2),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
