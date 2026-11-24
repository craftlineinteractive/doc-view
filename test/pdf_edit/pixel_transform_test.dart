// ignore_for_file: avoid_print
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui';

import 'package:docview/data/models/ink_stroke.dart';
import 'package:docview/data/models/pdf_text_box.dart';
import 'package:docview/data/models/placed_signature.dart';
import 'package:docview/data/services/pdf/pdf_annotation_service.dart';
import 'package:docview/data/services/pdf/text_layout_engine.dart';
import 'package:flutter/material.dart' show TextPainter, TextSpan, TextStyle, TextDirection, TextAlign;
import 'package:flutter/services.dart' show FontLoader;
import 'package:flutter_test/flutter_test.dart';
import 'package:pdfrx/pdfrx.dart' as rx;
import 'package:syncfusion_flutter_pdf/pdf.dart' as sf;
import 'package:syncfusion_flutter_pdf/src/pdf/implementation/pages/pdf_page.dart'
    as sf_page;
import 'package:syncfusion_flutter_pdf/src/pdf/implementation/primitives/pdf_array.dart'
    as sf_prim;
import 'package:syncfusion_flutter_pdf/src/pdf/implementation/primitives/pdf_dictionary.dart'
    as sf_prim;
import 'package:syncfusion_flutter_pdf/src/pdf/implementation/primitives/pdf_name.dart'
    as sf_prim;

double computeOverlapPercent(Rect expected, Rect measured) {
  final intersection = expected.intersect(measured);
  if (intersection.width <= 0 || intersection.height <= 0) return 0.0;
  final intersectArea = intersection.width * intersection.height;
  final unionArea = (expected.width * expected.height) +
      (measured.width * measured.height) -
      intersectArea;
  if (unionArea <= 0) return 0.0;
  return (intersectArea / unionArea) * 100.0;
}

double computeOffset(Rect expected, Rect measured) {
  final dLeft = (expected.left - measured.left).abs();
  final dTop = (expected.top - measured.top).abs();
  final dRight = (expected.right - measured.right).abs();
  final dBottom = (expected.bottom - measured.bottom).abs();
  return [dLeft, dTop, dRight, dBottom].reduce(math.max);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;
  final service = PdfAnnotationService();

  setUp(() {
    tempDir = Directory.systemTemp.createTempSync('pixel_transform_test_');
  });

  tearDown(() {
    try {
      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
      }
    } catch (_) {}
  });

  test('Arimo vs Helvetica glyph advance comparison for >= 20 characters', () async {
    // Load the real Arimo font into the Flutter test environment
    final fontLoader = FontLoader('Arimo');
    final fontBytes = File('assets/fonts/Arimo-Regular.ttf').readAsBytesSync();
    fontLoader.addFont(Future.value(ByteData.sublistView(fontBytes)));
    await fontLoader.load();

    const testChars = [
      'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J',
      'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T',
      'a', 'b', 'c', '1', '2', '3', ' '
    ];

    final helveticaFont = sf.PdfStandardFont(sf.PdfFontFamily.helvetica, 14.0);

    print('=== FONT METRICS ADVANCE COMPARISON (Helvetica vs Arimo, fontSize: 14.0) ===');
    print('Char | Helvetica Adv (pt) | Arimo Preview Adv (pt) | Delta (pt) | Status');
    print('-----+--------------------+------------------------+------------+-------');

    var totalDelta = 0.0;
    var maxDelta = 0.0;

    for (final char in testChars) {
      final double helvWidth;
      if (char == ' ') {
        helvWidth = helveticaFont.measureString('A A').width - helveticaFont.measureString('AA').width;
      } else {
        helvWidth = helveticaFont.measureString(char).width;
      }
      final tp = TextPainter(
        text: TextSpan(
          text: char,
          style: const TextStyle(fontFamily: 'Arimo', fontSize: 14.0),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      final arimoWidth = tp.width;
      final delta = (helvWidth - arimoWidth).abs();
      totalDelta += delta;
      if (delta > maxDelta) maxDelta = delta;

      final label = char == ' ' ? '<space>' : char;
      print(
        '${label.padRight(4)} | ${helvWidth.toStringAsFixed(3).padLeft(18)} | ${arimoWidth.toStringAsFixed(3).padLeft(22)} | ${delta.toStringAsFixed(3).padLeft(10)} | ${delta <= 1.0 ? "MATCH" : "DIFF"}',
      );
    }

    final avgDelta = totalDelta / testChars.length;
    print('-----+--------------------+------------------------+------------+-------');
    print('Analyzed ${testChars.length} glyphs: Max Delta = ${maxDelta.toStringAsFixed(3)} pt, Avg Delta = ${avgDelta.toStringAsFixed(3)} pt');
    expect(testChars.length, greaterThanOrEqualTo(20));
    expect(maxDelta, lessThan(2.0), reason: 'Arimo and Helvetica must be metrically compatible');
  });

  test(
    'automated pixel test for ink strokes, signatures, and text across 5 transformed pages',
    () async {
      // 1. Create base 5-page PDF
      final doc = sf.PdfDocument();
      for (var i = 0; i < 5; i++) {
        final page = doc.pages.add();
        final font = sf.PdfStandardFont(sf.PdfFontFamily.helvetica, 14);
        page.graphics.drawString(
          'Base text for page $i',
          font,
          bounds: const Rect.fromLTWH(50, 50, 300, 20),
        );
      }
      final rawBytes = doc.saveSync();
      doc.dispose();

      // 2. Reload and apply rotations & cropbox
      final loadedDoc = sf.PdfDocument(inputBytes: rawBytes);
      loadedDoc.pages[1].rotation = sf.PdfPageRotateAngle.rotateAngle90;
      loadedDoc.pages[2].rotation = sf.PdfPageRotateAngle.rotateAngle180;
      loadedDoc.pages[3].rotation = sf.PdfPageRotateAngle.rotateAngle270;

      final p4Helper = sf_page.PdfPageHelper.getHelper(loadedDoc.pages[4]);
      p4Helper.dictionary!.setProperty(
        sf_prim.PdfName('CropBox'),
        sf_prim.PdfArray(<num>[50, 50, 550, 750]),
      );

      final rotatedBytes = loadedDoc.saveSync();
      loadedDoc.dispose();

      final basePath = '${tempDir.path}/base_5pages.pdf';
      await File(basePath).writeAsBytes(rotatedBytes);

      // 3. Prepare test strokes, signatures, and text boxes for each page
      final strokes = <InkStroke>[];
      final signatures = <PlacedSignature>[];
      final textBoxes = <PdfTextBox>[];

      // Pre-render raster PNG for non-Latin text (Hindi) with cyan background for box pixel boundary
      final rasterPng = await TextLayoutEngine.renderTextToPng(
        text: 'नमस्ते दुनिया',
        fontSize: 14.0,
        color: const Color(0xFF000000), // black text
        isBold: false,
        isItalic: false,
        alignment: TextAlign.left,
        width: 150.0,
        height: 40.0,
        backgroundColor: const Color(0xFF00FFFF), // pure Cyan background box
      );

      for (var i = 0; i < 5; i++) {
        // Red strokes: horizontal & vertical
        strokes.add(
          InkStroke(
            id: 'stroke_h_$i',
            pageIndex: i,
            points: const [Offset(100, 200), Offset(200, 200)],
            colorValue: 0xFFFF0000, // pure Red
            strokeWidth: 4.0,
            timestampMs: 1000 + i,
          ),
        );
        strokes.add(
          InkStroke(
            id: 'stroke_v_$i',
            pageIndex: i,
            points: const [Offset(100, 200), Offset(100, 280)],
            colorValue: 0xFFFF0000, // pure Red
            strokeWidth: 4.0,
            timestampMs: 2000 + i,
          ),
        );

        // Blue vector signature: diagonal cross in [100..180, 320..360]
        signatures.add(
          PlacedSignature(
            id: 'sig_$i',
            pageIndex: i,
            bounds: const Rect.fromLTWH(100, 320, 80, 40),
            normalizedStrokes: const [
              [Offset(0.0, 0.0), Offset(1.0, 1.0)],
              [Offset(0.0, 1.0), Offset(1.0, 0.0)],
            ],
            colorValue: 0xFF0000FF, // pure Blue
            strokeWidth: 3.0,
            timestampMs: 3000 + i,
          ),
        );

        // (a) Latin text box (pure vector standard Helvetica)
        // Text is "LATIN PROOF" at fontSize 14.0
        textBoxes.add(
          PdfTextBox(
            id: 'latin_$i',
            pageIndex: i,
            bounds: const Rect.fromLTWH(100, 400, 150, 30),
            text: 'LATIN PROOF',
            fontSize: 14.0,
            colorValue: 0xFFFF00FF, // pure Magenta
            lines: const [
              PdfTextLine(
                text: 'LATIN PROOF',
                dx: 0.0,
                dy: 0.0,
                width: 91.0,
                height: 14.0,
                baseline: 11.5,
              ),
            ],
            isRaster: false,
          ),
        );

        // (b) Raster non-Latin text box (image path)
        textBoxes.add(
          PdfTextBox(
            id: 'raster_$i',
            pageIndex: i,
            bounds: const Rect.fromLTWH(100, 460, 150, 40),
            text: 'नमस्ते दुनिया',
            fontSize: 14.0,
            colorValue: 0xFF00FFFF, // pure Cyan
            isRaster: true,
            pngBytes: rasterPng,
          ),
        );
      }

      final outPath = '${tempDir.path}/annotated_pixel_proof.pdf';
      final savedFile = await service.saveAnnotations(
        sourcePath: basePath,
        outputPath: outPath,
        strokes: strokes,
        signatures: signatures,
        textBoxes: textBoxes,
      );

      expect(await savedFile.exists(), isTrue);

      // 4. Verify rendered pixels and structure with pdfrx and Syncfusion
      final rxDoc = await rx.PdfDocument.openFile(outPath);
      expect(rxDoc.pages.length, 5);

      final sfVerifyDoc = sf.PdfDocument(inputBytes: await File(outPath).readAsBytes());
      expect(sfVerifyDoc.pages.count, 5);

      const pageDescs = [
        'Page 0 (Rot 0°)',
        'Page 1 (Rot 90°)',
        'Page 2 (Rot 180°)',
        'Page 3 (Rot 270°)',
        'Page 4 (CropBox [50,50,550,750])',
      ];

      for (var i = 0; i < 5; i++) {
        final page = rxDoc.pages[i];
        final desc = pageDescs[i];

        final img = await page.render(
          width: page.width.round(),
          height: page.height.round(),
        );
        expect(img, isNotNull);

        int redMinX = 9999, redMaxX = -1, redMinY = 9999, redMaxY = -1, redCount = 0;
        int blueMinX = 9999, blueMaxX = -1, blueMinY = 9999, blueMaxY = -1, blueCount = 0;
        int magMinX = 9999, magMaxX = -1, magMinY = 9999, magMaxY = -1, magCount = 0;
        int cyanMinX = 9999, cyanMaxX = -1, cyanMinY = 9999, cyanMaxY = -1, cyanCount = 0;

        for (var y = 0; y < img!.height; y++) {
          for (var x = 0; x < img.width; x++) {
            final idx = (y * img.width + x) * 4;
            final b = img.pixels[idx];
            final g = img.pixels[idx + 1];
            final r = img.pixels[idx + 2];

            // Pure Red: r > 180, g < 80, b < 80 (Strokes)
            if (r > 180 && g < 80 && b < 80) {
              redCount++;
              if (x < redMinX) redMinX = x;
              if (x > redMaxX) redMaxX = x;
              if (y < redMinY) redMinY = y;
              if (y > redMaxY) redMaxY = y;
            }

            // Pure Blue: b > 180, r < 80, g < 80 (Signatures)
            if (b > 180 && r < 80 && g < 80) {
              blueCount++;
              if (x < blueMinX) blueMinX = x;
              if (x > blueMaxX) blueMaxX = x;
              if (y < blueMinY) blueMinY = y;
              if (y > blueMaxY) blueMaxY = y;
            }

            // Pure Magenta: r > 180, g < 80, b > 180 (Latin Text)
            if (r > 180 && g < 80 && b > 180) {
              magCount++;
              if (x < magMinX) magMinX = x;
              if (x > magMaxX) magMaxX = x;
              if (y < magMinY) magMinY = y;
              if (y > magMaxY) magMaxY = y;
            }

            // Pure Cyan: r < 80, g > 180, b > 180 (Raster Non-Latin Text)
            if (r < 80 && g > 180 && b > 180) {
              cyanCount++;
              if (x < cyanMinX) cyanMinX = x;
              if (x > cyanMaxX) cyanMaxX = x;
              if (y < cyanMinY) cyanMinY = y;
              if (y > cyanMaxY) cyanMaxY = y;
            }
          }
        }

        // --- STROKE VERIFICATION ---
        expect(redCount > 0, isTrue, reason: '$desc: red strokes must be rendered');
        expect(redCount > 0, isTrue, reason: 'Broken rotation must render red pixels');
      final expStroke = const Rect.fromLTRB(98, 198, 201, 281);
        final measStroke = Rect.fromLTRB(
          redMinX.toDouble(),
          redMinY.toDouble(),
          redMaxX.toDouble(),
          redMaxY.toDouble(),
        );
        final strokeOverlap = computeOverlapPercent(expStroke, measStroke);
        final strokeOffset = computeOffset(expStroke, measStroke);

        print(
          '$desc [Stroke]     | Exp: $expStroke | Meas: $measStroke | Overlap: ${strokeOverlap.toStringAsFixed(1)}% | Offset: ${strokeOffset.toStringAsFixed(2)} px',
        );

        expect(strokeOffset <= 2.0, isTrue, reason: '$desc: stroke offset $strokeOffset <= 2.0px');
        expect(strokeOverlap >= 85.0, isTrue, reason: '$desc: stroke IoU >= 0.85');

        // --- SIGNATURE VERIFICATION ---
        expect(blueCount > 0, isTrue, reason: '$desc: blue signature must be rendered');
        final expSig = const Rect.fromLTRB(99, 319, 180, 360);
        final measSig = Rect.fromLTRB(
          blueMinX.toDouble(),
          blueMinY.toDouble(),
          blueMaxX.toDouble(),
          blueMaxY.toDouble(),
        );
        final sigOverlap = computeOverlapPercent(expSig, measSig);
        final sigOffset = computeOffset(expSig, measSig);

        print(
          '$desc [Signature]  | Exp: $expSig | Meas: $measSig | Overlap: ${sigOverlap.toStringAsFixed(1)}% | Offset: ${sigOffset.toStringAsFixed(2)} px',
        );

        expect(sigOffset <= 2.0, isTrue, reason: '$desc: signature offset $sigOffset <= 2.0px');
        expect(sigOverlap >= 85.0, isTrue, reason: '$desc: signature IoU >= 0.85');

        // --- (a) LATIN TEXT VERIFICATION (Ink Bounding Box Comparison) ---
        expect(magCount > 0, isTrue, reason: '$desc: magenta Latin text must be rendered');
        final structText = await page.loadStructuredText();
        expect(
          structText.fullText.contains('LATIN PROOF'),
          isTrue,
          reason: '$desc: Extracted text must contain "LATIN PROOF"',
        );

        // Preview TextPainter ink bounding box for "LATIN PROOF" at (100, 400)
        final expLatinInk = const Rect.fromLTRB(101.0, 403.0, 192.0, 412.0);
        final measLatinInk = Rect.fromLTRB(
          magMinX.toDouble(),
          magMinY.toDouble(),
          magMaxX.toDouble(),
          magMaxY.toDouble(),
        );
        final latinOverlap = computeOverlapPercent(expLatinInk, measLatinInk);
        final latinOffset = computeOffset(expLatinInk, measLatinInk);

        print(
          '$desc [Latin Text] | Exp Ink: $expLatinInk | Meas Ink: $measLatinInk | Overlap: ${latinOverlap.toStringAsFixed(1)}% | Edge Offset: ${latinOffset.toStringAsFixed(2)} px | Text: "LATIN PROOF"',
        );

        expect(latinOffset <= 2.0, isTrue, reason: '$desc: Latin text ink edge offset $latinOffset <= 2.0px');
        expect(latinOverlap >= 85.0, isTrue, reason: '$desc: Latin text ink IoU $latinOverlap >= 85.0%');

        // --- (b) RASTER NON-LATIN TEXT VERIFICATION ---
        expect(cyanCount > 0, isTrue, reason: '$desc: cyan raster non-Latin text must be rendered');
        final pHelper = sf_page.PdfPageHelper.getHelper(sfVerifyDoc.pages[i]);
        final res = pHelper.dictionary![sf_prim.PdfName('Resources')] as sf_prim.PdfDictionary?;
        final xobj = res?[sf_prim.PdfName('XObject')] as sf_prim.PdfDictionary?;
        expect(
          xobj != null && (xobj.items?.isNotEmpty ?? false),
          isTrue,
          reason: '$desc: must contain image XObject in resources',
        );

        final expRaster = const Rect.fromLTRB(100.0, 460.0, 249.0, 499.0);
        final measRaster = Rect.fromLTRB(
          cyanMinX.toDouble(),
          cyanMinY.toDouble(),
          cyanMaxX.toDouble(),
          cyanMaxY.toDouble(),
        );
        final rasterOverlap = computeOverlapPercent(expRaster, measRaster);
        final rasterOffset = computeOffset(expRaster, measRaster);

        print(
          '$desc [Raster]     | Exp: $expRaster | Meas: $measRaster | Overlap: ${rasterOverlap.toStringAsFixed(1)}% | Offset: ${rasterOffset.toStringAsFixed(2)} px | ImageObj: true',
        );

        expect(rasterOffset <= 2.0, isTrue, reason: '$desc: raster offset $rasterOffset <= 2.0px');
        expect(rasterOverlap >= 85.0, isTrue, reason: '$desc: raster IoU >= 0.85');

        img.dispose();
      }

      rxDoc.dispose();
      sfVerifyDoc.dispose();
    },
  );

  test(
    'NEGATIVE CONTROL: deliberately broken 90-degree transform fails threshold',
    () async {
      // 1. Create a 90-degree rotated page
      final doc = sf.PdfDocument();
      doc.pages.add();
      final rawBytes = doc.saveSync();
      doc.dispose();

      final loadedDoc = sf.PdfDocument(inputBytes: rawBytes);
      loadedDoc.pages[0].rotation = sf.PdfPageRotateAngle.rotateAngle90;
      final rotatedBytes = loadedDoc.saveSync();
      loadedDoc.dispose();

      final basePath = '${tempDir.path}/broken_rot_base.pdf';
      await File(basePath).writeAsBytes(rotatedBytes);

      // 2. Deliberately bypass rotation coordinate transform (draw without rotation compensation)
      // Directly drawing at un-rotated [100, 200, 200, 280] on a 90° rotated page causes
      // the rendered pixels to land in the top-right / orthogonal orientation
      final brokenDoc = sf.PdfDocument(inputBytes: rotatedBytes);
      final page = brokenDoc.pages[0];
      final pen = sf.PdfPen(sf.PdfColor(255, 0, 0), width: 4.0);
      // Drawing directly to raw uncompensated coordinates:
      page.graphics.drawLine(pen, const Offset(100, 200), const Offset(200, 200));
      page.graphics.drawLine(pen, const Offset(100, 200), const Offset(100, 280));
      final brokenBytes = brokenDoc.saveSync();
      brokenDoc.dispose();

      final brokenPath = '${tempDir.path}/broken_rot_output.pdf';
      await File(brokenPath).writeAsBytes(brokenBytes);

      // 3. Render and measure in pdfrx
      final rxDoc = await rx.PdfDocument.openFile(brokenPath);
      final rxPage = rxDoc.pages[0];
      final img = await rxPage.render(
        width: rxPage.width.round(),
        height: rxPage.height.round(),
      );
      expect(img, isNotNull);

      int redMinX = 9999, redMaxX = -1, redMinY = 9999, redMaxY = -1, redCount = 0;
      for (var y = 0; y < img!.height; y++) {
        for (var x = 0; x < img.width; x++) {
          final idx = (y * img.width + x) * 4;
          final b = img.pixels[idx];
          final g = img.pixels[idx + 1];
          final r = img.pixels[idx + 2];
          if (r > 180 && g < 80 && b < 80) {
            redCount++;
            if (x < redMinX) redMinX = x;
            if (x > redMaxX) redMaxX = x;
            if (y < redMinY) redMinY = y;
            if (y > redMaxY) redMaxY = y;
          }
        }
      }

      expect(redCount > 0, isTrue, reason: 'Broken rotation must render red pixels');
      final expStroke = const Rect.fromLTRB(98, 198, 201, 281);
      final measStroke = Rect.fromLTRB(
        redMinX.toDouble(),
        redMinY.toDouble(),
        redMaxX.toDouble(),
        redMaxY.toDouble(),
      );
      final overlap = computeOverlapPercent(expStroke, measStroke);
      final offset = computeOffset(expStroke, measStroke);

      print(
        'NEGATIVE CONTROL RESULT: Exp: $expStroke | Meas: $measStroke | Overlap: ${overlap.toStringAsFixed(1)}% | Offset: ${offset.toStringAsFixed(2)} px',
      );

      // Assert that negative control FAILS the pass thresholds:
      // (Overlap must be < 50%, and edge offset must be > 20px)
      expect(overlap, lessThan(50.0), reason: 'Deliberately broken transform MUST fail overlap threshold');
      expect(offset, greaterThan(20.0), reason: 'Deliberately broken transform MUST fail offset threshold');
      print('NEGATIVE CONTROL VERIFIED: Broken 90-degree transform correctly rejected by pixel validator.');

      img.dispose();
      rxDoc.dispose();
    },
  );
}
