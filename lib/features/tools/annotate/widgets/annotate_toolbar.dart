// ignore_for_file: prefer_initializing_formals
import 'package:flutter/material.dart';

import '../../../../core/extensions/l10n_extension.dart';
import '../../../../core/theme/doc_view_tokens.dart';
import '../../../../data/models/pdf_markup.dart';
import '../../../../shared/widgets/create_pdf/color_swatch_row.dart';
import '../../../../shared/widgets/reader/reader_bottom_row.dart';
import '../annotate_session_notifier.dart';

/// Bottom toolbar for PDF annotation containing 5 tool selectors (Copy, Highlight, Underline, Strikethrough, Pen)
/// and dynamic color palette swatches.
class AnnotateToolbar extends StatelessWidget {
  const AnnotateToolbar({
    this.activeTool,
    this.selectedMarkupColor,
    this.penColor = PenColors.black,
    this.onToolSelected,
    this.onColorSelected,
    this.onPenSettingsTapped,
    this.onCopyTapped,
    TextMarkupType? selectedTool,
    Color? selectedColor,
    super.key,
  })  : _selectedTool = selectedTool,
        _selectedColor = selectedColor;

  final AnnotateActiveTool? activeTool;
  final Color? selectedMarkupColor;
  final Color penColor;
  final ValueChanged<dynamic>? onToolSelected;
  final ValueChanged<Color>? onColorSelected;
  final VoidCallback? onPenSettingsTapped;
  final VoidCallback? onCopyTapped;
  final TextMarkupType? _selectedTool;
  final Color? _selectedColor;

  AnnotateActiveTool get _resolvedTool {
    final explicit = activeTool;
    if (explicit != null) return explicit;
    final legacy = _selectedTool;
    if (legacy != null) {
      switch (legacy) {
        case TextMarkupType.underline:
          return AnnotateActiveTool.underline;
        case TextMarkupType.strikethrough:
          return AnnotateActiveTool.strikethrough;
        case TextMarkupType.highlight:
          return AnnotateActiveTool.highlight;
      }
    }
    return AnnotateActiveTool.highlight;
  }

  void _handleToolSelected(AnnotateActiveTool tool) {
    if (onToolSelected == null) return;
    if (onToolSelected is ValueChanged<AnnotateActiveTool>) {
      (onToolSelected as ValueChanged<AnnotateActiveTool>)(tool);
    } else if (onToolSelected is ValueChanged<TextMarkupType>) {
      if (tool == AnnotateActiveTool.highlight) {
        (onToolSelected as ValueChanged<TextMarkupType>)(TextMarkupType.highlight);
      } else if (tool == AnnotateActiveTool.underline) {
        (onToolSelected as ValueChanged<TextMarkupType>)(TextMarkupType.underline);
      } else if (tool == AnnotateActiveTool.strikethrough) {
        (onToolSelected as ValueChanged<TextMarkupType>)(TextMarkupType.strikethrough);
      }
    } else {
      try {
        onToolSelected!(tool);
      } catch (_) {
        if (tool == AnnotateActiveTool.highlight) onToolSelected!(TextMarkupType.highlight);
        if (tool == AnnotateActiveTool.underline) onToolSelected!(TextMarkupType.underline);
        if (tool == AnnotateActiveTool.strikethrough) onToolSelected!(TextMarkupType.strikethrough);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = context.l10n;
    final tool = _resolvedTool;

    final isPen = tool == AnnotateActiveTool.pen;
    final colors = isPen ? PenColors.palette : AnnotateColors.palette;
    final activeColor = isPen
        ? penColor
        : (selectedMarkupColor ?? _selectedColor ?? AnnotateColors.yellow);

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
                colors: colors,
                selectedColor: activeColor,
                onColorSelected: onColorSelected ?? (_) {},
                labelBuilder: (color) {
                  if (color == AnnotateColors.yellow) return l10n.annotateColorYellow;
                  if (color == AnnotateColors.green || color == PenColors.green) return l10n.annotateColorGreen;
                  if (color == AnnotateColors.cyan) return l10n.annotateColorCyan;
                  if (color == AnnotateColors.pink) return l10n.annotateColorPink;
                  if (color == AnnotateColors.orange || color == PenColors.orange) return l10n.annotateColorOrange;
                  if (color == PenColors.black) return l10n.annotateColorBlack;
                  if (color == PenColors.blue) return l10n.annotateColorBlue;
                  if (color == PenColors.red) return l10n.annotateColorRed;
                  if (color == PenColors.purple) return l10n.annotateColorPurple;
                  return '';
                },
              ),
            ),

            // Tools bottom row (5 tools: Copy, Highlight, Underline, Strikethrough, Pen)
            ReaderBottomRow(
              items: [
                ReaderBottomRowItem(
                  key: const Key('annotate_tool_copy'),
                  icon: Icons.copy_outlined,
                  label: l10n.annotateToolbarCopy,
                  isSelected: false,
                  onTap: onCopyTapped ?? () {},
                  tooltip: l10n.annotateToolbarCopy,
                ),
                ReaderBottomRowItem(
                  key: const Key('annotate_tool_highlight'),
                  icon: Icons.border_color_outlined,
                  label: l10n.annotateToolbarHighlight,
                  isSelected: tool == AnnotateActiveTool.highlight,
                  onTap: () => _handleToolSelected(AnnotateActiveTool.highlight),
                  tooltip: l10n.annotateToolbarHighlight,
                ),
                ReaderBottomRowItem(
                  key: const Key('annotate_tool_underline'),
                  icon: Icons.format_underlined_outlined,
                  label: l10n.annotateToolbarUnderline,
                  isSelected: tool == AnnotateActiveTool.underline,
                  onTap: () => _handleToolSelected(AnnotateActiveTool.underline),
                  tooltip: l10n.annotateToolbarUnderline,
                ),
                ReaderBottomRowItem(
                  key: const Key('annotate_tool_strikethrough'),
                  icon: Icons.format_strikethrough_outlined,
                  label: l10n.annotateToolbarStrikethrough,
                  isSelected: tool == AnnotateActiveTool.strikethrough,
                  onTap: () => _handleToolSelected(AnnotateActiveTool.strikethrough),
                  tooltip: l10n.annotateToolbarStrikethrough,
                ),
                ReaderBottomRowItem(
                  key: const Key('annotate_tool_pen'),
                  icon: Icons.draw_outlined,
                  label: l10n.annotateToolbarPen,
                  isSelected: tool == AnnotateActiveTool.pen,
                  onTap: () {
                    if (tool == AnnotateActiveTool.pen) {
                      onPenSettingsTapped?.call();
                    } else {
                      _handleToolSelected(AnnotateActiveTool.pen);
                    }
                  },
                  tooltip: l10n.annotateToolbarPen,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
