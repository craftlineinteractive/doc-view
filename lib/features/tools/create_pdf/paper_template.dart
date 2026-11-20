import 'package:flutter/foundation.dart';

/// Available paper template patterns.
enum PaperTemplate {
  blank,
  line1,
  line2,
  notebook,
  cornell,
  grid,
  graph,
}

/// Standard paper sizes in points (72 pt = 1 inch = 25.4 mm).
///
/// Note: B4 and B5 follow the ISO 216 standard dimensions:
/// B5 ISO = 176 x 250 mm (498.90 x 708.66 pt)
/// B4 ISO = 250 x 353 mm (708.66 x 1000.63 pt)
enum PaperPageSize {
  a5(widthPt: 419.53, heightPt: 595.28, label: 'A5'),
  a4(widthPt: 595.28, heightPt: 841.89, label: 'A4'),
  a3(widthPt: 841.89, heightPt: 1190.55, label: 'A3'),
  b5(widthPt: 498.90, heightPt: 708.66, label: 'B5 (ISO)'),
  b4(widthPt: 708.66, heightPt: 1000.63, label: 'B4 (ISO)'),
  letter(widthPt: 612.00, heightPt: 792.00, label: 'Letter'),
  legal(widthPt: 612.00, heightPt: 1008.00, label: 'Legal');

  const PaperPageSize({
    required this.widthPt,
    required this.heightPt,
    required this.label,
  });

  final double widthPt;
  final double heightPt;
  final String label;

  double getWidth(PaperOrientation orientation) {
    return orientation == PaperOrientation.portrait ? widthPt : heightPt;
  }

  double getHeight(PaperOrientation orientation) {
    return orientation == PaperOrientation.portrait ? heightPt : widthPt;
  }
}

/// Orientation of the paper template page.
enum PaperOrientation {
  portrait,
  landscape,
}

/// 10 preset light page background color swatches.
enum PaperColorSwatch {
  white(0xFFFFFFFF, 'swatchWhite'),
  cream(0xFFFFF8E7, 'swatchCream'),
  lightYellow(0xFFFFFBD6, 'swatchLightYellow'),
  lightPeach(0xFFFFEBDD, 'swatchLightPeach'),
  lightPink(0xFFFFE6EE, 'swatchLightPink'),
  lightLavender(0xFFEEE8FF, 'swatchLightLavender'),
  lightBlue(0xFFE6F1FF, 'swatchLightBlue'),
  lightMint(0xFFE3F8EF, 'swatchLightMint'),
  lightGreen(0xFFEAF7DC, 'swatchLightGreen'),
  lightGray(0xFFF0F1F4, 'swatchLightGray');

  const PaperColorSwatch(this.colorValue, this.keyName);

  final int colorValue;
  final String keyName;
}

/// Role of a drawn stroke primitive on the paper template.
enum StrokeRole {
  minor,
  major,
  margin,
}

/// A single straight line stroke primitive on the paper page.
/// Coordinates are in points relative to the top-left (0,0) of the page.
@immutable
class PaperStrokePrimitive {
  const PaperStrokePrimitive({
    required this.x1,
    required this.y1,
    required this.x2,
    required this.y2,
    required this.role,
  });

  final double x1;
  final double y1;
  final double x2;
  final double y2;
  final StrokeRole role;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaperStrokePrimitive &&
          runtimeType == other.runtimeType &&
          x1 == other.x1 &&
          y1 == other.y1 &&
          x2 == other.x2 &&
          y2 == other.y2 &&
          role == other.role;

  @override
  int get hashCode => Object.hash(x1, y1, x2, y2, role);

  @override
  String toString() =>
      'PaperStrokePrimitive($x1, $y1 -> $x2, $y2, role: $role)';
}

/// Computes the exact blended opaque 32-bit ARGB integer for a given role over [pageColorValue].
///
/// Base ink: `#6B7A99` (RGB: 107, 122, 153).
/// Margin ink: `#E07A7A` (RGB: 224, 122, 122).
/// - minor: 35% base ink + 65% pageColor.
/// - major: 55% base ink + 45% pageColor.
/// - margin: 55% margin ink + 45% pageColor.
int blendStrokeColor(int pageColorValue, StrokeRole role) {
  final pr = (pageColorValue >> 16) & 0xFF;
  final pg = (pageColorValue >> 8) & 0xFF;
  final pb = pageColorValue & 0xFF;

  final int ir;
  final int ig;
  final int ib;
  final double ratio;

  switch (role) {
    case StrokeRole.minor:
      ir = 0x6B;
      ig = 0x7A;
      ib = 0x99;
      ratio = 0.35;
      break;
    case StrokeRole.major:
      ir = 0x6B;
      ig = 0x7A;
      ib = 0x99;
      ratio = 0.55;
      break;
    case StrokeRole.margin:
      ir = 0xE0;
      ig = 0x7A;
      ib = 0x7A;
      ratio = 0.55;
      break;
  }

  final r = (pr * (1.0 - ratio) + ir * ratio).round().clamp(0, 255);
  final g = (pg * (1.0 - ratio) + ig * ratio).round().clamp(0, 255);
  final b = (pb * (1.0 - ratio) + ib * ratio).round().clamp(0, 255);

  return 0xFF000000 | (r << 16) | (g << 8) | b;
}

/// Stroke width in points for each stroke role.
double strokeWidthForRole(StrokeRole role) {
  switch (role) {
    case StrokeRole.minor:
      return 0.5;
    case StrokeRole.major:
      return 1.0;
    case StrokeRole.margin:
      return 1.0;
  }
}

/// Pure geometry generator for paper template stroke primitives.
///
/// Guarantees that margins are >= 8mm (22.68 pt) from every edge.
/// Shared across both screen custom painters and background isolate PDF generation.
List<PaperStrokePrimitive> computePaperDrawingPrimitives({
  required PaperTemplate template,
  required double widthPt,
  required double heightPt,
}) {
  if (template == PaperTemplate.blank) {
    return const <PaperStrokePrimitive>[];
  }

  // Minimum 8.47 mm (24.0 pt) safety margin from all four edges
  const marginPt = 24.0;
  final contentWidth = widthPt - (marginPt * 2);
  final contentHeight = heightPt - (marginPt * 2);

  if (contentWidth <= 0 || contentHeight <= 0) {
    return const <PaperStrokePrimitive>[];
  }

  final primitives = <PaperStrokePrimitive>[];

  switch (template) {
    case PaperTemplate.blank:
      break;

    case PaperTemplate.line1:
      // Narrow ruled: 7.1 mm = ~20.13 pt spacing
      const spacing = 20.126;
      for (var y = marginPt + spacing; y <= heightPt - marginPt; y += spacing) {
        primitives.add(
          PaperStrokePrimitive(
            x1: marginPt,
            y1: y,
            x2: widthPt - marginPt,
            y2: y,
            role: StrokeRole.minor,
          ),
        );
      }
      break;

    case PaperTemplate.line2:
      // Wide ruled: 8.7 mm = ~24.66 pt spacing
      const spacing = 24.661;
      for (var y = marginPt + spacing; y <= heightPt - marginPt; y += spacing) {
        primitives.add(
          PaperStrokePrimitive(
            x1: marginPt,
            y1: y,
            x2: widthPt - marginPt,
            y2: y,
            role: StrokeRole.minor,
          ),
        );
      }
      break;

    case PaperTemplate.notebook:
      // Notebook ruled: 8.0 mm = ~22.68 pt spacing with vertical margin line
      const spacing = 22.677;
      // Margin line positioned ~32 mm (90.7 pt) from left edge
      const marginX = 90.7;

      // Header rule line (major)
      primitives.add(
        PaperStrokePrimitive(
          x1: marginPt,
          y1: marginPt + spacing,
          x2: widthPt - marginPt,
          y2: marginPt + spacing,
          role: StrokeRole.major,
        ),
      );

      // Subsequent ruled lines (minor)
      for (var y = marginPt + (spacing * 2);
          y <= heightPt - marginPt;
          y += spacing) {
        primitives.add(
          PaperStrokePrimitive(
            x1: marginPt,
            y1: y,
            x2: widthPt - marginPt,
            y2: y,
            role: StrokeRole.minor,
          ),
        );
      }

      // Left vertical margin line (margin role, red/coral ink)
      if (marginX > marginPt && marginX < widthPt - marginPt) {
        primitives.add(
          PaperStrokePrimitive(
            x1: marginX,
            y1: marginPt,
            x2: marginX,
            y2: heightPt - marginPt,
            role: StrokeRole.margin,
          ),
        );
      }
      break;

    case PaperTemplate.cornell:
      // Cornell notes system:
      // - Top header area (72 pt)
      // - Bottom summary area (120 pt)
      // - Left cue column (30% width)
      // - Main notes area (70% width, ruled with minor lines)
      const headerY = 72.0;
      final summaryY = heightPt - 120.0;
      final cueX = marginPt + (contentWidth * 0.30);

      // Header horizontal rule (major)
      if (headerY > marginPt && headerY < summaryY) {
        primitives.add(
          PaperStrokePrimitive(
            x1: marginPt,
            y1: headerY,
            x2: widthPt - marginPt,
            y2: headerY,
            role: StrokeRole.major,
          ),
        );
      }

      // Summary horizontal rule (major)
      if (summaryY > headerY && summaryY < heightPt - marginPt) {
        primitives.add(
          PaperStrokePrimitive(
            x1: marginPt,
            y1: summaryY,
            x2: widthPt - marginPt,
            y2: summaryY,
            role: StrokeRole.major,
          ),
        );
      }

      // Vertical cue column separator (major)
      if (cueX > marginPt && cueX < widthPt - marginPt) {
        primitives.add(
          PaperStrokePrimitive(
            x1: cueX,
            y1: headerY,
            x2: cueX,
            y2: summaryY,
            role: StrokeRole.major,
          ),
        );
      }

      // Ruled lines in main notes area (minor)
      const spacing = 22.677;
      for (var y = headerY + spacing; y < summaryY - 4.0; y += spacing) {
        primitives.add(
          PaperStrokePrimitive(
            x1: cueX,
            y1: y,
            x2: widthPt - marginPt,
            y2: y,
            role: StrokeRole.minor,
          ),
        );
      }
      break;

    case PaperTemplate.grid:
      // 5 mm = ~14.173 pt square grid
      const gridSize = 14.173;

      // Vertical grid lines (minor)
      for (var x = marginPt; x <= widthPt - marginPt + 0.01; x += gridSize) {
        primitives.add(
          PaperStrokePrimitive(
            x1: x,
            y1: marginPt,
            x2: x,
            y2: heightPt - marginPt,
            role: StrokeRole.minor,
          ),
        );
      }

      // Horizontal grid lines (minor)
      for (var y = marginPt; y <= heightPt - marginPt + 0.01; y += gridSize) {
        primitives.add(
          PaperStrokePrimitive(
            x1: marginPt,
            y1: y,
            x2: widthPt - marginPt,
            y2: y,
            role: StrokeRole.minor,
          ),
        );
      }
      break;

    case PaperTemplate.graph:
      // Graph paper: 5 mm minor grid, every 5th line (25 mm) major grid
      const minorSize = 14.173;
      var colIndex = 0;
      for (var x = marginPt;
          x <= widthPt - marginPt + 0.01;
          x += minorSize, colIndex++) {
        final isMajor = colIndex % 5 == 0;
        primitives.add(
          PaperStrokePrimitive(
            x1: x,
            y1: marginPt,
            x2: x,
            y2: heightPt - marginPt,
            role: isMajor ? StrokeRole.major : StrokeRole.minor,
          ),
        );
      }

      var rowIndex = 0;
      for (var y = marginPt;
          y <= heightPt - marginPt + 0.01;
          y += minorSize, rowIndex++) {
        final isMajor = rowIndex % 5 == 0;
        primitives.add(
          PaperStrokePrimitive(
            x1: marginPt,
            y1: y,
            x2: widthPt - marginPt,
            y2: y,
            role: isMajor ? StrokeRole.major : StrokeRole.minor,
          ),
        );
      }
      break;
  }

  return primitives;
}
