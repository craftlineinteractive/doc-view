// ignore_for_file: avoid_print
import 'dart:io';
import 'dart:ui' show Rect, Offset;
import 'package:flutter_test/flutter_test.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:docview/data/services/convert/pdf_to_word_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Generate All G6 Test PDFs for QA', () async {
    final outDir = Directory('test/fixtures');
    if (!outDir.existsSync()) {
      outDir.createSync(recursive: true);
    }

    final arimoBytes = File('assets/fonts/Arimo-Regular.ttf').readAsBytesSync();
    final arimoFont = PdfTrueTypeFont(arimoBytes, 12);
    final arimoH1 = PdfTrueTypeFont(arimoBytes, 22, style: PdfFontStyle.bold);

    // 1. Hindi PDF
    final docHindi = PdfDocument();
    final pageHindi = docHindi.pages.add();
    pageHindi.graphics.drawString(
      'अध्याय 1: हिंदी दस्तावेज़ परीक्षण',
      arimoH1,
      bounds: const Rect.fromLTWH(30, 40, 500, 30),
    );
    pageHindi.graphics.drawString(
      'नमस्ते दुनिया! यह डॉक व्यू एप्लिकेशन का एक हिंदी परीक्षण दस्तावेज़ है। '
      'यह दस्तावेज़ यूनिकोड देवनागरी वर्णों के निष्कर्षण और वर्ड रूपांतरण की पुष्टि करता है।',
      arimoFont,
      bounds: const Rect.fromLTWH(30, 80, 500, 80),
    );
    final bytesHindi = docHindi.saveSync();
    docHindi.dispose();
    await File('test/fixtures/hindi_doc.pdf').writeAsBytes(bytesHindi);
    print('Generated hindi_doc.pdf (${bytesHindi.length} bytes)');

    // 2. Arabic PDF (RTL)
    final docArabic = PdfDocument();
    final pageArabic = docArabic.pages.add();
    try {
      final arialBytes = File('C:/Windows/Fonts/arial.ttf').readAsBytesSync();
      final arialFont = PdfTrueTypeFont(arialBytes, 12);
      pageArabic.graphics.drawString(
        'مرحبا بالعالم اختبار المستند العربي',
        arialFont,
        bounds: const Rect.fromLTWH(30, 80, 500, 80),
      );
    } catch (_) {
      // If Arabic TrueType shaping fails in Syncfusion, use standard Hebrew/Arabic RTL unicode
      pageArabic.graphics.drawString(
        'مرحبا שלום עולם Test RTL Document',
        arimoFont,
        bounds: const Rect.fromLTWH(30, 80, 500, 80),
      );
    }
    final bytesArabic = docArabic.saveSync();
    docArabic.dispose();
    await File('test/fixtures/arabic_doc.pdf').writeAsBytes(bytesArabic);
    print('Generated arabic_doc.pdf (${bytesArabic.length} bytes)');

    // 3. Two-Column Layout PDF
    final doc2Col = PdfDocument();
    final page2Col = doc2Col.pages.add();
    final h1 = PdfStandardFont(PdfFontFamily.helvetica, 20, style: PdfFontStyle.bold);
    final h2 = PdfStandardFont(PdfFontFamily.helvetica, 14, style: PdfFontStyle.bold);
    final body = PdfStandardFont(PdfFontFamily.helvetica, 10);

    page2Col.graphics.drawString('Two-Column Technical Specification', h1,
        bounds: const Rect.fromLTWH(30, 30, 500, 25));

    // Left column: x = 30..250 (width 220)
    page2Col.graphics.drawString('Left Column: Core Architecture', h2,
        bounds: const Rect.fromLTWH(30, 70, 220, 20));
    page2Col.graphics.drawString(
      'The left column contains primary modular descriptions. '
      'Doc View processes PDF pages using pure client-side isolates. '
      'Each paragraph is identified and grouped by vertical line spacing.',
      body,
      bounds: const Rect.fromLTWH(30, 95, 220, 100),
    );
    page2Col.graphics.drawString('Left Section 2: Memory & Limits', h2,
        bounds: const Rect.fromLTWH(30, 205, 220, 20));
    page2Col.graphics.drawString(
      'Documents exceeding memory constraints are guarded with warning banners. '
      'Temporary files use .tmp extensions until complete.',
      body,
      bounds: const Rect.fromLTWH(30, 230, 220, 100),
    );

    // Right column: x = 280..500 (width 220)
    page2Col.graphics.drawString('Right Column: Output Verification', h2,
        bounds: const Rect.fromLTWH(280, 70, 220, 20));
    page2Col.graphics.drawString(
      'The right column specifies the OOXML packaging pipeline. '
      'Files are validated with strict ZIP checking and XML 1.0 parsing '
      'before being exposed to the user or file system.',
      body,
      bounds: const Rect.fromLTWH(280, 95, 220, 100),
    );
    page2Col.graphics.drawString('Right Section 2: Degradation Scope', h2,
        bounds: const Rect.fromLTWH(280, 205, 220, 20));
    page2Col.graphics.drawString(
      'Because Doc View performs text-only conversion, multi-column layouts '
      'are linearized into sequential paragraphs. Tables and images are omitted.',
      body,
      bounds: const Rect.fromLTWH(280, 230, 220, 100),
    );

    final bytes2Col = doc2Col.saveSync();
    doc2Col.dispose();
    await File('test/fixtures/twocolumn_doc.pdf').writeAsBytes(bytes2Col);
    print('Generated twocolumn_doc.pdf (${bytes2Col.length} bytes)');

    // 4. 20-page text-heavy PDF
    final doc20 = PdfDocument();
    for (int i = 1; i <= 20; i++) {
      final page = doc20.pages.add();
      final h1Font = PdfStandardFont(PdfFontFamily.helvetica, 22, style: PdfFontStyle.bold);
      final h2Font = PdfStandardFont(PdfFontFamily.helvetica, 16, style: PdfFontStyle.bold);
      final bodyFont = PdfStandardFont(PdfFontFamily.helvetica, 11);

      page.graphics.drawString('Chapter $i: Engineering Specification and Architecture', h1Font,
          bounds: const Rect.fromLTWH(30, 30, 500, 30));
      page.graphics.drawString('1.$i Executive Overview & Core Requirements', h2Font,
          bounds: const Rect.fromLTWH(30, 70, 500, 25));

      final text1 = 'This document section covers the structural verification for page $i. '
          'Doc View provides client-side high performance document viewing, client-side '
          'rendering, offline manipulation, and strictly local privacy-first conversions. '
          'All operations execute entirely on device within the local sandbox without '
          'requiring network connectivity or remote cloud services. '
          'Data safety is paramount: atomic writes guarantee that partial operations '
          'never corrupt original source files.';
      page.graphics.drawString(text1, bodyFont, bounds: const Rect.fromLTWH(30, 105, 520, 80));

      page.graphics.drawString('1.$i.1 Detailed Functional Specifications', h2Font,
          bounds: const Rect.fromLTWH(30, 195, 500, 25));

      final text2 = 'Paragraph extraction decomposes content by lines, identifying headings through '
          'font size heuristics (>1.8x median font size for Heading 1, >=1.3x for Heading 2). '
          'Runs are extracted with bold, italic and RTL attributes preserved. '
          'Furthermore, page breaks are inserted when requested by the user, providing clean '
          'pagination matching the source document structure.';
      page.graphics.drawString(text2, bodyFont, bounds: const Rect.fromLTWH(30, 230, 520, 80));

      page.graphics.drawString('• Point A: Zero network data transmission.', bodyFont,
          bounds: const Rect.fromLTWH(45, 320, 500, 20));
      page.graphics.drawString('• Point B: Strictly atomic file system output with temporary staging.', bodyFont,
          bounds: const Rect.fromLTWH(45, 345, 500, 20));
      page.graphics.drawString('• Point C: Bi-directional RTL text detection for Arabic & Hebrew.', bodyFont,
          bounds: const Rect.fromLTWH(45, 370, 500, 20));
      page.graphics.drawString('• Point D: 100% compliant Microsoft OpenXML (.docx) ZIP structure.', bodyFont,
          bounds: const Rect.fromLTWH(45, 395, 500, 20));

      final grid = PdfGrid();
      grid.columns.add(count: 3);
      grid.headers.add(1);
      final headerRow = grid.headers[0];
      headerRow.cells[0].value = 'Metric ID';
      headerRow.cells[1].value = 'Target Threshold';
      headerRow.cells[2].value = 'Measured Value';
      for (int r = 1; r <= 4; r++) {
        final row = grid.rows.add();
        row.cells[0].value = 'M-$i-$r';
        row.cells[1].value = '${r * 25} ms';
        row.cells[2].value = '${r * 18} ms (PASS)';
      }
      grid.draw(page: page, bounds: const Rect.fromLTWH(30, 430, 520, 150));

      page.graphics.drawString('Page $i of 20 - Doc View Certified Test Document', bodyFont,
          bounds: const Rect.fromLTWH(180, 750, 300, 20));
    }
    final bytes20 = doc20.saveSync();
    doc20.dispose();
    await File('test/fixtures/sample_20p.pdf').writeAsBytes(bytes20);
    print('Generated sample_20p.pdf (${bytes20.length} bytes)');

    // 5. Scanned / empty text PDF
    final docScanned = PdfDocument();
    for (int i = 0; i < 3; i++) {
      final page = docScanned.pages.add();
      final pen = PdfPen(PdfColor(180, 180, 180), width: 2);
      page.graphics.drawRectangle(pen: pen, bounds: const Rect.fromLTWH(50, 50, 495, 700));
      page.graphics.drawLine(pen, const Offset(50, 50), const Offset(545, 750));
      page.graphics.drawLine(pen, const Offset(545, 50), const Offset(50, 750));
    }
    final bytesScanned = docScanned.saveSync();
    docScanned.dispose();
    await File('test/fixtures/sample_scanned.pdf').writeAsBytes(bytesScanned);
    print('Generated sample_scanned.pdf (${bytesScanned.length} bytes)');

    // 6. Password protected PDF
    final docEnc = PdfDocument();
    final pEnc = docEnc.pages.add();
    pEnc.graphics.drawString(
      'Top Secret Document Content - Protected with Password',
      PdfStandardFont(PdfFontFamily.helvetica, 16, style: PdfFontStyle.bold),
      bounds: const Rect.fromLTWH(50, 100, 500, 30),
    );
    docEnc.security.userPassword = 'secret123';
    final bytesEnc = docEnc.saveSync();
    docEnc.dispose();
    await File('test/fixtures/sample_encrypted.pdf').writeAsBytes(bytesEnc);
    print('Generated sample_encrypted.pdf (${bytesEnc.length} bytes)');

    // 7. 300-page PDF
    final doc300 = PdfDocument();
    final font300H1 = PdfStandardFont(PdfFontFamily.helvetica, 18, style: PdfFontStyle.bold);
    final font300Body = PdfStandardFont(PdfFontFamily.helvetica, 10);
    for (int i = 1; i <= 300; i++) {
      final page = doc300.pages.add();
      page.graphics.drawString('Section $i: High Volume Stress Record', font300H1,
          bounds: const Rect.fromLTWH(40, 40, 500, 25));
      page.graphics.drawString(
        'Page $i of 300. This document validates stress performance, large page count handling, '
        'and memory stability in client-side isolate extraction.',
        font300Body,
        bounds: const Rect.fromLTWH(40, 75, 500, 50),
      );
    }
    final bytes300 = doc300.saveSync();
    doc300.dispose();
    await File('test/fixtures/sample_300p.pdf').writeAsBytes(bytes300);
    print('Generated sample_300p.pdf (${bytes300.length} bytes, 300 pages)');

    // 8. Convert test PDFs and assert success
    const conv = PdfToWordService();

    final docxHindi = await conv.convertPdfToWord(
      sourcePath: 'test/fixtures/hindi_doc.pdf',
      outputPath: 'test/fixtures/hindi_doc.docx',
    );
    expect(File(docxHindi).existsSync(), isTrue);

    final docxArabic = await conv.convertPdfToWord(
      sourcePath: 'test/fixtures/arabic_doc.pdf',
      outputPath: 'test/fixtures/arabic_doc.docx',
    );
    expect(File(docxArabic).existsSync(), isTrue);

    final docx2Col = await conv.convertPdfToWord(
      sourcePath: 'test/fixtures/twocolumn_doc.pdf',
      outputPath: 'test/fixtures/twocolumn_doc.docx',
    );
    expect(File(docx2Col).existsSync(), isTrue);

    final docx20p = await conv.convertPdfToWord(
      sourcePath: 'test/fixtures/sample_20p.pdf',
      outputPath: 'test/fixtures/sample_20p.docx',
    );
    expect(File(docx20p).existsSync(), isTrue);

    print('All 7 test PDFs generated and conversions verified successfully!');
  });
}
