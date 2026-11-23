import 'dart:io';
import 'dart:ui' show Rect, Offset;
import 'package:flutter_test/flutter_test.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:docview/data/services/convert/pdf_to_word_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Generate G6 Test PDFs for QA', () async {
    final outDir = Directory('test/fixtures');
    if (!outDir.existsSync()) {
      outDir.createSync(recursive: true);
    }

    // 1. Generate 20-page text-heavy PDF
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
          'font size heuristics (>=1.8x median font size for Heading 1, >=1.3x for Heading 2). '
          'Runs are extracted with bold, italic and RTL attributes preserved. '
          'Furthermore, page breaks are inserted when requested by the user, providing clean '
          'pagination matching the source document structure.';
      page.graphics.drawString(text2, bodyFont, bounds: const Rect.fromLTWH(30, 230, 520, 80));

      // Draw bullet points
      page.graphics.drawString('• Point A: Zero network data transmission.', bodyFont,
          bounds: const Rect.fromLTWH(45, 320, 500, 20));
      page.graphics.drawString('• Point B: Strictly atomic file system output with temporary staging.', bodyFont,
          bounds: const Rect.fromLTWH(45, 345, 500, 20));
      page.graphics.drawString('• Point C: Bi-directional RTL text detection for Arabic & Hebrew.', bodyFont,
          bounds: const Rect.fromLTWH(45, 370, 500, 20));
      page.graphics.drawString('• Point D: 100% compliant Microsoft OpenXML (.docx) ZIP structure.', bodyFont,
          bounds: const Rect.fromLTWH(45, 395, 500, 20));

      // Draw a small table grid
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
    final file20 = File('test/fixtures/sample_20p.pdf');
    await file20.writeAsBytes(bytes20);
    expect(bytes20.length, greaterThan(10000));

    // 2. Generate scanned / no text PDF (3 pages of empty graphics / no text)
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
    final fileScanned = File('test/fixtures/sample_scanned.pdf');
    await fileScanned.writeAsBytes(bytesScanned);
    expect(bytesScanned.length, greaterThan(1000));

    // 3. Generate password protected PDF
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
    final fileEnc = File('test/fixtures/sample_encrypted.pdf');
    await fileEnc.writeAsBytes(bytesEnc);
    expect(bytesEnc.length, greaterThan(1000));

    // 4. Convert 20-page PDF to standard .docx document
    const convService = PdfToWordService();
    final docxPath = await convService.convertPdfToWord(
      sourcePath: file20.path,
      outputPath: 'test/fixtures/sample_20p.docx',
      insertPageBreaks: true,
    );
    expect(File(docxPath).existsSync(), isTrue);
  });
}
