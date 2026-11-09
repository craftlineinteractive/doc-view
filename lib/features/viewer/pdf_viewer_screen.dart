import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_filex/open_filex.dart';
import 'package:pdfrx/pdfrx.dart';

import '../../core/theme/doc_view_colors.dart';
import '../../core/theme/doc_view_tokens.dart';
import '../../core/theme/doc_view_typography.dart';
import '../../core/utils/format_utils.dart';
import '../../data/models/doc_file.dart';
import '../../shared/widgets/skeletons/shimmer.dart';
import '../providers/providers.dart';
import 'widgets/pdf_goto_page_dialog.dart';
import 'widgets/pdf_more_sheet.dart';
import 'widgets/pdf_pages_sheet.dart';
import 'widgets/pdf_password_dialog.dart';

/// Full-featured PDF reader screen built with pdfrx matching production mockups.
/// Features a custom reader chassis (#EEF0F5 light, #11131B dark), auto-hiding top bar
/// and floating bottom toolbar, auto-fading page indicator pill with tabular figures,
/// page number jump sheet, password prompt, and error / missing-file states.
class PdfViewerScreen extends ConsumerStatefulWidget {
  final DocFile file;

  const PdfViewerScreen({
    super.key,
    required this.file,
  });

  @override
  ConsumerState<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends ConsumerState<PdfViewerScreen>
    with SingleTickerProviderStateMixin {
  late final PdfViewerController _controller;
  int _currentPage = 1;
  int _pageCount = 0;
  bool _isLoading = true;
  bool _hasError = false;
  bool _isMissing = false;
  bool _hasPromptedPasswordOnce = false;

  bool _showChrome = true;
  bool _showPagePill = true;
  Timer? _pagePillIdleTimer;

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
    super.dispose();
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

  Future<void> _openPagesSheet() async {
    if (_pageCount <= 1) return;
    await PdfPagesSheet.show(
      context,
      currentPage: _currentPage,
      pageCount: _pageCount,
      onPageSelected: (page) {
        _controller.goToPage(pageNumber: page);
        _onInteractionOrScroll();
      },
    );
  }

  void _openMoreSheet(DocFile liveFile) {
    PdfMoreSheet.show(
      context,
      file: liveFile,
      pageCount: _pageCount > 0 ? _pageCount : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final canvasBg = isDark
        ? DocViewColors.readerCanvasDark
        : DocViewColors.readerCanvasLight;

    // Reflect live bookmark and file state
    final filesAsync = ref.watch(filesProvider(null));
    final liveFile = filesAsync.value
            ?.where((f) => f.path == widget.file.path)
            .firstOrNull ??
        widget.file;

    // Missing file screen
    if (_isMissing) {
      return _buildMissingScreen(tokens, isDark);
    }

    // Corrupt screen
    if (_hasError) {
      return _buildCorruptScreen(tokens, isDark);
    }

    final topInset = MediaQuery.paddingOf(context).top;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: canvasBg,
      body: Stack(
        children: [
          // 1. Interactive PDF Canvas
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: _toggleChrome,
            child: Listener(
              onPointerDown: (_) => _onInteractionOrScroll(),
              onPointerMove: (_) => _onInteractionOrScroll(),
              child: PdfViewer.file(
                widget.file.path,
                controller: _controller,
                passwordProvider: _handlePasswordRequest,
                params: PdfViewerParams(
                  backgroundColor: canvasBg,
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
                    if (mounted) {
                      setState(() {
                        _pageCount = document.pages.length;
                        _isLoading = false;
                      });
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

          // 2. Loading Skeleton Placeholder
          if (_isLoading)
            Positioned.fill(
              child: _buildLoadingSkeleton(tokens, isDark),
            ),

          // 3. Floating Page Pill (fades on idle)
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

          // 4. Top App Bar (Animated Visibility)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            top: _showChrome ? 0 : -(kToolbarHeight + topInset + 20),
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(8, topInset + 4, 8, 8),
              decoration: BoxDecoration(
                color: (isDark ? DocViewColors.backgroundDark : Colors.white)
                    .withValues(alpha: 0.94),
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
                    constraints: const BoxConstraints(
                      minWidth: 48,
                      minHeight: 48,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 4),
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
                          _pageCount > 0
                              ? '$_pageCount Pages • ${FormatUtils.formatFileSize(widget.file.sizeBytes)}'
                              : FormatUtils.formatFileSize(widget.file.sizeBytes),
                          style: DocViewTypography.bodySm.copyWith(
                            color: tokens.textSecondary,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      liveFile.isBookmarked
                          ? Icons.bookmark_rounded
                          : Icons.bookmark_border_rounded,
                      color: liveFile.isBookmarked
                          ? tokens.primaryBlue
                          : tokens.textSecondary,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 48,
                      minHeight: 48,
                    ),
                    onPressed: () {
                      ref
                          .read(fileActionsControllerProvider)
                          .toggleBookmark(liveFile);
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.more_vert_rounded,
                      color: tokens.textPrimary,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 48,
                      minHeight: 48,
                    ),
                    onPressed: () => _openMoreSheet(liveFile),
                  ),
                ],
              ),
            ),
          ),

          // 5. Floating Bottom Toolbar (Animated Visibility, 24pt radius, safe-area clear)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            bottom: _showChrome ? (16 + bottomInset) : -(100 + bottomInset),
            left: 24,
            right: 24,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                child: Container(
                  height: 64,
                  decoration: BoxDecoration(
                    color: (isDark
                            ? const Color(0xEB232838)
                            : const Color(0xF5FFFFFF))
                        .withValues(alpha: 0.92),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: tokens.hairline.withValues(alpha: 0.7),
                      width: 0.75,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x1F000000),
                        blurRadius: 18,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Pages
                      _ToolbarButton(
                        icon: Icons.grid_view_outlined,
                        label: 'Pages',
                        tokens: tokens,
                        onTap: _openPagesSheet,
                      ),
                      // Go to
                      _ToolbarButton(
                        icon: Icons.format_list_numbered_rounded,
                        label: 'Go to',
                        tokens: tokens,
                        onTap: _openGoToDialog,
                      ),
                      // Share
                      _ToolbarButton(
                        icon: Icons.share_outlined,
                        label: 'Share',
                        tokens: tokens,
                        onTap: () {
                          ref
                              .read(fileActionsControllerProvider)
                              .shareFiles([liveFile]);
                        },
                      ),
                      // More
                      _ToolbarButton(
                        icon: Icons.more_horiz_rounded,
                        label: 'More',
                        tokens: tokens,
                        onTap: () => _openMoreSheet(liveFile),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingSkeleton(DocViewTokens tokens, bool isDark) {
    return Container(
      color: isDark
          ? DocViewColors.readerCanvasDark
          : DocViewColors.readerCanvasLight,
      child: Center(
        child: Shimmer(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 260,
                height: 360,
                decoration: BoxDecoration(
                  color: tokens.surface,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x12000000),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 140,
                      height: 12,
                      decoration: BoxDecoration(
                        color: tokens.shimmerBase,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 16),
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
                  color: const Color(0xFFFDE8E8),
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
                "Can't open this PDF",
                style: DocViewTypography.headlineSm.copyWith(
                  color: tokens.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'This file appears to be damaged or not a valid PDF.',
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
                        const SnackBar(
                          content: Text('No app found to open this file'),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.open_in_new_rounded, size: 18),
                  label: const Text('Open in another app'),
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
                  child: const Text('Back'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMissingScreen(DocViewTokens tokens, bool isDark) {
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
                'This file no longer exists',
                style: DocViewTypography.headlineSm.copyWith(
                  color: tokens.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'The file has been deleted or moved from device storage.',
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
                    // Remove stale record from database
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
                  child: const Text('Back to files'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ToolbarButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final DocViewTokens tokens;
  final VoidCallback onTap;

  const _ToolbarButton({
    required this.icon,
    required this.label,
    required this.tokens,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          constraints: const BoxConstraints(minWidth: 54, minHeight: 48),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 20,
                color: tokens.textPrimary,
              ),
              const SizedBox(height: 3),
              Text(
                label,
                style: DocViewTypography.labelXs.copyWith(
                  color: tokens.textSecondary,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
