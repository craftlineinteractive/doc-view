import 'dart:ui';

/// Represents a vector signature placed onto a PDF page.
class PlacedSignature {
  const PlacedSignature({
    required this.id,
    required this.pageIndex,
    required this.bounds,
    this.signatureId,
    this.normalizedStrokes = const [],
    this.colorValue = 0xFF000000,
    this.strokeWidth = 2.0,
    required this.timestampMs,
  });

  /// Maximum allowed placed signatures per document.
  static const int maxSignaturesPerDocument = 20;

  /// Unique identifier for this placed signature on the document.
  final String id;

  /// 0-based page index where the signature is placed.
  final int pageIndex;

  /// Visual coordinates rectangle on the rendered page in points (72 DPI).
  final Rect bounds;

  /// ID of the saved signature from SignatureRepository (if sourced from saved).
  final String? signatureId;

  /// Normalized vector stroke polylines in [0..1] x [0..1] bounding coordinates.
  final List<List<Offset>> normalizedStrokes;

  /// ARGB color of the signature ink.
  final int colorValue;

  /// Stroke width in points.
  final double strokeWidth;

  /// Creation timestamp in milliseconds since epoch.
  final int timestampMs;

  PlacedSignature copyWith({
    String? id,
    int? pageIndex,
    Rect? bounds,
    String? signatureId,
    List<List<Offset>>? normalizedStrokes,
    int? colorValue,
    double? strokeWidth,
    int? timestampMs,
  }) {
    return PlacedSignature(
      id: id ?? this.id,
      pageIndex: pageIndex ?? this.pageIndex,
      bounds: bounds ?? this.bounds,
      signatureId: signatureId ?? this.signatureId,
      normalizedStrokes: normalizedStrokes ?? this.normalizedStrokes,
      colorValue: colorValue ?? this.colorValue,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      timestampMs: timestampMs ?? this.timestampMs,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'page_index': pageIndex,
      'bounds': [bounds.left, bounds.top, bounds.width, bounds.height],
      'signature_id': signatureId,
      'normalized_strokes': normalizedStrokes
          .map((stroke) => stroke.map((p) => [p.dx, p.dy]).toList())
          .toList(),
      'color_value': colorValue,
      'stroke_width': strokeWidth,
      'timestamp_ms': timestampMs,
    };
  }

  factory PlacedSignature.fromMap(Map<String, dynamic> map) {
    final rawBounds = (map['bounds'] as List<dynamic>?) ?? [0, 0, 100, 40];
    final b = Rect.fromLTWH(
      (rawBounds[0] as num).toDouble(),
      (rawBounds[1] as num).toDouble(),
      (rawBounds[2] as num).toDouble(),
      (rawBounds[3] as num).toDouble(),
    );

    final rawStrokes = map['normalized_strokes'] as List<dynamic>?;
    final strokes = <List<Offset>>[];
    if (rawStrokes != null) {
      for (final s in rawStrokes) {
        final strokePoints = <Offset>[];
        for (final p in s as List<dynamic>) {
          final pt = p as List<dynamic>;
          strokePoints.add(Offset(
            (pt[0] as num).toDouble(),
            (pt[1] as num).toDouble(),
          ));
        }
        strokes.add(strokePoints);
      }
    }

    return PlacedSignature(
      id: map['id'] as String,
      pageIndex: (map['page_index'] as num).toInt(),
      bounds: b,
      signatureId: map['signature_id'] as String?,
      normalizedStrokes: strokes,
      colorValue: (map['color_value'] as num?)?.toInt() ?? 0xFF000000,
      strokeWidth: (map['stroke_width'] as num?)?.toDouble() ?? 2.0,
      timestampMs: (map['timestamp_ms'] as num).toInt(),
    );
  }
}
