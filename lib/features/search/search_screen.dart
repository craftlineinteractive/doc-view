import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/file_types.dart';
import '../../data/models/doc_file.dart';
import '../files/controllers/selection_controller.dart';
import '../files/open_document.dart';
import '../files/widgets/file_tile.dart';
import '../providers/providers.dart';

/// Screen allowing full-text search across document names with live category filters
/// and unified multi-selection actions.
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final initialQuery = ref.read(searchQueryProvider);
    _controller = TextEditingController(text: initialQuery);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onQueryChanged(String value) {
    ref.read(searchQueryProvider.notifier).setQuery(value);
  }

  void _onClear() {
    _controller.clear();
    ref.read(searchQueryProvider.notifier).clear();
  }

  void _showBatchDeleteDialog(List<DocFile> selectedFiles) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete selected files?'),
          content: Text(
            'Delete ${selectedFiles.length} file(s)? This can\'t be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Theme.of(context).colorScheme.onError,
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
    final theme = Theme.of(context);
    final currentCategory = ref.watch(searchCategoryProvider);
    final query = ref.watch(searchQueryProvider);
    final searchResultsAsync = ref.watch(searchResultsProvider);
    final selection = ref.watch(selectionProvider);
    final selectionNotifier = ref.read(selectionProvider.notifier);

    return PopScope(
      canPop: !selection.isSelectionMode,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        selectionNotifier.clear();
      },
      child: Scaffold(
        appBar: selection.isSelectionMode
            ? AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.close),
                  tooltip: 'Cancel selection',
                  onPressed: selectionNotifier.clear,
                ),
                title: Semantics(
                  liveRegion: true,
                  child: Text('${selection.count} selected'),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.select_all),
                    tooltip: 'Select all',
                    onPressed: () {
                      final files = searchResultsAsync.value ?? [];
                      selectionNotifier
                          .selectAll(files.map((f) => f.path).toList());
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.share_outlined),
                    tooltip: 'Share',
                    onPressed: selection.count == 0
                        ? null
                        : () {
                            final files = searchResultsAsync.value ?? [];
                            final selected = files
                                .where((f) => selection.isSelected(f.path))
                                .toList();
                            ref
                                .read(fileActionsControllerProvider)
                                .shareFiles(selected);
                          },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    tooltip: 'Delete',
                    onPressed: selection.count == 0
                        ? null
                        : () {
                            final files = searchResultsAsync.value ?? [];
                            final selected = files
                                .where((f) => selection.isSelected(f.path))
                                .toList();
                            _showBatchDeleteDialog(selected);
                          },
                  ),
                ],
              )
            : AppBar(
                titleSpacing: 0,
                title: TextField(
                  controller: _controller,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Search documents',
                    border: InputBorder.none,
                    suffixIcon: query.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            tooltip: 'Clear search',
                            onPressed: _onClear,
                          )
                        : null,
                  ),
                  onChanged: _onQueryChanged,
                ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(48),
                  child: Container(
                    height: 48,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: const Text('All'),
                            selected: currentCategory == null,
                            onSelected: (selected) {
                              if (selected) {
                                ref
                                    .read(searchCategoryProvider.notifier)
                                    .setCategory(null);
                              }
                            },
                          ),
                        ),
                        ...FileCategory.values.map(
                          (cat) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: FilterChip(
                              avatar: Icon(
                                cat.icon,
                                size: 16,
                                color: currentCategory == cat
                                    ? theme.colorScheme.onPrimaryContainer
                                    : cat.color,
                              ),
                              label: Text(cat.label),
                              selected: currentCategory == cat,
                              onSelected: (selected) {
                                ref
                                    .read(searchCategoryProvider.notifier)
                                    .setCategory(selected ? cat : null);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
        body: Builder(
          builder: (context) {
            if (query.trim().isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search_rounded,
                      size: 64,
                      color:
                          theme.colorScheme.onSurface.withValues(alpha: 0.3),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Type to search documents',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              );
            }

            return searchResultsAsync.when(
              data: (files) {
                if (files.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off_rounded,
                          size: 64,
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.3),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No documents found',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.6),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try searching with a different filename keyword or category filter',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.4),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  itemCount: files.length,
                  separatorBuilder: (context, index) => Divider(
                    height: 1,
                    indent: 72,
                    color: theme.dividerColor.withValues(alpha: 0.2),
                  ),
                  itemBuilder: (context, index) {
                    final file = files[index];
                    final isSelected = selection.isSelected(file.path);

                    return FileTile(
                      file: file,
                      selectionMode: selection.isSelectionMode,
                      selected: isSelected,
                      onTap: selection.isSelectionMode
                          ? () => selectionNotifier.toggle(file.path)
                          : () => openDocument(context, ref, file),
                      onLongPress: () {
                        if (!selection.isSelectionMode) {
                          selectionNotifier.startSelection(file.path);
                        }
                      },
                      onSelectChanged: (_) =>
                          selectionNotifier.toggle(file.path),
                    );
                  },
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text('Error loading search results: $error'),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
