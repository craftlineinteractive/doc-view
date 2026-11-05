import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/file_types.dart';
import '../files/open_document.dart';
import '../files/widgets/file_tile.dart';
import '../providers/providers.dart';

/// Main documents hub displaying category metrics, scan progress, and recent/bookmarked tabs.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scanState = ref.watch(scanStateProvider);
    final countsAsync = ref.watch(categoryCountsProvider);
    final categoryCounts = countsAsync.value ?? const <FileCategory, int>{};

    final totalFiles = categoryCounts.values.fold<int>(
      0,
      (sum, count) => sum + count,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Doc Reader'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Search',
            onPressed: () => context.push('/search'),
          ),
        ],
      ),
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              // Scanning progress indicator banner
              if (scanState.isScanning)
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      const LinearProgressIndicator(minHeight: 2.5),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        color: theme.colorScheme.primary.withValues(alpha: 0.1),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 12,
                              height: 12,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Scanning... ${scanState.filesFound} files found',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

              // 4x2 Category Grid
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
                  child: GridView.count(
                    crossAxisCount: 4,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 0.88,
                    children: [
                      _CategoryTile(
                        label: 'All',
                        icon: Icons.folder_copy_rounded,
                        color: const Color(0xFF1A73E8),
                        count: '$totalFiles files',
                        onTap: () => context.push('/files?category=all'),
                      ),
                      _CategoryTile(
                        label: FileCategory.pdf.label,
                        icon: FileCategory.pdf.icon,
                        color: FileCategory.pdf.color,
                        count: '${categoryCounts[FileCategory.pdf] ?? 0} files',
                        onTap: () => context.push('/files?category=pdf'),
                      ),
                      _CategoryTile(
                        label: FileCategory.word.label,
                        icon: FileCategory.word.icon,
                        color: FileCategory.word.color,
                        count:
                            '${categoryCounts[FileCategory.word] ?? 0} files',
                        onTap: () => context.push('/files?category=word'),
                      ),
                      _CategoryTile(
                        label: FileCategory.excel.label,
                        icon: FileCategory.excel.icon,
                        color: FileCategory.excel.color,
                        count:
                            '${categoryCounts[FileCategory.excel] ?? 0} files',
                        onTap: () => context.push('/files?category=excel'),
                      ),
                      _CategoryTile(
                        label: FileCategory.ppt.label,
                        icon: FileCategory.ppt.icon,
                        color: FileCategory.ppt.color,
                        count: '${categoryCounts[FileCategory.ppt] ?? 0} files',
                        onTap: () => context.push('/files?category=ppt'),
                      ),
                      _CategoryTile(
                        label: FileCategory.txt.label,
                        icon: FileCategory.txt.icon,
                        color: FileCategory.txt.color,
                        count: '${categoryCounts[FileCategory.txt] ?? 0} files',
                        onTap: () => context.push('/files?category=txt'),
                      ),
                      _CategoryTile(
                        label: FileCategory.image.label,
                        icon: FileCategory.image.icon,
                        color: FileCategory.image.color,
                        count:
                            '${categoryCounts[FileCategory.image] ?? 0} files',
                        onTap: () => context.push('/files?category=image'),
                      ),
                      _CategoryTile(
                        label: 'Directories',
                        icon: Icons.snippet_folder_rounded,
                        color: const Color(0xFF8E24AA),
                        count: 'Browse',
                        onTap: () => context.push('/directories'),
                      ),
                    ],
                  ),
                ),
              ),

              // Pinned TabBar for Recent / Bookmarks
              SliverPersistentHeader(
                pinned: true,
                delegate: _TabBarHeaderDelegate(
                  TabBar(
                    indicatorColor: theme.colorScheme.primary,
                    labelColor: theme.colorScheme.primary,
                    unselectedLabelColor:
                        theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    labelStyle: const TextStyle(fontWeight: FontWeight.w600),
                    tabs: const [
                      Tab(text: 'Recent'),
                      Tab(text: 'Bookmarks'),
                    ],
                  ),
                  backgroundColor: theme.scaffoldBackgroundColor,
                ),
              ),
            ];
          },
          body: const TabBarView(
            children: [
              _RecentsList(),
              _BookmarksList(),
            ],
          ),

        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            final count = await ref.read(importServiceProvider).importFiles();
            ref.invalidate(categoryCountsProvider);
            ref.invalidate(filesProvider);

            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$count files imported')),
              );
            }
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Import failed: $e')),
              );
            }
          }
        },
        tooltip: 'Import documents',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _TabBarHeaderDelegate extends SliverPersistentHeaderDelegate {
  _TabBarHeaderDelegate(
    this.tabBar, {
    required this.backgroundColor,
  });

  final TabBar tabBar;
  final Color backgroundColor;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: backgroundColor,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_TabBarHeaderDelegate oldDelegate) {
    return tabBar != oldDelegate.tabBar ||
        backgroundColor != oldDelegate.backgroundColor;
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({
    required this.label,
    required this.icon,
    required this.color,
    required this.count,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final String count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.dividerColor.withValues(alpha: 0.1),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(
                  icon,
                  color: color,
                  size: 20,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                count,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color:
                      theme.textTheme.bodySmall?.color?.withValues(alpha: 0.6),
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyStateIllustration extends StatelessWidget {
  const _EmptyStateIllustration({
    required this.icon,
    required this.label,
    required this.description,
  });

  final IconData icon;
  final String label;
  final String description;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final subtleColor = theme.colorScheme.onSurface.withValues(alpha: 0.35);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 56,
            color: subtleColor,
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: theme.textTheme.titleMedium?.copyWith(
              color: subtleColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: theme.textTheme.bodySmall?.copyWith(
              color: subtleColor.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentsList extends ConsumerWidget {
  const _RecentsList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final recentsAsync = ref.watch(recentsProvider);

    return recentsAsync.when(
      data: (files) {
        if (files.isEmpty) {
          return const _EmptyStateIllustration(
            icon: Icons.history_rounded,
            label: 'Empty',
            description: 'Recently opened files will appear here',
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
            return FileTile(
              file: file,
              onTap: () => openDocument(context, ref, file),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Text('Error loading recents: $error'),
      ),
    );
  }
}

class _BookmarksList extends ConsumerWidget {
  const _BookmarksList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final bookmarksAsync = ref.watch(bookmarksProvider);

    return bookmarksAsync.when(
      data: (files) {
        if (files.isEmpty) {
          return const _EmptyStateIllustration(
            icon: Icons.bookmark_border_rounded,
            label: 'Empty',
            description: 'Bookmarked documents will appear here',
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
            return FileTile(
              file: file,
              onTap: () => openDocument(context, ref, file),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Text('Error loading bookmarks: $error'),
      ),
    );
  }
}

