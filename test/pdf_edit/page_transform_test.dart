import 'dart:io';
import 'dart:ui';

import 'package:docview/data/services/pdf/pdf_coordinate_transform.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdfrx/pdfrx.dart' as rx;
import 'package:syncfusion_flutter_pdf/pdf.dart' as sf;
import 'package:syncfusion_flutter_pdf/src/pdf/implementation/pages/pdf_page.dart' as sf_page;
import 'package:syncfusion_flutter_pdf/src/pdf/implementation/primitives/pdf_array.dart' as sf_prim;
import 'package:syncfusion_flutter_pdf/src/pdf/implementation/primitives/pdf_name.dart' as sf_prim;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;

  setUp(() {
    tempDir = Directory.systemTemp.createTempSync('pdf_coord_test_');
  });

  tearDown(() {
    try {
      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
      }
    } catch (_) {}
  });

  test('coordinate transform accuracy on 5 pages with render pixel verification and round-trip', () async {
    final pdfDoc = sf.PdfDocument();
    final font = sf.PdfStandardFont(sf.PdfFontFamily.helvetica, 16);

    for (var i = 0; i < 5; i++) {
      final p = pdfDoc.pages.add();
      p.graphics.drawString('Line 1: Hello Flutter PDF Editing', font,
          bounds: const Rect.fromLTWH(100, 100, 300, 25));
      p.graphics.drawString('Line 2: Precision Annotation Proof', font,
          bounds: const Rect.fromLTWH(100, 140, 300, 25));
    }

    final rawBytes = pdfDoc.saveSync();
    pdfDoc.dispose();

    // Reload and apply rotations/cropbox
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

    final testPdfFile = File('${tempDir.path}/base_rotated.pdf');
    await testPdfFile.writeAsBytes(rotatedBytes);

    // 1. Open with pdfrx to extract text line visual rectangles
    final rxDoc = await rx.PdfDocument.openFile(testPdfFile.path);
    expect(rxDoc.pages.length, 5);

    final pageVisualLines = <int, List<Rect>>{};
    for (var i = 0; i < 5; i++) {
      final page = rxDoc.pages[i];
      final st = await page.loadStructuredText();
      final l1Frags = st.fragments.where((f) => f.text.contains('Line 1') || f.text.contains('Hello') || f.text.contains('Flutter') || f.text.contains('PDF') || f.text.contains('Editing'));
      final l2Frags = st.fragments.where((f) => f.text.contains('Line 2') || f.text.contains('Precision') || f.text.contains('Annotation') || f.text.contains('Proof'));

      final l1Bounds = l1Frags.map((f) => f.bounds).reduce((a, b) => a.merge(b));
      final l2Bounds = l2Frags.map((f) => f.bounds).reduce((a, b) => a.merge(b));

      final l1Visual = l1Bounds.toRect(page: page);
      final l2Visual = l2Bounds.toRect(page: page);

      pageVisualLines[i] = [l1Visual, l2Visual];
    }
    rxDoc.dispose();

    // 2. Open with Syncfusion, apply highlight annotation across both lines using PdfCoordinateTransform
    final editDoc = sf.PdfDocument(inputBytes: rotatedBytes);
    for (var i = 0; i < 5; i++) {
      final page = editDoc.pages[i];
      final visualLines = pageVisualLines[i]!;
      final rotDegrees = i == 1 ? 90 : (i == 2 ? 180 : (i == 3 ? 270 : 0));
      final visualWidth = (rotDegrees == 90 || rotDegrees == 270) ? page.size.height : page.size.width;
      final visualHeight = (rotDegrees == 90 || rotDegrees == 270) ? page.size.width : page.size.height;

      final crop = i == 4 ? const Rect.fromLTWH(50, 50, 500, 700) : null;

      final syncLines = visualLines.map((v) {
        final syncRect = PdfCoordinateTransform.visualToSyncfusionRect(
          visualRect: v,
          visualWidth: visualWidth,
          visualHeight: visualHeight,
          rotationDegrees: rotDegrees,
          cropBox: crop,
        );

        // Verify round-trip back to visual
        final roundTrip = PdfCoordinateTransform.syncfusionToVisualRect(
          syncfusionRect: syncRect,
          visualWidth: visualWidth,
          visualHeight: visualHeight,
          rotationDegrees: rotDegrees,
          cropBox: crop,
        );
        expect((roundTrip.left - v.left).abs() < 0.001, isTrue);
        expect((roundTrip.top - v.top).abs() < 0.001, isTrue);
        expect((roundTrip.width - v.width).abs() < 0.001, isTrue);
        expect((roundTrip.height - v.height).abs() < 0.001, isTrue);

        return syncRect;
      }).toList();

      final unionSyncRect = syncLines.reduce((a, b) => a.expandToInclude(b));

      final markup = sf.PdfTextMarkupAnnotation(
        unionSyncRect,
        'Highlight Proof',
        sf.PdfColor(255, 255, 0),
        boundsCollection: syncLines,
        textMarkupAnnotationType: sf.PdfTextMarkupAnnotationType.highlight,
      );
      page.annotations.add(markup);
    }

    final annotatedBytes = editDoc.saveSync();
    editDoc.dispose();

    final annotatedFile = File('${tempDir.path}/annotated_5pages.pdf');
    await annotatedFile.writeAsBytes(annotatedBytes);

    // Also copy to persistent docs location for second viewer inspection if needed
    final exportDir = Directory('docs/redesign/evidence');
    if (!exportDir.existsSync()) exportDir.createSync(recursive: true);
    await annotatedFile.copy('docs/redesign/evidence/annotated_5pages.pdf');

    // 3. Open annotated file in pdfrx, render each page, sample pixels and verify highlight overlap!
    final rxAnnotated = await rx.PdfDocument.openFile(annotatedFile.path);
    for (var i = 0; i < 5; i++) {
      final page = rxAnnotated.pages[i];
      final img = await page.render(
        width: page.width.round(),
        height: page.height.round(),
      );
      expect(img, isNotNull);

      int minX = 9999, maxX = -1, minY = 9999, maxY = -1, yellowCount = 0;
      for (var y = 0; y < img!.height; y++) {
        for (var x = 0; x < img.width; x++) {
          final idx = (y * img.width + x) * 4;
          final b = img.pixels[idx];
          final g = img.pixels[idx + 1];
          final r = img.pixels[idx + 2];
          if (b < 100 && r > 100 && g > 100) {
            yellowCount++;
            if (x < minX) minX = x;
            if (x > maxX) maxX = x;
            if (y < minY) minY = y;
            if (y > maxY) maxY = y;
          }
        }
      }

      final visualLines = pageVisualLines[i]!;
      final textUnion = visualLines.reduce((a, b) => a.expandToInclude(b));
      expect(yellowCount > 0, isTrue, reason: 'Page $i should have detected highlight pixels');

      final highlightRect = Rect.fromLTRB(minX.toDouble(), minY.toDouble(), maxX.toDouble(), maxY.toDouble());

      // Verify bounds match within 2 px
      expect((highlightRect.left - textUnion.left).abs() <= 2.0, isTrue,
          reason: 'Page $i Left mismatch: highlight=${highlightRect.left}, text=${textUnion.left}');
      expect((highlightRect.top - textUnion.top).abs() <= 2.0, isTrue,
          reason: 'Page $i Top mismatch: highlight=${highlightRect.top}, text=${textUnion.top}');
      expect((highlightRect.right - textUnion.right).abs() <= 2.0, isTrue,
          reason: 'Page $i Right mismatch: highlight=${highlightRect.right}, text=${textUnion.right}');
      expect((highlightRect.bottom - textUnion.bottom).abs() <= 2.0, isTrue,
          reason: 'Page $i Bottom mismatch: highlight=${highlightRect.bottom}, text=${textUnion.bottom}');

      img.dispose();
    }
    rxAnnotated.dispose();
  });
}
