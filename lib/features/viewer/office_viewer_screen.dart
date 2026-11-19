import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offline_document_viewer/offline_document_viewer.dart';
import 'package:open_filex/open_filex.dart';

import '../../core/extensions/l10n_extension.dart';
import '../../core/theme/doc_view_colors.dart';
import '../../core/theme/doc_view_tokens.dart';
import '../../core/theme/doc_view_typography.dart';
import '../../core/utils/format_utils.dart';
import '../../data/models/doc_file.dart';
import '../../shared/widgets/buttons/doc_buttons.dart';
import '../../shared/widgets/reader/reader_bottom_row.dart';
import '../../shared/widgets/reader/reader_orientation.dart';
import '../../shared/widgets/reader/reader_search_bar.dart';
import '../../shared/widgets/skeletons/shimmer.dart';
import '../files/widgets/file_details_sheet.dart';
import '../providers/providers.dart';
import 'widgets/office_outline_sheet.dart';

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
  late final ReaderOrientationController _orientationController;
  late DocumentSource _source;
  final TextEditingController _searchController = TextEditingController();

  bool _isSearching = false;
  bool _showChrome = true;
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
    _orientationController = ReaderOrientationController();
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
    _orientationController.dispose();
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
      _showChrome = true;
    });
  }

  void _stopSearch() {
    _searchController.clear();
    _controller.search('');
    setState(() {
      _isSearching = false;
    });
  }

  void _onSearchChanged(String query) {
    if (query.isEmpty) {
      _controller.search('');
    } else {
      _controller.search(query.trim());
    }
  }

  void _toggleChrome() {
    if (_isSearching) return;
    setState(() {
      _showChrome = !_showChrome;
    });
  }

  void _showOutlineBottomSheet(BuildContext context, List<String> outline) {
    OfficeOutlineSheet.show(
      context,
      outline: outline,
      currentPosition: _controller.position,
      onSectionSelected: (index) => _controller.goTo(index),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = context.l10n;
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
    final isLegacyFormat =
        ext == 'doc' || ext == 'ppt' || ext == 'xls' || ext == 'rtf';

    // Banner color tokens
    final legacyBg =
        isDark ? const Color(0xFF2A2518) : const Color(0xFFFFF8E1);
    final legacyFg =
        isDark ? const Color(0xFFE8C860) : const Color(0xFF8A6D00);

    final topInset = MediaQuery.paddingOf(context).top;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: tokens.readerCanvas,
      body: Stack(
        children: [
          // 1. Reading Body with optional banners
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: _toggleChrome,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Spacer matching top chrome height when visible
                  SizedBox(height: topInset + 56),

                  // 1. Legacy format banner (doc, ppt, xls, rtf)
                  if (isLegacyFormat && !_dismissedLegacyBanner)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
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
                              l10n.viewerLegacyFormatBanner,
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
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
                              l10n.viewerSpreadsheetTruncatedBanner,
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

                  // 3. Document View
                  Expanded(
                    child: DocumentView(
                      source: _source,
                      controller: _controller,
                      placeholderBuilder: (context) {
                        return _buildOpeningSkeleton(tokens, l10n);
                      },
                      errorBuilder: (context, failure) {
                        return _buildErrorState(context, failure, tokens, l10n);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. Animated Top Bar / Search Bar
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            top: (_showChrome || _isSearching) ? 0 : -(100 + topInset),
            left: 0,
            right: 0,
            child: _isSearching
                ? ReaderSearchBar(
                    controller: _searchController,
                    onQueryChanged: _onSearchChanged,
                    onClose: _stopSearch,
                    onClear: () {
                      _searchController.clear();
                      _controller.search('');
                    },
                    currentMatchIndex: null,
                    totalMatches: _controller.searchHits,
                    showNavigationChevrons: false,
                  )
                : _buildTopBar(tokens, l10n, isDark, topInset, currentFile, outline, ext),
          ),

          // 3. Animated Floating Bottom Toolbar ([ReaderBottomRow])
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            bottom: _showChrome ? (16 + bottomInset) : -(100 + bottomInset),
            left: 20,
            right: 20,
            child: ReaderBottomRow(
              items: [
                // 1. Rotate
                ReaderBottomRowItem(
                  icon: Icons.screen_rotation_outlined,
                  label: l10n.readerActionRotate,
                  tooltip: l10n.readerActionRotate,
                  onTap: () => _orientationController.toggle(context),
                ),
                // 2. Search
                ReaderBottomRowItem(
                  icon: Icons.search_rounded,
                  label: l10n.readerActionSearch,
                  tooltip: l10n.readerActionSearch,
                  onTap: _startSearch,
                ),
                // 3. Share
                ReaderBottomRowItem(
                  icon: Icons.share_outlined,
                  label: l10n.readerActionShare,
                  tooltip: l10n.readerActionShare,
                  onTap: () {
                    ref
                        .read(fileActionsControllerProvider)
                        .shareFiles([currentFile]);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(
    DocViewTokens tokens,
    dynamic l10n,
    bool isDark,
    double topInset,
    DocFile currentFile,
    List<String> outline,
    String ext,
  ) {
    final subtitle = _controller.info != null
        ? l10n.viewerOfficeUnitsSubtitle(
            _controller.info!.unitCount,
            ext.toUpperCase(),
          )
        : FormatUtils.formatFileSize(widget.file.sizeBytes);

    return Container(
      padding: EdgeInsets.fromLTRB(8, topInset + 4, 8, 8),
      decoration: BoxDecoration(
        color: (isDark ? DocViewColors.backgroundDark : Colors.white)
            .withValues(alpha: 0.96),
        border: Border(
          bottom: BorderSide(
            color: tokens.hairline.withValues(alpha: 0.6),
            width: 0.5,
          ),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.arrow_back_rounded,
              color: tokens.textPrimary,
            ),
            tooltip: l10n.tooltipBack,
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  currentFile.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: DocViewTypography.titleMd.copyWith(
                    color: tokens.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: DocViewTypography.captionXs.copyWith(
                    color: tokens.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          // Bookmark toggle
          IconButton(
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            icon: Icon(
              currentFile.isBookmarked
                  ? Icons.bookmark_rounded
                  : Icons.bookmark_border_rounded,
              color: currentFile.isBookmarked
                  ? tokens.primaryBlue
                  : tokens.textPrimary,
            ),
            tooltip: currentFile.isBookmarked
                ? l10n.tooltipRemoveBookmark
                : l10n.tooltipBookmark,
            onPressed: () {
              ref
                  .read(fileActionsControllerProvider)
                  .toggleBookmark(currentFile);
            },
          ),
          // 3-dot popup menu
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert_rounded, color: tokens.textPrimary),
            tooltip: l10n.tooltipMoreOptions,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            onSelected: (action) {
              if (action == 'outline') {
                _showOutlineBottomSheet(context, outline);
              } else if (action == 'details') {
                FileDetailsSheet.show(context, currentFile);
              } else if (action == 'open_external') {
                OpenFilex.open(widget.file.path);
              }
            },
            itemBuilder: (context) => [
              if (outline.isNotEmpty)
                PopupMenuItem(
                  value: 'outline',
                  child: Row(
                    children: [
                      Icon(
                        Icons.list_alt_rounded,
                        size: 20,
                        color: tokens.textPrimary,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        l10n.viewerMenuOutline,
                        style: DocViewTypography.bodyMd.copyWith(
                          color: tokens.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              PopupMenuItem(
                value: 'details',
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      size: 20,
                      color: tokens.textPrimary,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      l10n.readerMenuDetails,
                      style: DocViewTypography.bodyMd.copyWith(
                        color: tokens.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'open_external',
                child: Row(
                  children: [
                    Icon(
                      Icons.open_in_new_rounded,
                      size: 20,
                      color: tokens.textPrimary,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      l10n.readerMenuOpenExternal,
                      style: DocViewTypography.bodyMd.copyWith(
                        color: tokens.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOpeningSkeleton(DocViewTokens tokens, dynamic l10n) {
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
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: SizedBox(
                      width: 140,
                      height: 3,
                      child: LinearProgressIndicator(
                        backgroundColor: tokens.hairline,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(tokens.primaryBlue),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            l10n.viewerOpeningDocument,
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
    dynamic l10n,
  ) {
    final (String title, String subtitle, IconData icon) = switch (failure) {
      EncryptedDocumentFailure() => (
          l10n.viewerErrorEncryptedTitle as String,
          l10n.viewerErrorEncryptedMessage as String,
          Icons.lock_outline_rounded,
        ),
      TooLargeFailure() => (
          l10n.viewerErrorTooLargeTitle as String,
          l10n.viewerErrorTooLargeMessage as String,
          Icons.data_usage_rounded,
        ),
      UnsupportedFormatFailure() => (
          l10n.viewerErrorUnsupportedFormatTitle as String,
          l10n.viewerErrorUnsupportedFormatMessage as String,
          Icons.help_outline_rounded,
        ),
      _ => (
          l10n.viewerErrorCantOpenTitle as String,
          l10n.viewerErrorCantOpenMessage as String,
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
              label: l10n.viewerActionOpenExternal,
              icon: const Icon(
                Icons.open_in_new_rounded,
                size: 20,
                color: Colors.white,
              ),
              onPressed: () {
                OpenFilex.open(widget.file.path);
              },
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.of(context).maybePop(),
              child: Text(
                l10n.viewerErrorBackToFiles,
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
