import 'package:flutter/material.dart';

import '../../../../core/extensions/l10n_extension.dart';
import '../../../../core/theme/doc_view_tokens.dart';
import '../../../../core/theme/doc_view_typography.dart';
import '../../../../shared/widgets/create_pdf/color_swatch_row.dart';
import '../../../../shared/widgets/sheets/doc_bottom_sheet.dart';

/// Bottom sheet allowing users to customize font size, color, style, and alignment.
class TextStyleSheet extends StatefulWidget {
  const TextStyleSheet({
    required this.initialFontSize,
    required this.initialColor,
    required this.initialIsBold,
    required this.initialIsItalic,
    required this.initialAlignment,
    required this.onChanged,
    super.key,
  });

  final double initialFontSize;
  final Color initialColor;
  final bool initialIsBold;
  final bool initialIsItalic;
  final TextAlign initialAlignment;
  final void Function({
    required double fontSize,
    required Color color,
    required bool isBold,
    required bool isItalic,
    required TextAlign alignment,
  }) onChanged;

  /// The 8 standard design tokens for text color swatches.
  static const List<Color> swatchColors = <Color>[
    Color(0xFF212121), // Black (default)
    Color(0xFF616161), // Dark gray
    Color(0xFFE53935), // Red
    Color(0xFF1E5FD8), // Blue
    Color(0xFF1E9E4F), // Green
    Color(0xFFF26B1D), // Orange
    Color(0xFF8E24AA), // Purple
    Color(0xFF6D4C41), // Brown
  ];

  /// Static helper to display the modal style sheet.
  static Future<void> show(
    BuildContext context, {
    required double initialFontSize,
    required Color initialColor,
    required bool initialIsBold,
    required bool initialIsItalic,
    required TextAlign initialAlignment,
    required void Function({
      required double fontSize,
      required Color color,
      required bool isBold,
      required bool isItalic,
      required TextAlign alignment,
    }) onChanged,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => TextStyleSheet(
        initialFontSize: initialFontSize,
        initialColor: initialColor,
        initialIsBold: initialIsBold,
        initialIsItalic: initialIsItalic,
        initialAlignment: initialAlignment,
        onChanged: onChanged,
      ),
    );
  }

  @override
  State<TextStyleSheet> createState() => _TextStyleSheetState();
}

class _TextStyleSheetState extends State<TextStyleSheet> {
  late double _fontSize;
  late Color _color;
  late bool _isBold;
  late bool _isItalic;
  late TextAlign _alignment;

  @override
  void initState() {
    super.initState();
    _fontSize = widget.initialFontSize;
    _color = widget.initialColor;
    _isBold = widget.initialIsBold;
    _isItalic = widget.initialIsItalic;
    _alignment = widget.initialAlignment;
  }

  void _notifyChange() {
    widget.onChanged(
      fontSize: _fontSize,
      color: _color,
      isBold: _isBold,
      isItalic: _isItalic,
      alignment: _alignment,
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = context.l10n;

    return DocBottomSheet(
      title: l10n.addTextStyleSheetTitle,
      showCloseButton: true,
      onClose: () => Navigator.of(context).pop(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Live preview card
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: tokens.surfaceAlt,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: tokens.hairline),
            ),
            child: Text(
              l10n.addTextSamplePreview,
              textAlign: _alignment,
              style: TextStyle(
                fontFamily: 'Arimo',
                fontSize: _fontSize.clamp(12.0, 36.0),
                color: _color,
                fontWeight: _isBold ? FontWeight.bold : FontWeight.normal,
                fontStyle: _isItalic ? FontStyle.italic : FontStyle.normal,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Font size slider: 8 to 72 pt
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.addTextFontSize,
                style: DocViewTypography.labelSm.copyWith(
                  color: tokens.textSecondary,
                ),
              ),
              Text(
                l10n.addTextFontSizePt(_fontSize.round()),
                style: DocViewTypography.labelSm.copyWith(
                  color: tokens.primaryBlue,
                ),
              ),
            ],
          ),
          Slider(
            value: _fontSize,
            min: 8.0,
            max: 72.0,
            divisions: 64,
            activeColor: tokens.primaryBlue,
            onChanged: (val) {
              setState(() {
                _fontSize = val;
              });
              _notifyChange();
            },
          ),
          const SizedBox(height: 12),

          // Color swatches (>= 48dp hit targets)
          Text(
            l10n.addTextColor,
            style: DocViewTypography.labelSm.copyWith(
              color: tokens.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          ColorSwatchRow.colors(
            colors: TextStyleSheet.swatchColors,
            selectedColor: _color,
            onColorSelected: (c) {
              setState(() {
                _color = c;
              });
              _notifyChange();
            },
          ),
          const SizedBox(height: 16),

          // Style and Alignment row
          Row(
            children: [
              // Bold toggle
              Expanded(
                child: FilterChip(
                  label: Center(
                    child: Text(
                      l10n.addTextBold,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  selected: _isBold,
                  selectedColor: tokens.primaryBlue.withValues(alpha: 0.15),
                  checkmarkColor: tokens.primaryBlue,
                  onSelected: (val) {
                    setState(() {
                      _isBold = val;
                    });
                    _notifyChange();
                  },
                ),
              ),
              const SizedBox(width: 8),

              // Italic toggle
              Expanded(
                child: FilterChip(
                  label: Center(
                    child: Text(
                      l10n.addTextItalic,
                      style: const TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                  selected: _isItalic,
                  selectedColor: tokens.primaryBlue.withValues(alpha: 0.15),
                  checkmarkColor: tokens.primaryBlue,
                  onSelected: (val) {
                    setState(() {
                      _isItalic = val;
                    });
                    _notifyChange();
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Alignment segmented buttons (Start, Center, End)
          Text(
            l10n.addTextAlign,
            style: DocViewTypography.labelSm.copyWith(
              color: tokens.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          SegmentedButton<TextAlign>(
            segments: [
              ButtonSegment<TextAlign>(
                value: TextAlign.start,
                icon: const Icon(Icons.format_align_left_outlined),
                label: Text(l10n.addTextAlignStart),
              ),
              ButtonSegment<TextAlign>(
                value: TextAlign.center,
                icon: const Icon(Icons.format_align_center_outlined),
                label: Text(l10n.addTextAlignCenter),
              ),
              ButtonSegment<TextAlign>(
                value: TextAlign.end,
                icon: const Icon(Icons.format_align_right_outlined),
                label: Text(l10n.addTextAlignEnd),
              ),
            ],
            selected: {_alignment},
            onSelectionChanged: (newSelection) {
              setState(() {
                _alignment = newSelection.first;
              });
              _notifyChange();
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
