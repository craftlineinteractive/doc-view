import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui';

import 'package:syncfusion_flutter_pdf/pdf.dart' as sf;

/// Pure coordinate transformation utility for mapping between pdfrx visual viewport
/// coordinates and Syncfusion PDF document coordinates.
///
/// Coordinate spaces:
/// 1. **pdfrx Visual Coordinates**:
///    Origin (0,0) is at the top-left of the visually rendered page.
///    X increases rightward: `0 <= x <= visualWidth`.
///    Y increases downward: `0 <= y <= visualHeight`.
///    `visualWidth` and `visualHeight` are the display dimensions at 72 DPI after
///    applying page rotation and CropBox clipping.
///
/// 2. **PDF Default User Space (Native PDF Coordinates)**:
///    Origin (0,0) is at the bottom-left of the page.
///    X increases rightward.
///    Y increases upward.
///
/// 3. **Syncfusion Text Markup Annotation Space**:
///    Syncfusion's [PdfTextMarkupAnnotation] expects [Rect] bounds and [boundsCollection]
///    to have origin (0,0) at the top-left of the unrotated page, with Y pointing downward.
///    Syncfusion's internal `setQuadPoints()` maps this to PDF user space as:
///    `y_pdf = pageHeight - y_sync`.
///    When page rotation (/Rotate 90, 180, 270) or CropBox offsets are present,
///    the coordinates must be transformed to match the default user space.
class PdfCoordinateTransform {
  const PdfCoordinateTransform._();

  /// Converts a visual [Rect] on a rendered page (Flutter top-left coordinate space)
  /// into the [Rect] expected by Syncfusion's [PdfTextMarkupAnnotation].
  ///
  /// - [visualRect]: Bounding rectangle of text or selection in visual page coordinates.
  /// - [visualWidth]: Width of the rendered page at 72 DPI.
  /// - [visualHeight]: Height of the rendered page at 72 DPI.
  /// - [rotationDegrees]: Page rotation in degrees (0, 90, 180, or 270).
  /// - [cropBox]: Optional CropBox of the page if different from MediaBox.
  static Rect visualToSyncfusionRect({
    required Rect visualRect,
    required double visualWidth,
    required double visualHeight,
    required int rotationDegrees,
    Rect? cropBox,
  }) {
    final rotIndex = (rotationDegrees ~/ 90) % 4;

    // Step 1: Convert visual Rect (top-left origin, Y down) to visual PDF space (bottom-left origin, Y up)
    final vPdfLeft = visualRect.left;
    final vPdfTop = visualHeight - visualRect.top;
    final vPdfRight = visualRect.right;
    final vPdfBottom = visualHeight - visualRect.bottom;

    // Step 2: Unrotate visual PDF space back to unrotated default PDF user space.
    // For a page rotated clockwise by rotationDegrees, the inverse rotation (counter-clockwise)
    // restores the default user space coordinates.
    final swap = (rotIndex & 1) == 1;
    final rawWidth = swap ? visualHeight : visualWidth;
    final rawHeight = swap ? visualWidth : visualHeight;

    double uPdfLeft, uPdfTop, uPdfRight, uPdfBottom;
    switch (rotIndex) {
      case 0:
        uPdfLeft = vPdfLeft;
        uPdfTop = vPdfTop;
        uPdfRight = vPdfRight;
        uPdfBottom = vPdfBottom;
        break;
      case 1: // 90° CW -> unrotate 90° CCW
        uPdfLeft = rawWidth - vPdfTop;
        uPdfRight = rawWidth - vPdfBottom;
        uPdfBottom = vPdfLeft;
        uPdfTop = vPdfRight;
        break;
      case 2: // 180° CW -> unrotate 180° CCW
        uPdfLeft = rawWidth - vPdfRight;
        uPdfRight = rawWidth - vPdfLeft;
        uPdfBottom = rawHeight - vPdfTop;
        uPdfTop = rawHeight - vPdfBottom;
        break;
      case 3: // 270° CW -> unrotate 270° CCW (90° CW)
        uPdfLeft = vPdfBottom;
        uPdfRight = vPdfTop;
        uPdfBottom = rawHeight - vPdfRight;
        uPdfTop = rawHeight - vPdfLeft;
        break;
      default:
        throw ArgumentError.value(rotationDegrees, 'rotationDegrees', 'Must be 0, 90, 180, or 270');
    }

    // Step 3: Convert unrotated PDF coordinates (bottom-left origin) to Syncfusion's
    // unrotated page space (top-left origin, Y down).
    var syncLeft = uPdfLeft;
    var syncTop = rawHeight - uPdfTop;
    var syncWidth = uPdfRight - uPdfLeft;
    var syncHeight = uPdfTop - uPdfBottom;

    // Step 4: If CropBox offset origin is present, adjust by CropBox origin
    if (cropBox != null) {
      syncLeft += cropBox.left;
      syncTop -= cropBox.top;
    }

    return Rect.fromLTWH(syncLeft, syncTop, syncWidth, syncHeight);
  }

  /// Converts a visual [Offset] point on a rendered page (Flutter top-left coordinate space)
  /// into the [Offset] in Syncfusion PDF page space.
  static Offset visualToSyncfusionPoint({
    required Offset visualPoint,
    required double visualWidth,
    required double visualHeight,
    required int rotationDegrees,
    Rect? cropBox,
  }) {
    final rect = visualToSyncfusionRect(
      visualRect: Rect.fromLTWH(visualPoint.dx, visualPoint.dy, 0, 0),
      visualWidth: visualWidth,
      visualHeight: visualHeight,
      rotationDegrees: rotationDegrees,
      cropBox: cropBox,
    );
    return Offset(rect.left, rect.top);
  }

  /// Converts a Syncfusion [Offset] back to a visual [Offset] on the rendered page.
  static Offset syncfusionToVisualPoint({
    required Offset syncfusionPoint,
    required double visualWidth,
    required double visualHeight,
    required int rotationDegrees,
    Rect? cropBox,
  }) {
    final rect = syncfusionToVisualRect(
      syncfusionRect: Rect.fromLTWH(syncfusionPoint.dx, syncfusionPoint.dy, 0, 0),
      visualWidth: visualWidth,
      visualHeight: visualHeight,
      rotationDegrees: rotationDegrees,
      cropBox: cropBox,
    );
    return Offset(rect.left, rect.top);
  }

  /// Converts a Syncfusion [Rect] back to a visual [Rect] on the rendered page.
  static Rect syncfusionToVisualRect({
    required Rect syncfusionRect,
    required double visualWidth,
    required double visualHeight,
    required int rotationDegrees,
    Rect? cropBox,
  }) {
    var syncLeft = syncfusionRect.left;
    var syncTop = syncfusionRect.top;

    if (cropBox != null) {
      syncLeft -= cropBox.left;
      syncTop += cropBox.top;
    }

    final rotIndex = (rotationDegrees ~/ 90) % 4;
    final swap = (rotIndex & 1) == 1;
    final rawWidth = swap ? visualHeight : visualWidth;
    final rawHeight = swap ? visualWidth : visualHeight;

    // Convert Syncfusion (top-left, Y down) to unrotated PDF (bottom-left, Y up)
    final uPdfLeft = syncLeft;
    final uPdfTop = rawHeight - syncTop;
    final uPdfRight = syncLeft + syncfusionRect.width;
    final uPdfBottom = uPdfTop - syncfusionRect.height;

    // Forward rotate by rotIndex CW to visual PDF coordinates
    double vPdfLeft, vPdfTop, vPdfRight, vPdfBottom;
    switch (rotIndex) {
      case 0:
        vPdfLeft = uPdfLeft;
        vPdfTop = uPdfTop;
        vPdfRight = uPdfRight;
        vPdfBottom = uPdfBottom;
        break;
      case 1: // 90° CW
        vPdfLeft = uPdfBottom;
        vPdfRight = uPdfTop;
        vPdfTop = rawWidth - uPdfLeft;
        vPdfBottom = rawWidth - uPdfRight;
        break;
      case 2: // 180° CW
        vPdfLeft = rawWidth - uPdfRight;
        vPdfRight = rawWidth - uPdfLeft;
        vPdfTop = rawHeight - uPdfBottom;
        vPdfBottom = rawHeight - uPdfTop;
        break;
      case 3: // 270° CW
        vPdfLeft = rawHeight - uPdfTop;
        vPdfRight = rawHeight - uPdfBottom;
        vPdfTop = uPdfRight;
        vPdfBottom = uPdfLeft;
        break;
      default:
        throw ArgumentError.value(rotationDegrees);
    }

    // Convert visual PDF coordinates to Flutter visual coordinates (top-left, Y down)
    final vLeft = vPdfLeft;
    final vTop = visualHeight - vPdfTop;
    final vWidth = vPdfRight - vPdfLeft;
    final vHeight = vPdfTop - vPdfBottom;

    return Rect.fromLTWH(vLeft, vTop, vWidth, vHeight);
  }

  /// Applies visual-to-PDF transform for all drawing operations (strokes, signatures, text)
  /// so callers draw in visual page coordinates (top-left origin, unrotated view).
  static void withVisualSpace({
    required sf.PdfPage page,
    required double visualWidth,
    required double visualHeight,
    required int rotationDegrees,
    Rect? cropBox,
    required void Function(VisualSpace space) drawCallback,
  }) {
    final space = VisualSpace(
      page: page,
      visualWidth: visualWidth,
      visualHeight: visualHeight,
      rotationDegrees: rotationDegrees,
      cropBox: cropBox,
    );
    drawCallback(space);
  }
}

/// Represents a visual drawing context where coordinates match the rendered page view
/// (origin top-left, X right, Y down, unrotated and CropBox-clipped).
class VisualSpace {
  final sf.PdfPage page;
  final double visualWidth;
  final double visualHeight;
  final int rotationDegrees;
  final Rect? cropBox;

  const VisualSpace({
    required this.page,
    required this.visualWidth,
    required this.visualHeight,
    required this.rotationDegrees,
    this.cropBox,
  });

  /// Maps visual point (Flutter top-left coordinates) to Syncfusion PDF coordinates.
  Offset toSyncPoint(Offset visualPoint) {
    return PdfCoordinateTransform.visualToSyncfusionPoint(
      visualPoint: visualPoint,
      visualWidth: visualWidth,
      visualHeight: visualHeight,
      rotationDegrees: rotationDegrees,
      cropBox: cropBox,
    );
  }

  /// Maps visual rect (Flutter top-left coordinates) to Syncfusion PDF coordinates.
  Rect toSyncRect(Rect visualRect) {
    return PdfCoordinateTransform.visualToSyncfusionRect(
      visualRect: visualRect,
      visualWidth: visualWidth,
      visualHeight: visualHeight,
      rotationDegrees: rotationDegrees,
      cropBox: cropBox,
    );
  }

  /// Draws a freehand pen stroke or tap dot given visual coordinates.
  void drawStroke({
    required List<Offset> points,
    required double strokeWidth,
    required Color color,
    bool isDot = false,
  }) {
    if (points.isEmpty) return;
    final sfColor = sf.PdfColor(
      (color.r * 255.0).round(),
      (color.g * 255.0).round(),
      (color.b * 255.0).round(),
    );

    if (isDot || points.length <= 1) {
      final syncPt = toSyncPoint(points.first);
      final r = math.max(strokeWidth / 2, 1.0);
      page.graphics.drawEllipse(
        Rect.fromCircle(center: syncPt, radius: r),
        brush: sf.PdfSolidBrush(sfColor),
      );
      return;
    }

    final syncPts = points.map(toSyncPoint).toList();
    final path = sf.PdfPath();
    for (var i = 0; i < syncPts.length - 1; i++) {
      path.addLine(syncPts[i], syncPts[i + 1]);
    }
    final pen = sf.PdfPen(sfColor, width: strokeWidth)
      ..lineCap = sf.PdfLineCap.round
      ..lineJoin = sf.PdfLineJoin.round;
    page.graphics.drawPath(path, pen: pen);
  }

  /// Draws a vector signature placed at [visualBounds].
  ///
  /// [normalizedStrokes] are polylines with coordinates normalized to [0..1] x [0..1].
  void drawVectorSignature({
    required List<List<Offset>> normalizedStrokes,
    required Rect visualBounds,
    required double strokeWidth,
    required Color color,
  }) {
    for (final stroke in normalizedStrokes) {
      if (stroke.isEmpty) continue;
      final visualStrokePoints = stroke.map((p) {
        return Offset(
          visualBounds.left + p.dx * visualBounds.width,
          visualBounds.top + p.dy * visualBounds.height,
        );
      }).toList();

      drawStroke(
        points: visualStrokePoints,
        strokeWidth: strokeWidth,
        color: color,
        isDot: stroke.length == 1,
      );
    }
  }

  /// Draws an image (PNG raster) placed at [visualBounds].
  void drawImage({
    required Uint8List pngBytes,
    required Rect visualBounds,
  }) {
    final syncTopLeft = toSyncPoint(visualBounds.topLeft);
    final bitmap = sf.PdfBitmap(pngBytes);
    final rot = (rotationDegrees ~/ 90) % 4;

    if (rot == 0) {
      final syncRect = toSyncRect(visualBounds);
      page.graphics.drawImage(bitmap, syncRect);
      return;
    }

    page.graphics.save();
    page.graphics.translateTransform(syncTopLeft.dx, syncTopLeft.dy);
    switch (rot) {
      case 1:
        page.graphics.rotateTransform(270);
        break;
      case 2:
        page.graphics.rotateTransform(180);
        break;
      case 3:
        page.graphics.rotateTransform(90);
        break;
    }
    page.graphics.drawImage(
      bitmap,
      Rect.fromLTWH(0, 0, visualBounds.width, visualBounds.height),
    );
    page.graphics.restore();
  }

  /// Draws a single line of text at visual position [visualPosition] with [font].
  void drawTextLine({
    required String text,
    required sf.PdfFont font,
    required Offset visualPosition,
    required sf.PdfBrush brush,
  }) {
    final syncPt = toSyncPoint(visualPosition);
    final rot = (rotationDegrees ~/ 90) % 4;

    if (rot == 0) {
      page.graphics.drawString(
        text,
        font,
        bounds: Rect.fromLTWH(syncPt.dx, syncPt.dy, 0, 0),
        brush: brush,
      );
      return;
    }

    page.graphics.save();
    page.graphics.translateTransform(syncPt.dx, syncPt.dy);
    switch (rot) {
      case 1:
        page.graphics.rotateTransform(270);
        break;
      case 2:
        page.graphics.rotateTransform(180);
        break;
      case 3:
        page.graphics.rotateTransform(90);
        break;
    }
    page.graphics.drawString(
      text,
      font,
      bounds: const Rect.fromLTWH(0, 0, 0, 0),
      brush: brush,
    );
    page.graphics.restore();
  }
}
