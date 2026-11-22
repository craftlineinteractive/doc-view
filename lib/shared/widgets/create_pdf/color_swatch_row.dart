import 'package:flutter/material.dart';

import '../../../core/theme/doc_view_tokens.dart';
import '../../../features/tools/create_pdf/paper_template.dart';

/// Row of color swatches allowing users to pick page background or annotation color.
class ColorSwatchRow extends StatelessWidget {
  const ColorSwatchRow({
    required this.selectedSwatch,
    required this.onSwatchSelected,
    required this.labelBuilder,
    super.key,
  })  : colors = null,
        selectedColor = null,
        onColorSelected = null,
        colorLabelBuilder = null;

  const ColorSwatchRow.colors({
    required this.colors,
    required this.selectedColor,
    required this.onColorSelected,
    String Function(Color color)? labelBuilder,
    super.key,
  })  : selectedSwatch = null,
        onSwatchSelected = null,
        labelBuilder = null,
        colorLabelBuilder = labelBuilder;

  final PaperColorSwatch? selectedSwatch;
  final ValueChanged<PaperColorSwatch>? onSwatchSelected;
  final String Function(PaperColorSwatch swatch)? labelBuilder;

  final List<Color>? colors;
  final Color? selectedColor;
  final ValueChanged<Color>? onColorSelected;
  final String Function(Color color)? colorLabelBuilder;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    final items = colors != null
        ? colors!.map((c) => _SwatchItem(
              color: c,
              isSelected: c == selectedColor,
              label: colorLabelBuilder?.call(c) ?? '',
              onTap: () => onColorSelected?.call(c),
            ))
        : (PaperColorSwatch.values).map((s) => _SwatchItem(
              color: Color(s.colorValue),
              isSelected: s == selectedSwatch,
              label: labelBuilder?.call(s) ?? '',
              onTap: () => onSwatchSelected?.call(s),
            ));

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: items.map((item) {
          final isLight = item.color.computeLuminance() > 0.65;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Semantics(
              button: true,
              selected: item.isSelected,
              label: item.label,
              child: InkWell(
                onTap: item.onTap,
                borderRadius: BorderRadius.circular(24),
                child: SizedBox(
                  width: 48,
                  height: 48,
                  child: Center(
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: item.color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: item.isSelected
                              ? tokens.primaryBlue
                              : tokens.hairline,
                          width: item.isSelected ? 2.5 : 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: item.isSelected
                          ? Center(
                              child: Icon(
                                Icons.check,
                                size: 18,
                                color: isLight
                                    ? tokens.primaryBlue
                                    : Colors.white,
                              ),
                            )
                          : null,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _SwatchItem {
  final Color color;
  final bool isSelected;
  final String label;
  final VoidCallback onTap;

  const _SwatchItem({
    required this.color,
    required this.isSelected,
    required this.label,
    required this.onTap,
  });
}
