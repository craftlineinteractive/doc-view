import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/file_types.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/doc_view_tokens.dart';
import '../../../core/theme/doc_view_typography.dart';
import '../../../core/utils/format_utils.dart';
import '../../../data/models/doc_file.dart';
import '../../../shared/widgets/ads/ad_placeholders.dart';
import '../../../shared/widgets/buttons/doc_icon_button.dart';
import '../../../shared/widgets/skeletons/shimmer.dart';
import '../../../shared/widgets/skeletons/skeleton_variants.dart';
import '../../../shared/widgets/tiles/file_thumbnail.dart';
import '../../../shared/widgets/tiles/pdf_thumbnail_source.dart';
import '../../providers/providers.dart';
import '../services/pdf_page_count_service.dart';

enum _PickerTab {
  all,
  recent,
  platformSource, // "Downloads" on Android, "iCloud Drive" on iOS
}

/// Redesigned Step 1 picker for Merge PDF matching mockups and prompt specifications.
/// Features:
/// - Source tabs: All PDFs, Recent, Downloads (Android) / iCloud Drive (iOS)
/// - Lazy page count loading with pdfrx (concurrency 2, in-memory cache)
/// - Skeleton chip until loaded, "Protected or damaged" badge for unreadable PDFs
/// - In-feed native ad row after 5th item only
/// - Sticky footer with selection count, total pages (or skeleton bar), and primary "Next"
class MergePdfPickerScreen extends ConsumerStatefulWidget {
  const MergePdfPickerScreen({
    this.title,
    this.minSelection = 2,
    super.key,
  });

  final String? title;
  final int minSelection;

  static Future<List<DocFile>?> pick(
    BuildContext context, {
    String? title,
    int minSelection = 2,
  }) {
    return Navigator.of(context).push<List<DocFile>>(
      MaterialPageRoute(
        builder: (context) => MergePdfPickerScreen(
          title: title,
          minSelection: minSelection,
        ),
      ),
    );
  }

  @override
  ConsumerState<MergePdfPickerScreen> createState() =>
      _MergePdfPickerScreenState();
}

class _MergePdfPickerScreenState extends ConsumerState<MergePdfPickerScreen> {
  final Set<String> _selectedPaths = <String>{};
  final Map<String, DocFile> _selectedFilesMap = <String, DocFile>{};
  final List<DocFile> _importedICloudFiles = <DocFile>[];

  _PickerTab _currentTab = _PickerTab.all;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  String _filterQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool get _isIOS =>
      defaultTargetPlatform == TargetPlatform.iOS ||
      (!kIsWeb && Platform.isIOS);

  void _toggleSelection(DocFile file) {
    setState(() {
      if (_selectedPaths.contains(file.path)) {
        _selectedPaths.remove(file.path);
        _selectedFilesMap.remove(file.path);
      } else {
        _selectedPaths.add(file.path);
        _selectedFilesMap[file.path] = file;
      }
    });
  }

  Future<void> _handleICloudPick() async {
    try {
      final pickedFiles = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (pickedFiles.isNotEmpty) {
        final now = DateTime.now();
        setState(() {
          for (final f in pickedFiles) {
            final path = f.path;
            if (path == null) continue;
            final ioFile = File(path);
            final sizeBytes = ioFile.existsSync() ? ioFile.lengthSync() : 0;
            final docFile = DocFile(
              id: -1,
              path: path,
              name: f.name,
              extension: '.pdf',
              sizeBytes: sizeBytes,
              modified: now,
              category: FileCategory.pdf,
            );
            _importedICloudFiles.add(docFile);
            _selectedPaths.add(path);
            _selectedFilesMap[path] = docFile;
          }
        });
      }
    } catch (_) {
      // Graceful fallback if file picker cancelled or unavailable
    }
  }

  List<DocFile> _filterFiles(List<DocFile> allFiles) {
    final combined = <DocFile>[..._importedICloudFiles, ...allFiles];
    // Deduplicate by path
    final seen = <String>{};
    final unique = <DocFile>[];
    for (final f in combined) {
      if (seen.add(f.path)) {
        unique.add(f);
      }
    }

    final now = DateTime.now();
    final thirtyDaysAgo = now.subtract(const Duration(days: 30));

    Iterable<DocFile> list;
    switch (_currentTab) {
      case _PickerTab.all:
        list = unique;
        break;
      case _PickerTab.recent:
        list = unique.where((f) => f.modified.isAfter(thirtyDaysAgo));
        break;
      case _PickerTab.platformSource:
        if (_isIOS) {
          list = _importedICloudFiles;
        } else {
          list = unique.where((f) {
            final lower = f.path.toLowerCase();
            return lower.contains('/download') || lower.contains(r'\download');
          });
        }
        break;
    }

    if (_filterQuery.isNotEmpty) {
      list = list.where((f) => f.name.toLowerCase().contains(_filterQuery));
    }

    return list.toList();
  }

  void _onDone() {
    final selectedList = _selectedFilesMap.values.toList();
    Navigator.of(context).pop(selectedList);
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final pdfsAsync = ref.watch(filesProvider(FileCategory.pdf));
    final effectiveTitle = widget.title ?? 'Select PDFs';

    return Scaffold(
      backgroundColor: tokens.surface,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: SafeArea(
          child: Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: tokens.surface,
              border: Border(
                bottom: BorderSide(color: tokens.hairline, width: 1),
              ),
            ),
            child: _isSearching
                ? Row(
                    children: [
                      DocIconButton(
                        icon: AppIcons.back,
                        tooltip: 'Close search',
                        onPressed: () {
                          setState(() {
                            _isSearching = false;
                            _filterQuery = '';
                            _searchController.clear();
                          });
                        },
                      ),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          autofocus: true,
                          textInputAction: TextInputAction.search,
                          style: DocViewTypography.bodyLg.copyWith(
                            color: tokens.textPrimary,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Search PDFs...',
                            hintStyle: DocViewTypography.bodyLg.copyWith(
                              color: tokens.textSecondary,
                            ),
                            border: InputBorder.none,
                          ),
                          onChanged: (val) {
                            setState(
                                () => _filterQuery = val.trim().toLowerCase());
                          },
                        ),
                      ),
                      if (_searchController.text.isNotEmpty)
                        DocIconButton(
                          icon: AppIcons.close,
                          tooltip: 'Clear search',
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                              _filterQuery = '';
                            });
                          },
                        ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          DocIconButton(
                            icon: AppIcons.back,
                            tooltip: 'Back',
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            effectiveTitle,
                            style: DocViewTypography.headlineSm.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: tokens.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      DocIconButton(
                        icon: AppIcons.search,
                        tooltip: 'Search',
                        onPressed: () {
                          setState(() => _isSearching = true);
                        },
                      ),
                    ],
                  ),
          ),
        ),
      ),
      body: pdfsAsync.when(
        data: (allFiles) {
          final filteredFiles = _filterFiles(allFiles);

          // Eagerly trigger page count loading for displayed files
          for (final f in filteredFiles) {
            PdfPageCountService.instance.loadPageCount(
              f.path,
              onLoaded: () {
                if (mounted) setState(() {});
              },
            );
          }

          return Column(
            children: [
              // Source tabs / Filter Pill Row
              _buildFilterPillRow(tokens, allFiles.length),

              // File list or empty state
              Expanded(
                child: filteredFiles.isEmpty
                    ? _buildEmptyState(tokens)
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                        itemCount: filteredFiles.length +
                            (filteredFiles.length >= 5 ? 1 : 0),
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          // In-feed native ad row strictly after 5th item (index 5 in combined list)
                          if (filteredFiles.length >= 5 && index == 5) {
                            return const NativeAdRow(isLoaded: true);
                          }

                          final fileIndex =
                              (filteredFiles.length >= 5 && index > 5)
                                  ? index - 1
                                  : index;
                          final file = filteredFiles[fileIndex];
                          final isSelected =
                              _selectedPaths.contains(file.path);

                          return _buildFileRow(tokens, file, isSelected);
                        },
                      ),
              ),
            ],
          );
        },
        loading: () => Column(
          children: [
            _buildFilterPillRow(tokens, 0),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: 6,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (_, _) => const SkeletonFileRow(),
              ),
            ),
          ],
        ),
        error: (err, _) => Center(
          child: Text('Error loading PDFs: $err'),
        ),
      ),
      bottomSheet: _buildStickyFooter(tokens, pdfsAsync.value ?? []),
    );
  }

  Widget _buildFilterPillRow(DocViewTokens tokens, int totalCount) {
    final platformTabLabel = _isIOS ? 'iCloud Drive' : 'Downloads';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: tokens.surface,
        border: Border(
          bottom: BorderSide(color: tokens.hairline, width: 1),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildPill(
              tokens: tokens,
              label: 'All PDFs ($totalCount)',
              isSelected: _currentTab == _PickerTab.all,
              onTap: () => setState(() => _currentTab = _PickerTab.all),
            ),
            const SizedBox(width: 8),
            _buildPill(
              tokens: tokens,
              label: 'Recent',
              isSelected: _currentTab == _PickerTab.recent,
              onTap: () => setState(() => _currentTab = _PickerTab.recent),
            ),
            const SizedBox(width: 8),
            _buildPill(
              tokens: tokens,
              label: platformTabLabel,
              isSelected: _currentTab == _PickerTab.platformSource,
              onTap: () {
                if (_isIOS) {
                  _handleICloudPick();
                } else {
                  setState(() => _currentTab = _PickerTab.platformSource);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPill({
    required DocViewTokens tokens,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? tokens.primaryBlue : tokens.surfaceAlt,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? tokens.primaryBlue : tokens.hairline,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: DocViewTypography.labelXs.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : tokens.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildFileRow(DocViewTokens tokens, DocFile file, bool isSelected) {
    final isFlagged =
        PdfPageCountService.instance.isFlaggedError(file.path);
    final pageCount =
        PdfPageCountService.instance.getCachedCount(file.path);
    final sizeStr = FormatUtils.formatFileSize(file.sizeBytes);
    final dateStr = FormatUtils.formatDate(file.modified);

    return InkWell(
      onTap: () => _toggleSelection(file),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? tokens.blueTint : tokens.surfaceAlt,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? tokens.primaryBlue : tokens.hairline,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            // Preview thumbnail
            FileThumbnail(
              filePath: file.path,
              category: FileCategory.pdf,
              source: PdfThumbnailSource.instance,
              width: 44,
              height: 52,
              borderRadius: 10,
            ),
            const SizedBox(width: 12),

            // Metadata column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    file.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: DocViewTypography.titleMd.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: tokens.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (isFlagged)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: tokens.error.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Protected or damaged',
                        style: DocViewTypography.captionXs.copyWith(
                          color: tokens.error,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    )
                  else
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const NeverScrollableScrollPhysics(),
                      child: Row(
                        children: [
                          Text(
                            '$dateStr · $sizeStr · ',
                            style: DocViewTypography.bodySm.copyWith(
                              color: tokens.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                          if (pageCount != null)
                            Text(
                              '$pageCount ${pageCount == 1 ? 'page' : 'pages'}',
                              style: DocViewTypography.bodySm.copyWith(
                                color: tokens.textSecondary,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          else
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Shimmer(
                                  child: SkeletonBox(
                                    width: 24,
                                    height: 12,
                                    borderRadius: 3,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'pgs',
                                  style: DocViewTypography.bodySm.copyWith(
                                    color: tokens.textSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 8),

            // Round check circle
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? tokens.primaryBlue : Colors.transparent,
                border: Border.all(
                  color: isSelected ? tokens.primaryBlue : tokens.hairline,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      size: 16,
                      color: Colors.white,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStickyFooter(DocViewTokens tokens, List<DocFile> allFiles) {
    var allSelectedPagesKnown = true;
    var totalPages = 0;
    for (final path in _selectedPaths) {
      final count = PdfPageCountService.instance.getCachedCount(path);
      if (count == null) {
        allSelectedPagesKnown = false;
      } else {
        totalPages += count;
      }
    }

    final canProceed = _selectedPaths.length >= widget.minSelection;

    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        14,
        20,
        MediaQuery.paddingOf(context).bottom + 14,
      ),
      decoration: BoxDecoration(
        color: tokens.surfaceAlt,
        border: Border(
          top: BorderSide(color: tokens.hairline, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_selectedPaths.length} selected',
                  style: DocViewTypography.titleMd.copyWith(
                    fontWeight: FontWeight.bold,
                    color: tokens.textPrimary,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                if (_selectedPaths.isEmpty)
                  Text(
                    'Select at least ${widget.minSelection} files',
                    style: DocViewTypography.captionXs.copyWith(
                      color: tokens.textSecondary,
                    ),
                  )
                else if (allSelectedPagesKnown)
                  Text(
                    '$totalPages pages total',
                    style: DocViewTypography.captionXs.copyWith(
                      color: tokens.textSecondary,
                      fontSize: 12,
                    ),
                  )
                else
                  Row(
                    children: [
                      Shimmer(
                        child: SkeletonBox(
                          width: 56,
                          height: 12,
                          borderRadius: 3,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'pages total',
                        style: DocViewTypography.captionXs.copyWith(
                          color: tokens.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: tokens.primaryBlue,
              foregroundColor: Colors.white,
              disabledBackgroundColor: tokens.hairline,
              disabledForegroundColor: tokens.textSecondary.withValues(alpha: 0.5),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            icon: const Text('Next', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            label: const Icon(Icons.arrow_forward_rounded, size: 18),
            onPressed: canProceed ? _onDone : null,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(DocViewTokens tokens) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.picture_as_pdf_outlined,
            size: 56,
            color: tokens.textSecondary.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 12),
          Text(
            _filterQuery.isEmpty
                ? 'No PDF documents found'
                : 'No matches found',
            style: DocViewTypography.titleMd.copyWith(
              color: tokens.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
