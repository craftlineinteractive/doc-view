import 'dart:ui';
import 'package:docview/data/models/pdf_text_box.dart';
import 'package:docview/data/services/pdf/text_layout_engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('TextLayoutEngine Unit Tests', () {
    group('WinAnsi Character Set & Path Selection', () {
      test('Empty string is WinAnsi safe and selects Latin path', () {
        expect(TextLayoutEngine.isWinAnsiSafe(''), isTrue);
        expect(TextLayoutEngine.selectPath(''), TextRenderPath.latin);
      });

      test('Standard ASCII Latin text is WinAnsi safe', () {
        const latin = 'The quick brown fox jumps over the lazy dog! 1234567890';
        expect(TextLayoutEngine.isWinAnsiSafe(latin), isTrue);
        expect(TextLayoutEngine.selectPath(latin), TextRenderPath.latin);
      });

      test('Latin-1 supplement characters with accents are WinAnsi safe', () {
        const latinAccents = 'Café, résumé, Über, Señor, naïve, façade, £, §, ©, ®';
        expect(TextLayoutEngine.isWinAnsiSafe(latinAccents), isTrue);
        expect(TextLayoutEngine.selectPath(latinAccents), TextRenderPath.latin);
      });

      test('Newlines and tabs are preserved as safe control characters', () {
        const multiline = 'Line 1\nLine 2\r\nLine 3\tIndented';
        expect(TextLayoutEngine.isWinAnsiSafe(multiline), isTrue);
        expect(TextLayoutEngine.selectPath(multiline), TextRenderPath.latin);
      });

      test('Hindi text is NOT WinAnsi safe and selects raster path', () {
        const hindi = 'नमस्ते दुनिया, क्षत्रिय, श्री';
        expect(TextLayoutEngine.isWinAnsiSafe(hindi), isFalse);
        expect(TextLayoutEngine.selectPath(hindi), TextRenderPath.raster);
      });

      test('Arabic text is NOT WinAnsi safe and selects raster path', () {
        const arabic = 'مرحبا بالعالم';
        expect(TextLayoutEngine.isWinAnsiSafe(arabic), isFalse);
        expect(TextLayoutEngine.selectPath(arabic), TextRenderPath.raster);
      });

      test('Emoji characters are NOT WinAnsi safe and select raster path', () {
        const emoji = 'Document approval 👍🎉✅';
        expect(TextLayoutEngine.isWinAnsiSafe(emoji), isFalse);
        expect(TextLayoutEngine.selectPath(emoji), TextRenderPath.raster);
      });

      test('Mixed Latin and Hindi selects raster path', () {
        const mixed = 'Invoice नमस्ते No. 42';
        expect(TextLayoutEngine.isWinAnsiSafe(mixed), isFalse);
        expect(TextLayoutEngine.selectPath(mixed), TextRenderPath.raster);
      });

      test('2,000 characters limit Latin string is WinAnsi safe', () {
        final longLatin = 'A' * 2000;
        expect(TextLayoutEngine.isWinAnsiSafe(longLatin), isTrue);
        expect(TextLayoutEngine.selectPath(longLatin), TextRenderPath.latin);
      });
    });

    group('Pure Line Breaking Algorithm', () {
      double mockMeasure(String token) => token.length * 10.0;

      test('Empty string yields empty lines', () {
        final lines = TextLayoutEngine.breakLinesPure(
          text: '',
          maxWidth: 100,
          measureWidth: mockMeasure,
        );
        expect(lines, isEmpty);
      });

      test('Text within maxWidth stays on single line', () {
        final lines = TextLayoutEngine.breakLinesPure(
          text: 'Short line',
          maxWidth: 200,
          measureWidth: mockMeasure,
        );
        expect(lines, ['Short line']);
      });

      test('Text wraps cleanly at word boundaries when exceeding maxWidth', () {
        // 'word1' = 50, ' ' = 10, 'word2' = 50 -> total 110 > 100
        final lines = TextLayoutEngine.breakLinesPure(
          text: 'word1 word2 word3',
          maxWidth: 100,
          measureWidth: mockMeasure,
        );
        expect(lines, ['word1', 'word2', 'word3']);
      });

      test('Long words exceeding maxWidth are chunked', () {
        // 'Supercalifragilistic' = 200, maxWidth = 100 -> chunks of 10 chars
        final lines = TextLayoutEngine.breakLinesPure(
          text: 'Supercalifragilistic',
          maxWidth: 100,
          measureWidth: mockMeasure,
        );
        expect(lines.length, 2);
        expect(lines[0], 'Supercalif');
        expect(lines[1], 'ragilistic');
      });

      test('Explicit newlines are respected', () {
        final lines = TextLayoutEngine.breakLinesPure(
          text: 'First\nSecond\n\nFourth',
          maxWidth: 200,
          measureWidth: mockMeasure,
        );
        expect(lines, ['First', 'Second', '', 'Fourth']);
      });
    });

    group('Alignment & Text Direction Calculations', () {
      test('Left and Start alignment in LTR aligns to 0', () {
        final dxStart = TextLayoutEngine.calculateLineDx(
          lineWidth: 50,
          totalWidth: 200,
          alignment: TextAlign.start,
          textDirection: TextDirection.ltr,
        );
        expect(dxStart, 0.0);

        final dxLeft = TextLayoutEngine.calculateLineDx(
          lineWidth: 50,
          totalWidth: 200,
          alignment: TextAlign.left,
          textDirection: TextDirection.ltr,
        );
        expect(dxLeft, 0.0);
      });

      test('Center alignment centers within totalWidth', () {
        final dx = TextLayoutEngine.calculateLineDx(
          lineWidth: 50,
          totalWidth: 200,
          alignment: TextAlign.center,
          textDirection: TextDirection.ltr,
        );
        expect(dx, 75.0);
      });

      test('End and Right alignment in LTR aligns to right edge', () {
        final dxEnd = TextLayoutEngine.calculateLineDx(
          lineWidth: 50,
          totalWidth: 200,
          alignment: TextAlign.end,
          textDirection: TextDirection.ltr,
        );
        expect(dxEnd, 150.0);

        final dxRight = TextLayoutEngine.calculateLineDx(
          lineWidth: 50,
          totalWidth: 200,
          alignment: TextAlign.right,
          textDirection: TextDirection.ltr,
        );
        expect(dxRight, 150.0);
      });

      test('Start alignment in RTL flips to right edge', () {
        final dx = TextLayoutEngine.calculateLineDx(
          lineWidth: 50,
          totalWidth: 200,
          alignment: TextAlign.start,
          textDirection: TextDirection.rtl,
        );
        expect(dx, 150.0);
      });

      test('End alignment in RTL flips to left edge', () {
        final dx = TextLayoutEngine.calculateLineDx(
          lineWidth: 50,
          totalWidth: 200,
          alignment: TextAlign.end,
          textDirection: TextDirection.rtl,
        );
        expect(dx, 0.0);
      });
    });

    group('Flutter TextPainter Layout & Raster PNG', () {
      test('layoutText extracts lines and metrics accurately', () {
        final result = TextLayoutEngine.layoutText(
          text: 'Hello world\nSecond line of text',
          fontSize: 14,
          isBold: false,
          isItalic: false,
          maxWidth: 300,
          alignment: TextAlign.start,
        );

        expect(result.lines.length, 2);
        expect(result.lines[0].text, 'Hello world');
        expect(result.lines[1].text, 'Second line of text');
        expect(result.totalHeight, greaterThan(20.0));
      });

      test('renderTextToPng generates valid non-empty PNG bytes for complex script', () async {
        final pngBytes = await TextLayoutEngine.renderTextToPng(
          text: 'नमस्ते दुनिया',
          fontSize: 16,
          color: const Color(0xFF212121),
          isBold: false,
          isItalic: false,
          alignment: TextAlign.start,
          width: 200,
          height: 50,
        );

        expect(pngBytes, isNotEmpty);
        // Standard PNG magic header: 0x89, 'P', 'N', 'G'
        expect(pngBytes[0], 0x89);
        expect(pngBytes[1], 0x50);
        expect(pngBytes[2], 0x4E);
        expect(pngBytes[3], 0x47);
      });
    });

    group('PdfTextBox Model Contract', () {
      test('Serialization toMap and deserialization fromMap preserve all fields', () {
        const original = PdfTextBox(
          id: 'box_123',
          pageIndex: 2,
          bounds: Rect.fromLTWH(50, 100, 200, 80),
          text: 'Sample note',
          fontSize: 18,
          colorValue: 0xFF1E5FD8,
          isBold: true,
          isItalic: false,
          alignment: TextAlign.center,
          lines: [
            PdfTextLine(
              text: 'Sample note',
              dx: 20,
              dy: 0,
              width: 160,
              height: 22,
              baseline: 16,
            ),
          ],
        );

        final map = original.toMap();
        final restored = PdfTextBox.fromMap(map);

        expect(restored.id, original.id);
        expect(restored.pageIndex, original.pageIndex);
        expect(restored.bounds, original.bounds);
        expect(restored.text, original.text);
        expect(restored.fontSize, original.fontSize);
        expect(restored.colorValue, original.colorValue);
        expect(restored.isBold, original.isBold);
        expect(restored.isItalic, original.isItalic);
        expect(restored.alignment, original.alignment);
        expect(restored.lines.length, 1);
        expect(restored.lines.first.text, 'Sample note');
      });

      test('Document limits constants match specification', () {
        expect(PdfTextBox.maxBoxesPerDocument, 30);
        expect(PdfTextBox.maxCharactersPerBox, 2000);
        expect(PdfTextBox.minBoxWidth, 60.0);
        expect(PdfTextBox.defaultFontSize, 14.0);
        expect(PdfTextBox.defaultColorValue, 0xFF212121);
      });
    });
  });
}
