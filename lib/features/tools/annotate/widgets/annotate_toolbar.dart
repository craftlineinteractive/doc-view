import 'package:flutter/material.dart';

import '../../../../core/extensions/l10n_extension.dart';
import '../../../../core/theme/doc_view_tokens.dart';
import '../../../../data/models/pdf_markup.dart';
import '../../../../shared/widgets/create_pdf/color_swatch_row.dart';
import '../../../../shared/widgets/reader/reader_bottom_row.dart';
import '../annotate_session_notifier.dart';

/// Bottom toolbar for PDF annotation containing tool selectors and color palette.
class AnnotateToolbar extends StatelessWidget {
  const AnnotateToolbar({
    required this.selectedTool,
    required this.selectedColor,
    required this.onToolSelected,
    required this.onColorSelected,
    super.key,
  });

  final TextMarkupType selectedTool;
  final Color selectedColor;
  final ValueChanged<TextMarkupType> onToolSelected;
  final ValueChanged<Color> onColorSelected;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = context.l10n;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Color swatch row floating above tool actions
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(vertical: 4),
              decoration: BoxDecoration(
                color: tokens.surface.withValues(alpha: 0.90),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: tokens.hairline.withValues(alpha: 0.5),
                  width: 0.75,
                ),
              ),
              child: ColorSwatchRow.colors(
                key: const Key('annotate_color_swatches'),
                colors: AnnotateColors.palette,
                selectedColor: selectedColor,
                onColorSelected: onColorSelected,
                labelBuilder: (color) {
                  if (color == AnnotateColors.yellow) return l10n.annotateColorYellow;
                  if (color == AnnotateColors.green) return l10n.annotateColorGreen;
                  if (color == AnnotateColors.cyan) return l10n.annotateColorCyan;
                  if (color == AnnotateColors.pink) return l10n.annotateColorPink;
                  if (color == AnnotateColors.orange) return l10n.annotateColorOrange;
                  return '';
                },
              ),
            ),

            // Tools bottom row
            ReaderBottomRow(
              items: [
                ReaderBottomRowItem(
                  key: const Key('annotate_tool_highlight'),
                  icon: Icons.border_color_outlined,
                  label: l10n.annotateToolbarHighlight,
                  isSelected: selectedTool == TextMarkupType.highlight,
                  onTap: () => onToolSelected(TextMarkupType.highlight),
                  tooltip: l10n.annotateToolbarHighlight,
                ),
                ReaderBottomRowItem(
                  key: const Key('annotate_tool_underline'),
                  icon: Icons.format_underlined_outlined,
                  label: l10n.annotateToolbarUnderline,
                  isSelected: selectedTool == TextMarkupType.underline,
                  onTap: () => onToolSelected(TextMarkupType.underline),
                  tooltip: l10n.annotateToolbarUnderline,
                ),
                ReaderBottomRowItem(
                  key: const Key('annotate_tool_strikethrough'),
                  icon: Icons.format_strikethrough_outlined,
                  label: l10n.annotateToolbarStrikethrough,
                  isSelected: selectedTool == TextMarkupType.strikethrough,
                  onTap: () => onToolSelected(TextMarkupType.strikethrough),
                  tooltip: l10n.annotateToolbarStrikethrough,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
