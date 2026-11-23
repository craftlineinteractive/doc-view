import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:docview/data/services/convert/pdf_to_word_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;
  late PdfToWordService service;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('pdf_to_word_test_');
    service = const PdfToWordService();
  });

  tearDown(() async {
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  group('PdfToWordService Preflight Tests', () {
    test('checkTextLayer detects extractable text in standard PDF', () async {
      final pdfPath = '${tempDir.path}/test_text.pdf';
      final doc = PdfDocument();
      final page = doc.pages.add();
      page.graphics.drawString(
        'Hello World Document View',
        PdfStandardFont(PdfFontFamily.helvetica, 14),
      );
      final bytes = doc.saveSync();
      doc.dispose();
      await File(pdfPath).writeAsBytes(bytes);

      final preflight = await service.checkTextLayer(sourcePath: pdfPath);
      expect(preflight.hasText, isTrue);
      expect(preflight.pageCount, 1);
      expect(preflight.isEncrypted, isFalse);
      expect(preflight.totalCharacters, greaterThan(10));
    });

    test('checkTextLayer reports hasText false when PDF has no text layer', () async {
      final pdfPath = '${tempDir.path}/empty_scanned.pdf';
      final doc = PdfDocument();
      doc.pages.add(); // Blank page
      final bytes = doc.saveSync();
      doc.dispose();
      await File(pdfPath).writeAsBytes(bytes);

      final preflight = await service.checkTextLayer(sourcePath: pdfPath);
      expect(preflight.hasText, isFalse);
      expect(preflight.pageCount, 1);
      expect(preflight.totalCharacters, 0);
    });

    test('checkTextLayer identifies encrypted PDF when password is required', () async {
      final pdfPath = '${tempDir.path}/encrypted.pdf';
      final doc = PdfDocument();
      final page = doc.pages.add();
      page.graphics.drawString(
        'Secret Confidential Data',
        PdfStandardFont(PdfFontFamily.helvetica, 12),
      );
      doc.security.userPassword = 'test_password_123';
      final bytes = doc.saveSync();
      doc.dispose();
      await File(pdfPath).writeAsBytes(bytes);

      final preflight = await service.checkTextLayer(sourcePath: pdfPath);
      expect(preflight.isEncrypted, isTrue);
    });
  });

  group('PdfToWordService Conversion Tests', () {
    test('Converts multi-page PDF to valid DOCX with page breaks and progress', () async {
      final pdfPath = '${tempDir.path}/multipage.pdf';
      final doc = PdfDocument();

      final page1 = doc.pages.add();
      page1.graphics.drawString(
        'Document Title Heading',
        PdfStandardFont(PdfFontFamily.helvetica, 24, style: PdfFontStyle.bold),
      );
      page1.graphics.drawString(
        'This is the first paragraph of text on page 1.',
        PdfStandardFont(PdfFontFamily.helvetica, 12),
      );

      final page2 = doc.pages.add();
      page2.graphics.drawString(
        'Section 2 Subtitle',
        PdfStandardFont(PdfFontFamily.helvetica, 16, style: PdfFontStyle.bold),
      );
      page2.graphics.drawString(
        'Second page content with detail & analysis <important>.',
        PdfStandardFont(PdfFontFamily.helvetica, 12),
      );

      final bytes = doc.saveSync();
      doc.dispose();
      await File(pdfPath).writeAsBytes(bytes);

      final outPath = '${tempDir.path}/output_with_breaks.docx';
      final progressValues = <double>[];

      final resultPath = await service.convertPdfToWord(
        sourcePath: pdfPath,
        outputPath: outPath,
        insertPageBreaks: true,
        onProgress: (p) => progressValues.add(p),
      );

      expect(resultPath, outPath);
      final outFile = File(resultPath);
      expect(await outFile.exists(), isTrue);
      expect(await outFile.length(), greaterThan(1000));
      expect(progressValues, isNotEmpty);
      expect(progressValues.last, 1.0);

      // Verify DOCX ZIP archive structure and content
      final docxBytes = await outFile.readAsBytes();
      final archive = ZipDecoder().decodeBytes(docxBytes);

      final entryNames = archive.files.map((e) => e.name).toSet();
      expect(entryNames, contains('[Content_Types].xml'));
      expect(entryNames, contains('_rels/.rels'));
      expect(entryNames, contains('word/document.xml'));
      expect(entryNames, contains('word/_rels/document.xml.rels'));
      expect(entryNames, contains('word/styles.xml'));

      // Check document.xml content
      final docXmlFile = archive.files.firstWhere((e) => e.name == 'word/document.xml');
      final xmlContent = utf8.decode(docXmlFile.content as List<int>);

      expect(xmlContent, contains('Document Title Heading'));
      expect(xmlContent, contains('Section 2 Subtitle'));
      expect(xmlContent, contains('&amp;')); // Escaped &
      expect(xmlContent, contains('&lt;important&gt;')); // Escaped <important>
      // Verify page break is present
      expect(
        xmlContent.contains('<w:br w:type="page"/>') || xmlContent.contains('<w:pageBreakBefore/>'),
        isTrue,
      );
    });

    test('Converts without page breaks when insertPageBreaks is false', () async {
      final pdfPath = '${tempDir.path}/multipage_nobreak.pdf';
      final doc = PdfDocument();

      final page1 = doc.pages.add();
      page1.graphics.drawString('Page 1 Content', PdfStandardFont(PdfFontFamily.helvetica, 12));
      final page2 = doc.pages.add();
      page2.graphics.drawString('Page 2 Content', PdfStandardFont(PdfFontFamily.helvetica, 12));

      final bytes = doc.saveSync();
      doc.dispose();
      await File(pdfPath).writeAsBytes(bytes);

      final outPath = '${tempDir.path}/output_no_breaks.docx';
      await service.convertPdfToWord(
        sourcePath: pdfPath,
        outputPath: outPath,
        insertPageBreaks: false,
      );

      final docxBytes = await File(outPath).readAsBytes();
      final archive = ZipDecoder().decodeBytes(docxBytes);
      final docXmlFile = archive.files.firstWhere((e) => e.name == 'word/document.xml');
      final xmlContent = utf8.decode(docXmlFile.content as List<int>);

      expect(xmlContent, contains('Page 1 Content'));
      expect(xmlContent, contains('Page 2 Content'));
      expect(xmlContent.contains('<w:br w:type="page"/>'), isFalse);
      expect(xmlContent.contains('<w:pageBreakBefore/>'), isFalse);
    });

    test('Throws fileNotFound when source PDF does not exist', () async {
      expect(
        () => service.convertPdfToWord(
          sourcePath: '${tempDir.path}/non_existent_file.pdf',
        ),
        throwsA(
          isA<PdfToWordException>().having(
            (e) => e.reason,
            'reason',
            PdfToWordErrorReason.fileNotFound,
          ),
        ),
      );
    });

    test('Throws noTextFound when PDF contains no extractable text', () async {
      final pdfPath = '${tempDir.path}/blank_doc.pdf';
      final doc = PdfDocument();
      doc.pages.add();
      final bytes = doc.saveSync();
      doc.dispose();
      await File(pdfPath).writeAsBytes(bytes);

      expect(
        () => service.convertPdfToWord(sourcePath: pdfPath),
        throwsA(
          isA<PdfToWordException>().having(
            (e) => e.reason,
            'reason',
            PdfToWordErrorReason.noTextFound,
          ),
        ),
      );
    });

    test('Converts password protected PDF when correct password is provided', () async {
      final pdfPath = '${tempDir.path}/pw_protected.pdf';
      final doc = PdfDocument();
      final page = doc.pages.add();
      page.graphics.drawString('Protected Top Secret Text', PdfStandardFont(PdfFontFamily.helvetica, 14));
      doc.security.userPassword = 'mypassword';
      final bytes = doc.saveSync();
      doc.dispose();
      await File(pdfPath).writeAsBytes(bytes);

      final outPath = '${tempDir.path}/pw_output.docx';
      final res = await service.convertPdfToWord(
        sourcePath: pdfPath,
        outputPath: outPath,
        password: 'mypassword',
      );
      expect(await File(res).exists(), isTrue);

      final docxBytes = await File(res).readAsBytes();
      final archive = ZipDecoder().decodeBytes(docxBytes);
      final docXmlFile = archive.files.firstWhere((e) => e.name == 'word/document.xml');
      final xmlContent = utf8.decode(docXmlFile.content as List<int>);
      expect(xmlContent, contains('Protected Top Secret Text'));
    });

    test('Throws encrypted when password is missing or incorrect', () async {
      final pdfPath = '${tempDir.path}/pw_protected2.pdf';
      final doc = PdfDocument();
      final page = doc.pages.add();
      page.graphics.drawString('Protected Text', PdfStandardFont(PdfFontFamily.helvetica, 14));
      doc.security.userPassword = 'correct_key';
      final bytes = doc.saveSync();
      doc.dispose();
      await File(pdfPath).writeAsBytes(bytes);

      expect(
        () => service.convertPdfToWord(
          sourcePath: pdfPath,
          password: 'wrong_key',
        ),
        throwsA(
          isA<PdfToWordException>().having(
            (e) => e.reason,
            'reason',
            PdfToWordErrorReason.encrypted,
          ),
        ),
      );
    });

    test('Handles RTL text with <w:bidi/> in word XML', () async {
      final pdfPath = '${tempDir.path}/hebrew_doc.pdf';
      final doc = PdfDocument();
      final page = doc.pages.add();
      final fontBytes = File('assets/fonts/Arimo-Regular.ttf').readAsBytesSync();
      final font = PdfTrueTypeFont(fontBytes, 14);
      page.graphics.drawString('שלום עולם Test', font);
      final bytes = doc.saveSync();
      doc.dispose();
      await File(pdfPath).writeAsBytes(bytes);

      final outPath = '${tempDir.path}/hebrew_output.docx';
      await service.convertPdfToWord(
        sourcePath: pdfPath,
        outputPath: outPath,
      );

      final docxBytes = await File(outPath).readAsBytes();
      final archive = ZipDecoder().decodeBytes(docxBytes);
      final docXmlFile = archive.files.firstWhere((e) => e.name == 'word/document.xml');
      final xmlContent = utf8.decode(docXmlFile.content as List<int>);

      expect(xmlContent, contains('<w:bidi/>'));
      expect(xmlContent, contains('<w:rtl/>'));
    });
  });
}
