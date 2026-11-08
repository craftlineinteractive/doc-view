import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
import '../../shared/widgets/tabs/doc_tabs_and_filters.dart';
import '../../shared/widgets/tiles/file_and_folder_rows.dart';
import '../files/controllers/selection_controller.dart';
import '../files/open_document.dart';
import '../files/widgets/file_options_sheet.dart';
import '../providers/providers.dart';

/// Screen allowing full-text search across document names with live category filters,
/// persistent recent search history, match highlighting, and native ads at slot 6.
/// Implements all 5 states matching mockup 03_search/01_search_states.
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  late final TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    final initialQuery = ref.read(searchQueryProvider);
    _controller = TextEditingController(text: initialQuery);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onQueryChanged(String value) {
    ref.read(searchQueryProvider.notifier).setQuery(value);
  }

  void _submitSearch(String value) {
    final trimmed = value.trim();
    if (trimmed.isNotEmpty) {
      ref.read(recentSearchesProvider.notifier).addSearch(trimmed);
    }
  }

  void _onClear() {
    _controller.clear();
    ref.read(searchQueryProvider.notifier).clear();
  }

  void _applyRecentSearch(String search) {
    _controller.text = search;
    ref.read(searchQueryProvider.notifier).setQuery(search);
    ref.read(recentSearchesProvider.notifier).addSearch(search);
  }

  void _showBatchDeleteDialog(List<DocFile> selectedFiles) {
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
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final currentCategory = ref.watch(searchCategoryProvider);
    final query = ref.watch(searchQueryProvider);
    final searchResultsAsync = ref.watch(searchResultsProvider);
    final selection = ref.watch(selectionProvider);
    final selectionNotifier = ref.read(selectionProvider.notifier);
    final recentSearchesAsync = ref.watch(recentSearchesProvider);
    final recentSearches = recentSearchesAsync.value ?? const <String>[];

    final isTyping = query.trim().isNotEmpty;

    return PopScope(
      canPop: !selection.isSelectionMode,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        selectionNotifier.clear();
      },
      child: DocScaffold(
        showDockedBanner: false, // Strictly NO docked banner on Search screen
        applyHeaderGradient: false,
        appBar: selection.isSelectionMode
            ? DocSelectionAppBar(
                selectedCount: selection.count,
                totalCount: (searchResultsAsync.value ?? []).length,
                onCancel: selectionNotifier.clear,
                onSelectAll: () {
                  final files = searchResultsAsync.value ?? [];
                  if (selection.count == files.length) {
                    selectionNotifier.clear();
                  } else {
                    selectionNotifier
                        .selectAll(files.map((f) => f.path).toList());
                  }
                },
                onDelete: selection.count == 0
                    ? null
                    : () {
                        final files = searchResultsAsync.value ?? [];
                        final selected = files
                            .where((f) => selection.isSelected(f.path))
                            .toList();
                        _showBatchDeleteDialog(selected);
                      },
              )
            : PreferredSize(
                preferredSize: const Size.fromHeight(114),
                child: SafeArea(
                  bottom: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Search Input Bar
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 8, 16, 6),
                        child: Row(
                          children: [
                            DocIconButton(
                              icon: AppIcons.back,
                              tooltip: 'Back',
                              onPressed: () => Navigator.of(context).maybePop(),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Container(
                                height: 48,
                                decoration: BoxDecoration(
                                  color: tokens.surface,
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                    color: isTyping
                                        ? tokens.primaryBlue
                                        : tokens.hairline,
                                    width: isTyping ? 1.5 : 1.0,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const SizedBox(width: 14),
                                    Icon(
                                      AppIcons.search,
                                      size: 20,
                                      color: isTyping
                                          ? tokens.primaryBlue
                                          : tokens.textSecondary,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: TextField(
                                        controller: _controller,
                                        focusNode: _focusNode,
                                        autofocus: true,
                                        style: DocViewTypography.bodyLg.copyWith(
                                          color: tokens.textPrimary,
                                        ),
                                        onChanged: _onQueryChanged,
                                        onSubmitted: _submitSearch,
                                        decoration: InputDecoration(
                                          hintText: 'Search documents, files...',
                                          hintStyle: DocViewTypography.bodyMd
                                              .copyWith(
                                            color: tokens.textSecondary,
                                          ),
                                          border: InputBorder.none,
                                          isDense: true,
                                          contentPadding: EdgeInsets.zero,
                                        ),
                                      ),
                                    ),
                                    if (query.isNotEmpty)
                                      IconButton(
                                        icon: const Icon(AppIcons.close, size: 18),
                                        color: tokens.textSecondary,
                                        tooltip: 'Clear search',
                                        onPressed: _onClear,
                                      ),
                                    const SizedBox(width: 6),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Category Filter Chips
                      DocFilterChipRow(
                        selectedCategory: currentCategory,
                        onSelected: (cat) {
                          ref
                              .read(searchCategoryProvider.notifier)
                              .setCategory(cat);
                        },
                      ),
                      Container(height: 1, color: tokens.hairline),
                    ],
                  ),
                ),
              ),
        body: Builder(
          builder: (context) {
            // STATE 2: EMPTY QUERY (Recent searches or initial prompt)
            if (!isTyping) {
              if (recentSearches.isNotEmpty) {
                return ListView(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'RECENT SEARCHES',
                            style: DocViewTypography.labelXs.copyWith(
                              color: tokens.sectionHeader,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              ref
                                  .read(recentSearchesProvider.notifier)
                                  .clearAll();
                            },
                            child: Text(
                              'Clear',
                              style: DocViewTypography.labelMd.copyWith(
                                color: tokens.primaryBlue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ...recentSearches.map((item) {
                      return ListTile(
                        leading: Icon(
                          AppIcons.history,
                          size: 20,
                          color: tokens.textSecondary,
                        ),
                        title: Text(
                          item,
                          style: DocViewTypography.bodyMd.copyWith(
                            color: tokens.textPrimary,
                          ),
                        ),
                        trailing: Icon(
                          Icons.north_west,
                          size: 16,
                          color: tokens.textSecondary,
                        ),
                        onTap: () => _applyRecentSearch(item),
                      );
                    }),
                  ],
                );
              }

              // Idle empty state with prompt
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: tokens.surface,
                          shape: BoxShape.circle,
                          border: Border.all(color: tokens.hairline),
                        ),
                        child: Icon(
                          AppIcons.search,
                          size: 32,
                          color: tokens.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Type to search documents',
                        style: DocViewTypography.titleMd.copyWith(
                          color: tokens.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Search across all local folders by filename or extension',
                        textAlign: TextAlign.center,
                        style: DocViewTypography.bodySm.copyWith(
                          color: tokens.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            // STATE 4: SKELETON LOADING
            return searchResultsAsync.when(
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: SkeletonFileList(itemCount: 6),
              ),
              error: (error, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: DocErrorState(
                    message: 'Error searching documents: $error',
                    onRetry: () => ref.invalidate(searchResultsProvider),
                  ),
                ),
              ),
              // STATE 1 & 3: ACTIVE RESULTS OR NO RESULTS
              data: (files) {
                // STATE 3: NO RESULTS FOUND
                if (files.isEmpty) {
                  return const DocEmptyState(
                    icon: AppIcons.search,
                    title: 'No matching documents found',
                    message:
                        'Try searching with a different filename keyword or format filter',
                  );
                }

                // STATE 1: TYPING STATE MATCHES WITH HIGHLIGHTING
                // Native ad placeholder strictly at result position 6 (after 5 items, index 5)
                final hasAd = files.length >= 5;
                final totalItems = files.length + (hasAd ? 1 : 0);

                return ListView.builder(
                  itemCount: totalItems,
                  itemBuilder: (context, index) {
                    if (hasAd && index == 5) {
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

                    final fileIndex = (hasAd && index > 5) ? index - 1 : index;
                    final file = files[fileIndex];
                    final isSelected = selection.isSelected(file.path);

                    return FileRow(
                      title: file.name,
                      highlightQuery: query, // Bold primary blue matching
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
                          _submitSearch(query);
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
            );
          },
        ),
      ),
    );
  }
}
