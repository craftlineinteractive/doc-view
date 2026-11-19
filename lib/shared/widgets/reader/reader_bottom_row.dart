import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../core/theme/doc_view_tokens.dart';
import '../../../core/theme/doc_view_typography.dart';
import '../skeletons/shimmer.dart';

/// Specification for a single action button inside [ReaderBottomRow].
class ReaderBottomRowItem {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool isSelected;
  final bool isEnabled;
  final String? tooltip;
  final String? semanticLabel;
  final Key? key;

  const ReaderBottomRowItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isSelected = false,
    this.isEnabled = true,
    this.tooltip,
    this.semanticLabel,
    this.key,
  });
}

/// Floating bottom toolbar for document viewers (PDF, TXT, etc.).
///
/// Features:
/// - 64pt fixed height with translucent blurred backdrop and 24pt radius.
/// - Outlined icon + label layout with >= 48x48 accessible touch targets.
/// - Active/selected styling (e.g. for Color Invert toggle).
/// - Skeleton placeholder state via [isLoading].
/// - Reduced-motion aware and RTL reading-direction compliant.
class ReaderBottomRow extends StatelessWidget {
  final List<ReaderBottomRowItem> items;
  final bool isLoading;

  const ReaderBottomRow({
    super.key,
    required this.items,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = (isDark
            ? const Color(0xEB232838)
            : const Color(0xF5FFFFFF))
        .withValues(alpha: 0.94);

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: tokens.hairline.withValues(alpha: 0.7),
              width: 0.75,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1F000000),
                blurRadius: 18,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: isLoading
              ? _buildSkeleton(tokens)
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: items.map((item) {
                    return Expanded(
                      child: _ReaderBottomRowButton(
                        item: item,
                        tokens: tokens,
                      ),
                    );
                  }).toList(),
                ),
        ),
      ),
    );
  }

  Widget _buildSkeleton(DocViewTokens tokens) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(5, (index) {
        return const Expanded(
          child: Center(
            child: Shimmer(
              child: SkeletonBox(
                width: 44,
                height: 44,
                borderRadius: 12,
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _ReaderBottomRowButton extends StatelessWidget {
  final ReaderBottomRowItem item;
  final DocViewTokens tokens;

  const _ReaderBottomRowButton({
    required this.item,
    required this.tokens,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = item.isEnabled && item.onTap != null;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final activeColor = tokens.primaryBlue;
    final inactiveColor = enabled
        ? tokens.textPrimary
        : tokens.textSecondary.withValues(alpha: 0.4);

    final selectedBg = isDark
        ? activeColor.withValues(alpha: 0.22)
        : activeColor.withValues(alpha: 0.12);

    final effectiveColor = item.isSelected ? activeColor : inactiveColor;

    Widget content = Semantics(
      button: true,
      enabled: enabled,
      selected: item.isSelected,
      label: item.semanticLabel ?? item.label,
      tooltip: item.tooltip,
      child: Material(
        color: item.isSelected ? selectedBg : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          key: item.key,
          borderRadius: BorderRadius.circular(16),
          onTap: enabled ? item.onTap : null,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 48, minWidth: 48),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    item.icon,
                    size: 22,
                    color: effectiveColor,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    item.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: DocViewTypography.captionXs.copyWith(
                      color: effectiveColor,
                      fontSize: 10.5,
                      fontWeight: item.isSelected
                          ? FontWeight.w700
                          : FontWeight.w500,
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    if (item.tooltip != null && item.tooltip!.isNotEmpty) {
      content = Tooltip(
        message: item.tooltip!,
        child: content,
      );
    }

    return content;
  }
}
