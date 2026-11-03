import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/doc_file.dart';
import '../providers/providers.dart';

/// Full-screen image viewer with pinch-to-zoom, double-tap zoom toggle, and tap-to-hide chrome.
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

  bool _showAppBar = true;

  @override
  void initState() {
    super.initState();
    _transformController = TransformationController();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    )..addListener(() {
        if (_zoomAnimation != null) {
          _transformController.value = _zoomAnimation!.value;
        }
      });
  }

  @override
  void dispose() {
    _animController.dispose();
    _transformController.dispose();
    super.dispose();
  }

  void _onDoubleTapDown(TapDownDetails details) {
    final currentScale = _transformController.value.getMaxScaleOnAxis();

    final Matrix4 endMatrix;
    if (currentScale > 1.2) {
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

  void _onSingleTap() {
    setState(() {
      _showAppBar = !_showAppBar;
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
    final appBarHeight = kToolbarHeight + topPadding;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: InteractiveViewer(
              transformationController: _transformController,
              minScale: 1.0,
              maxScale: 5.0,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _onSingleTap,
                onDoubleTapDown: _onDoubleTapDown,
                onDoubleTap: () {},
                child: SizedBox.expand(
                  child: Center(
                    child: Image.file(
                      File(widget.file.path),
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
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
                              style: TextStyle(color: Colors.white70),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            top: _showAppBar ? 0 : -appBarHeight,
            left: 0,
            right: 0,
            height: appBarHeight,
            child: AppBar(
              backgroundColor: Colors.black.withValues(alpha: 0.7),
              elevation: 0,
              title: Text(
                widget.file.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              iconTheme: const IconThemeData(color: Colors.white),
              actions: [
                IconButton(
                  constraints:
                      const BoxConstraints(minWidth: 48, minHeight: 48),
                  icon: Icon(
                    currentFile.isBookmarked
                        ? Icons.bookmark
                        : Icons.bookmark_border,
                    color: currentFile.isBookmarked
                        ? const Color(0xFF1A73E8)
                        : Colors.white70,
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
