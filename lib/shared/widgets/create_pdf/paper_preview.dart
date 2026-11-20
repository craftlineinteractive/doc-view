import 'package:flutter/material.dart';

import '../../../features/tools/create_pdf/paper_template.dart';

/// Interactive vector preview of a paper template.
///
/// Automatically maintains the exact page aspect ratio and scales
/// stroke primitives to fit available layout constraints.
class PaperPreview extends StatelessWidget {
  const PaperPreview({
    required this.template,
    required this.pageSize,
    required this.orientation,
    required this.colorSwatch,
    this.borderRadius,
    this.border,
    this.boxShadow,
    this.isThumbnail = false,
    super.key,
  });

  final PaperTemplate template;
  final PaperPageSize pageSize;
  final PaperOrientation orientation;
  final PaperColorSwatch colorSwatch;
  final BorderRadius? borderRadius;
  final BoxBorder? border;
  final List<BoxShadow>? boxShadow;
  final bool isThumbnail;

  @override
  Widget build(BuildContext context) {
    final widthPt = pageSize.getWidth(orientation);
    final heightPt = pageSize.getHeight(orientation);
    final aspectRatio = widthPt / heightPt;

    final radius = borderRadius ?? BorderRadius.circular(8);

    return AspectRatio(
      aspectRatio: aspectRatio,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: radius,
          border: border ??
              Border.all(
                color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
                width: 1,
              ),
          boxShadow: boxShadow ??
              [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
        ),
        child: ClipRRect(
          borderRadius: radius,
          child: CustomPaint(
            painter: PaperPreviewPainter(
              template: template,
              pageSize: pageSize,
              orientation: orientation,
              colorSwatch: colorSwatch,
              isThumbnail: isThumbnail,
            ),
          ),
        ),
      ),
    );
  }
}

/// Custom painter rendering the identical geometry spec used in the PDF generator.
class PaperPreviewPainter extends CustomPainter {
  const PaperPreviewPainter({
    required this.template,
    required this.pageSize,
    required this.orientation,
    required this.colorSwatch,
    this.isThumbnail = false,
  });

  final PaperTemplate template;
  final PaperPageSize pageSize;
  final PaperOrientation orientation;
  final PaperColorSwatch colorSwatch;
  final bool isThumbnail;

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Draw page background color
    final bgPaint = Paint()
      ..color = Color(colorSwatch.colorValue)
      ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    if (template == PaperTemplate.blank) {
      return;
    }

    final widthPt = pageSize.getWidth(orientation);
    final heightPt = pageSize.getHeight(orientation);
    if (widthPt <= 0 || heightPt <= 0) return;

    final scaleX = size.width / widthPt;
    final scaleY = size.height / heightPt;

    // Spec: when the on-screen pixel pitch between minor lines is below 3 px (small template cards),
    // skip the minor role in the PAINTER (not in the geometry function) so the card stays legible;
    // the large preview must draw everything.
    final minorPitchPx = kPtPerMm * scaleY;
    final skipMinor = (isThumbnail || size.height < 100) && minorPitchPx < 3.0;

    // 2. Fetch single source of truth primitives
    final primitives = computePaperDrawingPrimitives(
      template: template,
      widthPt: widthPt,
      heightPt: heightPt,
    );

    // 3. Batch strokes by role for optimal canvas draw calls
    final minorColor = Color(blendStrokeColor(colorSwatch.colorValue, StrokeRole.minor));
    final majorColor = Color(blendStrokeColor(colorSwatch.colorValue, StrokeRole.major));
    final marginColor = Color(blendStrokeColor(colorSwatch.colorValue, StrokeRole.margin));

    final minorPaint = Paint()
      ..color = minorColor
      ..strokeWidth = 0.6
      ..style = PaintingStyle.stroke;

    final majorPaint = Paint()
      ..color = majorColor
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final marginPaint = Paint()
      ..color = marginColor
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    for (final p in primitives) {
      if (skipMinor && p.role == StrokeRole.minor) {
        continue;
      }

      final Paint paint;
      switch (p.role) {
        case StrokeRole.minor:
          paint = minorPaint;
          break;
        case StrokeRole.major:
          paint = majorPaint;
          break;
        case StrokeRole.margin:
          paint = marginPaint;
          break;
      }

      canvas.drawLine(
        Offset(p.x1 * scaleX, p.y1 * scaleY),
        Offset(p.x2 * scaleX, p.y2 * scaleY),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant PaperPreviewPainter oldDelegate) {
    return template != oldDelegate.template ||
        pageSize != oldDelegate.pageSize ||
        orientation != oldDelegate.orientation ||
        colorSwatch != oldDelegate.colorSwatch ||
        isThumbnail != oldDelegate.isThumbnail;
  }
}
