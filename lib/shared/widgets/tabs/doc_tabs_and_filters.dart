import 'package:flutter/material.dart';
import '../../../core/constants/file_types.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/doc_view_tokens.dart';
import '../../../core/theme/doc_view_typography.dart';

/// Underline tab bar for switching between "Recent" and "Bookmarks"
/// with a 3pt active pill indicator and item count badges.
class DocUnderlineTabs extends StatelessWidget {
  final int selectedIndex;
  final int recentCount;
  final int bookmarksCount;
  final ValueChanged<int> onTabSelected;
  final Widget? trailing;

  const DocUnderlineTabs({
    super.key,
    required this.selectedIndex,
    required this.recentCount,
    required this.bookmarksCount,
    required this.onTabSelected,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeColor = isDark ? tokens.interactiveBlue : tokens.primaryBlue;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: tokens.hairline, width: 1),
        ),
      ),
      child: Row(
        children: [
          _TabItem(
            label: 'Recent',
            count: recentCount,
            isSelected: selectedIndex == 0,
            activeColor: activeColor,
            onTap: () => onTabSelected(0),
          ),
          _TabItem(
            label: 'Bookmarks',
            count: bookmarksCount,
            isSelected: selectedIndex == 1,
            activeColor: activeColor,
            onTap: () => onTabSelected(1),
          ),
          if (trailing != null) ...[
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: trailing!,
            ),
          ],
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final String label;
  final int count;
  final bool isSelected;
  final Color activeColor;
  final VoidCallback onTap;

  const _TabItem({
    required this.label,
    required this.count,
    required this.isSelected,
    required this.activeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 11, bottom: 9),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      label,
                      style: DocViewTypography.titleMd.copyWith(
                        fontSize: 15,
                        color: isSelected ? activeColor : tokens.textSecondary,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: isSelected ? tokens.blueTint : tokens.surface,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '$count',
                        style: DocViewTypography.labelXs.copyWith(
                          color: isSelected ? activeColor : tokens.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 3,
                decoration: BoxDecoration(
                  color: isSelected ? activeColor : Colors.transparent,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(3)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Horizontally scrollable row of rounded filter chips:
/// All, PDF, Word, Excel, PPT, TXT, Image.
class DocFilterChipRow extends StatelessWidget {
  final FileCategory? selectedCategory;
  final Map<FileCategory, int>? counts;
  final ValueChanged<FileCategory?> onSelected;

  const DocFilterChipRow({
    super.key,
    required this.selectedCategory,
    this.counts,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final categories = [
      null, // All
      FileCategory.pdf,
      FileCategory.word,
      FileCategory.excel,
      FileCategory.ppt,
      FileCategory.txt,
      FileCategory.image,
    ];

    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category == selectedCategory;
          final label = category == null ? 'All' : category.label;
          final count = category != null && counts != null ? counts![category] : null;

          Color? dotColor;
          if (category != null) {
            dotColor = tokens.categoryColors(category).solid;
          }

          return GestureDetector(
            onTap: () => onSelected(category),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? tokens.primaryBlue : tokens.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? tokens.primaryBlue : tokens.hairline,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (dotColor != null) ...[
                    Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.only(right: 6),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.white : dotColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                  Text(
                    count != null ? '$label ($count)' : label,
                    style: DocViewTypography.labelMd.copyWith(
                      color: isSelected ? Colors.white : tokens.textPrimary,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Horizontally scrollable breadcrumb bar for folder navigation.
class DocBreadcrumbBar extends StatelessWidget {
  final List<String> pathSegments;
  final ValueChanged<int> onSegmentTap;

  const DocBreadcrumbBar({
    super.key,
    required this.pathSegments,
    required this.onSegmentTap,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: tokens.surfaceAlt,
        border: Border(
          bottom: BorderSide(color: tokens.hairline, width: 1),
        ),
      ),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: pathSegments.length,
        separatorBuilder: (_, _) => Icon(
          AppIcons.chevronRight,
          size: 16,
          color: tokens.textSecondary,
        ),
        itemBuilder: (context, index) {
          final isLast = index == pathSegments.length - 1;
          final segment = pathSegments[index];

          return Center(
            child: GestureDetector(
              onTap: isLast ? null : () => onSegmentTap(index),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                child: Text(
                  segment,
                  style: DocViewTypography.labelMd.copyWith(
                    color: isLast ? tokens.textPrimary : tokens.interactiveBlue,
                    fontWeight: isLast ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

