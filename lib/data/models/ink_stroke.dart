// ignore_for_file: prefer_initializing_formals
import 'dart:math' as math;
import 'dart:ui';

/// Pure mathematical models and utilities for high-precision digital ink strokes.
///
/// Designed to process touch/stylus point streams through noise filtering,
/// Ramer-Douglas-Peucker simplification, and Catmull-Rom spline smoothing.
class InkStrokeMath {
  const InkStrokeMath._();

  /// Maximum points permitted within a single stroke to guarantee smooth 60fps rendering.
  static const int maxPointsPerStroke = 5000;

  /// Maximum aggregated points permitted across all strokes in a document.
  static const int maxPointsPerDocument = 300000;

  /// Determines if a point sequence constitutes a single tap (dot).
  ///
  /// Returns true if there are fewer than 3 points, or all points lie within [maxRadius]
  /// of the initial point.
  static bool isTapDot(List<Offset> points, {double maxRadius = 3.0}) {
    if (points.isEmpty) return false;
    if (points.length == 1) return true;
    final first = points.first;
    for (var i = 1; i < points.length; i++) {
      final p = points[i];
      final dx = p.dx - first.dx;
      final dy = p.dy - first.dy;
      if (math.sqrt(dx * dx + dy * dy) > maxRadius) {
        return false;
      }
    }
    return true;
  }

  /// Filters points closer than [minDistance] to eliminate touch digitizer jitter.
  ///
  /// Always preserves the first and last points.
  static List<Offset> resample(List<Offset> points, {double minDistance = 2.0}) {
    if (points.length <= 2) return List<Offset>.from(points);

    final resampled = <Offset>[points.first];
    var lastAdded = points.first;
    final minDistanceSq = minDistance * minDistance;

    for (var i = 1; i < points.length - 1; i++) {
      final current = points[i];
      final dx = current.dx - lastAdded.dx;
      final dy = current.dy - lastAdded.dy;
      if (dx * dx + dy * dy >= minDistanceSq) {
        resampled.add(current);
        lastAdded = current;
      }
    }

    // Always include the termination point
    final last = points.last;
    final dx = last.dx - lastAdded.dx;
    final dy = last.dy - lastAdded.dy;
    if (dx * dx + dy * dy >= minDistanceSq || resampled.length == 1) {
      resampled.add(last);
    } else {
      resampled[resampled.length - 1] = last;
    }

    return resampled;
  }

  /// Simplifies polyline using the Ramer-Douglas-Peucker algorithm.
  ///
  /// Reduces vertex count while keeping perpendicular error below [epsilon].
  static List<Offset> simplify(List<Offset> points, {double epsilon = 1.0}) {
    if (points.length <= 2) return List<Offset>.from(points);
    return _rdpRecursive(points, 0, points.length - 1, epsilon);
  }

  static List<Offset> _rdpRecursive(
    List<Offset> points,
    int startIndex,
    int endIndex,
    double epsilon,
  ) {
    var maxDistance = 0.0;
    var maxIndex = 0;

    final start = points[startIndex];
    final end = points[endIndex];

    for (var i = startIndex + 1; i < endIndex; i++) {
      final dist = _perpendicularDistance(points[i], start, end);
      if (dist > maxDistance) {
        maxDistance = dist;
        maxIndex = i;
      }
    }

    if (maxDistance > epsilon) {
      final left = _rdpRecursive(points, startIndex, maxIndex, epsilon);
      final right = _rdpRecursive(points, maxIndex, endIndex, epsilon);
      // Combine without duplicating maxIndex
      return [...left.take(left.length - 1), ...right];
    } else {
      return [start, end];
    }
  }

  /// Perpendicular distance from [p] to the line segment between [a] and [b].
  static double _perpendicularDistance(Offset p, Offset a, Offset b) {
    final dx = b.dx - a.dx;
    final dy = b.dy - a.dy;
    final lengthSq = dx * dx + dy * dy;

    if (lengthSq == 0.0) {
      final px = p.dx - a.dx;
      final py = p.dy - a.dy;
      return math.sqrt(px * px + py * py);
    }

    final numerator = ((p.dx - a.dx) * dy - (p.dy - a.dy) * dx).abs();
    return numerator / math.sqrt(lengthSq);
  }

  /// Smooths point sequence using uniform Catmull-Rom splines to generate organic curves.
  ///
  /// Interpolates [subdivisions] points between each control point pair.
  static List<Offset> smooth(List<Offset> points, {int subdivisions = 3}) {
    if (points.length <= 2) return List<Offset>.from(points);

    final smoothed = <Offset>[points.first];

    for (var i = 0; i < points.length - 1; i++) {
      final p0 = i == 0 ? points[i] : points[i - 1];
      final p1 = points[i];
      final p2 = points[i + 1];
      final p3 = (i + 2 < points.length) ? points[i + 2] : p2;

      for (var s = 1; s <= subdivisions; s++) {
        final t = s / subdivisions;
        smoothed.add(_catmullRom(p0, p1, p2, p3, t));
      }
    }

    return smoothed;
  }

  static Offset _catmullRom(Offset p0, Offset p1, Offset p2, Offset p3, double t) {
    final t2 = t * t;
    final t3 = t2 * t;

    final x = 0.5 *
        ((2 * p1.dx) +
            (-p0.dx + p2.dx) * t +
            (2 * p0.dx - 5 * p1.dx + 4 * p2.dx - p3.dx) * t2 +
            (-p0.dx + 3 * p1.dx - 3 * p2.dx + p3.dx) * t3);

    final y = 0.5 *
        ((2 * p1.dy) +
            (-p0.dy + p2.dy) * t +
            (2 * p0.dy - 5 * p1.dy + 4 * p2.dy - p3.dy) * t2 +
            (-p0.dy + 3 * p1.dy - 3 * p2.dy + p3.dy) * t3);

    return Offset(x, y);
  }

  /// End-to-end processing pipeline for raw touch input streams:
  /// 1. Tap-to-dot recognition
  /// 2. Distance resampling (jitter removal)
  /// 3. Ramer-Douglas-Peucker simplification
  /// 4. Hard cap enforcement ([maxPointsPerStroke])
  static List<Offset> processPoints(
    List<Offset> points, {
    double minDistance = 2.0,
    double epsilon = 1.0,
    int maxPoints = maxPointsPerStroke,
  }) {
    if (points.isEmpty) return const [];
    if (isTapDot(points)) {
      return [points.first];
    }

    var result = resample(points, minDistance: minDistance);
    result = simplify(result, epsilon: epsilon);

    if (result.length > maxPoints) {
      // Downsample uniformly if still exceeding cap
      final stride = result.length / maxPoints;
      final capped = <Offset>[];
      for (var i = 0; i < maxPoints - 1; i++) {
        capped.add(result[(i * stride).floor()]);
      }
      capped.add(result.last);
      result = capped;
    }

    return result;
  }

  /// Determines whether a touch point hits the given [stroke] within [tolerance].
  ///
  /// Evaluates distance to dots directly, or shortest distance to any line segment
  /// in the polyline.
  static bool hitTest(InkStroke stroke, Offset point, {double tolerance = 16.0}) {
    final hitRadius = (stroke.strokeWidth / 2) + tolerance;
    final hitRadiusSq = hitRadius * hitRadius;

    // Fast reject using bounding box padded by tolerance
    final bbox = stroke.boundingRect.inflate(tolerance);
    if (!bbox.contains(point)) return false;

    if (stroke.isDot) {
      if (stroke.points.isEmpty) return false;
      return (stroke.points.first - point).distanceSquared <= hitRadiusSq;
    }

    for (var i = 0; i < stroke.points.length - 1; i++) {
      final p1 = stroke.points[i];
      final p2 = stroke.points[i + 1];
      if (_distanceSquaredToSegment(point, p1, p2) <= hitRadiusSq) {
        return true;
      }
    }
    return false;
  }

  static double _distanceSquaredToSegment(Offset p, Offset v, Offset w) {
    final l2 = (v - w).distanceSquared;
    if (l2 == 0) return (p - v).distanceSquared;
    final t = ((p.dx - v.dx) * (w.dx - v.dx) + (p.dy - v.dy) * (w.dy - v.dy)) / l2;
    final clampedT = t.clamp(0.0, 1.0);
    final projection = Offset(v.dx + clampedT * (w.dx - v.dx), v.dy + clampedT * (w.dy - v.dy));
    return (p - projection).distanceSquared;
  }
}

/// Represents an immutable freehand pen stroke or tap-dot rendered onto a PDF page.
class InkStroke {
  const InkStroke({
    required this.id,
    required this.pageIndex,
    required this.points,
    this.colorValue = 0xFF000000,
    this.strokeWidth = 2.0,
    required this.timestampMs,
    this.isDot = false,
    Rect? boundingRect,
  }) : _boundingRect = boundingRect;

  final String id;
  final int pageIndex;
  final List<Offset> points;
  final int colorValue;
  final double strokeWidth;
  final int timestampMs;
  final bool isDot;
  final Rect? _boundingRect;

  /// Bounding box enclosing the stroke, padded by half stroke width for hit-testing and clipping.
  Rect get boundingRect {
    final cached = _boundingRect;
    if (cached != null) return cached;
    if (points.isEmpty) return Rect.zero;

    var minX = points.first.dx;
    var maxX = points.first.dx;
    var minY = points.first.dy;
    var maxY = points.first.dy;

    for (var i = 1; i < points.length; i++) {
      final p = points[i];
      if (p.dx < minX) minX = p.dx;
      if (p.dx > maxX) maxX = p.dx;
      if (p.dy < minY) minY = p.dy;
      if (p.dy > maxY) maxY = p.dy;
    }

    final pad = strokeWidth / 2;
    return Rect.fromLTRB(minX - pad, minY - pad, maxX + pad, maxY + pad);
  }

  InkStroke copyWith({
    String? id,
    int? pageIndex,
    List<Offset>? points,
    int? colorValue,
    double? strokeWidth,
    int? timestampMs,
    bool? isDot,
    Rect? boundingRect,
  }) {
    return InkStroke(
      id: id ?? this.id,
      pageIndex: pageIndex ?? this.pageIndex,
      points: points ?? this.points,
      colorValue: colorValue ?? this.colorValue,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      timestampMs: timestampMs ?? this.timestampMs,
      isDot: isDot ?? this.isDot,
      boundingRect: boundingRect ?? _boundingRect,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'page_index': pageIndex,
      'points': points.map((p) => [p.dx, p.dy]).toList(),
      'color_value': colorValue,
      'stroke_width': strokeWidth,
      'timestamp_ms': timestampMs,
      'is_dot': isDot ? 1 : 0,
    };
  }

  factory InkStroke.fromMap(Map<String, dynamic> map) {
    final rawPoints = (map['points'] as List<dynamic>?) ?? [];
    final pts = rawPoints.map((item) {
      final list = item as List<dynamic>;
      return Offset((list[0] as num).toDouble(), (list[1] as num).toDouble());
    }).toList();

    return InkStroke(
      id: map['id'] as String,
      pageIndex: (map['page_index'] as num).toInt(),
      points: pts,
      colorValue: (map['color_value'] as num?)?.toInt() ?? 0xFF000000,
      strokeWidth: (map['stroke_width'] as num?)?.toDouble() ?? 2.0,
      timestampMs: (map['timestamp_ms'] as num).toInt(),
      isDot: (map['is_dot'] as num?) == 1,
    );
  }
}
