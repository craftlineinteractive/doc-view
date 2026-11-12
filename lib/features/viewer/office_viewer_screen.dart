import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offline_document_viewer/offline_document_viewer.dart';
import 'package:open_filex/open_filex.dart';

import '../../core/theme/doc_view_colors.dart';
import '../../core/theme/doc_view_tokens.dart';
import '../../core/theme/doc_view_typography.dart';
import '../../data/models/doc_file.dart';
import '../../shared/widgets/buttons/doc_buttons.dart';
import '../../shared/widgets/skeletons/shimmer.dart';
import '../providers/providers.dart';
import 'widgets/pdf_more_sheet.dart';

/// Full-featured, offline Office document viewer supporting Word, Excel, and PowerPoint files.
///
/// Wraps [DocumentView] from `offline_document_viewer`. Keeps `offline_document_viewer`
/// strictly isolated to this file.
class OfficeViewerScreen extends ConsumerStatefulWidget {
  const OfficeViewerScreen({
    required this.file,
    super.key,
  });

  final DocFile file;

  @override
  ConsumerState<OfficeViewerScreen> createState() => _OfficeViewerScreenState();
}

class _OfficeViewerScreenState extends ConsumerState<OfficeViewerScreen> {
  late final DocumentViewController _controller;
  late DocumentSource _source;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  bool _isSearching = false;
  bool _dismissedLegacyBanner = false;
  bool _dismissedTruncatedBanner = false;
  DocumentInfo? _lastInfo;
  int _lastSearchHits = 0;

  @override
  void initState() {
    super.initState();
    _source = DocumentSource.file(widget.file.path);
    _controller = DocumentViewController();
    _controller.addListener(_onControllerChanged);
  }

  @override
  void didUpdateWidget(OfficeViewerScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.file.path != widget.file.path) {
      _source = DocumentSource.file(widget.file.path);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    _controller.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onControllerChanged() {
    if (!mounted) return;
    if (_controller.info != _lastInfo ||
        _controller.searchHits != _lastSearchHits) {
      _lastInfo = _controller.info;
      _lastSearchHits = _controller.searchHits;
      setState(() {});
    }
  }

  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _searchFocusNode.requestFocus();
      }
    });
  }

  void _stopSearch() {
    _searchController.clear();
    _controller.search('');
    setState(() {
      _isSearching = false;
    });
  }

  void _onSearchSubmitted(String query) {
    _controller.search(query.trim());
  }

  void _onSearchChanged(String query) {
    if (query.isEmpty) {
      _controller.search('');
    } else {
      _controller.search(query.trim());
    }
  }

  void _showOutlineBottomSheet(BuildContext context, List<String> outline) {
    final tokens = context.tokens;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 0.75,
          ),
          decoration: BoxDecoration(
            color: isDark ? DocViewColors.backgroundDark : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    margin: const EdgeInsets.only(top: 12, bottom: 8),
                    decoration: BoxDecoration(
                      color: tokens.textSecondary.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Row(
                    children: [
                      Icon(
                        Icons.list_alt_rounded,
                        size: 22,
                        color: tokens.primaryBlue,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Document Outline',
                        style: DocViewTypography.titleMd.copyWith(
                          color: tokens.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: tokens.surface,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${outline.length} items',
                          style: DocViewTypography.captionXs.copyWith(
                            color: tokens.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(height: 1, color: tokens.hairline),
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: outline.length,
                    itemBuilder: (context, index) {
                      final title = outline[index].trim();
                      final isCurrent = index == _controller.position;

                      return ConstrainedBox(
                        constraints: const BoxConstraints(minHeight: 48),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 2,
                          ),
                          leading: Container(
                            width: 28,
                            height: 28,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isCurrent
                                  ? tokens.primaryBlue
                                  : tokens.surface,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '${index + 1}',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: isCurrent
                                    ? Colors.white
                                    : tokens.textSecondary,
                              ),
                            ),
                          ),
                          title: Text(
                            title.isEmpty ? 'Section ${index + 1}' : title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: DocViewTypography.bodyMd.copyWith(
                              color: isCurrent
                                  ? tokens.primaryBlue
                                  : tokens.textPrimary,
                              fontWeight:
                                  isCurrent ? FontWeight.w700 : FontWeight.w500,
                            ),
                          ),
                          trailing: isCurrent
                              ? Icon(
                                  Icons.check_circle_rounded,
                                  size: 18,
                                  color: tokens.primaryBlue,
                                )
                              : null,
                          onTap: () {
                            _controller.goTo(index);
                            Navigator.of(context).pop();
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Watch filesProvider to reflect bookmark state in real-time
    final filesAsync = ref.watch(filesProvider(null));
    final currentFile = filesAsync.value
            ?.where((f) => f.path == widget.file.path)
            .firstOrNull ??
        widget.file;

    final outline = _controller.info?.outline ?? const <String>[];
    final isTruncated = _controller.info?.truncated ?? false;

    final ext = widget.file.name.contains('.')
        ? widget.file.name.split('.').last.toLowerCase()
        : '';
    final isLegacyFormat = ext == 'doc' || ext == 'ppt' || ext == 'xls' || ext == 'rtf';

    // Banner color tokens
    final legacyBg = isDark ? const Color(0xFF2A2518) : const Color(0xFFFFF8E1);
    final legacyFg = isDark ? const Color(0xFFE8C860) : const Color(0xFF8A6D00);

    return Scaffold(
      backgroundColor: tokens.readerCanvas,
      appBar: _isSearching
          ? AppBar(
              backgroundColor: isDark ? DocViewColors.backgroundDark : Colors.white,
              elevation: 0,
              leading: IconButton(
                constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                icon: Icon(Icons.arrow_back_rounded, color: tokens.textPrimary),
                tooltip: 'Exit search',
                onPressed: _stopSearch,
              ),
              title: TextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                textInputAction: TextInputAction.search,
                style: DocViewTypography.bodyLg.copyWith(
                  color: tokens.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: 'Search document...',
                  hintStyle: DocViewTypography.bodyLg.copyWith(
                    color: tokens.textSecondary,
                  ),
                  border: InputBorder.none,
                ),
                onSubmitted: _onSearchSubmitted,
                onChanged: _onSearchChanged,
              ),
              actions: [
                if (_controller.searchHits > 0)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: tokens.primaryBlue.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${_controller.searchHits} matches',
                          style: TextStyle(
                            color: tokens.primaryBlue,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                if (_searchController.text.isNotEmpty)
                  IconButton(
                    constraints:
                        const BoxConstraints(minWidth: 48, minHeight: 48),
                    icon: Icon(Icons.clear_rounded, color: tokens.textSecondary),
                    tooltip: 'Clear search',
                    onPressed: () {
                      _searchController.clear();
                      _controller.search('');
                    },
                  ),
              ],
            )
          : AppBar(
              backgroundColor: isDark ? DocViewColors.backgroundDark : Colors.white,
              elevation: 0,
              leading: IconButton(
                constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                icon: Icon(Icons.arrow_back_rounded, color: tokens.textPrimary),
                tooltip: 'Back',
                onPressed: () => Navigator.of(context).maybePop(),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.file.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: DocViewTypography.titleMd.copyWith(
                      color: tokens.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (_controller.info != null)
                    Text(
                      '${_controller.info!.unitCount} units • ${ext.toUpperCase()}',
                      style: DocViewTypography.captionXs.copyWith(
                        color: tokens.textSecondary,
                      ),
                    ),
                ],
              ),
              actions: [
                IconButton(
                  constraints:
                      const BoxConstraints(minWidth: 48, minHeight: 48),
                  icon: Icon(Icons.search_rounded, color: tokens.textPrimary),
                  tooltip: 'Search document',
                  onPressed: _startSearch,
                ),
                if (outline.isNotEmpty)
                  IconButton(
                    constraints:
                        const BoxConstraints(minWidth: 48, minHeight: 48),
                    icon: Icon(Icons.list_alt_rounded, color: tokens.textPrimary),
                    tooltip: 'Outline',
                    onPressed: () => _showOutlineBottomSheet(context, outline),
                  ),
                IconButton(
                  constraints:
                      const BoxConstraints(minWidth: 48, minHeight: 48),
                  icon: Icon(
                    currentFile.isBookmarked
                        ? Icons.bookmark_rounded
                        : Icons.bookmark_border_rounded,
                    color: currentFile.isBookmarked
                        ? tokens.primaryBlue
                        : tokens.textPrimary,
                  ),
                  tooltip: currentFile.isBookmarked
                      ? 'Remove bookmark'
                      : 'Bookmark',
                  onPressed: () {
                    ref
                        .read(fileActionsControllerProvider)
                        .toggleBookmark(currentFile);
                  },
                ),
                IconButton(
                  constraints:
                      const BoxConstraints(minWidth: 48, minHeight: 48),
                  icon: Icon(Icons.more_vert_rounded, color: tokens.textPrimary),
                  tooltip: 'More options',
                  onPressed: () {
                    ViewerMoreSheet.show(
                      context,
                      file: currentFile,
                      pageCount: _controller.info?.unitCount,
                    );
                  },
                ),
              ],
            ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Legacy format banner (doc, ppt, xls, rtf)
          if (isLegacyFormat && !_dismissedLegacyBanner)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: legacyBg,
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 18,
                    color: legacyFg,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Legacy format: text only',
                      style: DocViewTypography.bodySm.copyWith(
                        color: legacyFg,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _dismissedLegacyBanner = true;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                        Icons.close_rounded,
                        size: 16,
                        color: legacyFg,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // 2. Truncation banner (large spreadsheet)
          if (isTruncated && !_dismissedTruncatedBanner)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: tokens.blueTint,
              child: Row(
                children: [
                  Icon(
                    Icons.table_rows_rounded,
                    size: 18,
                    color: tokens.primaryBlue,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Large spreadsheet: showing the first 3000 rows',
                      style: DocViewTypography.bodySm.copyWith(
                        color: tokens.primaryBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _dismissedTruncatedBanner = true;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                        Icons.close_rounded,
                        size: 16,
                        color: tokens.primaryBlue,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // 3. Document reading body
          Expanded(
            child: DocumentView(
              source: _source,
              controller: _controller,
              onFailure: (failure) {
                debugPrint('DOCUMENT_VIEW_FAILURE: $failure (${failure.runtimeType}) detail: ${failure.detail}');
              },
              placeholderBuilder: (context) {
                return _buildOpeningSkeleton(tokens);
              },
              errorBuilder: (context, failure) {
                return _buildErrorState(context, failure, tokens);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOpeningSkeleton(DocViewTokens tokens) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 220,
            height: 280,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: tokens.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: tokens.hairline),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Shimmer(
                  child: Container(
                    width: 120,
                    height: 16,
                    decoration: BoxDecoration(
                      color: tokens.surfaceHover,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Shimmer(
                  child: Container(
                    width: double.infinity,
                    height: 10,
                    decoration: BoxDecoration(
                      color: tokens.surfaceHover,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Shimmer(
                  child: Container(
                    width: double.infinity,
                    height: 10,
                    decoration: BoxDecoration(
                      color: tokens.surfaceHover,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Shimmer(
                  child: Container(
                    width: 140,
                    height: 10,
                    decoration: BoxDecoration(
                      color: tokens.surfaceHover,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const Spacer(),
                Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(tokens.primaryBlue),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Opening document...',
            style: DocViewTypography.bodyMd.copyWith(
              color: tokens.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(
    BuildContext context,
    DocumentFailure failure,
    DocViewTokens tokens,
  ) {
    final (title, subtitle, icon) = switch (failure) {
      EncryptedDocumentFailure() => (
          'This document is encrypted',
          'Password-protected files cannot be viewed in the offline reader.',
          Icons.lock_outline_rounded,
        ),
      TooLargeFailure() => (
          'This file exceeds the view limit',
          'Large documents should be opened using an external Office viewer.',
          Icons.data_usage_rounded,
        ),
      UnsupportedFormatFailure() => (
          "This format isn't supported",
          'Doc View cannot parse this file format directly.',
          Icons.help_outline_rounded,
        ),
      _ => (
          "Can't open this document",
          'The document could not be rendered offline.',
          Icons.error_outline_rounded,
        ),
    };

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: DocViewColors.pdfSolid.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 36,
                color: DocViewColors.pdfSolid,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: DocViewTypography.headlineSm.copyWith(
                color: tokens.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: DocViewTypography.bodyMd.copyWith(
                color: tokens.textSecondary,
              ),
            ),
            const SizedBox(height: 28),
            DocPrimaryButton(
              label: 'Open in another app',
              icon: const Icon(Icons.open_in_new_rounded, size: 20, color: Colors.white),
              onPressed: () {
                OpenFilex.open(widget.file.path);
              },
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.of(context).maybePop(),
              child: Text(
                'Back to files',
                style: DocViewTypography.labelLg.copyWith(
                  color: tokens.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
