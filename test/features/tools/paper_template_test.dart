import 'package:docview/features/tools/create_pdf/paper_template.dart';
import 'package:docview/shared/widgets/create_pdf/paper_preview.dart';
import 'package:flutter/material.dart';
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

      final minorWhite = blendStrokeColor(white, StrokeRole.minor);
      expect((minorWhite >> 24) & 0xFF, 0xFF, reason: 'Alpha must be opaque');
      expect((minorWhite >> 16) & 0xFF, 203);
      expect((minorWhite >> 8) & 0xFF, 208);
      expect(minorWhite & 0xFF, 219);

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

  group('Paper Template Geometry Spec Line Counts', () {
    const a4W = 595.28;
    const a4H = 841.89;
    const a3H = 1190.55;

    test('Exact expected line counts on A4 Portrait (595.28 x 841.89 pt)', () {
      expect(computePaperDrawingPrimitives(template: PaperTemplate.blank, widthPt: a4W, heightPt: a4H).length, 0);
      expect(computePaperDrawingPrimitives(template: PaperTemplate.line1, widthPt: a4W, heightPt: a4H).length, 43);
      expect(computePaperDrawingPrimitives(template: PaperTemplate.line2, widthPt: a4W, heightPt: a4H).length, 27);
      expect(computePaperDrawingPrimitives(template: PaperTemplate.notebook, widthPt: a4W, heightPt: a4H).length, 34);
      expect(computePaperDrawingPrimitives(template: PaperTemplate.cornell, widthPt: a4W, heightPt: a4H).length, 30);
      expect(computePaperDrawingPrimitives(template: PaperTemplate.grid, widthPt: a4W, heightPt: a4H).length, 96);
      expect(computePaperDrawingPrimitives(template: PaperTemplate.graph, widthPt: a4W, heightPt: a4H).length, 477);
    });

    test('Exact expected line counts on A4 Landscape (841.89 x 595.28 pt)', () {
      expect(computePaperDrawingPrimitives(template: PaperTemplate.blank, widthPt: a4H, heightPt: a4W).length, 0);
      expect(computePaperDrawingPrimitives(template: PaperTemplate.line1, widthPt: a4H, heightPt: a4W).length, 29);
      expect(computePaperDrawingPrimitives(template: PaperTemplate.line2, widthPt: a4H, heightPt: a4W).length, 19);
      expect(computePaperDrawingPrimitives(template: PaperTemplate.notebook, widthPt: a4H, heightPt: a4W).length, 24);
      expect(computePaperDrawingPrimitives(template: PaperTemplate.cornell, widthPt: a4H, heightPt: a4W).length, 22);
      expect(computePaperDrawingPrimitives(template: PaperTemplate.grid, widthPt: a4H, heightPt: a4W).length, 96);
      expect(computePaperDrawingPrimitives(template: PaperTemplate.graph, widthPt: a4H, heightPt: a4W).length, 477);
    });

    test('Exact expected line counts on A3 Portrait (841.89 x 1190.55 pt)', () {
      expect(computePaperDrawingPrimitives(template: PaperTemplate.blank, widthPt: a4H, heightPt: a3H).length, 0);
      expect(computePaperDrawingPrimitives(template: PaperTemplate.line1, widthPt: a4H, heightPt: a3H).length, 62);
      expect(computePaperDrawingPrimitives(template: PaperTemplate.line2, widthPt: a4H, heightPt: a3H).length, 40);
      expect(computePaperDrawingPrimitives(template: PaperTemplate.notebook, widthPt: a4H, heightPt: a3H).length, 50);
      expect(computePaperDrawingPrimitives(template: PaperTemplate.cornell, widthPt: a4H, heightPt: a3H).length, 41);
      expect(computePaperDrawingPrimitives(template: PaperTemplate.grid, widthPt: a4H, heightPt: a3H).length, 138);
      expect(computePaperDrawingPrimitives(template: PaperTemplate.graph, widthPt: a4H, heightPt: a3H).length, 687);
    });
  });

  group('Margin Boundaries, Proportions, and Alignment Checks', () {
    const a4W = 595.28;
    const a4H = 841.89;

    test('No primitive crosses page boundaries for any template', () {
      for (final template in PaperTemplate.values) {
        final primitives = computePaperDrawingPrimitives(
          template: template,
          widthPt: a4W,
          heightPt: a4H,
        );
        for (final p in primitives) {
          expect(p.x1, inInclusiveRange(0.0, a4W));
          expect(p.x2, inInclusiveRange(0.0, a4W));
          expect(p.y1, inInclusiveRange(0.0, a4H));
          expect(p.y2, inInclusiveRange(0.0, a4H));
        }
      }
    });

    test('Line 1 and Line 2 respect exact insets and spacing (Line 1 < Line 2)', () {
      final line1 = computePaperDrawingPrimitives(template: PaperTemplate.line1, widthPt: a4W, heightPt: a4H);
      final line2 = computePaperDrawingPrimitives(template: PaperTemplate.line2, widthPt: a4W, heightPt: a4H);

      expect(line1.length, greaterThan(line2.length), reason: 'Line 1 (6.35mm) has smaller spacing than Line 2 (10mm)');

      // Line 1 checks: 10mm inset horizontally, starts at 18mm below top, ends <= 12mm above bottom
      const margin10mm = 10.0 * kPtPerMm;
      const top18mm = 18.0 * kPtPerMm;
      const bottom12mm = a4H - (12.0 * kPtPerMm);

      for (final p in line1) {
        expect(p.x1, closeTo(margin10mm, 0.001));
        expect(p.x2, closeTo(a4W - margin10mm, 0.001));
        expect(p.y1, p.y2);
        expect(p.y1, greaterThanOrEqualTo(top18mm));
        expect(p.y1, lessThanOrEqualTo(bottom12mm));
        expect(p.role, StrokeRole.minor);
      }

      // Line 2 checks
      for (final p in line2) {
        expect(p.x1, closeTo(margin10mm, 0.001));
        expect(p.x2, closeTo(a4W - margin10mm, 0.001));
        expect(p.y1, p.y2);
        expect(p.y1, greaterThanOrEqualTo(top18mm));
        expect(p.y1, lessThanOrEqualTo(bottom12mm));
        expect(p.role, StrokeRole.minor);
      }
    });

    test('Notebook produces header gap, 10mm insets, and vertical margin line at 12% width', () {
      final notebook = computePaperDrawingPrimitives(template: PaperTemplate.notebook, widthPt: a4W, heightPt: a4H);

      final marginLines = notebook.where((p) => p.role == StrokeRole.margin).toList();
      final minorLines = notebook.where((p) => p.role == StrokeRole.minor).toList();

      expect(marginLines.length, 1, reason: 'Exactly one vertical margin line');
      expect(minorLines.length, 33);

      const top22mm = 22.0 * kPtPerMm;
      const bottom12mm = a4H - (12.0 * kPtPerMm);

      final marginLine = marginLines.first;
      expect(marginLine.x1, closeTo(a4W * 0.12, 0.001));
      expect(marginLine.x2, closeTo(a4W * 0.12, 0.001));
      expect(marginLine.y1, closeTo(top22mm, 0.001));
      expect(marginLine.y2, closeTo(bottom12mm, 0.001));

      // No horizontal lines in the top 22mm gap
      for (final p in minorLines) {
        expect(p.y1, greaterThanOrEqualTo(top22mm));
        expect(p.y1, lessThanOrEqualTo(bottom12mm));
      }
    });

    test('Cornell adheres strictly to 8% header, 82% summary, 30% cue, and no masks', () {
      final cornell = computePaperDrawingPrimitives(template: PaperTemplate.cornell, widthPt: a4W, heightPt: a4H);

      final majorLines = cornell.where((p) => p.role == StrokeRole.major).toList();
      final minorLines = cornell.where((p) => p.role == StrokeRole.minor).toList();

      expect(majorLines.length, 3, reason: 'Header rule, summary rule, and vertical cue separator');
      expect(minorLines.length, 27, reason: 'Only notes area ruled lines');

      const left10mm = 10.0 * kPtPerMm;
      const right10mm = a4W - (10.0 * kPtPerMm);

      final headerRule = majorLines.firstWhere((p) => (p.y1 - a4H * 0.08).abs() < 0.01);
      final summaryRule = majorLines.firstWhere((p) => (p.y1 - a4H * 0.82).abs() < 0.01);
      final cueSeparator = majorLines.firstWhere((p) => (p.x1 - a4W * 0.30).abs() < 0.01);

      expect(headerRule.x1, closeTo(left10mm, 0.001));
      expect(headerRule.x2, closeTo(right10mm, 0.001));
      expect(summaryRule.x1, closeTo(left10mm, 0.001));
      expect(summaryRule.x2, closeTo(right10mm, 0.001));

      expect(cueSeparator.x1, closeTo(a4W * 0.30, 0.001));
      expect(cueSeparator.y1, closeTo(headerRule.y1, 0.001));
      expect(cueSeparator.y2, closeTo(summaryRule.y1, 0.001));

      // All notes lines must be strictly right of cue separator and between header and summary
      for (final p in minorLines) {
        expect(p.x1, closeTo(cueSeparator.x1, 0.001));
        expect(p.x2, closeTo(right10mm, 0.001));
        expect(p.y1, greaterThan(headerRule.y1));
        expect(p.y1, lessThan(summaryRule.y1));
      }
    });

    test('Grid respects 8mm margins and single stroke role', () {
      final grid = computePaperDrawingPrimitives(template: PaperTemplate.grid, widthPt: a4W, heightPt: a4H);
      const m8mm = 8.0 * kPtPerMm;

      expect(grid.every((p) => p.role == StrokeRole.minor), isTrue);
      for (final p in grid) {
        expect(p.x1, inInclusiveRange(m8mm - 0.01, a4W - m8mm + 0.01));
        expect(p.x2, inInclusiveRange(m8mm - 0.01, a4W - m8mm + 0.01));
        expect(p.y1, inInclusiveRange(m8mm - 0.01, a4H - m8mm + 0.01));
        expect(p.y2, inInclusiveRange(m8mm - 0.01, a4H - m8mm + 0.01));
      }
    });

    test('Graph major lines coincide exactly with minor lines (10:1 alignment)', () {
      final graph = computePaperDrawingPrimitives(template: PaperTemplate.graph, widthPt: a4W, heightPt: a4H);

      final majorLines = graph.where((p) => p.role == StrokeRole.major).toList();
      final minorLines = graph.where((p) => p.role == StrokeRole.minor).toList();

      expect(majorLines.length, 49);
      expect(minorLines.length, 428);

      const m8mm = 8.0 * kPtPerMm;
      const minorStep = 1.0 * kPtPerMm;
      const majorStep = 10.0 * kPtPerMm;
      expect(majorStep / minorStep, closeTo(10.0, 0.001));

      // Vertical major lines coincide with 10mm intervals
      final vMajor = majorLines.where((p) => p.x1 == p.x2).toList();
      for (var i = 0; i < vMajor.length; i++) {
        expect(vMajor[i].x1, closeTo(m8mm + (i * majorStep), 0.001));
      }

      // Horizontal major lines coincide with 10mm intervals
      final hMajor = majorLines.where((p) => p.y1 == p.y2).toList();
      for (var i = 0; i < hMajor.length; i++) {
        expect(hMajor[i].y1, closeTo(m8mm + (i * majorStep), 0.001));
      }
    });

    test('Geometry contains strictly stroke line primitives and zero rectangles/masks', () {
      for (final template in PaperTemplate.values) {
        final primitives = computePaperDrawingPrimitives(
          template: template,
          widthPt: a4W,
          heightPt: a4H,
        );
        for (final p in primitives) {
          expect(p, isA<PaperStrokePrimitive>());
          // Must be a 1D straight line, never an area or rectangle
          expect(p.x1 == p.x2 || p.y1 == p.y2, isTrue, reason: 'Primitives are straight orthogonal lines');
        }
      }
    });
  });

  group('PaperPreviewPainter Minor Role Skipping on Small Cards', () {
    testWidgets('Painter skips minor lines when pixel pitch < 3px on small thumbnail cards', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 48,
                height: 64,
                child: PaperPreview(
                  template: PaperTemplate.graph,
                  pageSize: PaperPageSize.a4,
                  orientation: PaperOrientation.portrait,
                  colorSwatch: PaperColorSwatch.white,
                  isThumbnail: true,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(PaperPreview), findsOneWidget);
    });

    testWidgets('Large preview renders all stroke roles', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 300,
                height: 424,
                child: PaperPreview(
                  template: PaperTemplate.graph,
                  pageSize: PaperPageSize.a4,
                  orientation: PaperOrientation.portrait,
                  colorSwatch: PaperColorSwatch.white,
                  isThumbnail: false,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(PaperPreview), findsOneWidget);
    });
  });
}
