import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:archive/archive.dart';
import 'package:docview/data/services/convert/pdf_to_word_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
// ignore: depend_on_referenced_packages
import 'package:xml/xml.dart';

/// Automated test helper validating well-formed OOXML structure and XML syntax.
void assertDocxXmlWellFormed(Uint8List docxBytes) {
  final archive = ZipDecoder().decodeBytes(docxBytes);
  final entryMap = <String, String>{};

  for (final file in archive.files) {
    if (file.isFile) {
      entryMap[file.name] = utf8.decode(file.content as List<int>);
    }
  }

  // 1. Mandatory OOXML Parts
  expect(entryMap.containsKey('[Content_Types].xml'), isTrue, reason: 'Must contain [Content_Types].xml');
  expect(entryMap.containsKey('_rels/.rels'), isTrue, reason: 'Must contain _rels/.rels');
  expect(entryMap.containsKey('word/document.xml'), isTrue, reason: 'Must contain word/document.xml');
  expect(entryMap.containsKey('word/_rels/document.xml.rels'), isTrue, reason: 'Must contain word/_rels/document.xml.rels');
  expect(entryMap.containsKey('word/styles.xml'), isTrue, reason: 'Must contain word/styles.xml');
  expect(entryMap.containsKey('docProps/core.xml'), isTrue, reason: 'Must contain docProps/core.xml');

  // 2. Parse every XML file with XmlDocument.parse to verify XML 1.0 validity and balanced tags
  final parsedDocs = <String, XmlDocument>{};
  for (final entry in entryMap.entries) {
    if (entry.key.endsWith('.xml') || entry.key.endsWith('.rels')) {
      try {
        final doc = XmlDocument.parse(entry.value);
        parsedDocs[entry.key] = doc;
      } catch (e) {
        fail('XML parsing failed for entry "${entry.key}": $e\nContent:\n${entry.value}');
      }
    }
  }

  // 3. Verify docProps/core.xml contains creator "Doc View" and title
  final coreXml = parsedDocs['docProps/core.xml']!;
  final creatorEl = coreXml.findAllElements('dc:creator');
  expect(creatorEl.isNotEmpty, isTrue, reason: 'docProps/core.xml must contain dc:creator');
  expect(creatorEl.first.innerText, 'Doc View', reason: 'Creator must be "Doc View"');
  final titleEl = coreXml.findAllElements('dc:title');
  expect(titleEl.isNotEmpty, isTrue, reason: 'docProps/core.xml must contain dc:title');

  // 4. Extract defined style IDs from word/styles.xml
  final stylesXml = parsedDocs['word/styles.xml']!;
  final definedStyleIds = <String>{};
  for (final styleEl in stylesXml.findAllElements('w:style')) {
    final id = styleEl.getAttribute('w:styleId');
    if (id != null) definedStyleIds.add(id);
  }
  expect(definedStyleIds, contains('Normal'), reason: 'styles.xml must define Normal');
  expect(definedStyleIds, contains('Heading1'), reason: 'styles.xml must define Heading1');
  expect(definedStyleIds, contains('Heading2'), reason: 'styles.xml must define Heading2');

  // 5. In word/document.xml, verify every w:pStyle has a definition in styles.xml
  final docXml = parsedDocs['word/document.xml']!;
  for (final pStyleEl in docXml.findAllElements('w:pStyle')) {
    final styleVal = pStyleEl.getAttribute('w:val');
    expect(
      definedStyleIds.contains(styleVal),
      isTrue,
      reason: 'w:pStyle "$styleVal" used in document.xml must be defined in word/styles.xml',
    );
  }

  // 6. In [Content_Types].xml, verify every PartName override targets an existing part
  final contentTypesXml = parsedDocs['[Content_Types].xml']!;
  for (final overrideEl in contentTypesXml.findAllElements('Override')) {
    var partName = overrideEl.getAttribute('PartName') ?? '';
    if (partName.startsWith('/')) {
      partName = partName.substring(1);
    }
    expect(
      entryMap.containsKey(partName),
      isTrue,
      reason: 'ContentType Override "$partName" must target an existing part in the archive',
    );
  }
}

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
      assertDocxXmlWellFormed(docxBytes);
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
      assertDocxXmlWellFormed(docxBytes);
      final archive = ZipDecoder().decodeBytes(docxBytes);
      final docXmlFile = archive.files.firstWhere((e) => e.name == 'word/document.xml');
      final xmlContent = utf8.decode(docXmlFile.content as List<int>);

      expect(xmlContent, contains('<w:bidi/>'));
      expect(xmlContent, contains('<w:rtl/>'));
    });

    test('Cancellation via PdfToWordCancellationToken stops conversion and deletes temp file', () async {
      final pdfPath = '${tempDir.path}/cancel_test.pdf';
      final doc = PdfDocument();
      for (int i = 0; i < 10; i++) {
        final page = doc.pages.add();
        page.graphics.drawString('Page $i text content', PdfStandardFont(PdfFontFamily.helvetica, 12));
      }
      final bytes = doc.saveSync();
      doc.dispose();
      await File(pdfPath).writeAsBytes(bytes);

      final outPath = '${tempDir.path}/cancelled_output.docx';
      final token = PdfToWordCancellationToken();

      PdfToWordService.slowConvertForTesting = true;
      PdfToWordService.slowConvertDelayMs = 40;

      final future = service.convertPdfToWord(
        sourcePath: pdfPath,
        outputPath: outPath,
        onProgress: (p) {
          if (p > 0.1) {
            token.cancel();
          }
        },
        cancellationToken: token,
      );

      await expectLater(
        future,
        throwsA(
          isA<PdfToWordException>().having(
            (e) => e.reason,
            'reason',
            PdfToWordErrorReason.cancelled,
          ),
        ),
      );

      PdfToWordService.slowConvertForTesting = false;
      PdfToWordService.slowConvertDelayMs = 0;

      expect(await File(outPath).exists(), isFalse);
      expect(await File('$outPath.tmp').exists(), isFalse);
    });

    test('Release guard: isSlowConvertActive returns false when isDebug is false', () {
      PdfToWordService.slowConvertForTesting = true;
      PdfToWordService.slowConvertDelayMs = 100;
      expect(PdfToWordService.isSlowConvertActive(isDebug: false), isFalse);
      expect(PdfToWordService.isSlowConvertActive(isDebug: true), isTrue);
      PdfToWordService.slowConvertForTesting = false;
      PdfToWordService.slowConvertDelayMs = 0;
    });

    test('Heading classification strictly follows H1 (> 1.8x) and H2 (>= 1.3x) median heuristics', () async {
      final pdfPath = '${tempDir.path}/heading_test.pdf';
      final doc = PdfDocument();
      final page = doc.pages.add();
      // Heading 1: 24.0 > 1.8 * 10 (18.0)
      page.graphics.drawString(
        'Main Heading One',
        PdfStandardFont(PdfFontFamily.helvetica, 24),
        bounds: const Rect.fromLTWH(0, 0, 300, 30),
      );
      // Heading 2: 15.0 >= 1.3 * 10 (13.0)
      page.graphics.drawString(
        'Sub Heading Two',
        PdfStandardFont(PdfFontFamily.helvetica, 15),
        bounds: const Rect.fromLTWH(0, 40, 300, 25),
      );
      // Median body text size = 10.0
      page.graphics.drawString(
        'Body text line 1',
        PdfStandardFont(PdfFontFamily.helvetica, 10),
        bounds: const Rect.fromLTWH(0, 80, 300, 20),
      );
      page.graphics.drawString(
        'Body text line 2',
        PdfStandardFont(PdfFontFamily.helvetica, 10),
        bounds: const Rect.fromLTWH(0, 110, 300, 20),
      );
      page.graphics.drawString(
        'Body text line 3',
        PdfStandardFont(PdfFontFamily.helvetica, 10),
        bounds: const Rect.fromLTWH(0, 140, 300, 20),
      );

      final bytes = doc.saveSync();
      doc.dispose();
      await File(pdfPath).writeAsBytes(bytes);

      final outPath = '${tempDir.path}/headings_output.docx';
      await service.convertPdfToWord(
        sourcePath: pdfPath,
        outputPath: outPath,
      );

      final docxBytes = await File(outPath).readAsBytes();
      assertDocxXmlWellFormed(docxBytes);
      final archive = ZipDecoder().decodeBytes(docxBytes);
      final docXmlFile = archive.files.firstWhere((e) => e.name == 'word/document.xml');
      final xmlContent = utf8.decode(docXmlFile.content as List<int>);

      expect(xmlContent, contains('<w:pStyle w:val="Heading1"/>'));
      expect(xmlContent, contains('<w:pStyle w:val="Heading2"/>'));
    });
  });
}
