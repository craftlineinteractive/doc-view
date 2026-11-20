import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions/l10n_extension.dart';
import '../../../core/theme/doc_view_tokens.dart';
import '../../../core/theme/doc_view_typography.dart';
import '../../../core/utils/format_utils.dart';
import '../../../data/models/trash_item.dart';
import '../../../shared/widgets/navigation/doc_app_bar.dart';
import '../../../shared/widgets/navigation/doc_scaffold.dart';
import '../../../shared/widgets/skeletons/skeleton_variants.dart';
import '../../../shared/widgets/status/doc_status_widgets.dart';
import '../../../shared/widgets/tiles/file_and_folder_rows.dart';
import '../../providers/providers.dart';
import 'widgets/trash_options_sheet.dart';

/// Screen displaying files moved to the Recycle bin with restore and delete-forever actions.
class RecycleBinScreen extends ConsumerStatefulWidget {
  const RecycleBinScreen({super.key});

  @override
  ConsumerState<RecycleBinScreen> createState() => _RecycleBinScreenState();
}

class _RecycleBinScreenState extends ConsumerState<RecycleBinScreen> {
  bool _isBannerDismissed = false;
  bool _isSelectionMode = false;
  final Set<String> _selectedIds = <String>{};

  Widget _buildDaysLeftBadge(BuildContext context, TrashItem item) {
    final tokens = context.tokens;
    final daysLeft = item.daysLeft();
    final isExpiringSoon = item.isExpiringSoon();

    final backgroundColor = isExpiringSoon
        ? tokens.error.withValues(alpha: 0.12)
        : tokens.surfaceAlt;
    final textColor = isExpiringSoon ? tokens.error : tokens.textSecondary;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 110),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isExpiringSoon
                ? tokens.error.withValues(alpha: 0.3)
                : tokens.hairline,
            width: 1,
          ),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            context.l10n.trashDaysLeft(daysLeft),
            maxLines: 1,
            style: DocViewTypography.captionXs.copyWith(
              color: textColor,
              fontWeight: isExpiringSoon ? FontWeight.w700 : FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  void _showEmptyBinDialog(BuildContext context, int itemCount) {
    final tokens = context.tokens;
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.trashDialogEmptyTitle),
          content: Text(l10n.trashDialogEmptyBody(itemCount)),
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
                final count = await ref
                    .read(fileActionsControllerProvider)
                    .emptyTrash();

                if (!mounted) return;
                setState(() {
                  _isSelectionMode = false;
                  _selectedIds.clear();
                });

                messenger.showSnackBar(
                  SnackBar(content: Text(l10n.trashDeletedForeverSuccess(count))),
                );
              },
              child: Text(l10n.trashActionEmptyBin),
            ),
          ],
        );
      },
    );
  }

  Future<void> _restoreSelected(
    BuildContext context,
    List<TrashItem> itemsToRestore,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.l10n;

    final restored = await ref
        .read(fileActionsControllerProvider)
        .restoreFromTrash(itemsToRestore);

    if (!mounted) return;
    setState(() {
      _isSelectionMode = false;
      _selectedIds.clear();
    });

    if (restored.isNotEmpty) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.trashRestoredSuccess(restored.length))),
      );
    }
  }

  void _confirmDeleteForeverSelected(
    BuildContext context,
    List<TrashItem> itemsToDelete,
  ) {
    final tokens = context.tokens;
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.trashDialogDeleteForeverTitle),
          content: Text(l10n.trashDialogDeleteForeverBody(itemsToDelete.length)),
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
                    .deleteForeverFromTrash(itemsToDelete);

                if (!mounted) return;
                setState(() {
                  _isSelectionMode = false;
                  _selectedIds.clear();
                });

                messenger.showSnackBar(
                  SnackBar(content: Text(l10n.trashDeletedForeverSuccess(itemsToDelete.length))),
                );
              },
              child: Text(l10n.trashActionDeleteForever),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSelectionBottomBar(
    BuildContext context,
    List<TrashItem> selectedItems,
  ) {
    final tokens = context.tokens;
    final l10n = context.l10n;

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: tokens.surface,
          border: Border(
            top: BorderSide(color: tokens.hairline, width: 1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: FilledButton.tonalIcon(
                onPressed: () => _restoreSelected(context, selectedItems),
                icon: const Icon(Icons.restore, size: 20),
                label: Text(l10n.trashSheetRestore),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton.icon(
                onPressed: () => _confirmDeleteForeverSelected(context, selectedItems),
                icon: const Icon(Icons.delete_forever_outlined, size: 20),
                label: Text(l10n.trashActionDeleteForever),
                style: FilledButton.styleFrom(
                  backgroundColor: tokens.error,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = context.l10n;
    final trashItemsAsync = ref.watch(trashItemsProvider);

    return trashItemsAsync.when(
      loading: () => DocScaffold(
        showDockedBanner: false,
        isAdLoaded: false,
        appBar: DocSubAppBar(
          title: l10n.toolRecycleBin,
        ),
        body: const SkeletonFileList(itemCount: 8),
      ),
      error: (err, _) => DocScaffold(
        showDockedBanner: false,
        isAdLoaded: false,
        appBar: DocSubAppBar(
          title: l10n.toolRecycleBin,
        ),
        body: Center(
          child: Text(
            err.toString(),
            style: TextStyle(color: tokens.textSecondary),
          ),
        ),
      ),
      data: (items) {
        // Sync selection state if items changed externally
        final validIds = items.map((i) => i.id).toSet();
        _selectedIds.removeWhere((id) => !validIds.contains(id));
        if (items.isEmpty && _isSelectionMode) {
          _isSelectionMode = false;
        }

        final selectedItems = items
            .where((item) => _selectedIds.contains(item.id))
            .toList();

        final PreferredSizeWidget appBar = _isSelectionMode
            ? DocSelectionAppBar(
                selectedCount: _selectedIds.length,
                totalCount: items.length,
                onSelectAll: () {
                  setState(() {
                    if (_selectedIds.length == items.length) {
                      _selectedIds.clear();
                    } else {
                      _selectedIds.addAll(items.map((i) => i.id));
                    }
                  });
                },
                onCancel: () {
                  setState(() {
                    _isSelectionMode = false;
                    _selectedIds.clear();
                  });
                },
              )
            : DocSubAppBar(
                title: l10n.toolRecycleBin,
                actions: [
                  if (items.isNotEmpty)
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 120),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: () => _showEmptyBinDialog(context, items.length),
                          child: Text(
                            l10n.trashActionEmptyBin,
                            style: DocViewTypography.labelMd.copyWith(
                              color: tokens.error,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(width: 4),
                ],
              );

        return DocScaffold(
          showDockedBanner: false,
          isAdLoaded: false,
          appBar: appBar,
          bottomNavigationBar: _isSelectionMode && _selectedIds.isNotEmpty
              ? _buildSelectionBottomBar(context, selectedItems)
              : null,
          body: Column(
            children: [
              if (!_isBannerDismissed)
                InfoBanner(
                  message: l10n.trashInfoBanner,
                  trailing: IconButton(
                    icon: const Icon(Icons.close, size: 18),
                    tooltip: l10n.tooltipClose,
                    onPressed: () {
                      setState(() {
                        _isBannerDismissed = true;
                      });
                    },
                  ),
                ),
              Expanded(
                child: items.isEmpty
                    ? DocEmptyState(
                        icon: Icons.restore_from_trash_outlined,
                        title: l10n.trashEmptyTitle,
                        message: l10n.trashEmptySubtitle,
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: items.length,
                        separatorBuilder: (context, index) => Divider(
                          height: 1,
                          thickness: 1,
                          indent: 78,
                          color: tokens.hairline,
                        ),
                        itemBuilder: (context, index) {
                          final item = items[index];
                          final deletedDate = DateTime.fromMillisecondsSinceEpoch(
                            item.deletedMs,
                          );
                          final metadata = l10n.trashSubtitle(
                            FormatUtils.formatDate(deletedDate),
                            FormatUtils.formatFileSize(item.sizeBytes),
                          );

                          return FileRow(
                            key: ValueKey('trash_item_${item.id}'),
                            title: item.originalName,
                            metadata: metadata,
                            category: item.category,
                            filePath: item.trashPath,
                            isSelectionMode: _isSelectionMode,
                            isSelected: _selectedIds.contains(item.id),
                            trailing: _buildDaysLeftBadge(context, item),
                            onTap: () {
                              if (_isSelectionMode) {
                                setState(() {
                                  if (_selectedIds.contains(item.id)) {
                                    _selectedIds.remove(item.id);
                                  } else {
                                    _selectedIds.add(item.id);
                                  }
                                });
                              } else {
                                TrashOptionsSheet.show(context, item);
                              }
                            },
                            onLongPress: () {
                              if (!_isSelectionMode) {
                                setState(() {
                                  _isSelectionMode = true;
                                  _selectedIds.add(item.id);
                                });
                              }
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
