import 'dart:io';
import 'dart:ui';

import 'package:docview/data/models/ink_stroke.dart';
import 'package:docview/data/models/placed_signature.dart';
import 'package:docview/data/services/pdf/pdf_annotation_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdfrx/pdfrx.dart' as rx;
import 'package:syncfusion_flutter_pdf/pdf.dart' as sf;
import 'package:syncfusion_flutter_pdf/src/pdf/implementation/pages/pdf_page.dart' as sf_page;
import 'package:syncfusion_flutter_pdf/src/pdf/implementation/primitives/pdf_array.dart' as sf_prim;
import 'package:syncfusion_flutter_pdf/src/pdf/implementation/primitives/pdf_name.dart' as sf_prim;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;
  late PdfAnnotationService service;

  setUp(() {
    tempDir = Directory.systemTemp.createTempSync('pdf_ink_sign_test_');
    service = const PdfAnnotationService();
  });

  tearDown(() {
    try {
      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
      }
    } catch (_) {}
  });

  /// Creates a 5-page PDF with 0°, 90°, 180°, 270° and CropBox pages.
  Future<File> create5PagePdf() async {
    final doc = sf.PdfDocument();
    final font = sf.PdfStandardFont(sf.PdfFontFamily.helvetica, 16);

    for (var i = 0; i < 5; i++) {
      final p = doc.pages.add();
      p.graphics.drawString('Page ${i + 1} Visual Content', font,
          bounds: const Rect.fromLTWH(100, 100, 300, 25));
    }

    final rawBytes = doc.saveSync();
    doc.dispose();

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

    final file = File('${tempDir.path}/base_5pages.pdf');
    await file.writeAsBytes(rotatedBytes);
    return file;
  }

  test('PdfAnnotationService saves ink strokes and signatures across 5 pages with transform', () async {
    final baseFile = await create5PagePdf();
    final outputFile = File('${tempDir.path}/annotated_with_ink_and_sign.pdf');

    final strokes = <InkStroke>[];
    final signatures = <PlacedSignature>[];

    for (var i = 0; i < 5; i++) {
      // Add a stroke on each page
      strokes.add(
        InkStroke(
          id: 'stroke_$i',
          pageIndex: i,
          points: const [
            Offset(120, 150),
            Offset(140, 160),
            Offset(160, 150),
          ],
          colorValue: 0xFF2196F3, // Blue
          strokeWidth: 3.0,
          timestampMs: 1000 + i,
        ),
      );

      // Add a tap dot on each page
      strokes.add(
        InkStroke(
          id: 'dot_$i',
          pageIndex: i,
          points: const [Offset(200, 200)],
          colorValue: 0xFFE91E63, // Pink dot
          strokeWidth: 6.0,
          isDot: true,
          timestampMs: 2000 + i,
        ),
      );

      // Add a vector signature on each page
      signatures.add(
        PlacedSignature(
          id: 'sig_$i',
          pageIndex: i,
          bounds: const Rect.fromLTWH(220, 250, 120, 40),
          normalizedStrokes: const [
            [Offset(0.1, 0.5), Offset(0.9, 0.5)],
          ],
          timestampMs: 3000 + i,
        ),
      );
    }

    final saved = await service.saveAnnotations(
      sourcePath: baseFile.path,
      outputPath: outputFile.path,
      strokes: strokes,
      signatures: signatures,
    );

    expect(await saved.exists(), isTrue);

    // Verify output with pdfrx
    final rxDoc = await rx.PdfDocument.openFile(saved.path);
    expect(rxDoc.pages.length, 5);

    // Each page rendered successfully without error
    for (var i = 0; i < 5; i++) {
      final page = rxDoc.pages[i];
      expect(page.width, greaterThan(0));
      expect(page.height, greaterThan(0));
    }
    rxDoc.dispose();
  });

  test('PdfAnnotationService preserves existing elements when adding strokes and signatures', () async {
    final doc = sf.PdfDocument();
    final page = doc.pages.add();
    final font = sf.PdfStandardFont(sf.PdfFontFamily.helvetica, 14);
    page.graphics.drawString('Initial Text', font, bounds: const Rect.fromLTWH(50, 50, 200, 20));

    final bookmark = doc.bookmarks.add('Chapter 1');
    bookmark.destination = sf.PdfDestination(doc.pages[0], const Offset(0, 0));

    final textBox = sf.PdfTextBoxField(
      doc.pages[0],
      'user_field',
      const Rect.fromLTWH(50, 100, 150, 25),
      text: 'Existing Data',
    );
    doc.form.fields.add(textBox);

    final baseFile = File('${tempDir.path}/preservation_base.pdf');
    await baseFile.writeAsBytes(doc.saveSync());
    doc.dispose();

    final outputFile = File('${tempDir.path}/preservation_output.pdf');

    await service.saveAnnotations(
      sourcePath: baseFile.path,
      outputPath: outputFile.path,
      strokes: [
        InkStroke(
          id: 's1',
          pageIndex: 0,
          points: const [Offset(60, 200), Offset(100, 220)],
          timestampMs: 100,
        ),
      ],
      signatures: [
        PlacedSignature(
          id: 'sig1',
          pageIndex: 0,
          bounds: const Rect.fromLTWH(60, 240, 100, 40),
          normalizedStrokes: const [
            [Offset(0.1, 0.5), Offset(0.9, 0.5)],
          ],
          timestampMs: 200,
        ),
      ],
    );

    // Verify preservation
    final verifyDoc = sf.PdfDocument(inputBytes: outputFile.readAsBytesSync());
    expect(verifyDoc.pages.count, 1);
    expect(verifyDoc.bookmarks.count, 1);
    expect(verifyDoc.bookmarks[0].title, 'Chapter 1');
    expect(verifyDoc.form.fields.count, 1);
    expect((verifyDoc.form.fields[0] as sf.PdfTextBoxField).text, 'Existing Data');
    verifyDoc.dispose();
  });
}
