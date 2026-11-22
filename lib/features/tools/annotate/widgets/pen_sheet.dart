import 'package:flutter/material.dart';

import '../../../../core/extensions/l10n_extension.dart';
import '../../../../core/theme/doc_view_tokens.dart';
import '../../../../core/theme/doc_view_typography.dart';
import '../../../../shared/widgets/create_pdf/color_swatch_row.dart';
import '../annotate_session_notifier.dart';

/// Modal bottom sheet allowing users to customize pen color, stroke width, and toggle eraser mode.
class PenSheet extends StatelessWidget {
  const PenSheet({
    required this.selectedColor,
    required this.strokeWidth,
    required this.isEraserMode,
    required this.onColorChanged,
    required this.onStrokeWidthChanged,
    required this.onEraserModeChanged,
    super.key,
  });

  final Color selectedColor;
  final double strokeWidth;
  final bool isEraserMode;
  final ValueChanged<Color> onColorChanged;
  final ValueChanged<double> onStrokeWidthChanged;
  final ValueChanged<bool> onEraserModeChanged;

  /// Convenience helper to display [PenSheet] within a styled modal bottom sheet.
  static Future<void> show(
    BuildContext context, {
    required Color selectedColor,
    required double strokeWidth,
    required bool isEraserMode,
    required ValueChanged<Color> onColorChanged,
    required ValueChanged<double> onStrokeWidthChanged,
    required ValueChanged<bool> onEraserModeChanged,
  }) {
    final tokens = context.tokens;
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: tokens.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) {
          return PenSheet(
            selectedColor: selectedColor,
            strokeWidth: strokeWidth,
            isEraserMode: isEraserMode,
            onColorChanged: (c) {
              setModalState(() {});
              onColorChanged(c);
            },
            onStrokeWidthChanged: (w) {
              setModalState(() {});
              onStrokeWidthChanged(w);
            },
            onEraserModeChanged: (e) {
              setModalState(() {});
              onEraserModeChanged(e);
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = context.l10n;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.annotatePenSheetTitle,
                    style: DocViewTypography.headlineSm.copyWith(
                      color: tokens.textPrimary,
                      fontSize: 18,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                  tooltip: l10n.tooltipBack,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Color swatches (6 colors)
            ColorSwatchRow.colors(
              key: const Key('pen_color_swatches'),
              colors: PenColors.palette,
              selectedColor: selectedColor,
              onColorSelected: (c) {
                if (isEraserMode) {
                  onEraserModeChanged(false);
                }
                onColorChanged(c);
              },
              labelBuilder: (color) {
                if (color == PenColors.black) return l10n.annotateColorBlack;
                if (color == PenColors.blue) return l10n.annotateColorBlue;
                if (color == PenColors.red) return l10n.annotateColorRed;
                if (color == PenColors.green) return l10n.annotateColorGreen;
                if (color == PenColors.purple) return l10n.annotateColorPurple;
                if (color == PenColors.orange) return l10n.annotateColorOrange;
                return '';
              },
            ),
            const SizedBox(height: 20),

            // Stroke width slider (1 to 12 pt)
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.annotatePenStrokeWidth,
                    style: DocViewTypography.bodyMedium.copyWith(
                      color: tokens.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  l10n.annotatePenStrokeWidthValue(strokeWidth.toStringAsFixed(1)),
                  style: DocViewTypography.bodyMedium.copyWith(
                    color: tokens.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Slider(
              key: const Key('pen_stroke_width_slider'),
              value: strokeWidth,
              min: 1.0,
              max: 12.0,
              divisions: 22,
              activeColor: tokens.primaryBlue,
              onChanged: onStrokeWidthChanged,
            ),
            const SizedBox(height: 12),

            // Eraser Mode Toggle
            SwitchListTile.adaptive(
              key: const Key('pen_eraser_toggle'),
              title: Text(
                l10n.annotatePenEraserMode,
                style: DocViewTypography.bodyLg.copyWith(
                  color: tokens.textPrimary,
                ),
              ),
              secondary: Icon(
                Icons.cleaning_services_outlined,
                color: isEraserMode ? tokens.primaryBlue : tokens.textSecondary,
              ),
              value: isEraserMode,
              onChanged: onEraserModeChanged,
            ),
          ],
        ),
      ),
    );
  }
}
