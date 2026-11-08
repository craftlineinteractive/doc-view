import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/file_types.dart';
import '../../core/theme/app_icons.dart';
import '../../core/theme/doc_view_colors.dart';
import '../../core/theme/doc_view_tokens.dart';
import '../../core/theme/doc_view_typography.dart';
import '../../core/utils/format_utils.dart';
import '../../data/models/doc_file.dart';
import '../../shared/widgets/ads/ad_placeholders.dart';
import '../../shared/widgets/buttons/doc_icon_button.dart';
import '../../shared/widgets/navigation/doc_app_bar.dart';
import '../../shared/widgets/navigation/doc_scaffold.dart';
import '../../shared/widgets/skeletons/skeleton_variants.dart';
import '../../shared/widgets/status/doc_status_widgets.dart';
import '../../shared/widgets/tiles/file_and_folder_rows.dart';
import '../providers/providers.dart';
import 'controllers/selection_controller.dart';
import 'open_document.dart';
import 'widgets/file_options_sheet.dart';
import 'widgets/sort_bottom_sheet.dart';

/// Screen listing files belonging to a specific [FileCategory] (or all files if null).
/// For document categories (PDF, Word, Excel, PPT, TXT): renders list with SubAppBar,
/// sorting, selection, FileRow items, and native ads after 4th and every 8th item.
/// For the Image category: renders 3-column photo grid with 4pt gaps and check badge selection.
class FilesScreen extends ConsumerWidget {
  const FilesScreen({
    this.category,
    super.key,
  });

  final FileCategory? category;

  /// Helper to calculate if a combined list index is an in-feed native ad slot.
  /// First ad appears after 4 files (combined index 4), then every 8 files (13, 22, 31...).
  static bool _isAdIndex(int index) {
    return index >= 4 && (index - 4) % 9 == 0;
  }

  /// Calculates the original file index given a combined list index containing ads.
  static int _fileIndex(int index) {
    if (index < 4) return index;
    return index - ((index - 4 + 9) ~/ 9);
  }

  /// Calculates the total item count including all inserted in-feed ads.
  static int _totalItemCount(int fileCount) {
    if (fileCount < 4) return fileCount;
    return fileCount + 1 + ((fileCount - 4) ~/ 8);
  }

  void _showBatchDeleteDialog(
    BuildContext context,
    WidgetRef ref,
    List<DocFile> selectedFiles,
  ) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete selected files?'),
          content: Text(
            'Delete ${selectedFiles.length} file(s)? This cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: DocViewColors.error,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                final messenger = ScaffoldMessenger.of(context);
                final result = await ref
                    .read(fileActionsControllerProvider)
                    .deleteFiles(selectedFiles);

                ref.read(selectionProvider.notifier).clear();

                if (!context.mounted) return;
                messenger.showSnackBar(
                  SnackBar(
                    content: Text(
                      result.hasDeletions
                          ? 'Deleted ${result.deletedCount} file(s)'
                          : (result.errorMessage ?? 'Failed to delete files'),
                    ),
                  ),
                );
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filesAsync = ref.watch(filesProvider(category));
    final selection = ref.watch(selectionProvider);
    final selectionNotifier = ref.read(selectionProvider.notifier);

    final categoryLabel = category != null ? category!.label : 'All files';
    final isImageCategory = category == FileCategory.image;

    return PopScope(
      canPop: !selection.isSelectionMode,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        selectionNotifier.clear();
      },
      child: DocScaffold(
        showDockedBanner: false, // Category lists do not show docked banner
        applyHeaderGradient: false,
        appBar: selection.isSelectionMode
            ? DocSelectionAppBar(
                selectedCount: selection.count,
                totalCount: (filesAsync.value ?? []).length,
                onCancel: selectionNotifier.clear,
                onSelectAll: () {
                  final currentFiles = filesAsync.value ?? [];
                  if (selection.count == currentFiles.length) {
                    selectionNotifier.clear();
                  } else {
                    selectionNotifier.selectAll(
                      currentFiles.map((f) => f.path).toList(),
                    );
                  }
                },
                onDelete: selection.count == 0
                    ? null
                    : () {
                        final currentFiles = filesAsync.value ?? [];
                        final selected = currentFiles
                            .where((f) => selection.isSelected(f.path))
                            .toList();
                        _showBatchDeleteDialog(context, ref, selected);
                      },
              )
            : PreferredSize(
                preferredSize: const Size.fromHeight(56),
                child: filesAsync.maybeWhen(
                  data: (files) => _CategorySubAppBar(
                    title: categoryLabel,
                    subtitle: '${files.length} files',
                    onBack: () => Navigator.of(context).maybePop(),
                    onSearch: () {
                      if (category != null) {
                        ref
                            .read(searchCategoryProvider.notifier)
                            .setCategory(category);
                      }
                      context.push('/search');
                    },
                    onSort: () => SortBottomSheet.show(context),
                    onSelect: () {
                      if (files.isNotEmpty) {
                        selectionNotifier.startSelection(files.first.path);
                      }
                    },
                  ),
                  orElse: () => _CategorySubAppBar(
                    title: categoryLabel,
                    subtitle: 'Loading...',
                    onBack: () => Navigator.of(context).maybePop(),
                    onSearch: () => context.push('/search'),
                    onSort: () => SortBottomSheet.show(context),
                    onSelect: () {},
                  ),
                ),
              ),
        body: RefreshIndicator(
          onRefresh: () => handlePullToRefreshScan(context, ref),
          child: filesAsync.when(
            loading: () => isImageCategory
                ? const SkeletonImageGrid(itemCount: 18)
                : const SkeletonFileList(itemCount: 8),
            error: (error, _) => Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: DocErrorState(
                  message: 'Error loading files: $error',
                  onRetry: () => ref.invalidate(filesProvider(category)),
                ),
              ),
            ),
            data: (files) {
              if (files.isEmpty) {
                return Center(
                  child: DocEmptyState(
                    icon: isImageCategory
                        ? Icons.photo_library_outlined
                        : (category?.icon ?? Icons.description),
                    title: isImageCategory
                        ? 'No images found'
                        : 'No ${category?.label ?? "document"} files found',
                    message: isImageCategory
                        ? 'Images found on this device will appear here'
                        : 'Documents of this format will appear here after scanning',
                  ),
                );
              }

              // --- IMAGE CATEGORY: 3-COLUMN THUMBNAIL GRID ---
              if (isImageCategory) {
                return GridView.builder(
                  padding: const EdgeInsets.all(4),
                  physics: const AlwaysScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: files.length,
                  itemBuilder: (context, index) {
                    final file = files[index];
                    final isSelected = selection.isSelected(file.path);

                    return ImageGridTile(
                      imageProvider: ResizeImage(
                        FileImage(File(file.path)),
                        width: 300,
                      ),
                      isSelected: isSelected,
                      isSelectionMode: selection.isSelectionMode,
                      onTap: () {
                        if (selection.isSelectionMode) {
                          selectionNotifier.toggle(file.path);
                        } else {
                          openDocument(context, ref, file);
                        }
                      },
                      onLongPress: () {
                        if (!selection.isSelectionMode) {
                          selectionNotifier.startSelection(file.path);
                        }
                      },
                    );
                  },
                );
              }

              // --- DOCUMENT CATEGORIES: LIST VIEW WITH NATIVE ADS ---
              final totalCount = _totalItemCount(files.length);

              return ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: totalCount,
                itemBuilder: (context, index) {
                  // In-feed Native Ad Slot
                  if (_isAdIndex(index)) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: NativeAdRow(
                        ad: AdPlaceholderModel(
                          title: 'Clean Master Pro • 4.8★',
                          description: 'Speed up & protect storage',
                          ctaLabel: 'Install',
                          icon: Icons.cloud_sync,
                        ),
                      ),
                    );
                  }

                  final fileIndex = _fileIndex(index);
                  final file = files[fileIndex];
                  final isSelected = selection.isSelected(file.path);

                  return FileRow(
                    title: file.name,
                    metadata: FormatUtils.formatSubtitle(
                      file.modified,
                      file.sizeBytes,
                    ),
                    category: file.category,
                    filePath: file.path,
                    isBookmarked: file.isBookmarked,
                    isSelectionMode: selection.isSelectionMode,
                    isSelected: isSelected,
                    onTap: () {
                      if (selection.isSelectionMode) {
                        selectionNotifier.toggle(file.path);
                      } else {
                        openDocument(context, ref, file);
                      }
                    },
                    onLongPress: () {
                      if (!selection.isSelectionMode) {
                        selectionNotifier.startSelection(file.path);
                      }
                    },
                    onToggleBookmark: () => ref
                        .read(fileActionsControllerProvider)
                        .toggleBookmark(file),
                    onOptions: () => FileOptionsSheet.show(context, file),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Custom SubAppBar displaying Category Title + File count with search, sort, and select icons.
class _CategorySubAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String subtitle;
  final VoidCallback onBack;
  final VoidCallback onSearch;
  final VoidCallback onSort;
  final VoidCallback onSelect;

  const _CategorySubAppBar({
    required this.title,
    required this.subtitle,
    required this.onBack,
    required this.onSearch,
    required this.onSort,
    required this.onSelect,
  });

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: DocIconButton(
        icon: AppIcons.back,
        tooltip: 'Back',
        onPressed: onBack,
      ),
      titleSpacing: 0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: DocViewTypography.headlineSm.copyWith(
              color: tokens.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            subtitle,
            style: DocViewTypography.bodySm.copyWith(
              color: tokens.textSecondary,
              fontSize: 11,
            ),
          ),
        ],
      ),
      actions: [
        DocIconButton(
          icon: AppIcons.search,
          tooltip: 'Search',
          onPressed: onSearch,
        ),
        DocIconButton(
          icon: AppIcons.sort,
          tooltip: 'Sort options',
          onPressed: onSort,
        ),
        DocIconButton(
          icon: AppIcons.selectAll,
          tooltip: 'Select files',
          onPressed: onSelect,
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
