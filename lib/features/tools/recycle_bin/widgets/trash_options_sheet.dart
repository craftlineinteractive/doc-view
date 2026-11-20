import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/l10n_extension.dart';
import '../../../../core/theme/doc_view_tokens.dart';
import '../../../../core/theme/doc_view_typography.dart';
import '../../../../core/utils/format_utils.dart';
import '../../../../data/models/trash_item.dart';
import '../../../../shared/widgets/tiles/file_thumbnail.dart';
import '../../../providers/providers.dart';
import 'trash_details_sheet.dart';

/// Contextual bottom sheet presenting actions (Restore, Delete forever, Details) for a [TrashItem].
class TrashOptionsSheet extends ConsumerWidget {
  const TrashOptionsSheet({
    required this.item,
    this.parentContext,
    super.key,
  });

  final TrashItem item;
  final BuildContext? parentContext;

  /// Convenience method to show the trash options bottom sheet.
  static Future<void> show(BuildContext context, TrashItem item) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => TrashOptionsSheet(
        item: item,
        parentContext: context,
      ),
    );
  }

  void _onRestore(BuildContext context, WidgetRef ref) async {
    final targetContext = parentContext ?? context;
    final messenger = ScaffoldMessenger.of(targetContext);
    final l10n = targetContext.l10n;

    Navigator.of(context).pop();

    final restored = await ref
        .read(fileActionsControllerProvider)
        .restoreFromTrash([item]);

    if (!targetContext.mounted) return;
    if (restored.isNotEmpty) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.trashRestoredSuccess(1))),
      );
    }
  }

  void _onDeleteForever(BuildContext context, WidgetRef ref) {
    final targetContext = parentContext ?? context;
    final messenger = ScaffoldMessenger.of(targetContext);
    final l10n = targetContext.l10n;
    final tokens = targetContext.tokens;

    Navigator.of(context).pop();

    showDialog<void>(
      context: targetContext,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.trashDialogDeleteForeverTitle),
          content: Text(l10n.trashDialogDeleteForeverBody(1)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(l10n.actionCancel),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: tokens.error,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                await ref
                    .read(fileActionsControllerProvider)
                    .deleteForeverFromTrash([item]);

                if (!targetContext.mounted) return;
                messenger.showSnackBar(
                  SnackBar(content: Text(l10n.trashDeletedForeverSuccess(1))),
                );
              },
              child: Text(l10n.trashActionDeleteForever),
            ),
          ],
        );
      },
    );
  }

  void _onDetails(BuildContext context) {
    final targetContext = parentContext ?? context;
    Navigator.of(context).pop();
    TrashDetailsSheet.show(targetContext, item);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.tokens;
    final l10n = context.l10n;
    final deletedDate = DateTime.fromMillisecondsSinceEpoch(item.deletedMs);
    final subtitle = l10n.trashSubtitle(
      FormatUtils.formatDate(deletedDate),
      FormatUtils.formatFileSize(item.sizeBytes),
    );

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: [
                  FileThumbnail(
                    filePath: item.trashPath,
                    category: item.category,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.originalName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: DocViewTypography.titleMd.copyWith(
                            fontWeight: FontWeight.w600,
                            color: tokens.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
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
            const SizedBox(height: 8),
            Divider(color: tokens.hairline, height: 1),
            _ActionTile(
              icon: Icons.restore_outlined,
              label: l10n.trashSheetRestore,
              onTap: () => _onRestore(context, ref),
            ),
            _ActionTile(
              icon: Icons.delete_forever_outlined,
              label: l10n.trashSheetDeleteForever,
              textColor: tokens.error,
              iconColor: tokens.error,
              onTap: () => _onDeleteForever(context, ref),
            ),
            _ActionTile(
              icon: Icons.info_outline,
              label: l10n.trashSheetDetails,
              onTap: () => _onDetails(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.iconColor,
    this.textColor,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return InkWell(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 48),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            children: [
              Icon(
                icon,
                size: 22,
                color: iconColor ?? tokens.textSecondary,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: DocViewTypography.bodyMd.copyWith(
                    color: textColor ?? tokens.textPrimary,
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
