// ignore_for_file: avoid_print
import 'dart:io';
import 'dart:math' as math;
import 'dart:ui';

import 'package:docview/data/models/ink_stroke.dart';
import 'package:docview/data/models/pdf_text_box.dart';
import 'package:docview/data/models/placed_signature.dart';
import 'package:docview/data/services/pdf/pdf_annotation_service.dart';
import 'package:docview/data/services/pdf/text_layout_engine.dart';
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
                width: 86.0,
                height: 17.5,
                baseline: 14.0,
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
        final expStroke = const Rect.fromLTRB(100, 200, 200, 280);
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

        expect(strokeOffset <= 2.5, isTrue, reason: '$desc: stroke offset $strokeOffset <= 2.5px');

        // --- SIGNATURE VERIFICATION ---
        expect(blueCount > 0, isTrue, reason: '$desc: blue signature must be rendered');
        final expSig = const Rect.fromLTRB(100, 320, 180, 360);
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

        expect(sigOffset <= 2.5, isTrue, reason: '$desc: signature offset $sigOffset <= 2.5px');

        // --- (a) LATIN TEXT VERIFICATION ---
        expect(magCount > 0, isTrue, reason: '$desc: magenta Latin text must be rendered');
        // pdfrx text extraction check
        final structText = await page.loadStructuredText();
        expect(
          structText.fullText.contains('LATIN PROOF'),
          isTrue,
          reason: '$desc: Extracted text must contain "LATIN PROOF"',
        );

        // Measured glyph bounds (baseline y=400+14*0.82=411.5, glyphs span ~86px width, ~11px height)
        final measLatin = Rect.fromLTRB(
          magMinX.toDouble(),
          magMinY.toDouble(),
          magMaxX.toDouble(),
          magMaxY.toDouble(),
        );
        final expLatin = const Rect.fromLTRB(100, 400, 186, 414);
        final latinOverlap = computeOverlapPercent(expLatin, measLatin);
        final latinOffset = (magMinX - 100).abs().toDouble();

        print(
          '$desc [Latin Text] | Exp: $expLatin | Meas: $measLatin | Overlap: ${latinOverlap.toStringAsFixed(1)}% | Offset: ${latinOffset.toStringAsFixed(2)} px | Text: "LATIN PROOF"',
        );

        // Must be upright: left near 100, top near 400..403, right near 185, bottom near 412..414
        expect(latinOffset <= 2.0, isTrue, reason: '$desc: Latin text minX offset $latinOffset <= 2.0px');
        expect(
          (magMinY - 400).abs() <= 3.0,
          isTrue,
          reason: '$desc: Latin text minY offset <= 3.0px (upright)',
        );
        expect(
          measLatin.width > 70.0 && measLatin.height < 25.0,
          isTrue,
          reason: '$desc: Latin text must be horizontally upright',
        );

        // --- (b) RASTER NON-LATIN TEXT VERIFICATION ---
        expect(cyanCount > 0, isTrue, reason: '$desc: cyan raster non-Latin text must be rendered');
        // Verify image object exists in PDF on this page
        final pHelper = sf_page.PdfPageHelper.getHelper(sfVerifyDoc.pages[i]);
        final res = pHelper.dictionary![sf_prim.PdfName('Resources')] as sf_prim.PdfDictionary?;
        final xobj = res?[sf_prim.PdfName('XObject')] as sf_prim.PdfDictionary?;
        expect(
          xobj != null && (xobj.items?.isNotEmpty ?? false),
          isTrue,
          reason: '$desc: must contain image XObject in resources',
        );

        final expRaster = const Rect.fromLTWH(100, 460, 150, 40);
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

        expect(rasterOffset <= 2.5, isTrue, reason: '$desc: raster offset $rasterOffset <= 2.5px');
        expect(
          measRaster.width > 140.0 && measRaster.height > 35.0,
          isTrue,
          reason: '$desc: raster text image must be upright with expected dimensions',
        );

        img.dispose();
      }

      rxDoc.dispose();
      sfVerifyDoc.dispose();
    },
  );
}
