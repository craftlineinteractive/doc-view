import 'dart:io';

import 'package:docview/core/errors/app_errors.dart';
import 'package:docview/data/services/pdf/pdf_page_edit_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdfrx/pdfrx.dart';

Future<File> _createTestPdf(String path, int pageCount, {String prefix = 'P'}) async {
  final pdf = pw.Document();
  for (var i = 1; i <= pageCount; i++) {
    pdf.addPage(
      pw.Page(
        build: (context) => pw.Center(
          child: pw.Text('$prefix$i', style: const pw.TextStyle(fontSize: 40)),
        ),
      ),
    );
  }
  final file = File(path);
  await file.writeAsBytes(await pdf.save());
  return file;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;
  late PdfPageEditService service;

  setUp(() {
    tempDir = Directory.systemTemp.createTempSync('pdf_edit_service_test_');
    service = const PdfPageEditService();
  });

  tearDown(() {
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });

  group('PdfPageEditService Tests', () {
    test('getPageCount returns exact page count and handles missing file', () async {
      final docFile = await _createTestPdf('${tempDir.path}/doc6.pdf', 6);
      final count = await service.getPageCount(docFile.path);
      expect(count, 6);

      expect(
        () => service.getPageCount('${tempDir.path}/nonexistent.pdf'),
        throwsA(
          isA<PdfPageEditException>().having(
            (e) => e.reason,
            'reason',
            PdfPageEditErrorReason.sourceFileNotFound,
          ),
        ),
      );
    });

    test('reorders pages correctly', () async {
      final docFile = await _createTestPdf('${tempDir.path}/source.pdf', 4);
      final outPath = '${tempDir.path}/reordered.pdf';

      // Reorder 0,1,2,3 -> 2,0,3,1
      final specs = [
        PdfPageEditSpec(sourcePath: docFile.path, sourcePageIndex: 2),
        PdfPageEditSpec(sourcePath: docFile.path, sourcePageIndex: 0),
        PdfPageEditSpec(sourcePath: docFile.path, sourcePageIndex: 3),
        PdfPageEditSpec(sourcePath: docFile.path, sourcePageIndex: 1),
      ];

      final result = await service.saveDocument(
        pages: specs,
        outputPath: outPath,
      );

      expect(result.existsSync(), isTrue);

      final outDoc = await PdfDocument.openFile(outPath);
      expect(outDoc.pages.length, 4);

      // Verify text from structured text on reordered pages
      final text0 = (await outDoc.pages[0].loadStructuredText()).fullText.trim();
      final text1 = (await outDoc.pages[1].loadStructuredText()).fullText.trim();
      final text2 = (await outDoc.pages[2].loadStructuredText()).fullText.trim();
      final text3 = (await outDoc.pages[3].loadStructuredText()).fullText.trim();

      expect(text0, 'P3');
      expect(text1, 'P1');
      expect(text2, 'P4');
      expect(text3, 'P2');

      outDoc.dispose();
    });

    test('rotates page clockwise and encodes persistent rotation', () async {
      final docFile = await _createTestPdf('${tempDir.path}/rotate.pdf', 2);
      final outPath = '${tempDir.path}/rotated.pdf';

      final specs = [
        PdfPageEditSpec(sourcePath: docFile.path, sourcePageIndex: 0, rotationDegrees: 90),
        PdfPageEditSpec(sourcePath: docFile.path, sourcePageIndex: 1, rotationDegrees: 180),
      ];

      final result = await service.saveDocument(
        pages: specs,
        outputPath: outPath,
      );

      expect(result.existsSync(), isTrue);

      final outDoc = await PdfDocument.openFile(outPath);
      expect(outDoc.pages.length, 2);
      expect(outDoc.pages[0].rotation, PdfPageRotation.clockwise90);
      expect(outDoc.pages[1].rotation, PdfPageRotation.clockwise180);
      outDoc.dispose();
    });

    test('deletes pages correctly and throws on deleting all pages', () async {
      final docFile = await _createTestPdf('${tempDir.path}/delete.pdf', 5);
      final outPath = '${tempDir.path}/deleted.pdf';

      // Keep only pages 0 and 4 (delete 1, 2, 3)
      final specs = [
        PdfPageEditSpec(sourcePath: docFile.path, sourcePageIndex: 0),
        PdfPageEditSpec(sourcePath: docFile.path, sourcePageIndex: 4),
      ];

      final result = await service.saveDocument(
        pages: specs,
        outputPath: outPath,
      );

      expect(result.existsSync(), isTrue);

      final outDoc = await PdfDocument.openFile(outPath);
      expect(outDoc.pages.length, 2);
      final t0 = (await outDoc.pages[0].loadStructuredText()).fullText.trim();
      final t1 = (await outDoc.pages[1].loadStructuredText()).fullText.trim();
      expect(t0, 'P1');
      expect(t1, 'P5');
      outDoc.dispose();

      // Deleting all pages throws allPagesDeleted
      expect(
        () => service.saveDocument(pages: [], outputPath: outPath),
        throwsA(
          isA<PdfPageEditException>().having(
            (e) => e.reason,
            'reason',
            PdfPageEditErrorReason.allPagesDeleted,
          ),
        ),
      );
    });

    test('extractPages saves specified pages into a new document', () async {
      final docFile = await _createTestPdf('${tempDir.path}/extract_source.pdf', 6);
      final extractPath = '${tempDir.path}/extracted.pdf';

      // Extract pages 2 and 5 (1-based P3 and P6)
      final specs = [
        PdfPageEditSpec(sourcePath: docFile.path, sourcePageIndex: 2),
        PdfPageEditSpec(sourcePath: docFile.path, sourcePageIndex: 5),
      ];

      final result = await service.extractPages(
        pages: specs,
        outputPath: extractPath,
      );

      expect(result.existsSync(), isTrue);

      final outDoc = await PdfDocument.openFile(extractPath);
      expect(outDoc.pages.length, 2);
      final t0 = (await outDoc.pages[0].loadStructuredText()).fullText.trim();
      final t1 = (await outDoc.pages[1].loadStructuredText()).fullText.trim();
      expect(t0, 'P3');
      expect(t1, 'P6');
      outDoc.dispose();
    });

    test('inserts pages from another PDF document', () async {
      final docA = await _createTestPdf('${tempDir.path}/docA.pdf', 2, prefix: 'A');
      final docB = await _createTestPdf('${tempDir.path}/docB.pdf', 2, prefix: 'B');
      final outPath = '${tempDir.path}/combined.pdf';

      // Interleave A1, B1, A2, B2
      final specs = [
        PdfPageEditSpec(sourcePath: docA.path, sourcePageIndex: 0),
        PdfPageEditSpec(sourcePath: docB.path, sourcePageIndex: 0),
        PdfPageEditSpec(sourcePath: docA.path, sourcePageIndex: 1),
        PdfPageEditSpec(sourcePath: docB.path, sourcePageIndex: 1),
      ];

      final result = await service.saveDocument(
        pages: specs,
        outputPath: outPath,
      );

      expect(result.existsSync(), isTrue);

      final outDoc = await PdfDocument.openFile(outPath);
      expect(outDoc.pages.length, 4);
      final t0 = (await outDoc.pages[0].loadStructuredText()).fullText.trim();
      final t1 = (await outDoc.pages[1].loadStructuredText()).fullText.trim();
      final t2 = (await outDoc.pages[2].loadStructuredText()).fullText.trim();
      final t3 = (await outDoc.pages[3].loadStructuredText()).fullText.trim();

      expect(t0, 'A1');
      expect(t1, 'B1');
      expect(t2, 'A2');
      expect(t3, 'B2');
      outDoc.dispose();
    });

    test('replaceOriginal replaces source file atomically and cleans temporary files', () async {
      final docFile = await _createTestPdf('${tempDir.path}/original.pdf', 3);

      // Rotate page 0 and save in-place replacing original
      final specs = [
        PdfPageEditSpec(sourcePath: docFile.path, sourcePageIndex: 0, rotationDegrees: 90),
        PdfPageEditSpec(sourcePath: docFile.path, sourcePageIndex: 1),
      ];

      final result = await service.saveDocument(
        pages: specs,
        outputPath: docFile.path,
        replaceOriginal: true,
      );

      expect(result.path, docFile.path);
      expect(result.existsSync(), isTrue);
      expect(File('${docFile.path}.tmp').existsSync(), isFalse);
      expect(File('${docFile.path}.bak').existsSync(), isFalse);

      final outDoc = await PdfDocument.openFile(result.path);
      expect(outDoc.pages.length, 2);
      expect(outDoc.pages[0].rotation, PdfPageRotation.clockwise90);
      outDoc.dispose();
    });
  });
}
