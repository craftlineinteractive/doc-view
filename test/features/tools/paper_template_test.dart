import 'package:docview/features/tools/create_pdf/paper_template.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PaperPageSize & Orientation Specs', () {
    test('A4 dimensions and orientation swapping match specifications', () {
      const a4 = PaperPageSize.a4;
      expect(a4.widthPt, closeTo(595.28, 0.01));
      expect(a4.heightPt, closeTo(841.89, 0.01));

      expect(a4.getWidth(PaperOrientation.portrait), closeTo(595.28, 0.01));
      expect(a4.getHeight(PaperOrientation.portrait), closeTo(841.89, 0.01));

      expect(a4.getWidth(PaperOrientation.landscape), closeTo(841.89, 0.01));
      expect(a4.getHeight(PaperOrientation.landscape), closeTo(595.28, 0.01));
    });

    test('B4 and B5 follow standard ISO 216 dimensions', () {
      const b5 = PaperPageSize.b5;
      expect(b5.widthPt, closeTo(498.90, 0.01));
      expect(b5.heightPt, closeTo(708.66, 0.01));

      const b4 = PaperPageSize.b4;
      expect(b4.widthPt, closeTo(708.66, 0.01));
      expect(b4.heightPt, closeTo(1000.63, 0.01));
    });

    test('US Letter and Legal dimensions match specifications', () {
      const letter = PaperPageSize.letter;
      expect(letter.widthPt, closeTo(612.00, 0.01));
      expect(letter.heightPt, closeTo(792.00, 0.01));

      const legal = PaperPageSize.legal;
      expect(legal.widthPt, closeTo(612.00, 0.01));
      expect(legal.heightPt, closeTo(1008.00, 0.01));
    });
  });

  group('Color Blending Mathematics', () {
    test('Blends minor, major, and margin strokes onto white paper accurately', () {
      const white = 0xFFFFFFFF;

      // Minor: 35% of ink (#6B7A99 = 107, 122, 153) + 65% white (255)
      // R: 255 * 0.65 + 107 * 0.35 = 165.75 + 37.45 = 203.2 -> 203 (0xCB)
      // G: 255 * 0.65 + 122 * 0.35 = 165.75 + 42.7 = 208.45 -> 208 (0xD0)
      // B: 255 * 0.65 + 153 * 0.35 = 165.75 + 53.55 = 219.3 -> 219 (0xDB)
      final minorWhite = blendStrokeColor(white, StrokeRole.minor);
      expect((minorWhite >> 24) & 0xFF, 0xFF, reason: 'Alpha must be opaque');
      expect((minorWhite >> 16) & 0xFF, 203);
      expect((minorWhite >> 8) & 0xFF, 208);
      expect(minorWhite & 0xFF, 219);

      // Margin: 55% of margin ink (#E07A7A = 224, 122, 122) + 45% white (255)
      // R: 255 * 0.45 + 224 * 0.55 = 114.75 + 123.2 = 237.95 -> 238
      // G: 255 * 0.45 + 122 * 0.55 = 114.75 + 67.1 = 181.85 -> 182
      // B: 255 * 0.45 + 122 * 0.55 = 114.75 + 67.1 = 181.85 -> 182
      final marginWhite = blendStrokeColor(white, StrokeRole.margin);
      expect((marginWhite >> 24) & 0xFF, 0xFF);
      expect((marginWhite >> 16) & 0xFF, 238);
      expect((marginWhite >> 8) & 0xFF, 182);
      expect(marginWhite & 0xFF, 182);
    });

    test('Blends onto colored swatch and clamps properly', () {
      for (final swatch in PaperColorSwatch.values) {
        for (final role in StrokeRole.values) {
          final blended = blendStrokeColor(swatch.colorValue, role);
          expect((blended >> 24) & 0xFF, 0xFF);
          final r = (blended >> 16) & 0xFF;
          final g = (blended >> 8) & 0xFF;
          final b = blended & 0xFF;
          expect(r, inInclusiveRange(0, 255));
          expect(g, inInclusiveRange(0, 255));
          expect(b, inInclusiveRange(0, 255));
        }
      }
    });
  });

  group('Paper Drawing Geometry Tests', () {
    const a4W = 595.28;
    const a4H = 841.89;

    test('Blank template produces zero primitives', () {
      final primitives = computePaperDrawingPrimitives(
        template: PaperTemplate.blank,
        widthPt: a4W,
        heightPt: a4H,
      );
      expect(primitives, isEmpty);
    });

    test('Line 1 and Line 2 produce horizontal lines respecting margin boundaries', () {
      final line1 = computePaperDrawingPrimitives(
        template: PaperTemplate.line1,
        widthPt: a4W,
        heightPt: a4H,
      );
      final line2 = computePaperDrawingPrimitives(
        template: PaperTemplate.line2,
        widthPt: a4W,
        heightPt: a4H,
      );

      expect(line1, isNotEmpty);
      expect(line2, isNotEmpty);
      expect(line1.length, greaterThan(line2.length), reason: 'Line 1 is narrower spaced than Line 2');

      for (final p in line1) {
        expect(p.role, StrokeRole.minor);
        expect(p.y1, p.y2, reason: 'Horizontal lines must be straight');
        expect(p.x1, closeTo(24.0, 0.01));
        expect(p.x2, closeTo(a4W - 24.0, 0.01));
        expect(p.y1, greaterThanOrEqualTo(24.0));
        expect(p.y1, lessThanOrEqualTo(a4H - 24.0));
      }
    });

    test('Notebook produces header line, minor ruled lines, and red vertical margin', () {
      final notebook = computePaperDrawingPrimitives(
        template: PaperTemplate.notebook,
        widthPt: a4W,
        heightPt: a4H,
      );

      final majorLines = notebook.where((p) => p.role == StrokeRole.major).toList();
      final minorLines = notebook.where((p) => p.role == StrokeRole.minor).toList();
      final marginLines = notebook.where((p) => p.role == StrokeRole.margin).toList();

      expect(majorLines.length, 1, reason: 'Exactly one major header line');
      expect(minorLines, isNotEmpty);
      expect(marginLines.length, 1, reason: 'Exactly one vertical red margin line');

      final marginLine = marginLines.first;
      expect(marginLine.x1, marginLine.x2, reason: 'Vertical margin line');
      expect(marginLine.x1, closeTo(90.7, 0.01));
      expect(marginLine.y1, closeTo(24.0, 0.01));
      expect(marginLine.y2, closeTo(a4H - 24.0, 0.01));
    });

    test('Cornell produces header, summary, cue column, and ruled notes area', () {
      final cornell = computePaperDrawingPrimitives(
        template: PaperTemplate.cornell,
        widthPt: a4W,
        heightPt: a4H,
      );

      final majorLines = cornell.where((p) => p.role == StrokeRole.major).toList();
      final minorLines = cornell.where((p) => p.role == StrokeRole.minor).toList();

      expect(majorLines.length, 3, reason: 'Header, summary, and vertical cue separator');
      expect(minorLines, isNotEmpty);

      // Cue column is ~30% of content width (595.28 - 48 = 547.28 * 0.30 = 164.18 + 24 = 188.18)
      final cueSeparator = majorLines.firstWhere((p) => p.x1 == p.x2);
      expect(cueSeparator.x1, closeTo(24.0 + (a4W - 48.0) * 0.30, 0.01));

      // Ruled notes lines start at cue separator and end at right margin
      for (final p in minorLines) {
        expect(p.x1, closeTo(cueSeparator.x1, 0.01));
        expect(p.x2, closeTo(a4W - 24.0, 0.01));
        expect(p.y1, greaterThan(72.0));
        expect(p.y1, lessThan(a4H - 120.0));
      }
    });

    test('Grid produces orthogonal square grid within margins', () {
      final grid = computePaperDrawingPrimitives(
        template: PaperTemplate.grid,
        widthPt: a4W,
        heightPt: a4H,
      );

      final verticals = grid.where((p) => p.x1 == p.x2).toList();
      final horizontals = grid.where((p) => p.y1 == p.y2).toList();

      expect(verticals, isNotEmpty);
      expect(horizontals, isNotEmpty);
      expect(grid.every((p) => p.role == StrokeRole.minor), isTrue);
    });

    test('Graph produces minor and major grid lines with 5:1 subdivision ratio', () {
      final graph = computePaperDrawingPrimitives(
        template: PaperTemplate.graph,
        widthPt: a4W,
        heightPt: a4H,
      );

      final majorLines = graph.where((p) => p.role == StrokeRole.major).toList();
      final minorLines = graph.where((p) => p.role == StrokeRole.minor).toList();

      expect(majorLines, isNotEmpty);
      expect(minorLines, isNotEmpty);
      expect(minorLines.length, greaterThan(majorLines.length * 3));
    });

    test('Landscape orientation adjusts drawing limits seamlessly', () {
      final landscapePrimitives = computePaperDrawingPrimitives(
        template: PaperTemplate.line1,
        widthPt: a4H,
        heightPt: a4W,
      );

      expect(landscapePrimitives, isNotEmpty);
      for (final p in landscapePrimitives) {
        expect(p.x1, closeTo(24.0, 0.01));
        expect(p.x2, closeTo(a4H - 24.0, 0.01));
        expect(p.y1, lessThanOrEqualTo(a4W - 24.0));
      }
    });
  });
}
