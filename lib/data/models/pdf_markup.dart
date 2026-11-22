import 'dart:ui';

/// Supported markup types for G5a.
enum TextMarkupType {
  highlight,
  underline,
  strikethrough;

  String get name {
    switch (this) {
      case TextMarkupType.highlight:
        return 'highlight';
      case TextMarkupType.underline:
        return 'underline';
      case TextMarkupType.strikethrough:
        return 'strikethrough';
    }
  }

  static TextMarkupType fromName(String name) {
    switch (name.toLowerCase()) {
      case 'underline':
        return TextMarkupType.underline;
      case 'strikethrough':
        return TextMarkupType.strikethrough;
      case 'highlight':
      default:
        return TextMarkupType.highlight;
    }
  }
}

/// Immutable plain DTO representing a text markup annotation.
/// Safe to transfer across isolates.
class TextMarkup {
  const TextMarkup({
    required this.id,
    required this.pageIndex,
    required this.type,
    required this.colorValue,
    required this.lineRects,
    required this.text,
    required this.createdAtMs,
  });

  /// Unique identifier (e.g. UUID / timestamp id)
  final String id;

  /// 0-based page index
  final int pageIndex;

  /// Type of markup: highlight, underline, or strikethrough
  final TextMarkupType type;

  /// ARGB integer color (e.g. 0xFFFFEB3B for yellow)
  final int colorValue;

  /// Bounding boxes of individual lines/segments in visual page points (72 DPI)
  final List<Rect> lineRects;

  /// The underlying marked-up text
  final String text;

  /// Milliseconds since epoch when created
  final int createdAtMs;

  Color get color => Color(colorValue);

  /// Computes union bounding box across all line rects.
  Rect get bounds {
    if (lineRects.isEmpty) return Rect.zero;
    return lineRects.reduce((a, b) => a.expandToInclude(b));
  }

  TextMarkup copyWith({
    String? id,
    int? pageIndex,
    TextMarkupType? type,
    int? colorValue,
    List<Rect>? lineRects,
    String? text,
    int? createdAtMs,
  }) {
    return TextMarkup(
      id: id ?? this.id,
      pageIndex: pageIndex ?? this.pageIndex,
      type: type ?? this.type,
      colorValue: colorValue ?? this.colorValue,
      lineRects: lineRects ?? this.lineRects,
      text: text ?? this.text,
      createdAtMs: createdAtMs ?? this.createdAtMs,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'pageIndex': pageIndex,
      'type': type.name,
      'colorValue': colorValue,
      'lineRects': lineRects
          .map((r) => [r.left, r.top, r.width, r.height])
          .toList(),
      'text': text,
      'createdAtMs': createdAtMs,
    };
  }

  factory TextMarkup.fromMap(Map<String, dynamic> map) {
    final rawRects = map['lineRects'] as List<dynamic>? ?? [];
    final rects = rawRects.map((r) {
      final list = r as List<dynamic>;
      return Rect.fromLTWH(
        (list[0] as num).toDouble(),
        (list[1] as num).toDouble(),
        (list[2] as num).toDouble(),
        (list[3] as num).toDouble(),
      );
    }).toList();

    return TextMarkup(
      id: map['id'] as String,
      pageIndex: map['pageIndex'] as int,
      type: TextMarkupType.fromName(map['type'] as String),
      colorValue: map['colorValue'] as int,
      lineRects: rects,
      text: map['text'] as String? ?? '',
      createdAtMs: map['createdAtMs'] as int? ?? DateTime.now().millisecondsSinceEpoch,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TextMarkup &&
        other.id == id &&
        other.pageIndex == pageIndex &&
        other.type == type &&
        other.colorValue == colorValue &&
        other.text == text;
  }

  @override
  int get hashCode => Object.hash(id, pageIndex, type, colorValue, text);
}
