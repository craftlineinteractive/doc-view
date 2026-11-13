import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/file_types.dart';
import '../../core/theme/app_icons.dart';
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
import '../../shared/widgets/tiles/category_tile.dart';
import '../../shared/widgets/tiles/file_and_folder_rows.dart';
import '../files/open_document.dart';
import '../files/widgets/file_options_sheet.dart';
import '../providers/providers.dart';

/// Main documents hub displaying category metrics, scan progress, and recent/bookmarked tabs.
/// Implements all state variants matching mockups 02_home/01_home_all_files and 02_home_state_variants.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedTabIndex = 0;

  Future<void> _handleImportFiles() async {
    try {
      final count = await ref.read(importServiceProvider).importFiles();
      ref.invalidate(categoryCountsProvider);
      ref.invalidate(filesProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$count files imported')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Import failed: $e')),
        );
      }
    }
  }

  Future<void> _handleGrantAccess() async {
    final granted =
        await ref.read(allFilesAccessProvider.notifier).requestAccess();
    if (granted) {
      await ref.read(scanStateProvider.notifier).startScan();
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final scanState = ref.watch(scanStateProvider);
    final countsAsync = ref.watch(categoryCountsProvider);
    final recentsAsync = ref.watch(recentsProvider);
    final bookmarksAsync = ref.watch(bookmarksProvider);
    final allFilesAccessAsync = ref.watch(allFilesAccessProvider);

    final categoryCounts = countsAsync.value ?? const <FileCategory, int>{};
    final totalFiles = categoryCounts.values.fold<int>(
      0,
      (sum, count) => sum + count,
    );

    final recentFiles = recentsAsync.value ?? const <DocFile>[];
    final bookmarkedFiles = bookmarksAsync.value ?? const <DocFile>[];

    final isAndroid = Platform.isAndroid;
    final isPermissionDenied =
        isAndroid && (allFilesAccessAsync.value == false);

    return DocScaffold(
      applyHeaderGradient: true,
      showDockedBanner: true,
      isAdLoaded: true,
      appBar: DocHomeAppBar(
        onSearchTap: () => context.push('/search'),
        onSelectTap: () => context.push('/files?category=all'),
        onScanTap: () => handlePullToRefreshScan(context, ref),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _handleImportFiles,
        backgroundColor: tokens.primaryBlue,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        tooltip: 'Import documents',
        child: const Icon(Icons.add, size: 28),
      ),
      body: RefreshIndicator(
        onRefresh: () => handlePullToRefreshScan(context, ref),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            // 1. Scanning Banner (when active)
            if (scanState.isScanning)
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    LinearProgressIndicator(
                      minHeight: 2.5,
                      backgroundColor: tokens.hairline,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(tokens.primaryBlue),
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      color: tokens.blueTint,
                      child: Row(
                        children: [
                          Icon(
                            AppIcons.refresh,
                            size: 14,
                            color: tokens.primaryBlue,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Scanning... ${scanState.filesFound} files found',
                              style: DocViewTypography.bodySm.copyWith(
                                color: tokens.primaryBlue,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            // 2. 4x2 Category Grid (or Skeleton during initial load)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: countsAsync.isLoading
                    ? const SkeletonTileGrid(itemCount: 8)
                    : Builder(
                        builder: (context) {
                          final size = MediaQuery.sizeOf(context);
                          final textScale =
                              MediaQuery.textScalerOf(context).scale(1.0);
                          final double categoryAspectRatio;
                          if (size.width > 500) {
                            categoryAspectRatio = 1.6;
                          } else {
                            categoryAspectRatio = textScale > 1.4
                                ? 0.58
                                : (textScale > 1.1
                                    ? 0.68
                                    : (size.width <= 360 ? 0.72 : 0.80));
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
                                subtitle: scanState.isScanning
                                    ? 'Scanning...'
                                    : '$totalFiles files',
                                onTap: () => context.push('/files?category=all'),
                              ),
                              CategoryTile(
                                category: FileCategory.pdf,
                                label: 'PDF',
                                subtitle: scanState.isScanning
                                    ? '...'
                                    : '${categoryCounts[FileCategory.pdf] ?? 0} files',
                                onTap: () => context.push('/files?category=pdf'),
                              ),
                              CategoryTile(
                                category: FileCategory.word,
                                label: 'Word',
                                subtitle: scanState.isScanning
                                    ? '...'
                                    : '${categoryCounts[FileCategory.word] ?? 0} files',
                                onTap: () => context.push('/files?category=word'),
                              ),
                              CategoryTile(
                                category: FileCategory.excel,
                                label: 'Excel',
                                subtitle: scanState.isScanning
                                    ? '...'
                                    : '${categoryCounts[FileCategory.excel] ?? 0} files',
                                onTap: () =>
                                    context.push('/files?category=excel'),
                              ),
                              CategoryTile(
                                category: FileCategory.ppt,
                                label: 'PPT',
                                subtitle: scanState.isScanning
                                    ? '...'
                                    : '${categoryCounts[FileCategory.ppt] ?? 0} files',
                                onTap: () => context.push('/files?category=ppt'),
                              ),
                              CategoryTile(
                                category: FileCategory.txt,
                                label: 'TXT',
                                subtitle: scanState.isScanning
                                    ? '...'
                                    : '${categoryCounts[FileCategory.txt] ?? 0} files',
                                onTap: () => context.push('/files?category=txt'),
                              ),
                              CategoryTile(
                                category: FileCategory.image,
                                label: 'Image',
                                subtitle: scanState.isScanning
                                    ? '...'
                                    : '${categoryCounts[FileCategory.image] ?? 0} files',
                                onTap: () =>
                                    context.push('/files?category=image'),
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

            // 3. 6pt Divider Band
            SliverToBoxAdapter(
              child: Container(
                height: 6,
                color: tokens.dividerBand,
              ),
            ),

            // 4. Pinned Underline Tabs (Recent / Bookmarks)
            SliverPersistentHeader(
              pinned: true,
              delegate: _DocTabsHeaderDelegate(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                extent: (49.0 * MediaQuery.textScalerOf(context).scale(1.0)).clamp(49.0, 72.0),
                child: DocUnderlineTabs(
                  selectedIndex: _selectedTabIndex,
                  recentCount: recentFiles.length,
                  bookmarksCount: bookmarkedFiles.length,
                  onTabSelected: (index) {
                    setState(() => _selectedTabIndex = index);
                  },
                  trailing: DocIconButton(
                    icon: AppIcons.selectAll,
                    tooltip: 'Select files',
                    color: tokens.textSecondary,
                    onPressed: () => context.push('/files?category=all'),
                  ),
                ),
              ),
            ),

            // 5. State Handling: Permission Gate, Skeletons, Empty States, or Populated Rows
            if (isPermissionDenied &&
                recentFiles.isEmpty &&
                bookmarkedFiles.isEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: DocPermissionRequiredState(
                    onGrantAccess: _handleGrantAccess,
                    onImportFiles: _handleImportFiles,
                  ),
                ),
              )
            else if (_selectedTabIndex == 0)
              // --- RECENT TAB ---
              recentsAsync.when(
                loading: () => const SliverToBoxAdapter(
                  child: SkeletonFileList(itemCount: 5),
                ),
                error: (error, _) => SliverToBoxAdapter(
                  child: DocErrorState(
                    message: 'Error loading recent files: $error',
                    onRetry: () => ref.invalidate(recentsProvider),
                  ),
                ),
                data: (files) {
                  if (files.isEmpty) {
                    return const SliverToBoxAdapter(
                      child: DocEmptyState(
                        icon: AppIcons.history,
                        title: 'Empty',
                        message: 'Recently opened files will appear here',
                      ),
                    );
                  }

                  // Insert NativeAdRow after the 4th item (index 3)
                  final hasAd = files.length >= 4;
                  final itemCount = files.length + (hasAd ? 1 : 0);

                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (hasAd && index == 4) {
                          return const NativeAdRow(
                            ad: AdPlaceholderModel(
                              title: 'Clean Master Pro • 4.8★',
                              description: 'Speed up & protect storage',
                              ctaLabel: 'Install',
                              icon: Icons.cloud_sync,
                            ),
                          );
                        }

                        final fileIndex = (hasAd && index > 4) ? index - 1 : index;
                        final file = files[fileIndex];

                        return FileRow(
                          title: file.name,
                          metadata: FormatUtils.formatSubtitle(
                            file.modified,
                            file.sizeBytes,
                          ),
                          category: file.category,
                          filePath: file.path,
                          isBookmarked: file.isBookmarked,
                          onTap: () => openDocument(context, ref, file),
                          onToggleBookmark: () => ref
                              .read(fileActionsControllerProvider)
                              .toggleBookmark(file),
                          onOptions: () => FileOptionsSheet.show(context, file),
                        );
                      },
                      childCount: itemCount,
                    ),
                  );
                },
              )
            else
              // --- BOOKMARKS TAB ---
              bookmarksAsync.when(
                loading: () => const SliverToBoxAdapter(
                  child: SkeletonFileList(itemCount: 5),
                ),
                error: (error, _) => SliverToBoxAdapter(
                  child: DocErrorState(
                    message: 'Error loading bookmarked files: $error',
                    onRetry: () => ref.invalidate(bookmarksProvider),
                  ),
                ),
                data: (files) {
                  if (files.isEmpty) {
                    return const SliverToBoxAdapter(
                      child: DocEmptyState(
                        icon: AppIcons.bookmarkOutline,
                        title: 'Empty',
                        message: 'Bookmarked documents will appear here',
                      ),
                    );
                  }

                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final file = files[index];
                        return FileRow(
                          title: file.name,
                          metadata: FormatUtils.formatSubtitle(
                            file.modified,
                            file.sizeBytes,
                          ),
                          category: file.category,
                          filePath: file.path,
                          isBookmarked: true,
                          onTap: () => openDocument(context, ref, file),
                          onToggleBookmark: () => ref
                              .read(fileActionsControllerProvider)
                              .toggleBookmark(file),
                          onOptions: () => FileOptionsSheet.show(context, file),
                        );
                      },
                      childCount: files.length,
                    ),
                  );
                },
              ),

            // Bottom clearance buffer for scrolling past FAB
            const SliverToBoxAdapter(
              child: SizedBox(height: 80),
            ),
          ],
        ),
      ),
    );
  }
}

class _DocTabsHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final Color backgroundColor;
  final double extent;

  _DocTabsHeaderDelegate({
    required this.child,
    required this.backgroundColor,
    this.extent = 48,
  });

  @override
  double get minExtent => extent;

  @override
  double get maxExtent => extent;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: backgroundColor,
      alignment: Alignment.center,
      child: child,
    );
  }

  @override
  bool shouldRebuild(_DocTabsHeaderDelegate oldDelegate) {
    return child != oldDelegate.child ||
        backgroundColor != oldDelegate.backgroundColor ||
        extent != oldDelegate.extent;
  }
}
