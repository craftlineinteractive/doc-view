import 'package:docview/data/models/ink_stroke.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('InkStrokeMath Unit Tests', () {
    test('tap-to-dot identifies single taps and short clusters under 3pt', () {
      expect(InkStrokeMath.isTapDot([]), isFalse);
      expect(InkStrokeMath.isTapDot([const Offset(10, 10)]), isTrue);
      expect(
        InkStrokeMath.isTapDot([
          const Offset(10, 10),
          const Offset(11, 11),
          const Offset(10.5, 10.5),
        ]),
        isTrue,
      );
      // Beyond 3pt threshold
      expect(
        InkStrokeMath.isTapDot([
          const Offset(10, 10),
          const Offset(15, 15),
        ]),
        isFalse,
      );
    });

    test('resample drops high-frequency jitter points while preserving endpoints', () {
      final denseLine = <Offset>[
        const Offset(0, 0),
        const Offset(0.2, 0),
        const Offset(0.5, 0),
        const Offset(0.8, 0),
        const Offset(2.1, 0), // Kept
        const Offset(2.4, 0),
        const Offset(4.5, 0), // Kept
        const Offset(5.0, 0), // Endpoint kept
      ];

      final resampled = InkStrokeMath.resample(denseLine, minDistance: 2.0);

      expect(resampled.length, lessThan(denseLine.length));
      expect(resampled.first, const Offset(0, 0));
      expect(resampled.last, const Offset(5.0, 0));
      expect(resampled.length, 3);
    });

    test('simplify reduces collinear points to straight segment (RDP algorithm)', () {
      final lineWithMidpoints = <Offset>[
        const Offset(0, 0),
        const Offset(10, 0.1),
        const Offset(20, -0.1),
        const Offset(30, 0.05),
        const Offset(50, 0),
        const Offset(50, 50), // 90 degree corner
        const Offset(50, 75),
        const Offset(50, 100),
      ];

      final simplified = InkStrokeMath.simplify(lineWithMidpoints, epsilon: 1.0);

      // Should eliminate collinear jitter along the horizontal and vertical lines, keeping corners
      expect(simplified.length, 3);
      expect(simplified[0], const Offset(0, 0));
      expect(simplified[1], const Offset(50, 0));
      expect(simplified[2], const Offset(50, 100));
    });

    test('smooth produces continuous organic curve with deterministic output', () {
      final triangle = <Offset>[
        const Offset(0, 0),
        const Offset(50, 100),
        const Offset(100, 0),
      ];

      final smoothed1 = InkStrokeMath.smooth(triangle, subdivisions: 4);
      final smoothed2 = InkStrokeMath.smooth(triangle, subdivisions: 4);

      expect(smoothed1.length, greaterThan(triangle.length));
      expect(smoothed1.first, triangle.first);
      // Determinism
      for (var i = 0; i < smoothed1.length; i++) {
        expect(smoothed1[i].dx, smoothed2[i].dx);
        expect(smoothed1[i].dy, smoothed2[i].dy);
      }
    });

    test('processPoints applies resampling (minDistance 0.5) and RDP (epsilon 0.25)', () {
      final denseStroke = List.generate(
        1000,
        (i) => Offset(i * 0.1, 0), // points spaced by 0.1 pt (< 0.5 pt)
      );

      final processed = InkStrokeMath.processPoints(denseStroke);

      // Should eliminate points closer than 0.5pt and collinear points
      expect(processed.length, lessThan(denseStroke.length));
      expect(processed.first, denseStroke.first);
      expect(processed.last, denseStroke.last);
      // Since all points lie on a straight line, RDP simplifies to just 2 points!
      expect(processed.length, 2);
    });

    test('stroke and point document caps match requirements', () {
      expect(InkStrokeMath.maxStrokesPerDocument, 5000);
      expect(InkStrokeMath.maxPointsPerDocument, 300000);
    });

    test('maxPointsPerDocument cap validation logic', () {
      const docCap = InkStrokeMath.maxPointsPerDocument;
      expect(docCap, 300000);

      // Verify that strokes totaling over 300,000 points can be detected and guarded
      final strokes = [
        InkStroke(
          id: '1',
          pageIndex: 0,
          points: List.generate(200000, (i) => Offset(i.toDouble(), 0)),
          timestampMs: 100,
        ),
        InkStroke(
          id: '2',
          pageIndex: 0,
          points: List.generate(150000, (i) => Offset(i.toDouble(), 0)),
          timestampMs: 200,
        ),
      ];

      final totalPoints = strokes.fold<int>(0, (sum, s) => sum + s.points.length);
      expect(totalPoints, greaterThan(docCap));
    });

    test('InkStroke bounding box accounts for strokeWidth margin', () {
      final stroke = InkStroke(
        id: 's1',
        pageIndex: 0,
        points: const [
          Offset(100, 100),
          Offset(200, 300),
        ],
        strokeWidth: 4.0,
        timestampMs: 12345,
      );

      final bounds = stroke.boundingRect;
      expect(bounds.left, 98.0); // 100 - 2
      expect(bounds.top, 98.0); // 100 - 2
      expect(bounds.right, 202.0); // 200 + 2
      expect(bounds.bottom, 302.0); // 300 + 2
    });

    test('InkStroke serialization round-trip', () {
      final stroke = InkStroke(
        id: 'stroke_42',
        pageIndex: 1,
        points: const [Offset(12.5, 34.0), Offset(56.2, 78.9)],
        colorValue: 0xFF2196F3,
        strokeWidth: 3.5,
        timestampMs: 987654321,
        isDot: false,
      );

      final map = stroke.toMap();
      final revived = InkStroke.fromMap(map);

      expect(revived.id, stroke.id);
      expect(revived.pageIndex, stroke.pageIndex);
      expect(revived.points.length, 2);
      expect(revived.points[0], stroke.points[0]);
      expect(revived.points[1], stroke.points[1]);
      expect(revived.colorValue, stroke.colorValue);
      expect(revived.strokeWidth, stroke.strokeWidth);
      expect(revived.timestampMs, stroke.timestampMs);
      expect(revived.isDot, stroke.isDot);
    });

    test('hitTest accurately detects hits near stroke segments and dots', () {
      final lineStroke = InkStroke(
        id: 's_line',
        pageIndex: 0,
        points: const [Offset(0, 0), Offset(100, 0)],
        strokeWidth: 4.0,
        timestampMs: 100,
      );

      // Directly on segment
      expect(InkStrokeMath.hitTest(lineStroke, const Offset(50, 0)), isTrue);
      // Within tolerance (4/2 + 16 = 18 pt radius)
      expect(InkStrokeMath.hitTest(lineStroke, const Offset(50, 10)), isTrue);
      expect(InkStrokeMath.hitTest(lineStroke, const Offset(50, 17)), isTrue);
      // Outside tolerance
      expect(InkStrokeMath.hitTest(lineStroke, const Offset(50, 25)), isFalse);

      final dotStroke = InkStroke(
        id: 's_dot',
        pageIndex: 0,
        points: const [Offset(50, 50)],
        strokeWidth: 4.0,
        timestampMs: 100,
        isDot: true,
      );

      expect(InkStrokeMath.hitTest(dotStroke, const Offset(50, 50)), isTrue);
      expect(InkStrokeMath.hitTest(dotStroke, const Offset(60, 50)), isTrue);
      expect(InkStrokeMath.hitTest(dotStroke, const Offset(80, 50)), isFalse);
    });
  });
}
