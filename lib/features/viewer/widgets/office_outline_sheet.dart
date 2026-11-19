import 'package:flutter/material.dart';

import '../../../core/extensions/l10n_extension.dart';
import '../../../core/theme/doc_view_colors.dart';
import '../../../core/theme/doc_view_tokens.dart';
import '../../../core/theme/doc_view_typography.dart';

/// Modal bottom sheet displaying document outline / table of contents.
class OfficeOutlineSheet extends StatelessWidget {
  const OfficeOutlineSheet({
    required this.outline,
    this.currentPosition,
    this.onSectionSelected,
    super.key,
  });

  final List<String> outline;
  final int? currentPosition;
  final ValueChanged<int>? onSectionSelected;

  static Future<void> show(
    BuildContext context, {
    required List<String> outline,
    int? currentPosition,
    ValueChanged<int>? onSectionSelected,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => OfficeOutlineSheet(
        outline: outline,
        currentPosition: currentPosition,
        onSectionSelected: onSectionSelected,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = context.l10n;

    return Material(
      color: isDark ? DocViewColors.backgroundDark : Colors.white,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      clipBehavior: Clip.antiAlias,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.75,
        ),
        child: MediaQuery.withClampedTextScaling(
          maxScaleFactor: 1.3,
          child: SafeArea(
            top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  Icon(
                    Icons.list_alt_rounded,
                    size: 22,
                    color: tokens.primaryBlue,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      l10n.viewerOutlineTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: DocViewTypography.titleMd.copyWith(
                        color: tokens.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: tokens.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      l10n.viewerOutlineItemsCount(outline.length),
                      style: DocViewTypography.captionXs.copyWith(
                        color: tokens.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: tokens.hairline),
            if (outline.isEmpty)
              Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  l10n.viewerNoSections,
                  style: DocViewTypography.bodyMd.copyWith(
                    color: tokens.textSecondary,
                  ),
                ),
              )
            else
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: outline.length,
                  itemBuilder: (context, index) {
                    final title = outline[index].trim();
                    final isCurrent = index == currentPosition;

                    return ConstrainedBox(
                      constraints: const BoxConstraints(minHeight: 48),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 2,
                        ),
                        leading: Container(
                          width: 28,
                          height: 28,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isCurrent
                                ? tokens.primaryBlue
                                : tokens.surface,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: isCurrent
                                  ? Colors.white
                                  : tokens.textSecondary,
                            ),
                          ),
                        ),
                        title: Text(
                          title.isEmpty
                              ? l10n.viewerSectionTitle(index + 1)
                              : title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: DocViewTypography.bodyMd.copyWith(
                            color: isCurrent
                                ? tokens.primaryBlue
                                : tokens.textPrimary,
                            fontWeight: isCurrent
                                ? FontWeight.w700
                                : FontWeight.w500,
                          ),
                        ),
                        trailing: isCurrent
                            ? Icon(
                                Icons.check_circle_rounded,
                                size: 18,
                                color: tokens.primaryBlue,
                              )
                            : null,
                        onTap: () {
                          onSectionSelected?.call(index);
                          Navigator.of(context).pop();
                        },
                      ),
                    );
                  },
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
