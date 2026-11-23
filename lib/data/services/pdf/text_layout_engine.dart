import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

import '../../models/pdf_text_box.dart';

/// The rendering path chosen for a given text snippet.
enum TextRenderPath {
  /// Pure vector text with standard Helvetica, line-by-line positioning.
  latin,

  /// High-resolution raster bitmap (4x PNG) stamped onto the page for complex scripts.
  raster,
}

/// The layout result containing line fragments and overall dimensions.
class TextLayoutResult {
  const TextLayoutResult({
    required this.lines,
    required this.totalWidth,
    required this.totalHeight,
  });

  final List<PdfTextLine> lines;
  final double totalWidth;
  final double totalHeight;
}

/// Layout engine that unifies on-screen text preview and PDF serialization geometry.
class TextLayoutEngine {
  const TextLayoutEngine();

  /// Determines whether [text] consists entirely of characters in the WinAnsi character set.
  ///
  /// WinAnsi contains ASCII printable characters (0x20..0x7E) and Latin-1 supplement (0xA0..0xFF).
  /// Newlines (0x0A, 0x0D) and tabs (0x09) are treated as safe control characters.
  static bool isWinAnsiSafe(String text) {
    if (text.isEmpty) return true;
    for (final rune in text.runes) {
      if (rune == 0x0A || rune == 0x0D || rune == 0x09) continue;
      if (rune >= 0x20 && rune <= 0x7E) continue;
      if (rune >= 0xA0 && rune <= 0xFF) continue;
      return false;
    }
    return true;
  }

  /// Selects the appropriate rendering path based on text character coverage.
  static TextRenderPath selectPath(String text) {
    return isWinAnsiSafe(text) ? TextRenderPath.latin : TextRenderPath.raster;
  }

  /// Pure line-breaking algorithm based on word tokenization and character measurement.
  ///
  /// Useful for headless unit testing and verifying line wrapping without native engine bindings.
  static List<String> breakLinesPure({
    required String text,
    required double maxWidth,
    required double Function(String token) measureWidth,
  }) {
    if (text.isEmpty) return const <String>[];

    final result = <String>[];
    final paragraphs = text.split(RegExp(r'\r?\n'));

    for (final para in paragraphs) {
      if (para.isEmpty) {
        result.add('');
        continue;
      }

      final words = para.split(' ');
      var currentLine = StringBuffer();
      var currentLineWidth = 0.0;
      final spaceWidth = measureWidth(' ');

      for (var i = 0; i < words.length; i++) {
        final word = words[i];
        final wordWidth = measureWidth(word);

        if (currentLine.isEmpty) {
          if (wordWidth <= maxWidth) {
            currentLine.write(word);
            currentLineWidth = wordWidth;
          } else {
            // Long word exceeding maxWidth: break word into chunks
            var partialWord = StringBuffer();
            var partialWidth = 0.0;
            for (final char in word.characters) {
              final charWidth = measureWidth(char);
              if (partialWidth + charWidth > maxWidth && partialWord.isNotEmpty) {
                result.add(partialWord.toString());
                partialWord = StringBuffer(char);
                partialWidth = charWidth;
              } else {
                partialWord.write(char);
                partialWidth += charWidth;
              }
            }
            if (partialWord.isNotEmpty) {
              currentLine = partialWord;
              currentLineWidth = partialWidth;
            }
          }
        } else {
          if (currentLineWidth + spaceWidth + wordWidth <= maxWidth) {
            currentLine.write(' $word');
            currentLineWidth += spaceWidth + wordWidth;
          } else {
            result.add(currentLine.toString());
            currentLine = StringBuffer();
            currentLineWidth = 0.0;

            if (wordWidth <= maxWidth) {
              currentLine.write(word);
              currentLineWidth = wordWidth;
            } else {
              // Word is wider than line, split it
              var partialWord = StringBuffer();
              var partialWidth = 0.0;
              for (final char in word.characters) {
                final charWidth = measureWidth(char);
                if (partialWidth + charWidth > maxWidth && partialWord.isNotEmpty) {
                  result.add(partialWord.toString());
                  partialWord = StringBuffer(char);
                  partialWidth = charWidth;
                } else {
                  partialWord.write(char);
                  partialWidth += charWidth;
                }
              }
              if (partialWord.isNotEmpty) {
                currentLine = partialWord;
                currentLineWidth = partialWidth;
              }
            }
          }
        }
      }

      if (currentLine.isNotEmpty) {
        result.add(currentLine.toString());
      }
    }

    return result;
  }

  /// Calculates line offsets taking alignment into account.
  static double calculateLineDx({
    required double lineWidth,
    required double totalWidth,
    required TextAlign alignment,
    required TextDirection textDirection,
  }) {
    final effectiveAlignment = _resolveAlignment(alignment, textDirection);
    switch (effectiveAlignment) {
      case TextAlign.center:
        return (totalWidth - lineWidth) / 2.0;
      case TextAlign.right:
      case TextAlign.end:
        return totalWidth - lineWidth;
      case TextAlign.left:
      case TextAlign.start:
      case TextAlign.justify:
        return 0.0;
    }
  }

  static TextAlign _resolveAlignment(TextAlign align, TextDirection dir) {
    if (align == TextAlign.start) {
      return dir == TextDirection.rtl ? TextAlign.right : TextAlign.left;
    }
    if (align == TextAlign.end) {
      return dir == TextDirection.rtl ? TextAlign.left : TextAlign.right;
    }
    return align;
  }

  /// Computes the exact line breaking and positions using Flutter's [TextPainter].
  ///
  /// Uses font family [fontFamily] ('Arimo' by default for Helvetica metric compatibility).
  static TextLayoutResult layoutText({
    required String text,
    required double fontSize,
    required bool isBold,
    required bool isItalic,
    required double maxWidth,
    required TextAlign alignment,
    TextDirection textDirection = TextDirection.ltr,
    String fontFamily = 'Arimo',
  }) {
    if (text.isEmpty) {
      return TextLayoutResult(
        lines: const <PdfTextLine>[],
        totalWidth: maxWidth,
        totalHeight: fontSize * 1.2,
      );
    }

    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontFamily: fontFamily,
          fontSize: fontSize,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
        ),
      ),
      textAlign: alignment,
      textDirection: textDirection,
    );

    textPainter.layout(maxWidth: maxWidth);

    final lineMetrics = textPainter.computeLineMetrics();
    final lines = <PdfTextLine>[];

    var currentOffset = 0;
    for (var i = 0; i < lineMetrics.length; i++) {
      final metric = lineMetrics[i];
      if (currentOffset >= text.length) break;

      final range = textPainter.getLineBoundary(TextPosition(offset: currentOffset));
      var lineText = text.substring(range.start, range.end);

      // Strip trailing carriage return / newline
      while (lineText.endsWith('\n') || lineText.endsWith('\r')) {
        lineText = lineText.substring(0, lineText.length - 1);
      }

      final dy = metric.baseline - metric.ascent;
      final dx = metric.left;

      lines.add(
        PdfTextLine(
          text: lineText,
          dx: dx,
          dy: dy,
          width: metric.width,
          height: metric.height,
          baseline: metric.baseline,
        ),
      );

      currentOffset = range.end;
      while (currentOffset < text.length &&
          (text[currentOffset] == '\n' || text[currentOffset] == '\r')) {
        currentOffset++;
      }
      if (range.start == range.end) {
        currentOffset++;
      }
    }

    return TextLayoutResult(
      lines: lines,
      totalWidth: textPainter.width.clamp(maxWidth, double.infinity),
      totalHeight: textPainter.height,
    );
  }

  /// Renders complex non-Latin text to a high-resolution transparent PNG bitmap.
  ///
  /// Defaults to 4x scaling (target 288 dpi), capped at 4096 px maximum dimension.
  static Future<Uint8List> renderTextToPng({
    required String text,
    required double fontSize,
    required Color color,
    required bool isBold,
    required bool isItalic,
    required TextAlign alignment,
    required double width,
    required double height,
    TextDirection textDirection = TextDirection.ltr,
    double targetScale = 4.0,
  }) async {
    var scale = targetScale;
    var pxWidth = (width * scale).ceil();
    var pxHeight = (height * scale).ceil();

    const maxDim = 4096;
    if (pxWidth > maxDim || pxHeight > maxDim) {
      final scaleX = maxDim / width;
      final scaleY = maxDim / height;
      scale = scaleX < scaleY ? scaleX : scaleY;
      pxWidth = (width * scale).ceil();
      pxHeight = (height * scale).ceil();
    }

    if (pxWidth <= 0) pxWidth = 1;
    if (pxHeight <= 0) pxHeight = 1;

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(
      recorder,
      Rect.fromLTWH(0, 0, pxWidth.toDouble(), pxHeight.toDouble()),
    );
    canvas.scale(scale);

    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
          color: color,
        ),
      ),
      textAlign: alignment,
      textDirection: textDirection,
    );
    textPainter.layout(maxWidth: width);
    textPainter.paint(canvas, Offset.zero);

    final picture = recorder.endRecording();
    final image = await picture.toImage(pxWidth, pxHeight);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    image.dispose();
    picture.dispose();

    return byteData!.buffer.asUint8List();
  }
}
