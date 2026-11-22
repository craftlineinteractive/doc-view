import 'dart:io';
import 'package:flutter/material.dart';

import '../../../../core/theme/doc_view_tokens.dart';
import '../../../../data/models/placed_signature.dart';

/// Draggable and resizable bounding box representing a placed signature or date stamp on a PDF page.
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
  static const double handleSize = 18.0;

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
              child: Center(
                child: signature.isDateStamp
                    ? FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          child: Text(
                            signature.dateText ?? '',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                      )
                    : Image.file(
                        File(signature.signatureFilePath),
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.broken_image, size: 24),
                      ),
              ),
            ),
          ),

          // Floating controls (Delete & Apply) when selected
          if (isSelected) ...[
            // Top action bar
            Positioned(
              top: -36,
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
                            padding: const EdgeInsets.all(6),
                            child: Icon(Icons.delete_outline, size: 18, color: tokens.error),
                          ),
                        ),
                        Container(width: 1, height: 16, color: tokens.hairline),
                        InkWell(
                          key: const Key('placed_sig_apply'),
                          borderRadius: const BorderRadius.horizontal(right: Radius.circular(16)),
                          onTap: onApplied,
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: Icon(Icons.check, size: 18, color: tokens.primaryBlue),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 4 Corner resize handles
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
        ),
      ),
    );
  }
}
