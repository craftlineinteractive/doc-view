import 'package:flutter/material.dart';

import '../../../../data/models/pdf_markup.dart';

/// Overlay widget drawn over a PDF page rendering all active markup annotations.
class PageMarkupOverlay extends StatelessWidget {
  const PageMarkupOverlay({
    required this.pageIndex,
    required this.markups,
    super.key,
  });

  final int pageIndex;
  final List<TextMarkup> markups;

  @override
  Widget build(BuildContext context) {
    final pageMarkups = markups.where((m) => m.pageIndex == pageIndex).toList();
    if (pageMarkups.isEmpty) {
      return const SizedBox.shrink();
    }

    return CustomPaint(
      painter: _PageMarkupPainter(markups: pageMarkups),
    );
  }
}

class _PageMarkupPainter extends CustomPainter {
  final List<TextMarkup> markups;

  const _PageMarkupPainter({required this.markups});

  @override
  void paint(Canvas canvas, Size size) {
    for (final markup in markups) {
      final baseColor = Color(markup.colorValue);

      switch (markup.type) {
        case TextMarkupType.highlight:
          final paint = Paint()
            ..color = baseColor.withValues(alpha: 0.35)
            ..style = PaintingStyle.fill;

          for (final rect in markup.lineRects) {
            canvas.drawRect(rect, paint);
          }
          break;

        case TextMarkupType.underline:
          final paint = Paint()
            ..color = baseColor
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.5;

          for (final rect in markup.lineRects) {
            final y = rect.bottom - 1.0;
            canvas.drawLine(Offset(rect.left, y), Offset(rect.right, y), paint);
          }
          break;

        case TextMarkupType.strikethrough:
          final paint = Paint()
            ..color = baseColor
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.5;

          for (final rect in markup.lineRects) {
            final y = rect.center.dy;
            canvas.drawLine(Offset(rect.left, y), Offset(rect.right, y), paint);
          }
          break;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _PageMarkupPainter oldDelegate) {
    return oldDelegate.markups != markups;
  }
}
