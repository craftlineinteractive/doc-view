import 'dart:typed_data';
import 'dart:ui';

/// Represents a signature or date stamp placed onto a PDF page.
class PlacedSignature {
  const PlacedSignature({
    required this.id,
    required this.pageIndex,
    required this.bounds,
    this.signatureId,
    this.signatureFilePath = '',
    this.pngBytes,
    this.isDate = false,
    this.dateText,
    required this.timestampMs,
  });

  /// Maximum allowed placed signatures or dates per document.
  static const int maxSignaturesPerDocument = 20;

  /// Unique identifier for this placed signature on the document.
  final String id;

  /// 0-based page index where the signature is placed.
  final int pageIndex;

  /// Visual coordinates rectangle on the rendered page in points (72 DPI).
  final Rect bounds;

  /// ID of the saved signature from SignatureRepository (if sourced from saved).
  final String? signatureId;

  /// Local file path of the signature image (if loaded from disk).
  final String signatureFilePath;

  /// Raw PNG image bytes of the signature.
  final Uint8List? pngBytes;

  /// Whether this placed item is a localized date stamp instead of a handwritten signature.
  final bool isDate;

  bool get isDateStamp => isDate;

  /// Formatted date string if [isDate] is true.
  final String? dateText;

  /// Creation timestamp in milliseconds since epoch.
  final int timestampMs;

  PlacedSignature copyWith({
    String? id,
    int? pageIndex,
    Rect? bounds,
    String? signatureId,
    String? signatureFilePath,
    Uint8List? pngBytes,
    bool? isDate,
    String? dateText,
    int? timestampMs,
  }) {
    return PlacedSignature(
      id: id ?? this.id,
      pageIndex: pageIndex ?? this.pageIndex,
      bounds: bounds ?? this.bounds,
      signatureId: signatureId ?? this.signatureId,
      signatureFilePath: signatureFilePath ?? this.signatureFilePath,
      pngBytes: pngBytes ?? this.pngBytes,
      isDate: isDate ?? this.isDate,
      dateText: dateText ?? this.dateText,
      timestampMs: timestampMs ?? this.timestampMs,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'page_index': pageIndex,
      'bounds': [bounds.left, bounds.top, bounds.width, bounds.height],
      'signature_id': signatureId,
      'signature_file_path': signatureFilePath,
      'png_bytes': pngBytes,
      'is_date': isDate ? 1 : 0,
      'date_text': dateText,
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

    return PlacedSignature(
      id: map['id'] as String,
      pageIndex: (map['page_index'] as num).toInt(),
      bounds: b,
      signatureId: map['signature_id'] as String?,
      signatureFilePath: (map['signature_file_path'] as String?) ?? '',
      pngBytes: map['png_bytes'] != null
          ? Uint8List.fromList(List<int>.from(map['png_bytes'] as List))
          : null,
      isDate: (map['is_date'] as num?) == 1,
      dateText: map['date_text'] as String?,
      timestampMs: (map['timestamp_ms'] as num).toInt(),
    );
  }
}
