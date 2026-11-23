import 'dart:io';
import 'dart:ui';

import 'package:docview/core/errors/app_errors.dart';
import 'package:docview/data/models/ink_stroke.dart';
import 'package:docview/data/models/pdf_markup.dart';
import 'package:docview/data/services/pdf/pdf_annotation_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdfrx/pdfrx.dart' as rx;
import 'package:syncfusion_flutter_pdf/pdf.dart' as sf;
import 'package:syncfusion_flutter_pdf/src/pdf/implementation/forms/pdf_signature_field.dart' as sf_sig;
import 'package:syncfusion_flutter_pdf/src/pdf/implementation/primitives/pdf_dictionary.dart' as sf_prim;
import 'package:syncfusion_flutter_pdf/src/pdf/implementation/primitives/pdf_name.dart' as sf_prim;
import 'package:syncfusion_flutter_pdf/src/pdf/implementation/primitives/pdf_string.dart' as sf_prim;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;
  late PdfAnnotationService service;

  setUp(() {
    tempDir = Directory.systemTemp.createTempSync('pdf_annot_service_test_');
    service = const PdfAnnotationService();
  });

  tearDown(() {
    try {
      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
      }
    } catch (_) {}
  });

  /// Helper to create a test PDF with text, bookmarks, and form fields.
  Future<File> createSamplePdf({
    int pageCount = 3,
    bool addBookmark = true,
    bool addFormField = true,
  }) async {
    final doc = sf.PdfDocument();
    final font = sf.PdfStandardFont(sf.PdfFontFamily.helvetica, 14);

    for (var i = 0; i < pageCount; i++) {
      final page = doc.pages.add();
      page.graphics.drawString(
        'Page ${i + 1} Sample Content for Annotation Testing',
        font,
        bounds: const Rect.fromLTWH(50, 50, 400, 30),
      );
    }

    if (addBookmark) {
      final bookmark = doc.bookmarks.add('Chapter 1');
      bookmark.destination = sf.PdfDestination(doc.pages[0], const Offset(0, 0));
    }

    if (addFormField) {
      final textBox = sf.PdfTextBoxField(
        doc.pages[0],
        'user_name',
        const Rect.fromLTWH(50, 100, 200, 30),
        text: 'Initial Text Value',
      );
      doc.form.fields.add(textBox);
    }

    final bytes = doc.saveSync();
    doc.dispose();

    final file = File('${tempDir.path}/sample.pdf');
    await file.writeAsBytes(bytes);
    return file;
  }

  group('PdfAnnotationService - Inspection Tests', () {
    test('getDocumentInfo returns accurate page count and properties', () async {
      final file = await createSamplePdf(pageCount: 3);

      final info = await service.getDocumentInfo(file.path);

      expect(info.pageCount, 3);
      expect(info.isEncrypted, isFalse);
      expect(info.hasDigitalSignature, isFalse);
      expect(info.pageRotations, [0, 0, 0]);
      expect(info.pageSizes.length, 3);
      expect(info.pageSizes[0].width, greaterThan(0));
      expect(info.pageSizes[0].height, greaterThan(0));
    });

    test('getDocumentInfo throws sourceFileNotFound if file does not exist', () async {
      final missingPath = '${tempDir.path}/non_existent.pdf';

      expect(
        () => service.getDocumentInfo(missingPath),
        throwsA(isA<PdfAnnotationException>().having(
          (e) => e.reason,
          'reason',
          PdfAnnotationErrorReason.sourceFileNotFound,
        )),
      );
    });
  });

  group('PdfAnnotationService - Saving & Preservation Tests', () {
    test('saveAnnotations applies highlight, underline, and strikethrough', () async {
      final file = await createSamplePdf(pageCount: 2);
      final outputPath = '${tempDir.path}/annotated.pdf';

      final markups = [
        TextMarkup(
          id: 'm1',
          pageIndex: 0,
          type: TextMarkupType.highlight,
          colorValue: 0xFFFFEB3B, // Yellow
          lineRects: const [Rect.fromLTWH(50, 50, 200, 20)],
          text: 'Highlighted text',
          createdAtMs: 1000,
        ),
        TextMarkup(
          id: 'm2',
          pageIndex: 0,
          type: TextMarkupType.underline,
          colorValue: 0xFF2196F3, // Blue
          lineRects: const [Rect.fromLTWH(50, 80, 200, 20)],
          text: 'Underlined text',
          createdAtMs: 1001,
        ),
        TextMarkup(
          id: 'm3',
          pageIndex: 1,
          type: TextMarkupType.strikethrough,
          colorValue: 0xFFE91E63, // Pink
          lineRects: const [Rect.fromLTWH(50, 50, 150, 20)],
          text: 'Struck text',
          createdAtMs: 1002,
        ),
      ];

      final outputFile = await service.saveAnnotations(
        sourcePath: file.path,
        outputPath: outputPath,
        markups: markups,
      );

      expect(outputFile.existsSync(), isTrue);
      // Ensure no leftover .tmp file exists
      expect(File('$outputPath.tmp').existsSync(), isFalse);

      // Verify with Syncfusion reader
      final verifyDoc = sf.PdfDocument(inputBytes: outputFile.readAsBytesSync());
      expect(verifyDoc.pages.count, 2);
      expect(verifyDoc.pages[0].annotations.count, 2);
      expect(verifyDoc.pages[1].annotations.count, 1);

      final a1 = verifyDoc.pages[0].annotations[0];
      expect(a1, isA<sf.PdfTextMarkupAnnotation>());
      final t1 = a1 as sf.PdfTextMarkupAnnotation;
      expect(t1.textMarkupAnnotationType, sf.PdfTextMarkupAnnotationType.highlight);

      final a2 = verifyDoc.pages[0].annotations[1] as sf.PdfTextMarkupAnnotation;
      expect(a2.textMarkupAnnotationType, sf.PdfTextMarkupAnnotationType.underline);

      final a3 = verifyDoc.pages[1].annotations[0] as sf.PdfTextMarkupAnnotation;
      expect(a3.textMarkupAnnotationType, sf.PdfTextMarkupAnnotationType.strikethrough);

      // Verify bookmarks preserved
      expect(verifyDoc.bookmarks.count, 1);
      expect(verifyDoc.bookmarks[0].title, 'Chapter 1');

      // Verify form fields preserved
      expect(verifyDoc.form.fields.count, 1);
      final formField = verifyDoc.form.fields[0] as sf.PdfTextBoxField;
      expect(formField.name, 'user_name');
      expect(formField.text, 'Initial Text Value');

      verifyDoc.dispose();

      // Verify with pdfrx reader
      final rxDoc = await rx.PdfDocument.openFile(outputFile.path);
      expect(rxDoc.pages.length, 2);
      rxDoc.dispose();
    });

    test('preserves existing annotations when saving new markups', () async {
      final file = await createSamplePdf(pageCount: 1);
      final step1Path = '${tempDir.path}/step1.pdf';
      final step2Path = '${tempDir.path}/step2.pdf';

      // 1. Add first markup
      await service.saveAnnotations(
        sourcePath: file.path,
        outputPath: step1Path,
        markups: [
          TextMarkup(
            id: 'm1',
            pageIndex: 0,
            type: TextMarkupType.highlight,
            colorValue: 0xFFFFEB3B,
            lineRects: const [Rect.fromLTWH(50, 50, 100, 20)],
            text: 'First highlight',
            createdAtMs: 1000,
          ),
        ],
      );

      // 2. Add second markup to step1 output
      await service.saveAnnotations(
        sourcePath: step1Path,
        outputPath: step2Path,
        markups: [
          TextMarkup(
            id: 'm2',
            pageIndex: 0,
            type: TextMarkupType.underline,
            colorValue: 0xFF4CAF50,
            lineRects: const [Rect.fromLTWH(50, 100, 100, 20)],
            text: 'Second underline',
            createdAtMs: 2000,
          ),
        ],
      );

      final verifyDoc = sf.PdfDocument(inputBytes: File(step2Path).readAsBytesSync());
      expect(verifyDoc.pages[0].annotations.count, 2);
      verifyDoc.dispose();
    });

    test('replaceOriginal atomically overwrites the source file', () async {
      final file = await createSamplePdf(pageCount: 1);
      final originalSize = file.lengthSync();

      final markups = [
        TextMarkup(
          id: 'm1',
          pageIndex: 0,
          type: TextMarkupType.highlight,
          colorValue: 0xFFFFEB3B,
          lineRects: const [Rect.fromLTWH(50, 50, 100, 20)],
          text: 'Overwriting markup',
          createdAtMs: 1000,
        ),
      ];

      final replacedFile = await service.saveAnnotations(
        sourcePath: file.path,
        outputPath: file.path,
        markups: markups,
        replaceOriginal: true,
      );

      expect(replacedFile.path, file.path);
      expect(replacedFile.lengthSync(), isNot(originalSize));

      final verifyDoc = sf.PdfDocument(inputBytes: replacedFile.readAsBytesSync());
      expect(verifyDoc.pages[0].annotations.count, 1);
      verifyDoc.dispose();
    });

    test('throws signedDocumentReplaceBlocked if attempting to replace a digitally signed file', () async {
      // Create a doc with a signature field that has a signature dictionary /V
      final doc = sf.PdfDocument();
      final page = doc.pages.add();
      final sigField = sf.PdfSignatureField(
        page,
        'Signature1',
        bounds: const Rect.fromLTWH(100, 100, 200, 50),
      );
      doc.form.fields.add(sigField);

      // In a signed PDF, the signature field dictionary contains /V (the signature value)
      final sigDict = sf_prim.PdfDictionary();
      sigDict.setProperty(sf_prim.PdfName('Type'), sf_prim.PdfName('Sig'));
      sigDict.setProperty(sf_prim.PdfName('Filter'), sf_prim.PdfName('Adobe.PPKLite'));
      sigDict.setProperty(sf_prim.PdfName('SubFilter'), sf_prim.PdfName('adbe.pkcs7.detached'));
      sigDict.setProperty(sf_prim.PdfName('Name'), sf_prim.PdfString('John Doe'));

      final fieldHelper = sf_sig.PdfSignatureFieldHelper.getHelper(sigField);
      fieldHelper.dictionary!.setProperty(sf_prim.PdfName('V'), sigDict);

      final signedFile = File('${tempDir.path}/signed.pdf');
      await signedFile.writeAsBytes(doc.saveSync());
      doc.dispose();

      // Check detection
      final info = await service.getDocumentInfo(signedFile.path);
      expect(info.hasDigitalSignature, isTrue);

      expect(
        () => service.saveAnnotations(
          sourcePath: signedFile.path,
          outputPath: signedFile.path,
          markups: [],
          replaceOriginal: true,
        ),
        throwsA(isA<PdfAnnotationException>().having(
          (e) => e.reason,
          'reason',
          PdfAnnotationErrorReason.signedDocumentReplaceBlocked,
        )),
      );
    });
    test('throws tooManyStrokes if stroke count exceeds 5000', () async {
      final file = await createSamplePdf(pageCount: 1);
      final strokes = List.generate(
        5001,
        (i) => InkStroke(
          id: 's_$i',
          pageIndex: 0,
          points: const [Offset(10, 10), Offset(20, 20)],
          timestampMs: 100,
        ),
      );

      expect(
        () => service.saveAnnotations(
          sourcePath: file.path,
          outputPath: '${tempDir.path}/out_stroke_cap.pdf',
          strokes: strokes,
        ),
        throwsA(isA<PdfAnnotationException>().having(
          (e) => e.reason,
          'reason',
          PdfAnnotationErrorReason.tooManyStrokes,
        )),
      );
    });

    test('throws tooManyStrokes if total points exceed 300000', () async {
      final file = await createSamplePdf(pageCount: 1);
      final strokes = [
        InkStroke(
          id: 'huge_1',
          pageIndex: 0,
          points: List.generate(200000, (i) => Offset(i.toDouble(), 0)),
          timestampMs: 100,
        ),
        InkStroke(
          id: 'huge_2',
          pageIndex: 0,
          points: List.generate(150000, (i) => Offset(i.toDouble(), 0)),
          timestampMs: 200,
        ),
      ];

      expect(
        () => service.saveAnnotations(
          sourcePath: file.path,
          outputPath: '${tempDir.path}/out_point_cap.pdf',
          strokes: strokes,
        ),
        throwsA(isA<PdfAnnotationException>().having(
          (e) => e.reason,
          'reason',
          PdfAnnotationErrorReason.tooManyStrokes,
        )),
      );
    });
  });
}
