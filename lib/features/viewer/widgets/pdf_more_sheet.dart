import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_filex/open_filex.dart';

import '../../../core/theme/doc_view_colors.dart';
import '../../../core/theme/doc_view_tokens.dart';
import '../../../core/theme/doc_view_typography.dart';
import '../../../core/utils/format_utils.dart';
import '../../../data/models/doc_file.dart';
import '../../../shared/widgets/tiles/file_type_badge.dart';
import '../../files/widgets/file_details_sheet.dart';
import '../../providers/providers.dart';

/// PDF reader contextual More bottom sheet matching strict owner decisions.
/// Exactly 4 actions: Share, Open in another app, Details, Add/Remove bookmark.
class PdfMoreSheet extends ConsumerWidget {
  final DocFile file;
  final int? pageCount;

  const PdfMoreSheet({
    super.key,
    required this.file,
    this.pageCount,
  });

  static Future<void> show(
    BuildContext context, {
    required DocFile file,
    int? pageCount,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PdfMoreSheet(
        file: file,
        pageCount: pageCount,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.tokens;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Watch filesProvider for live bookmark state
    final filesAsync = ref.watch(filesProvider(null));
    final liveFile = filesAsync.value
            ?.where((f) => f.path == file.path)
            .firstOrNull ??
        file;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? DocViewColors.backgroundDark : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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

              // File preview header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    FileTypeBadge(
                      category: liveFile.category,
                      size: BadgeSize.large,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            liveFile.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: DocViewTypography.titleMd.copyWith(
                              color: tokens.textPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            FormatUtils.formatSubtitle(
                              liveFile.modified,
                              liveFile.sizeBytes,
                            ),
                            style: DocViewTypography.bodySm.copyWith(
                              color: tokens.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 12),

              // 1. Share
              _MoreOptionTile(
                icon: Icons.share_outlined,
                label: 'Share',
                onTap: () {
                  Navigator.of(context).pop();
                  ref.read(fileActionsControllerProvider).shareFiles([liveFile]);
                },
              ),

              // 2. Open in another app
              _MoreOptionTile(
                icon: Icons.launch_outlined,
                label: 'Open in another app',
                onTap: () async {
                  Navigator.of(context).pop();
                  final result = await OpenFilex.open(liveFile.path);
                  if (result.type != ResultType.done && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Could not open in external application'),
                      ),
                    );
                  }
                },
              ),

              // 3. Details
              _MoreOptionTile(
                icon: Icons.info_outline_rounded,
                label: 'Details',
                onTap: () {
                  Navigator.of(context).pop();
                  FileDetailsSheet.show(
                    context,
                    liveFile,
                    pageCount: pageCount,
                    showOpenButton: false,
                  );
                },
              ),

              // 4. Add / Remove bookmark
              _MoreOptionTile(
                icon: liveFile.isBookmarked
                    ? Icons.bookmark_rounded
                    : Icons.bookmark_border_rounded,
                iconColor: liveFile.isBookmarked ? tokens.primaryBlue : null,
                label: liveFile.isBookmarked
                    ? 'Remove bookmark'
                    : 'Add bookmark',
                onTap: () {
                  Navigator.of(context).pop();
                  ref
                      .read(fileActionsControllerProvider)
                      .toggleBookmark(liveFile);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MoreOptionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? iconColor;
  final VoidCallback onTap;

  const _MoreOptionTile({
    required this.icon,
    required this.label,
    this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              Icon(
                icon,
                size: 22,
                color: iconColor ?? tokens.textPrimary,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: DocViewTypography.bodyLg.copyWith(
                    color: tokens.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Generic alias for all viewers (PDF, Office, Image, TXT)
typedef ViewerMoreSheet = PdfMoreSheet;

