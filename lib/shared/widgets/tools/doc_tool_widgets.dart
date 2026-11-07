import 'package:flutter/material.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/doc_view_tokens.dart';
import '../../../core/theme/doc_view_typography.dart';
import '../buttons/doc_icon_button.dart';

/// Interactive tool card on the Tools tab with glossy gradient icon badge.
class ToolCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final LinearGradient gradient;
  final VoidCallback onTap;

  const ToolCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Semantics(
      button: true,
      label: '$title, $description',
      child: Material(
        color: tokens.surface,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: tokens.hairline, width: 1),
            ),
            child: Row(
              children: [
                // Glossy gradient container
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    gradient: gradient,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: gradient.colors.first.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Icon(icon, size: 28, color: Colors.white),
                ),
                const SizedBox(width: 16),
                // Titles
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: DocViewTypography.headlineSm.copyWith(
                          fontSize: 16,
                          color: tokens.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: DocViewTypography.bodySm.copyWith(
                          color: tokens.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(AppIcons.chevronRight, size: 20, color: tokens.textSecondary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Reorderable page row in Image to PDF and Merge PDF builders.
class ReorderablePageRow extends StatelessWidget {
  final int index;
  final Widget preview;
  final String label;
  final VoidCallback onRemove;
  final VoidCallback? onRotate;

  const ReorderablePageRow({
    super.key,
    required this.index,
    required this.preview,
    required this.label,
    required this.onRemove,
    this.onRotate,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Container(
      height: 72,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: tokens.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: tokens.hairline, width: 1),
      ),
      child: Row(
        children: [
          // Drag handle
          Icon(AppIcons.dragHandle, color: tokens.textSecondary, size: 22),
          const SizedBox(width: 12),
          // Page preview
          SizedBox(
            width: 44,
            height: 56,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: preview,
            ),
          ),
          const SizedBox(width: 14),
          // Label
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Page ${index + 1}',
                  style: DocViewTypography.labelMd.copyWith(color: tokens.textPrimary),
                ),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: DocViewTypography.bodySm.copyWith(color: tokens.textSecondary),
                ),
              ],
            ),
          ),
          if (onRotate != null)
            DocIconButton(
              icon: AppIcons.rotate,
              tooltip: 'Rotate page',
              size: 20,
              onPressed: onRotate,
            ),
          DocIconButton(
            icon: AppIcons.close,
            tooltip: 'Remove page',
            size: 20,
            onPressed: onRemove,
          ),
        ],
      ),
    );
  }
}

/// Dashed outline card for adding additional images or documents.
class DashedAddCard extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const DashedAddCard({
    super.key,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 64,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: tokens.surface.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: tokens.primaryBlue.withValues(alpha: 0.4),
              width: 1.5,
              style: BorderStyle.solid,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(AppIcons.add, size: 22, color: tokens.primaryBlue),
              const SizedBox(width: 8),
              Text(
                label,
                style: DocViewTypography.labelMd.copyWith(
                  color: tokens.primaryBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Elongated page indicator for the 3-step onboarding flow.
class OnboardingPageIndicator extends StatelessWidget {
  final int currentPage;
  final int totalPages;

  const OnboardingPageIndicator({
    super.key,
    required this.currentPage,
    this.totalPages = 3,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalPages, (index) {
        final isActive = index == currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 24 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: isActive ? tokens.primaryBlue : tokens.hairline,
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }
}

