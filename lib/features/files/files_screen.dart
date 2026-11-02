import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/file_types.dart';
import '../../data/models/sort_option.dart';
import '../providers/providers.dart';
import 'open_document.dart';
import 'widgets/file_tile.dart';

/// Screen listing files belonging to a specific [FileCategory] (or all files if null).
class FilesScreen extends ConsumerWidget {
  const FilesScreen({
    this.category,
    super.key,
  });

  final FileCategory? category;

  void _showSortSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) {
        return Consumer(
          builder: (context, ref, _) {
            final currentSort = ref.watch(sortOptionProvider);
            final theme = Theme.of(context);

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Sort by',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    RadioGroup<SortField>(
                      groupValue: currentSort.field,
                      onChanged: (field) {
                        if (field != null) {
                          ref
                              .read(sortOptionProvider.notifier)
                              .setSortOption(currentSort.copyWith(field: field));
                        }
                      },
                      child: const Column(
                        children: [
                          RadioListTile<SortField>(
                            title: Text('Date'),
                            value: SortField.date,
                          ),
                          RadioListTile<SortField>(
                            title: Text('Name'),
                            value: SortField.name,
                          ),
                          RadioListTile<SortField>(
                            title: Text('Size'),
                            value: SortField.size,
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    SwitchListTile(
                      title: const Text('Ascending order'),
                      subtitle: Text(
                        currentSort.direction == SortDirection.asc
                            ? 'Oldest first / A to Z / Smallest first'
                            : 'Newest first / Z to A / Largest first',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.textTheme.bodySmall?.color
                              ?.withValues(alpha: 0.6),
                        ),
                      ),
                      value: currentSort.direction == SortDirection.asc,
                      onChanged: (isAsc) {
                        ref.read(sortOptionProvider.notifier).setSortOption(
                              currentSort.copyWith(
                                direction: isAsc
                                    ? SortDirection.asc
                                    : SortDirection.desc,
                              ),
                            );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final filesAsync = ref.watch(filesProvider(category));

    final title = category != null ? '${category!.label} Files' : 'All Files';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Search',
            onPressed: () {
              ref.read(searchCategoryProvider.notifier).setCategory(category);
              context.push('/search');
            },
          ),
          IconButton(
            icon: const Icon(Icons.sort_rounded),
            tooltip: 'Sort',
            onPressed: () => _showSortSheet(context, ref),
          ),
        ],
      ),
      body: filesAsync.when(
        data: (files) {
          if (files.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    category?.icon ?? Icons.folder_open_rounded,
                    size: 64,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No ${category != null ? category!.label : ''} files found'
                        .trim(),
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Import files or run a storage scan to see them here.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(filesProvider(category));
              ref.invalidate(categoryCountsProvider);
            },
            child: ListView.separated(
              itemCount: files.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                indent: 72,
                color: theme.dividerColor.withValues(alpha: 0.2),
              ),
              itemBuilder: (context, index) {
                final file = files[index];
                return FileTile(
                  file: file,
                  onTap: () => openDocument(context, ref, file),
                );
              },
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline_rounded,
                  color: Colors.redAccent,
                  size: 48,
                ),
                const SizedBox(height: 12),
                Text(
                  'Error loading files',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 6),
                Text(
                  error.toString(),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => ref.invalidate(filesProvider(category)),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
