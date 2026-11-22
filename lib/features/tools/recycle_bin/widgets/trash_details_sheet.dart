import 'package:flutter/material.dart';

import '../../../../core/extensions/l10n_extension.dart';
import '../../../../core/theme/doc_view_tokens.dart';
import '../../../../core/theme/doc_view_typography.dart';
import '../../../../core/utils/format_utils.dart';
import '../../../../data/models/trash_item.dart';
import '../../../../shared/widgets/tiles/file_thumbnail.dart';

/// Modal bottom sheet presenting full metadata for a [TrashItem].
class TrashDetailsSheet extends StatelessWidget {
  const TrashDetailsSheet({
    required this.item,
    super.key,
  });

  final TrashItem item;

  /// Convenience helper to display the details bottom sheet.
  static Future<void> show(BuildContext context, TrashItem item) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => TrashDetailsSheet(item: item),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = context.l10n;
    final deletedDate = DateTime.fromMillisecondsSinceEpoch(item.deletedMs);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                FileThumbnail(
                  filePath: item.trashPath,
                  category: item.category,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.originalName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: DocViewTypography.titleMd.copyWith(
                          color: tokens.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        FormatUtils.formatFileSize(item.sizeBytes),
                        style: DocViewTypography.bodySm.copyWith(
                          color: tokens.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Divider(color: tokens.hairline, height: 1),
            const SizedBox(height: 12),
            _buildDetailRow(
              context,
              label: l10n.fileDetailsLabelType,
              value: item.extension.toUpperCase(),
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              context,
              label: l10n.fileDetailsLabelModified,
              value: FormatUtils.formatDate(
                DateTime.fromMillisecondsSinceEpoch(item.originalModifiedMs),
              ),
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              context,
              label: l10n.trashDetailsOriginalLocation,
              value: item.originalPath,
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              context,
              label: l10n.trashDetailsDateDeleted,
              value: FormatUtils.formatDate(deletedDate),
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              context,
              label: l10n.trashDetailsExpiresIn,
              value: l10n.trashDaysLeft(item.daysLeft()),
              isWarning: item.isExpiringSoon(),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required String label,
    required String value,
    bool isWarning = false,
  }) {
    final tokens = context.tokens;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: DocViewTypography.captionXs.copyWith(
            color: tokens.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: DocViewTypography.bodyMd.copyWith(
            color: isWarning ? tokens.error : tokens.textPrimary,
            fontWeight: isWarning ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
