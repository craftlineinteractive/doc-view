import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/doc_view_typography.dart';
import '../../core/utils/format_utils.dart';
import '../../data/models/doc_file.dart';
import '../../shared/widgets/skeletons/shimmer.dart';
import '../providers/providers.dart';
import 'widgets/pdf_more_sheet.dart';

/// Full-screen image viewer with pinch-to-zoom, double-tap zoom toggle,
/// real image dimensions info chip, zoom pill, and tap-to-hide chrome.
class ImageViewerScreen extends ConsumerStatefulWidget {
  const ImageViewerScreen({
    required this.file,
    super.key,
  });

  final DocFile file;

  @override
  ConsumerState<ImageViewerScreen> createState() => _ImageViewerScreenState();
}

class _ImageViewerScreenState extends ConsumerState<ImageViewerScreen>
    with SingleTickerProviderStateMixin {
  late final TransformationController _transformController;
  late final AnimationController _animController;
  Animation<Matrix4>? _zoomAnimation;

  bool _showChrome = true;
  bool _isLoading = true;
  bool _hasError = false;
  int? _imageWidth;
  int? _imageHeight;
  double _currentScale = 1.0;

  @override
  void initState() {
    super.initState();
    _transformController = TransformationController();
    _transformController.addListener(_onTransformationChanged);

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    )..addListener(() {
        if (_zoomAnimation != null) {
          _transformController.value = _zoomAnimation!.value;
        }
      });

    _resolveImageDimensions();
  }

  @override
  void dispose() {
    _transformController.removeListener(_onTransformationChanged);
    _animController.dispose();
    _transformController.dispose();
    super.dispose();
  }

  void _onTransformationChanged() {
    final scale = _transformController.value.getMaxScaleOnAxis();
    if ((scale - _currentScale).abs() > 0.02) {
      setState(() {
        _currentScale = scale;
      });
    }
  }

  void _resolveImageDimensions() {
    try {
      final imageProvider = FileImage(File(widget.file.path));
      final stream = imageProvider.resolve(ImageConfiguration.empty);
      late ImageStreamListener listener;
      listener = ImageStreamListener(
        (ImageInfo info, bool synchronousCall) {
          if (mounted) {
            setState(() {
              _imageWidth = info.image.width;
              _imageHeight = info.image.height;
              _isLoading = false;
            });
          }
          stream.removeListener(listener);
        },
        onError: (dynamic exception, StackTrace? stackTrace) {
          if (mounted) {
            setState(() {
              _hasError = true;
              _isLoading = false;
            });
          }
        },
      );
      stream.addListener(listener);
    } catch (_) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _isLoading = false;
        });
      }
    }
  }

  void _onDoubleTapDown(TapDownDetails details) {
    final Matrix4 endMatrix;
    if (_currentScale > 1.05) {
      endMatrix = Matrix4.identity();
    } else {
      final position = details.localPosition;
      const double targetScale = 2.5;
      final x = -position.dx * (targetScale - 1);
      final y = -position.dy * (targetScale - 1);

      endMatrix = Matrix4.identity()
        ..setTranslationRaw(x, y, 0.0)
        ..scaleByDouble(targetScale, targetScale, 1.0, 1.0);
    }

    _zoomAnimation = Matrix4Tween(
      begin: _transformController.value,
      end: endMatrix,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    ));

    _animController.forward(from: 0);
  }

  void _resetZoom() {
    _zoomAnimation = Matrix4Tween(
      begin: _transformController.value,
      end: Matrix4.identity(),
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    ));
    _animController.forward(from: 0);
  }

  void _toggleChrome() {
    setState(() {
      _showChrome = !_showChrome;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Watch filesProvider to reflect bookmark toggles in real-time
    final filesAsync = ref.watch(filesProvider(null));
    final currentFile = filesAsync.value
            ?.where((f) => f.path == widget.file.path)
            .firstOrNull ??
        widget.file;

    final mediaQuery = MediaQuery.of(context);
    final topPadding = mediaQuery.padding.top;
    final bottomPadding = mediaQuery.padding.bottom;
    final isZoomed = _currentScale > 1.05;

    // Dimension string from real decoded metadata
    final infoText = (_imageWidth != null && _imageHeight != null)
        ? '$_imageWidth × $_imageHeight • ${FormatUtils.formatFileSize(widget.file.sizeBytes)}'
        : FormatUtils.formatFileSize(widget.file.sizeBytes);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Reading / Interactive zoom area
          Positioned.fill(
            child: InteractiveViewer(
              transformationController: _transformController,
              minScale: 1.0,
              maxScale: 5.0,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _toggleChrome,
                onDoubleTapDown: _onDoubleTapDown,
                onDoubleTap: () {},
                child: SizedBox.expand(
                  child: Center(
                    child: _isLoading
                        ? _buildLoadingSkeleton()
                        : _hasError
                            ? _buildErrorPlaceholder()
                            : Image.file(
                                File(widget.file.path),
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return _buildErrorPlaceholder();
                                },
                              ),
                  ),
                ),
              ),
            ),
          ),

          // 2. Animated top bar
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            top: _showChrome ? 0 : -(kToolbarHeight + topPadding),
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(top: topPadding),
              color: Colors.black.withValues(alpha: 0.65),
              child: SizedBox(
                height: kToolbarHeight,
                child: Row(
                  children: [
                    IconButton(
                      constraints:
                          const BoxConstraints(minWidth: 48, minHeight: 48),
                      icon: const Icon(
                        Icons.arrow_back_rounded,
                        color: Colors.white,
                      ),
                      tooltip: 'Back',
                      onPressed: () => Navigator.of(context).maybePop(),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.file.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: DocViewTypography.titleMd.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            infoText,
                            style: DocViewTypography.captionXs.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      constraints:
                          const BoxConstraints(minWidth: 48, minHeight: 48),
                      icon: Icon(
                        currentFile.isBookmarked
                            ? Icons.bookmark_rounded
                            : Icons.bookmark_border_rounded,
                        color: currentFile.isBookmarked
                            ? const Color(0xFF1A73E8)
                            : Colors.white,
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
                      icon: const Icon(
                        Icons.more_vert_rounded,
                        color: Colors.white,
                      ),
                      tooltip: 'More options',
                      onPressed: () {
                        ViewerMoreSheet.show(
                          context,
                          file: currentFile,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 3. Zoom pill (visible only when zoomed > 1.05x)
          if (isZoomed)
            Positioned(
              right: 16,
              bottom: bottomPadding + 64,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 180),
                opacity: _showChrome ? 1.0 : 0.0,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _resetZoom,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.75),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${_currentScale.toStringAsFixed(1)}x',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              fontFeatures: [FontFeature.tabularFigures()],
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(
                            Icons.restart_alt_rounded,
                            size: 14,
                            color: Colors.white70,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // 4. Bottom info chip (centered, tap-to-toggle)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            bottom: _showChrome ? (bottomPadding + 16) : -60,
            left: 20,
            right: 20,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.65),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.15),
                  ),
                ),
                child: Text(
                  infoText,
                  style: DocViewTypography.captionXs.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingSkeleton() {
    return Container(
      width: 260,
      height: 260,
      decoration: BoxDecoration(
        color: const Color(0xFF1E2129),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Shimmer(
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: const Color(0xFF2E3342),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Loading image...',
              style: TextStyle(color: Colors.white54, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorPlaceholder() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.broken_image_outlined,
          size: 64,
          color: Colors.white38,
        ),
        SizedBox(height: 16),
        Text(
          'Failed to load image',
          style: TextStyle(color: Colors.white70, fontSize: 14),
        ),
      ],
    );
  }
}
