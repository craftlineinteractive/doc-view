import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/file_types.dart';
import '../../shared/widgets/tiles/category_tile.dart';
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
        title: const Text('Doc View'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Search',
            onPressed: () => context.push('/search'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => handlePullToRefreshScan(context, ref),
        child: DefaultTabController(
          length: 2,
          child: NestedScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
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
                  child: Builder(
                    builder: (context) {
                      final size = MediaQuery.sizeOf(context);
                      final textScale =
                          MediaQuery.textScalerOf(context).scale(1.0);
                      final double categoryAspectRatio;
                      if (size.width > 500) {
                        categoryAspectRatio = 1.6;
                      } else {
                        categoryAspectRatio = textScale > 1.4
                            ? 0.65
                            : (textScale > 1.1 ? 0.72 : 0.82);
                      }

                      return GridView.count(
                        crossAxisCount: 4,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: categoryAspectRatio,
                        children: [
                          CategoryTile(
                            label: 'All',
                            subtitle: '$totalFiles files',
                            onTap: () => context.push('/files?category=all'),
                          ),
                          CategoryTile(
                            category: FileCategory.pdf,
                            label: 'PDF',
                            subtitle: '${categoryCounts[FileCategory.pdf] ?? 0} files',
                            onTap: () => context.push('/files?category=pdf'),
                          ),
                          CategoryTile(
                            category: FileCategory.word,
                            label: 'Word',
                            subtitle: '${categoryCounts[FileCategory.word] ?? 0} files',
                            onTap: () => context.push('/files?category=word'),
                          ),
                          CategoryTile(
                            category: FileCategory.excel,
                            label: 'Excel',
                            subtitle: '${categoryCounts[FileCategory.excel] ?? 0} files',
                            onTap: () => context.push('/files?category=excel'),
                          ),
                          CategoryTile(
                            category: FileCategory.ppt,
                            label: 'PPT',
                            subtitle: '${categoryCounts[FileCategory.ppt] ?? 0} files',
                            onTap: () => context.push('/files?category=ppt'),
                          ),
                          CategoryTile(
                            category: FileCategory.txt,
                            label: 'TXT',
                            subtitle: '${categoryCounts[FileCategory.txt] ?? 0} files',
                            onTap: () => context.push('/files?category=txt'),
                          ),
                          CategoryTile(
                            category: FileCategory.image,
                            label: 'Image',
                            subtitle: '${categoryCounts[FileCategory.image] ?? 0} files',
                            onTap: () => context.push('/files?category=image'),
                          ),
                          CategoryTile(
                            label: 'Folders',
                            subtitle: 'Browse',
                            onTap: () => context.push('/directories'),
                          ),
                        ],
                      );
                    },
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
          return const SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: SizedBox(
              height: 250,
              child: _EmptyStateIllustration(
                icon: Icons.history_rounded,
                label: 'Empty',
                description: 'Recently opened files will appear here',
              ),
            ),
          );
        }
        return ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
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
          return const SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: SizedBox(
              height: 250,
              child: _EmptyStateIllustration(
                icon: Icons.bookmark_border_rounded,
                label: 'Empty',
                description: 'Bookmarked documents will appear here',
              ),
            ),
          );
        }
        return ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
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

