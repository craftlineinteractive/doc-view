// ignore_for_file: avoid_print
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart' as sf;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    // Load Arimo fonts into Flutter test engine
    final regularData = await File('assets/fonts/Arimo-Regular.ttf').readAsBytes();
    final boldData = await File('assets/fonts/Arimo-Bold.ttf').readAsBytes();
    final italicData = await File('assets/fonts/Arimo-Italic.ttf').readAsBytes();
    final boldItalicData = await File('assets/fonts/Arimo-BoldItalic.ttf').readAsBytes();

    final fontLoader = FontLoader('Arimo')
      ..addFont(Future.value(ByteData.view(regularData.buffer)))
      ..addFont(Future.value(ByteData.view(boldData.buffer)))
      ..addFont(Future.value(ByteData.view(italicData.buffer)))
      ..addFont(Future.value(ByteData.view(boldItalicData.buffer)));
    await fontLoader.load();
  });

  test('Metric Check: Arimo (TextPainter) vs Helvetica (Syncfusion)', () {
    const paragraph = [
      'Doc View is a high performance document reader and editor built for mobile devices.',
      'The application supports rendering and editing of complex PDF documents and forms.',
      'Text layout requires precise typography matching between editor UI and saved output.',
      'Syncfusion uses the standard Helvetica 14 font metrics embedded in PDF readers.',
      'Arimo is an open source typeface metrically compatible with Arial and Helvetica.',
      'Line breaking and word wrapping algorithms rely on deterministic character advances.',
      'When users type contracts or legal agreements, paragraph margins must remain stable.',
      'Testing text measurement ensures that lines do not unexpectedly overflow or clip.',
      'Font metrics include glyph bounding boxes, ascenders, descenders, and advance widths.',
      'This metric comparison validates line width deviations across 10 lines of Latin prose.',
    ];

    final sizes = [12.0, 14.0, 24.0];
    final styles = [
      ('Regular', false, false, <sf.PdfFontStyle>[]),
      ('Bold', true, false, [sf.PdfFontStyle.bold]),
      ('Italic', false, true, [sf.PdfFontStyle.italic]),
      ('BoldItalic', true, true, [sf.PdfFontStyle.bold, sf.PdfFontStyle.italic]),
    ];

    print('=== METRIC CHECK: Arimo (TextPainter) vs Helvetica (Syncfusion) ===');
    print('Size | Style      | Max Deviation (pt) | Avg Deviation (pt) | Status');
    print('------------------------------------------------------------------');

    for (final size in sizes) {
      for (final (styleName, isBold, isItalic, sfStyles) in styles) {
        final sfFont = sfStyles.isEmpty
            ? sf.PdfStandardFont(sf.PdfFontFamily.helvetica, size)
            : sf.PdfStandardFont(
                sf.PdfFontFamily.helvetica,
                size,
                multiStyle: sfStyles,
              );

        double maxDev = 0.0;
        double totalDev = 0.0;

        for (final line in paragraph) {
          final tp = TextPainter(
            text: TextSpan(
              text: line,
              style: TextStyle(
                fontFamily: 'Arimo',
                fontSize: size,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
              ),
            ),
            textDirection: TextDirection.ltr,
          )..layout();

          final arimoWidth = tp.width;
          final helveticaWidth = sfFont.measureString(line).width;
          final dev = (arimoWidth - helveticaWidth).abs();

          if (dev > maxDev) maxDev = dev;
          totalDev += dev;
        }

        final avgDev = totalDev / paragraph.length;
        final status = maxDev <= 1.0 ? 'PASS (<=1.0 pt)' : 'DEVIATION (>1.0 pt)';
        print(
          '${size.toString().padRight(4)} | ${styleName.padRight(10)} | ${maxDev.toStringAsFixed(3).padRight(18)} | ${avgDev.toStringAsFixed(3).padRight(18)} | $status',
        );
      }
    }
  });
}
