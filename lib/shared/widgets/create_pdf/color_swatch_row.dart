import 'package:flutter/material.dart';

import '../../../core/theme/doc_view_tokens.dart';
import '../../../features/tools/create_pdf/paper_template.dart';

/// Row of color swatches allowing users to pick page background color.
class ColorSwatchRow extends StatelessWidget {
  const ColorSwatchRow({
    required this.selectedSwatch,
    required this.onSwatchSelected,
    required this.labelBuilder,
    super.key,
  });

  final PaperColorSwatch selectedSwatch;
  final ValueChanged<PaperColorSwatch> onSwatchSelected;
  final String Function(PaperColorSwatch swatch) labelBuilder;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: PaperColorSwatch.values.map((swatch) {
          final isSelected = swatch == selectedSwatch;
          final localizedName = labelBuilder(swatch);

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Semantics(
              button: true,
              selected: isSelected,
              label: localizedName,
              child: InkWell(
                onTap: () => onSwatchSelected(swatch),
                borderRadius: BorderRadius.circular(24),
                child: SizedBox(
                  width: 48,
                  height: 48,
                  child: Center(
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Color(swatch.colorValue),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? tokens.primaryBlue
                              : tokens.hairline,
                          width: isSelected ? 2.5 : 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: isSelected
                          ? Center(
                              child: Icon(
                                Icons.check,
                                size: 18,
                                color: (swatch == PaperColorSwatch.white ||
                                        swatch == PaperColorSwatch.cream ||
                                        swatch == PaperColorSwatch.lightYellow)
                                    ? tokens.primaryBlue
                                    : Colors.black87,
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
