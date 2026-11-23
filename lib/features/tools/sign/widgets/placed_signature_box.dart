import 'package:flutter/material.dart';

import '../../../../core/theme/doc_view_tokens.dart';
import '../../../../data/models/placed_signature.dart';

/// Draggable and resizable bounding box representing a placed vector signature on a PDF page.
class PlacedSignatureBox extends StatelessWidget {
  const PlacedSignatureBox({
    required this.signature,
    required this.isSelected,
    required this.pageSize,
    required this.onTap,
    required this.onMoved,
    required this.onResized,
    required this.onDeleted,
    required this.onApplied,
    super.key,
  });

  final PlacedSignature signature;
  final bool isSelected;
  final Size pageSize;
  final VoidCallback onTap;
  final ValueChanged<Rect> onMoved;
  final ValueChanged<Rect> onResized;
  final VoidCallback onDeleted;
  final VoidCallback onApplied;

  static const double minWidth = 60.0;
  static const double minHeight = 20.0;
  static const double handleSize = 22.0;

  void _handlePanUpdate(DragUpdateDetails details) {
    var newLeft = signature.bounds.left + details.delta.dx;
    var newTop = signature.bounds.top + details.delta.dy;

    // Clamp within page visual bounds
    newLeft = newLeft.clamp(0.0, (pageSize.width - signature.bounds.width).clamp(0.0, double.infinity));
    newTop = newTop.clamp(0.0, (pageSize.height - signature.bounds.height).clamp(0.0, double.infinity));

    final newRect = Rect.fromLTWH(
      newLeft,
      newTop,
      signature.bounds.width,
      signature.bounds.height,
    );
    onMoved(newRect);
  }

  void _handleResize(DragUpdateDetails details, {required bool isRight, required bool isBottom}) {
    final maxWidth = pageSize.width * 0.9;
    final aspect = signature.bounds.width / signature.bounds.height;

    var newWidth = signature.bounds.width + (isRight ? details.delta.dx : -details.delta.dx);
    newWidth = newWidth.clamp(minWidth, maxWidth);
    var newHeight = newWidth / aspect;

    if (newHeight < minHeight) {
      newHeight = minHeight;
      newWidth = newHeight * aspect;
    }

    var newLeft = isRight ? signature.bounds.left : signature.bounds.right - newWidth;
    var newTop = isBottom ? signature.bounds.top : signature.bounds.bottom - newHeight;

    newLeft = newLeft.clamp(0.0, pageSize.width - newWidth);
    newTop = newTop.clamp(0.0, pageSize.height - newHeight);

    final newRect = Rect.fromLTWH(newLeft, newTop, newWidth, newHeight);
    onResized(newRect);
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final bounds = signature.bounds;

    return Positioned(
      left: bounds.left,
      top: bounds.top,
      width: bounds.width,
      height: bounds.height,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Content and drag area
          GestureDetector(
            onTap: onTap,
            onPanUpdate: isSelected ? _handlePanUpdate : null,
            child: Container(
              decoration: BoxDecoration(
                color: isSelected ? tokens.primaryBlue.withValues(alpha: 0.08) : Colors.transparent,
                border: Border.all(
                  color: isSelected ? tokens.primaryBlue : Colors.transparent,
                  width: isSelected ? 1.5 : 0.0,
                  strokeAlign: BorderSide.strokeAlignOutside,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: CustomPaint(
                size: Size(bounds.width, bounds.height),
                painter: _VectorSignatureWidgetPainter(
                  strokes: signature.normalizedStrokes,
                  color: Color(signature.colorValue),
                  strokeWidth: signature.strokeWidth,
                ),
              ),
            ),
          ),

          // Floating controls (Delete & Apply) when selected
          if (isSelected) ...[
            // Top action bar
            Positioned(
              top: -38,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Material(
                    color: tokens.surface,
                    elevation: 4,
                    borderRadius: BorderRadius.circular(16),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          key: const Key('placed_sig_delete'),
                          borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
                          onTap: onDeleted,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Icon(Icons.delete_outline, size: 20, color: tokens.error),
                          ),
                        ),
                        Container(width: 1, height: 18, color: tokens.hairline),
                        InkWell(
                          key: const Key('placed_sig_apply'),
                          borderRadius: const BorderRadius.horizontal(right: Radius.circular(16)),
                          onTap: onApplied,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Icon(Icons.check, size: 20, color: tokens.primaryBlue),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 4 Corner resize handles (min 48dp touch target)
            // Top-Left
            Positioned(
              left: -handleSize / 2,
              top: -handleSize / 2,
              child: _ResizeHandle(
                onPanUpdate: (d) => _handleResize(d, isRight: false, isBottom: false),
              ),
            ),
            // Top-Right
            Positioned(
              right: -handleSize / 2,
              top: -handleSize / 2,
              child: _ResizeHandle(
                onPanUpdate: (d) => _handleResize(d, isRight: true, isBottom: false),
              ),
            ),
            // Bottom-Left
            Positioned(
              left: -handleSize / 2,
              bottom: -handleSize / 2,
              child: _ResizeHandle(
                onPanUpdate: (d) => _handleResize(d, isRight: false, isBottom: true),
              ),
            ),
            // Bottom-Right
            Positioned(
              right: -handleSize / 2,
              bottom: -handleSize / 2,
              child: _ResizeHandle(
                onPanUpdate: (d) => _handleResize(d, isRight: true, isBottom: true),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _VectorSignatureWidgetPainter extends CustomPainter {
  final List<List<Offset>> strokes;
  final Color color;
  final double strokeWidth;

  const _VectorSignatureWidgetPainter({
    required this.strokes,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final dotPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    for (final s in strokes) {
      if (s.isEmpty) continue;
      if (s.length == 1) {
        canvas.drawCircle(
          Offset(s.first.dx * size.width, s.first.dy * size.height),
          strokeWidth / 2,
          dotPaint,
        );
      } else {
        final path = Path()
          ..moveTo(s.first.dx * size.width, s.first.dy * size.height);
        for (var i = 1; i < s.length; i++) {
          path.lineTo(s[i].dx * size.width, s[i].dy * size.height);
        }
        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _VectorSignatureWidgetPainter oldDelegate) =>
      oldDelegate.strokes != strokes || oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
}

class _ResizeHandle extends StatelessWidget {
  const _ResizeHandle({required this.onPanUpdate});

  final GestureDragUpdateCallback onPanUpdate;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return GestureDetector(
      onPanUpdate: onPanUpdate,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: PlacedSignatureBox.handleSize,
        height: PlacedSignatureBox.handleSize,
        decoration: BoxDecoration(
          color: tokens.surface,
          shape: BoxShape.circle,
          border: Border.all(color: tokens.primaryBlue, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
      ),
    );
  }
}
