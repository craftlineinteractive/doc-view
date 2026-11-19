import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:open_filex/open_filex.dart';
import 'package:pdfrx/pdfrx.dart';

import '../../core/config/feature_flags.dart';
import '../../core/extensions/l10n_extension.dart';
import '../../core/theme/doc_view_colors.dart';
import '../../core/theme/doc_view_tokens.dart';
import '../../core/theme/doc_view_typography.dart';
import '../../core/utils/format_utils.dart';
import '../../data/models/doc_file.dart';
import '../../shared/widgets/reader/reader_bottom_row.dart';
import '../../shared/widgets/reader/reader_search_bar.dart';
import '../../shared/widgets/skeletons/shimmer.dart';
import '../files/widgets/file_details_sheet.dart';
import '../providers/providers.dart';
import 'widgets/pdf_goto_page_dialog.dart';
import 'widgets/pdf_password_dialog.dart';

/// Matrix for color inversion (White -> Black, Black -> White).
const List<double> _kInvertColorMatrix = [
  -1,  0,  0, 0, 255,
   0, -1,  0, 0, 255,
   0,  0, -1, 0, 255,
   0,  0,  0, 1,   0,
];

/// Redesigned PDF Reader screen matching strict G3a owner decisions.
///
/// Features:
/// - Custom reader chassis (#EEF0F5 light, #11131B dark) with zero ads.
/// - Top bar: back, file name with "N Pages • size", conditional Convert-to-Word,
///   Pages icon (navigates to /pdf-pages), and 3-dot popup menu.
/// - Shared 5-item [ReaderBottomRow]: Vertical/Horizontal scroll toggle, Phone orientation toggle,
///   Search bar trigger, Canvas Invert toggle, and Share.
/// - Top bar replaced by [ReaderSearchBar] during search with highlight overlay & no-text-layer notice.
/// - Auto-hiding chrome on page tap, with auto-fading page pill ("3 / 120").
class PdfViewerScreen extends ConsumerStatefulWidget {
  final DocFile file;

  const PdfViewerScreen({
    super.key,
    required this.file,
  });

  @override
  ConsumerState<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends ConsumerState<PdfViewerScreen> {
  late final PdfViewerController _controller;
  PdfTextSearcher? _textSearcher;

  int _currentPage = 1;
  int _pageCount = 0;
  bool _isLoading = true;
  bool _hasError = false;
  bool _isMissing = false;
  bool _hasPromptedPasswordOnce = false;

  bool _showChrome = true;
  bool _showPagePill = true;
  Timer? _pagePillIdleTimer;

  bool _isHorizontal = false;
  bool _isInverted = false;
  bool _isSearchActive = false;
  bool _hasNoTextLayer = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = PdfViewerController();
    _checkFileExistence();
    _resetPagePillTimer();
  }

  @override
  void dispose() {
    _pagePillIdleTimer?.cancel();
    _searchController.dispose();
    _textSearcher?.removeListener(_onSearchStatusChanged);
    _textSearcher?.dispose();
    // Restore all device orientations when leaving the reader
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    super.dispose();
  }

  void _onSearchStatusChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _checkFileExistence() {
    final file = File(widget.file.path);
    if (!file.existsSync()) {
      setState(() {
        _isMissing = true;
        _isLoading = false;
      });
    }
  }

  void _toggleChrome() {
    setState(() {
      _showChrome = !_showChrome;
      if (_showChrome) {
        _showPagePill = true;
        _resetPagePillTimer();
      }
    });
  }

  void _onInteractionOrScroll() {
    if (!_showPagePill) {
      setState(() {
        _showPagePill = true;
      });
    }
    _resetPagePillTimer();
  }

  void _resetPagePillTimer() {
    _pagePillIdleTimer?.cancel();
    _pagePillIdleTimer = Timer(const Duration(milliseconds: 2500), () {
      if (mounted && _showPagePill) {
        setState(() {
          _showPagePill = false;
        });
      }
    });
  }

  Future<String?> _handlePasswordRequest() async {
    final isRetry = _hasPromptedPasswordOnce;
    _hasPromptedPasswordOnce = true;

    final password = await PdfPasswordDialog.show(context, isRetry: isRetry);
    if (password == null && mounted) {
      Navigator.of(context).pop();
    }
    return password;
  }

  Future<void> _openGoToDialog() async {
    if (_pageCount <= 1) return;
    final targetPage = await PdfGoToPageDialog.show(
      context,
      currentPage: _currentPage,
      pageCount: _pageCount,
    );
    if (targetPage != null && mounted) {
      _controller.goToPage(pageNumber: targetPage);
      _onInteractionOrScroll();
    }
  }

  Future<void> _openPagesScreen(DocFile liveFile) async {
    if (_hasError || _isMissing) return;

    final result = await context.push<dynamic>(
      '/pdf-pages',
      extra: {
        'file': liveFile,
        'currentPage': _currentPage,
      },
    );

    if (result != null && mounted) {
      if (result is int) {
        _controller.goToPage(pageNumber: result);
        _onInteractionOrScroll();
      } else if (result is Map && result['saved'] == true) {
        setState(() {});
      }
    }
  }

  void _toggleScrollDirection() {
    setState(() {
      _isHorizontal = !_isHorizontal;
    });
    _controller.invalidate();
    // Maintain current page after relayout
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _controller.goToPage(pageNumber: _currentPage);
      }
    });
  }

  void _toggleOrientation() {
    final isPortrait = MediaQuery.orientationOf(context) == Orientation.portrait;
    if (isPortrait) {
      SystemChrome.setPreferredOrientations(const [
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      SystemChrome.setPreferredOrientations(const [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
  }

  void _initSearcherIfNeeded() {
    if (_textSearcher == null && _controller.isReady) {
      _textSearcher = PdfTextSearcher(_controller);
      _textSearcher!.addListener(_onSearchStatusChanged);
    }
  }

  void _openSearch() {
    _initSearcherIfNeeded();
    setState(() {
      _isSearchActive = true;
    });
  }

  void _closeSearch() {
    _textSearcher?.resetTextSearch();
    _searchController.clear();
    setState(() {
      _isSearchActive = false;
    });
  }

  void _handleSearchQuery(String query) {
    _initSearcherIfNeeded();
    if (query.trim().isEmpty) {
      _textSearcher?.resetTextSearch();
    } else {
      _textSearcher?.startTextSearch(
        query,
        caseInsensitive: true,
        goToFirstMatch: true,
        searchImmediately: false,
      );
    }
  }

  Future<void> _checkScannedPdf(PdfDocument doc) async {
    try {
      final pagesToCheck = math.min(doc.pages.length, 5);
      var hasAnyText = false;
      for (var i = 0; i < pagesToCheck; i++) {
        final text = await doc.pages[i].loadText();
        if (text != null && text.fullText.trim().isNotEmpty) {
          hasAnyText = true;
          break;
        }
      }
      if (mounted) {
        setState(() {
          _hasNoTextLayer = !hasAnyText;
        });
      }
    } catch (_) {}
  }

  PdfPageLayout _horizontalPageLayout(
    List<PdfPage> pages,
    PdfViewerParams params,
  ) {
    final height = pages.fold<double>(
          0.0,
          (prev, page) => math.max(prev, page.height),
        ) +
        params.margin * 2;
    final pageLayouts = <Rect>[];
    double x = params.margin;

    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final orderedPages = isRtl ? pages.reversed.toList() : pages;

    for (final page in orderedPages) {
      pageLayouts.add(
        Rect.fromLTWH(
          x,
          (height - page.height) / 2,
          page.width,
          page.height,
        ),
      );
      x += page.width + params.margin;
    }

    if (isRtl) {
      return PdfPageLayout(
        pageLayouts: pageLayouts.reversed.toList(),
        documentSize: Size(x, height),
      );
    }

    return PdfPageLayout(pageLayouts: pageLayouts, documentSize: Size(x, height));
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = context.l10n;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final canvasBg = isDark
        ? DocViewColors.readerCanvasDark
        : DocViewColors.readerCanvasLight;

    // Watch live file state
    final filesAsync = ref.watch(filesProvider(null));
    final liveFile = filesAsync.value
            ?.where((f) => f.path == widget.file.path)
            .firstOrNull ??
        widget.file;

    if (_isMissing) {
      return _buildMissingScreen(tokens, isDark);
    }

    if (_hasError) {
      return _buildCorruptScreen(tokens, isDark);
    }

    final topInset = MediaQuery.paddingOf(context).top;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: canvasBg,
      body: Stack(
        children: [
          // 1. Interactive PDF Canvas (with color inversion filter when active)
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: _toggleChrome,
            child: Listener(
              onPointerDown: (_) => _onInteractionOrScroll(),
              onPointerMove: (_) => _onInteractionOrScroll(),
              child: ColorFiltered(
                colorFilter: _isInverted
                    ? const ColorFilter.matrix(_kInvertColorMatrix)
                    : const ColorFilter.mode(Colors.transparent, BlendMode.dst),
                child: PdfViewer.file(
                  widget.file.path,
                  controller: _controller,
                  passwordProvider: _handlePasswordRequest,
                  params: PdfViewerParams(
                    backgroundColor: canvasBg,
                    layoutPages: _isHorizontal ? _horizontalPageLayout : null,
                    pagePaintCallbacks: [
                      (canvas, rect, page) {
                        _textSearcher?.pageTextMatchPaintCallback(canvas, rect, page);
                      },
                    ],
                    matchTextColor: Colors.yellow.withValues(alpha: 0.5),
                    activeMatchTextColor: Colors.orange.withValues(alpha: 0.65),
                    errorBannerBuilder: (context, error, stackTrace, documentRef) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted && !_hasError) {
                          setState(() {
                            _hasError = true;
                            _isLoading = false;
                          });
                        }
                      });
                      return const SizedBox.shrink();
                    },
                    onViewerReady: (document, controller) {
                      _initSearcherIfNeeded();
                      if (mounted) {
                        setState(() {
                          _pageCount = document.pages.length;
                          _isLoading = false;
                        });
                        _checkScannedPdf(document);
                      }
                    },
                    onPageChanged: (pageNumber) {
                      if (mounted && pageNumber != null) {
                        setState(() {
                          _currentPage = pageNumber;
                        });
                        _onInteractionOrScroll();
                      }
                    },
                  ),
                ),
              ),
            ),
          ),

          // 2. Loading Skeleton Placeholder
          if (_isLoading)
            Positioned.fill(
              child: _buildLoadingSkeleton(tokens, isDark),
            ),

          // 3. Floating Page Pill (auto-fades after 2.5s idle)
          if (!_isLoading && _pageCount > 0)
            Positioned(
              bottom: 96 + bottomInset,
              left: 0,
              right: 0,
              child: Center(
                child: AnimatedOpacity(
                  opacity: _showPagePill ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 260),
                  child: IgnorePointer(
                    ignoring: !_showPagePill,
                    child: Material(
                      color: isDark
                          ? const Color(0xEB1A1D29)
                          : const Color(0xEB11141C),
                      borderRadius: BorderRadius.circular(20),
                      elevation: 4,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: _openGoToDialog,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 7,
                          ),
                          child: Text(
                            '$_currentPage / $_pageCount',
                            style: const TextStyle(
                              fontFamily: 'SpaceGrotesk',
                              fontFeatures: [FontFeature.tabularFigures()],
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // 4. Top App Bar / Search Bar (Animated Visibility)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            top: _showChrome ? 0 : -(kToolbarHeight + topInset + 20),
            left: 0,
            right: 0,
            child: _isSearchActive
                ? ReaderSearchBar(
                    controller: _searchController,
                    onQueryChanged: _handleSearchQuery,
                    onPrevMatch: () => _textSearcher?.goToPrevMatch(),
                    onNextMatch: () => _textSearcher?.goToNextMatch(),
                    onClose: _closeSearch,
                    onClear: () => _textSearcher?.resetTextSearch(),
                    currentMatchIndex: _textSearcher?.currentIndex,
                    totalMatches: _textSearcher?.matches.length ?? 0,
                    isSearching: _textSearcher?.isSearching ?? false,
                    hasNoTextLayer: _hasNoTextLayer,
                  )
                : _buildTopBar(tokens, l10n, isDark, topInset, liveFile),
          ),

          // 5. Floating Bottom Toolbar ([ReaderBottomRow])
          AnimatedPositioned(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            bottom: _showChrome ? (16 + bottomInset) : -(100 + bottomInset),
            left: 20,
            right: 20,
            child: ReaderBottomRow(
              items: [
                // 1. Scroll direction
                ReaderBottomRowItem(
                  icon: _isHorizontal
                      ? Icons.swap_vert_rounded
                      : Icons.swap_horiz_rounded,
                  label: _isHorizontal
                      ? l10n.readerActionVertical
                      : l10n.readerActionHorizontal,
                  tooltip: _isHorizontal
                      ? l10n.readerActionVertical
                      : l10n.readerActionHorizontal,
                  onTap: _toggleScrollDirection,
                ),
                // 2. Rotate orientation
                ReaderBottomRowItem(
                  icon: Icons.screen_rotation_outlined,
                  label: l10n.readerActionRotate,
                  tooltip: l10n.readerActionRotate,
                  onTap: _toggleOrientation,
                ),
                // 3. Search
                ReaderBottomRowItem(
                  icon: Icons.search_rounded,
                  label: l10n.readerActionSearch,
                  tooltip: l10n.readerActionSearch,
                  onTap: _openSearch,
                ),
                // 4. Invert
                ReaderBottomRowItem(
                  icon: Icons.invert_colors_rounded,
                  label: l10n.readerActionInvert,
                  tooltip: l10n.readerActionInvert,
                  isSelected: _isInverted,
                  onTap: () {
                    setState(() {
                      _isInverted = !_isInverted;
                    });
                  },
                ),
                // 5. Share
                ReaderBottomRowItem(
                  icon: Icons.share_outlined,
                  label: l10n.readerActionShare,
                  tooltip: l10n.readerActionShare,
                  onTap: () {
                    ref
                        .read(fileActionsControllerProvider)
                        .shareFiles([liveFile]);
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
    DocFile liveFile,
  ) {
    final subtitle = _pageCount > 0
        ? l10n.readerTopPagesSubtitle(
            _pageCount,
            FormatUtils.formatFileSize(widget.file.sizeBytes),
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
          // Back button
          IconButton(
            icon: Icon(
              Icons.arrow_back_rounded,
              color: tokens.textPrimary,
            ),
            tooltip: l10n.tooltipBack,
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 4),

          // File name & metadata
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  liveFile.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: DocViewTypography.titleMd.copyWith(
                    color: tokens.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: DocViewTypography.bodySm.copyWith(
                    color: tokens.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),

          // Convert to Word (gated behind feature flag; hidden in phase G3)
          if (conversionsEnabled)
            IconButton(
              icon: Icon(
                Icons.transform_rounded,
                color: tokens.textPrimary,
              ),
              tooltip: l10n.readerTooltipConvertToWord,
              constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
              onPressed: () {},
            ),

          // Pages screen button
          IconButton(
            key: const Key('reader_top_pages_button'),
            icon: Icon(
              Icons.grid_view_rounded,
              color: tokens.textPrimary,
            ),
            tooltip: l10n.readerActionPages,
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            onPressed: () => _openPagesScreen(liveFile),
          ),

          // 3-dot context menu
          PopupMenuButton<String>(
            key: const Key('reader_top_menu_button'),
            icon: Icon(
              Icons.more_vert_rounded,
              color: tokens.textPrimary,
            ),
            tooltip: l10n.tooltipMoreActions,
            color: isDark ? const Color(0xFF232838) : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: tokens.hairline.withValues(alpha: 0.6),
                width: 0.5,
              ),
            ),
            onSelected: (value) async {
              switch (value) {
                case 'goto':
                  _openGoToDialog();
                  break;
                case 'bookmark':
                  ref
                      .read(fileActionsControllerProvider)
                      .toggleBookmark(liveFile);
                  break;
                case 'details':
                  FileDetailsSheet.show(
                    context,
                    liveFile,
                    pageCount: _pageCount > 0 ? _pageCount : null,
                    showOpenButton: false,
                  );
                  break;
                case 'open_external':
                  final result = await OpenFilex.open(liveFile.path);
                  if (result.type != ResultType.done && mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n.viewerErrorNoAppFound),
                      ),
                    );
                  }
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'goto',
                child: Row(
                  children: [
                    Icon(
                      Icons.format_list_numbered_rounded,
                      size: 20,
                      color: tokens.textPrimary,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      l10n.readerMenuGoToPage,
                      style: DocViewTypography.bodyMd.copyWith(
                        color: tokens.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'bookmark',
                child: Row(
                  children: [
                    Icon(
                      liveFile.isBookmarked
                          ? Icons.bookmark_rounded
                          : Icons.bookmark_border_rounded,
                      size: 20,
                      color: liveFile.isBookmarked
                          ? tokens.primaryBlue
                          : tokens.textPrimary,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      liveFile.isBookmarked
                          ? l10n.readerMenuRemoveBookmark
                          : l10n.readerMenuAddBookmark,
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
                      Icons.launch_outlined,
                      size: 20,
                      color: tokens.textPrimary,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      l10n.readerMenuOpenInAnotherApp,
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

  Widget _buildLoadingSkeleton(DocViewTokens tokens, bool isDark) {
    return Center(
      child: Shimmer(
        child: Container(
          width: 280,
          height: 380,
          margin: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E2330) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1A000000),
                blurRadius: 16,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 220,
                height: 12,
                decoration: BoxDecoration(
                  color: tokens.shimmerBase,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 8,
                      decoration: BoxDecoration(
                        color: tokens.shimmerBase,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: 200,
                      height: 8,
                      decoration: BoxDecoration(
                        color: tokens.shimmerBase,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: 170,
                      height: 8,
                      decoration: BoxDecoration(
                        color: tokens.shimmerBase,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Container(
                width: 80,
                height: 28,
                decoration: BoxDecoration(
                  color: tokens.shimmerBase,
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCorruptScreen(DocViewTokens tokens, bool isDark) {
    final l10n = context.l10n;
    return Scaffold(
      backgroundColor: isDark
          ? DocViewColors.backgroundDark
          : DocViewColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          widget.file.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: Color(0xFFFDE8E8),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.broken_image_outlined,
                  size: 32,
                  color: Color(0xFFE02B2B),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                l10n.viewerErrorCorruptTitle,
                style: DocViewTypography.headlineSm.copyWith(
                  color: tokens.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.viewerErrorCorruptMessage,
                textAlign: TextAlign.center,
                style: DocViewTypography.bodyMd.copyWith(
                  color: tokens.textSecondary,
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton.icon(
                  onPressed: () async {
                    final messenger = ScaffoldMessenger.of(context);
                    final result = await OpenFilex.open(widget.file.path);
                    if (result.type != ResultType.done && mounted) {
                      messenger.showSnackBar(
                        SnackBar(
                          content: Text(l10n.viewerErrorNoAppFound),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.open_in_new_rounded, size: 18),
                  label: Text(l10n.readerMenuOpenInAnotherApp),
                  style: FilledButton.styleFrom(
                    backgroundColor: tokens.primaryBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: tokens.textPrimary,
                    side: BorderSide(color: tokens.hairline),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(l10n.actionBack),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMissingScreen(DocViewTokens tokens, bool isDark) {
    final l10n = context.l10n;
    return Scaffold(
      backgroundColor: isDark
          ? DocViewColors.backgroundDark
          : DocViewColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          widget.file.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: tokens.surface,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.folder_off_outlined,
                  size: 32,
                  color: tokens.textSecondary,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                l10n.viewerErrorMissingTitle,
                style: DocViewTypography.headlineSm.copyWith(
                  color: tokens.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.viewerErrorMissingMessage,
                textAlign: TextAlign.center,
                style: DocViewTypography.bodyMd.copyWith(
                  color: tokens.textSecondary,
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton(
                  onPressed: () {
                    ref
                        .read(fileActionsControllerProvider)
                        .deleteFiles([widget.file]);
                    Navigator.of(context).pop();
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: tokens.primaryBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(l10n.viewerErrorBackToFiles),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
