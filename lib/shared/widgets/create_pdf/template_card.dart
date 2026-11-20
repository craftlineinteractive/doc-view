import 'package:flutter/material.dart';

import '../../../core/theme/doc_view_tokens.dart';
import '../../../core/theme/doc_view_typography.dart';
import '../../../features/tools/create_pdf/paper_template.dart';
import 'paper_preview.dart';

/// Selectable thumbnail card displaying a paper template pattern and label.
class TemplateCard extends StatelessWidget {
  const TemplateCard({
    required this.template,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.colorSwatch = PaperColorSwatch.white,
    this.pageSize = PaperPageSize.a4,
    this.orientation = PaperOrientation.portrait,
    super.key,
  });

  final PaperTemplate template;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final PaperColorSwatch colorSwatch;
  final PaperPageSize pageSize;
  final PaperOrientation orientation;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Semantics(
      button: true,
      selected: isSelected,
      label: label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 80,
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? tokens.primaryBlue.withValues(alpha: 0.08)
                  : tokens.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? tokens.primaryBlue : tokens.hairline,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 64,
                  width: 48,
                  child: PaperPreview(
                    template: template,
                    pageSize: pageSize,
                    orientation: orientation,
                    colorSwatch: colorSwatch,
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: const [],
                    isThumbnail: true,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: DocViewTypography.captionXs.copyWith(
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? tokens.primaryBlue : tokens.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
