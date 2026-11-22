import 'dart:ui';

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
}
