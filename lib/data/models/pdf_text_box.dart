import 'dart:typed_data';
import 'package:flutter/material.dart';

/// Represents a single laid-out line of text within a [PdfTextBox] for the Latin vector path.
class PdfTextLine {
  const PdfTextLine({
    required this.text,
    required this.dx,
    required this.dy,
    required this.width,
    required this.height,
    required this.baseline,
  });

  factory PdfTextLine.fromMap(Map<String, dynamic> map) {
    return PdfTextLine(
      text: map['text'] as String,
      dx: (map['dx'] as num).toDouble(),
      dy: (map['dy'] as num).toDouble(),
      width: (map['width'] as num).toDouble(),
      height: (map['height'] as num).toDouble(),
      baseline: (map['baseline'] as num).toDouble(),
    );
  }

  final String text;
  final double dx;
  final double dy;
  final double width;
  final double height;
  final double baseline;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'text': text,
      'dx': dx,
      'dy': dy,
      'width': width,
      'height': height,
      'baseline': baseline,
    };
  }
}

/// Model representing a user-placed text box on a PDF page.
class PdfTextBox {
  const PdfTextBox({
    required this.id,
    required this.pageIndex,
    required this.bounds,
    required this.text,
    this.fontSize = defaultFontSize,
    this.colorValue = defaultColorValue,
    this.isBold = false,
    this.isItalic = false,
    this.alignment = TextAlign.start,
    this.lines = const <PdfTextLine>[],
    this.isRaster = false,
    this.pngBytes,
  });

  factory PdfTextBox.fromMap(Map<String, dynamic> map) {
    final rawBounds = (map['bounds'] as List<dynamic>).cast<num>();
    final rawLines = (map['lines'] as List<dynamic>?) ?? <dynamic>[];

    return PdfTextBox(
      id: map['id'] as String,
      pageIndex: map['pageIndex'] as int,
      bounds: Rect.fromLTWH(
        rawBounds[0].toDouble(),
        rawBounds[1].toDouble(),
        rawBounds[2].toDouble(),
        rawBounds[3].toDouble(),
      ),
      text: map['text'] as String,
      fontSize: (map['fontSize'] as num?)?.toDouble() ?? defaultFontSize,
      colorValue: map['colorValue'] as int? ?? defaultColorValue,
      isBold: map['isBold'] as bool? ?? false,
      isItalic: map['isItalic'] as bool? ?? false,
      alignment: TextAlign.values[map['alignment'] as int? ?? 0],
      lines: rawLines
          .map((l) => PdfTextLine.fromMap(l as Map<String, dynamic>))
          .toList(),
      isRaster: map['isRaster'] as bool? ?? false,
      pngBytes: map['pngBytes'] != null
          ? Uint8List.fromList((map['pngBytes'] as List<dynamic>).cast<int>())
          : null,
    );
  }

  /// System limits per document and per box.
  static const int maxBoxesPerDocument = 30;
  static const int maxCharactersPerBox = 2000;
  static const double minBoxWidth = 60.0;
  static const double minFontSize = 8.0;
  static const double maxFontSize = 72.0;
  static const double defaultFontSize = 14.0;
  static const int defaultColorValue = 0xFF212121;

  final String id;
  final int pageIndex;
  final Rect bounds;
  final String text;
  final double fontSize;
  final int colorValue;
  final bool isBold;
  final bool isItalic;
  final TextAlign alignment;
  final List<PdfTextLine> lines;
  final bool isRaster;
  final Uint8List? pngBytes;

  PdfTextBox copyWith({
    String? id,
    int? pageIndex,
    Rect? bounds,
    String? text,
    double? fontSize,
    int? colorValue,
    bool? isBold,
    bool? isItalic,
    TextAlign? alignment,
    List<PdfTextLine>? lines,
    bool? isRaster,
    Uint8List? pngBytes,
  }) {
    return PdfTextBox(
      id: id ?? this.id,
      pageIndex: pageIndex ?? this.pageIndex,
      bounds: bounds ?? this.bounds,
      text: text ?? this.text,
      fontSize: fontSize ?? this.fontSize,
      colorValue: colorValue ?? this.colorValue,
      isBold: isBold ?? this.isBold,
      isItalic: isItalic ?? this.isItalic,
      alignment: alignment ?? this.alignment,
      lines: lines ?? this.lines,
      isRaster: isRaster ?? this.isRaster,
      pngBytes: pngBytes ?? this.pngBytes,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'pageIndex': pageIndex,
      'bounds': <double>[bounds.left, bounds.top, bounds.width, bounds.height],
      'text': text,
      'fontSize': fontSize,
      'colorValue': colorValue,
      'isBold': isBold,
      'isItalic': isItalic,
      'alignment': alignment.index,
      'lines': lines.map((l) => l.toMap()).toList(),
      'isRaster': isRaster,
      'pngBytes': pngBytes?.toList(),
    };
  }
}
