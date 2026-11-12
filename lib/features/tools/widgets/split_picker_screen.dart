import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/file_types.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/doc_view_tokens.dart';
import '../../../core/theme/doc_view_typography.dart';
import '../../../core/utils/format_utils.dart';
import '../../../data/models/doc_file.dart';
import '../../../shared/widgets/buttons/doc_icon_button.dart';
import '../../../shared/widgets/skeletons/shimmer.dart';
import '../../../shared/widgets/skeletons/skeleton_variants.dart';
import '../../../shared/widgets/tiles/file_thumbnail.dart';
import '../../../shared/widgets/tiles/pdf_thumbnail_source.dart';
import '../../providers/providers.dart';
import '../services/pdf_page_count_service.dart';

/// Single-select PDF document picker for Split PDF tool matching Frame 01 of 06_tools/04_split_pdf.
class SplitPickerScreen extends ConsumerStatefulWidget {
  const SplitPickerScreen({super.key});

  static Future<DocFile?> pick(BuildContext context) {
    return Navigator.of(context).push<DocFile>(
      MaterialPageRoute(
        builder: (context) => const SplitPickerScreen(),
      ),
    );
  }

  @override
  ConsumerState<SplitPickerScreen> createState() => _SplitPickerScreenState();
}

class _SplitPickerScreenState extends ConsumerState<SplitPickerScreen> {
  DocFile? _selectedFile;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  String _filterQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onDone() {
    if (_selectedFile != null) {
      Navigator.of(context).pop(_selectedFile);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final pdfsAsync = ref.watch(filesProvider(FileCategory.pdf));

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
                            'Select PDF to split',
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
          // Sort by modified date descending
          final sortedFiles = List<DocFile>.from(allFiles)
            ..sort((a, b) => b.modified.compareTo(a.modified));

          final filteredFiles = _filterQuery.isEmpty
              ? sortedFiles
              : sortedFiles
                  .where((f) => f.name.toLowerCase().contains(_filterQuery))
                  .toList();

          // Eagerly trigger page count loading
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
              // Subhead
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: tokens.surface,
                  border: Border(
                    bottom: BorderSide(color: tokens.hairline, width: 1),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ALL LOCAL DOCUMENTS (${filteredFiles.length})',
                      style: DocViewTypography.captionXs.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.1,
                        color: tokens.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                    Text(
                      'SORT BY DATE',
                      style: DocViewTypography.captionXs.copyWith(
                        color: tokens.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),

              // File list or empty
              Expanded(
                child: filteredFiles.isEmpty
                    ? _buildEmptyState(tokens)
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
                        itemCount: filteredFiles.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final file = filteredFiles[index];
                          final isSelected = _selectedFile?.path == file.path;
                          return _buildFileItem(tokens, file, isSelected);
                        },
                      ),
              ),
            ],
          );
        },
        loading: () => Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: tokens.surface,
              child: const Row(
                children: [
                  Shimmer(
                    child: SkeletonBox(width: 140, height: 12, borderRadius: 3),
                  ),
                ],
              ),
            ),
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
          child: Text('Error loading files: $err'),
        ),
      ),
      bottomSheet: _buildStickyFooter(tokens),
    );
  }

  Widget _buildFileItem(DocViewTokens tokens, DocFile file, bool isSelected) {
    final pageCount = PdfPageCountService.instance.getCachedCount(file.path);
    final isFlagged = PdfPageCountService.instance.isFlaggedError(file.path);
    final sizeStr = FormatUtils.formatFileSize(file.sizeBytes);

    return InkWell(
      onTap: () {
        setState(() {
          _selectedFile = file;
        });
      },
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
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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
                    Row(
                      children: [
                        if (pageCount != null)
                          Text(
                            '$pageCount ${pageCount == 1 ? 'page' : 'pages'} · $sizeStr',
                            style: DocViewTypography.bodySm.copyWith(
                              color: tokens.textSecondary,
                              fontSize: 12,
                            ),
                          )
                        else
                          Row(
                            children: [
                              Shimmer(
                                child: SkeletonBox(width: 24, height: 12, borderRadius: 3),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'pgs · $sizeStr',
                                style: DocViewTypography.bodySm.copyWith(
                                  color: tokens.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                ],
              ),
            ),
            const SizedBox(width: 8),

            // Radio Button
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? tokens.primaryBlue : Colors.transparent,
                border: Border.all(
                  color: isSelected ? tokens.primaryBlue : tokens.hairline,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStickyFooter(DocViewTokens tokens) {
    final selectedCount = _selectedFile != null ? 1 : 0;
    final selectedPageCount = _selectedFile != null
        ? PdfPageCountService.instance.getCachedCount(_selectedFile!.path)
        : null;

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
                  '$selectedCount PDF selected',
                  style: DocViewTypography.titleMd.copyWith(
                    fontWeight: FontWeight.bold,
                    color: tokens.textPrimary,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                if (_selectedFile == null)
                  Text(
                    'Select a document to continue',
                    style: DocViewTypography.captionXs.copyWith(
                      color: tokens.textSecondary,
                    ),
                  )
                else if (selectedPageCount != null)
                  Text(
                    '$selectedPageCount pages active',
                    style: DocViewTypography.captionXs.copyWith(
                      color: tokens.textSecondary,
                      fontSize: 12,
                    ),
                  )
                else
                  Row(
                    children: [
                      Shimmer(
                        child: SkeletonBox(width: 44, height: 12, borderRadius: 3),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'pages active',
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
            onPressed: _selectedFile != null ? _onDone : null,
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
