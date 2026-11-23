import 'dart:io';
import 'dart:ui';

import 'package:docview/data/models/ink_stroke.dart';
import 'package:docview/data/models/placed_signature.dart';
import 'package:docview/data/services/pdf/pdf_annotation_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdfrx/pdfrx.dart' as rx;
import 'package:syncfusion_flutter_pdf/pdf.dart' as sf;
import 'package:syncfusion_flutter_pdf/src/pdf/implementation/pages/pdf_page.dart'
    as sf_page;
import 'package:syncfusion_flutter_pdf/src/pdf/implementation/primitives/pdf_array.dart'
    as sf_prim;
import 'package:syncfusion_flutter_pdf/src/pdf/implementation/primitives/pdf_name.dart'
    as sf_prim;

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
    'automated pixel test for ink strokes and vector signatures across 5 transformed pages',
    () async {
      // Create base 5-page PDF
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

      // Reload and apply rotations & cropbox
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

      // Prepare test strokes and signatures for each page at known visual coordinates
      // Red strokes: horizontal line from (100, 200) to (200, 200), vertical line from (100, 200) to (100, 280)
      // Blue signature: diagonal strokes inside Rect.fromLTWH(100, 320, 80, 40)
      final strokes = <InkStroke>[];
      final signatures = <PlacedSignature>[];

      for (var i = 0; i < 5; i++) {
        // Horizontal red stroke
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
        // Vertical red stroke
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

        // Blue vector signature: diagonal cross
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
      }

      final outPath = '${tempDir.path}/annotated_pixel_proof.pdf';
      final savedFile = await service.saveAnnotations(
        sourcePath: basePath,
        outputPath: outPath,
        strokes: strokes,
        signatures: signatures,
      );

      expect(await savedFile.exists(), isTrue);

      // Verify rendered pixels with pdfrx on all 5 pages
      final rxDoc = await rx.PdfDocument.openFile(outPath);
      expect(rxDoc.pages.length, 5);

      for (var i = 0; i < 5; i++) {
        final page = rxDoc.pages[i];
        final img = await page.render(
          width: page.width.round(),
          height: page.height.round(),
        );
        expect(img, isNotNull);

        int redMinX = 9999,
            redMaxX = -1,
            redMinY = 9999,
            redMaxY = -1,
            redCount = 0;
        int blueMinX = 9999,
            blueMaxX = -1,
            blueMinY = 9999,
            blueMaxY = -1,
            blueCount = 0;

        for (var y = 0; y < img!.height; y++) {
          for (var x = 0; x < img.width; x++) {
            final idx = (y * img.width + x) * 4;
            final b = img.pixels[idx];
            final g = img.pixels[idx + 1];
            final r = img.pixels[idx + 2];

            // Pure Red detection (r > 180, g < 80, b < 80)
            if (r > 180 && g < 80 && b < 80) {
              redCount++;
              if (x < redMinX) redMinX = x;
              if (x > redMaxX) redMaxX = x;
              if (y < redMinY) redMinY = y;
              if (y > redMaxY) redMaxY = y;
            }

            // Pure Blue detection (b > 180, r < 80, g < 80)
            if (b > 180 && r < 80 && g < 80) {
              blueCount++;
              if (x < blueMinX) blueMinX = x;
              if (x > blueMaxX) blueMaxX = x;
              if (y < blueMinY) blueMinY = y;
              if (y > blueMaxY) blueMaxY = y;
            }
          }
        }

        // Check red stroke presence and coordinates
        expect(
          redCount > 0,
          isTrue,
          reason: 'Page $i must have rendered red strokes',
        );
        // Stroke width is 4.0 (radius 2.0). Bounding box of points (100,200)->(200,200) and (100,200)->(100,280)
        // Visual expected: left ~ 98..102, right ~ 198..202, top ~ 198..202, bottom ~ 278..282
        expect(
          (redMinX - 100).abs() <= 2.5,
          isTrue,
          reason: 'Page $i: Red stroke minX=$redMinX, expected near 100',
        );
        expect(
          (redMaxX - 200).abs() <= 2.5,
          isTrue,
          reason: 'Page $i: Red stroke maxX=$redMaxX, expected near 200',
        );
        expect(
          (redMinY - 200).abs() <= 2.5,
          isTrue,
          reason: 'Page $i: Red stroke minY=$redMinY, expected near 200',
        );
        expect(
          (redMaxY - 280).abs() <= 2.5,
          isTrue,
          reason: 'Page $i: Red stroke maxY=$redMaxY, expected near 280',
        );

        // Check blue signature presence and coordinates
        // Bounds: Rect.fromLTWH(100, 320, 80, 40) => [100..180, 320..360]
        expect(
          blueCount > 0,
          isTrue,
          reason: 'Page $i must have rendered blue vector signature',
        );
        expect(
          (blueMinX - 100).abs() <= 2.5,
          isTrue,
          reason: 'Page $i: Blue signature minX=$blueMinX, expected near 100',
        );
        expect(
          (blueMaxX - 180).abs() <= 2.5,
          isTrue,
          reason: 'Page $i: Blue signature maxX=$blueMaxX, expected near 180',
        );
        expect(
          (blueMinY - 320).abs() <= 2.5,
          isTrue,
          reason: 'Page $i: Blue signature minY=$blueMinY, expected near 320',
        );
        expect(
          (blueMaxY - 360).abs() <= 2.5,
          isTrue,
          reason: 'Page $i: Blue signature maxY=$blueMaxY, expected near 360',
        );

        img.dispose();
      }

      rxDoc.dispose();
    },
  );
}
