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

/// Exact millimeter to point conversion factor: 1 mm = 2.8346 pt (72 pt / 25.4 mm).
const double kPtPerMm = 2.8346;

/// Pure geometry generator for paper template stroke primitives.
///
/// Follows the exact millimeter geometry specifications:
/// - Blank: no lines.
/// - Line 1: horizontal lines every 6.35 mm from 18 mm below top to 12 mm above bottom, 10 mm inset, no margin line.
/// - Line 2: horizontal lines every 10 mm from 18 mm below top to 12 mm above bottom, 10 mm inset, no margin line.
/// - Notebook: horizontal lines every 8 mm, top header gap of 22 mm, 10 mm inset, plus one vertical margin line at 12% width from top gap to 12 mm above bottom.
/// - Cornell: header rule at 8% height, summary rule at 82% height, vertical cue line at 30% width from header to summary, horizontal lines every 8 mm only in notes area (right of cue line, between header and summary), inset 10 mm. No masks or hidden lines.
/// - Grid: square grid every 5 mm over printable area (8 mm margin all sides), one stroke role.
/// - Graph: minor lines every 1 mm (minor role) and major line every 10 mm (major role) over printable area (8 mm margin), aligned so major lines coincide with minor lines.
List<PaperStrokePrimitive> computePaperDrawingPrimitives({
  required PaperTemplate template,
  required double widthPt,
  required double heightPt,
}) {
  if (template == PaperTemplate.blank) {
    return const <PaperStrokePrimitive>[];
  }

  if (widthPt <= 0 || heightPt <= 0) {
    return const <PaperStrokePrimitive>[];
  }

  final primitives = <PaperStrokePrimitive>[];

  switch (template) {
    case PaperTemplate.blank:
      break;

    case PaperTemplate.line1:
      // Line 1 (SMALL line spacing): horizontal lines every 6.35 mm from 18 mm below
      // top edge to 12 mm above bottom edge, spanning from 10 mm to 10 mm inside edges.
      // NO margin line.
      final x1 = 10.0 * kPtPerMm;
      final x2 = widthPt - (10.0 * kPtPerMm);
      final yStart = 18.0 * kPtPerMm;
      final yEnd = heightPt - (12.0 * kPtPerMm);
      final spacing = 6.35 * kPtPerMm;

      if (x2 > x1 && yEnd > yStart) {
        for (var y = yStart; y <= yEnd + 0.001; y += spacing) {
          primitives.add(
            PaperStrokePrimitive(
              x1: x1,
              y1: y,
              x2: x2,
              y2: y,
              role: StrokeRole.minor,
            ),
          );
        }
      }
      break;

    case PaperTemplate.line2:
      // Line 2 (BIG space between lines): the same layout with 10 mm spacing.
      // NO margin line.
      final x1 = 10.0 * kPtPerMm;
      final x2 = widthPt - (10.0 * kPtPerMm);
      final yStart = 18.0 * kPtPerMm;
      final yEnd = heightPt - (12.0 * kPtPerMm);
      final spacing = 10.0 * kPtPerMm;

      if (x2 > x1 && yEnd > yStart) {
        for (var y = yStart; y <= yEnd + 0.001; y += spacing) {
          primitives.add(
            PaperStrokePrimitive(
              x1: x1,
              y1: y,
              x2: x2,
              y2: y,
              role: StrokeRole.minor,
            ),
          );
        }
      }
      break;

    case PaperTemplate.notebook:
      // Notebook: horizontal lines every 8 mm, header gap of 22 mm at top with no lines,
      // lines span 10 mm inside both edges, plus ONE vertical margin line (margin role, soft red)
      // at 12% of page width running from top gap to 12 mm above bottom.
      final x1 = 10.0 * kPtPerMm;
      final x2 = widthPt - (10.0 * kPtPerMm);
      final topGap = 22.0 * kPtPerMm;
      final bottomLimit = heightPt - (12.0 * kPtPerMm);
      final spacing = 8.0 * kPtPerMm;

      if (x2 > x1 && bottomLimit > topGap) {
        for (var y = topGap; y <= bottomLimit + 0.001; y += spacing) {
          primitives.add(
            PaperStrokePrimitive(
              x1: x1,
              y1: y,
              x2: x2,
              y2: y,
              role: StrokeRole.minor,
            ),
          );
        }

        final marginX = widthPt * 0.12;
        primitives.add(
          PaperStrokePrimitive(
            x1: marginX,
            y1: topGap,
            x2: marginX,
            y2: bottomLimit,
            role: StrokeRole.margin,
          ),
        );
      }
      break;

    case PaperTemplate.cornell:
      // Cornell:
      // - header rule at 8% of page height
      // - vertical cue line at 30% of page width running from header rule down to summary rule
      // - summary rule at 82% of page height
      // - horizontal lines every 8 mm ONLY in notes area (right of cue line, between header and summary)
      // - everything inset 10 mm from page edges.
      // NO masking rectangles and no hidden lines anywhere.
      final left = 10.0 * kPtPerMm;
      final right = widthPt - (10.0 * kPtPerMm);
      final headerY = heightPt * 0.08;
      final summaryY = heightPt * 0.82;
      final cueX = widthPt * 0.30;
      final spacing = 8.0 * kPtPerMm;

      if (right > left && summaryY > headerY) {
        // Header rule
        primitives.add(
          PaperStrokePrimitive(
            x1: left,
            y1: headerY,
            x2: right,
            y2: headerY,
            role: StrokeRole.major,
          ),
        );

        // Summary rule
        primitives.add(
          PaperStrokePrimitive(
            x1: left,
            y1: summaryY,
            x2: right,
            y2: summaryY,
            role: StrokeRole.major,
          ),
        );

        // Vertical cue line
        primitives.add(
          PaperStrokePrimitive(
            x1: cueX,
            y1: headerY,
            x2: cueX,
            y2: summaryY,
            role: StrokeRole.major,
          ),
        );

        // Notes area horizontal lines (right of cue line, between header and summary)
        for (var y = headerY + spacing; y < summaryY - 0.001; y += spacing) {
          primitives.add(
            PaperStrokePrimitive(
              x1: cueX,
              y1: y,
              x2: right,
              y2: y,
              role: StrokeRole.minor,
            ),
          );
        }
      }
      break;

    case PaperTemplate.grid:
      // Grid: square grid every 5 mm over printable area (8 mm margin on all sides), one stroke role.
      final margin = 8.0 * kPtPerMm;
      final left = margin;
      final right = widthPt - margin;
      final top = margin;
      final bottom = heightPt - margin;
      final spacing = 5.0 * kPtPerMm;

      if (right > left && bottom > top) {
        // Vertical grid lines
        for (var x = left; x <= right + 0.001; x += spacing) {
          primitives.add(
            PaperStrokePrimitive(
              x1: x,
              y1: top,
              x2: x,
              y2: bottom,
              role: StrokeRole.minor,
            ),
          );
        }

        // Horizontal grid lines
        for (var y = top; y <= bottom + 0.001; y += spacing) {
          primitives.add(
            PaperStrokePrimitive(
              x1: left,
              y1: y,
              x2: right,
              y2: y,
              role: StrokeRole.minor,
            ),
          );
        }
      }
      break;

    case PaperTemplate.graph:
      // Graph: minor lines every 1 mm (minor role, very light) and a major line every 10 mm (major role, darker)
      // over printable area (8 mm margin), aligned so major lines coincide with minor lines.
      final margin = 8.0 * kPtPerMm;
      final left = margin;
      final right = widthPt - margin;
      final top = margin;
      final bottom = heightPt - margin;
      final minorStep = 1.0 * kPtPerMm;

      if (right > left && bottom > top) {
        // Vertical lines
        var col = 0;
        for (var x = left; x <= right + 0.001; x += minorStep, col++) {
          final isMajor = col % 10 == 0;
          primitives.add(
            PaperStrokePrimitive(
              x1: x,
              y1: top,
              x2: x,
              y2: bottom,
              role: isMajor ? StrokeRole.major : StrokeRole.minor,
            ),
          );
        }

        // Horizontal lines
        var row = 0;
        for (var y = top; y <= bottom + 0.001; y += minorStep, row++) {
          final isMajor = row % 10 == 0;
          primitives.add(
            PaperStrokePrimitive(
              x1: left,
              y1: y,
              x2: right,
              y2: y,
              role: isMajor ? StrokeRole.major : StrokeRole.minor,
            ),
          );
        }
      }
      break;
  }

  return primitives;
}
