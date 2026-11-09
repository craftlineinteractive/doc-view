import 'package:flutter/material.dart';
import '../../../core/theme/doc_view_colors.dart';
import '../../../core/theme/doc_view_tokens.dart';
import '../../../core/theme/doc_view_typography.dart';

/// Bottom sheet with a grid of page NUMBER tiles (no thumbnails, no rendering)
/// allowing rapid jumping across PDF pages.
/// The currently viewed page is highlighted.
class PdfPagesSheet extends StatelessWidget {
  final int currentPage;
  final int pageCount;
  final ValueChanged<int> onPageSelected;

  const PdfPagesSheet({
    super.key,
    required this.currentPage,
    required this.pageCount,
    required this.onPageSelected,
  });

  static Future<void> show(
    BuildContext context, {
    required int currentPage,
    required int pageCount,
    required ValueChanged<int> onPageSelected,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PdfPagesSheet(
        currentPage: currentPage,
        pageCount: pageCount,
        onPageSelected: onPageSelected,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mediaQuery = MediaQuery.of(context);
    final maxHeight = mediaQuery.size.height * 0.75;

    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
      decoration: BoxDecoration(
        color: isDark ? DocViewColors.backgroundDark : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                decoration: BoxDecoration(
                  color: tokens.textSecondary.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pages',
                        style: DocViewTypography.headlineSm.copyWith(
                          color: tokens.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        '$pageCount pages in document',
                        style: DocViewTypography.bodySm.copyWith(
                          color: tokens.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: tokens.blueTint,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Page $currentPage',
                      style: DocViewTypography.labelXs.copyWith(
                        color: tokens.primaryBlue,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 12),

            // Number Grid
            Flexible(
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                itemCount: pageCount,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1.0,
                ),
                itemBuilder: (context, index) {
                  final pageNum = index + 1;
                  final isCurrent = pageNum == currentPage;

                  return Material(
                    color: isCurrent ? tokens.primaryBlue : tokens.surface,
                    borderRadius: BorderRadius.circular(14),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                        onPageSelected(pageNum);
                      },
                      borderRadius: BorderRadius.circular(14),
                      child: Center(
                        child: Text(
                          '$pageNum',
                          style: TextStyle(
                            fontFamily: 'SpaceGrotesk',
                            fontSize: 16,
                            fontWeight: isCurrent
                                ? FontWeight.w800
                                : FontWeight.w600,
                            color: isCurrent
                                ? Colors.white
                                : tokens.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

