import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:docview/features/tools/create_pdf/create_pdf_service.dart';
import 'package:docview/features/tools/create_pdf/paper_template.dart';

void main() {
  test('Generate 7 QA template PDFs and 100-page Graph benchmark', () async {
    final outDir = Directory('build/qa_pdfs');
    if (!await outDir.exists()) {
      await outDir.create(recursive: true);
    }

    final configs = [
      (
        'qa_blank_a4_white.pdf',
        PaperTemplate.blank,
        PaperPageSize.a4,
        PaperOrientation.portrait,
        PaperColorSwatch.white,
        1,
      ),
      (
        'qa_line1_letter_cream.pdf',
        PaperTemplate.line1,
        PaperPageSize.letter,
        PaperOrientation.portrait,
        PaperColorSwatch.cream,
        2,
      ),
      (
        'qa_line2_legal_mint.pdf',
        PaperTemplate.line2,
        PaperPageSize.legal,
        PaperOrientation.landscape,
        PaperColorSwatch.lightMint,
        3,
      ),
      (
        'qa_notebook_a4_yellow.pdf',
        PaperTemplate.notebook,
        PaperPageSize.a4,
        PaperOrientation.portrait,
        PaperColorSwatch.lightYellow,
        5,
      ),
      (
        'qa_notebook_1p.pdf',
        PaperTemplate.notebook,
        PaperPageSize.a4,
        PaperOrientation.portrait,
        PaperColorSwatch.lightYellow,
        1,
      ),
      (
        'qa_notebook_100p.pdf',
        PaperTemplate.notebook,
        PaperPageSize.a4,
        PaperOrientation.portrait,
        PaperColorSwatch.lightYellow,
        100,
      ),
      (
        'qa_cornell_a4_gray.pdf',
        PaperTemplate.cornell,
        PaperPageSize.a4,
        PaperOrientation.landscape,
        PaperColorSwatch.lightGray,
        3,
      ),
      (
        'qa_grid_a5_pink.pdf',
        PaperTemplate.grid,
        PaperPageSize.a5,
        PaperOrientation.portrait,
        PaperColorSwatch.lightPink,
        4,
      ),
      (
        'qa_graph_a3_white_100p.pdf',
        PaperTemplate.graph,
        PaperPageSize.a3,
        PaperOrientation.portrait,
        PaperColorSwatch.white,
        100,
      ),
    ];

    // QA PDF generation verification
    for (final (name, template, pageSize, orientation, swatch, count) in configs) {
      final sw = Stopwatch()..start();
      final bytes = await compileTemplatePdfInWorker(
        CreatePdfParams(
          templateIndex: template.index,
          pageSizeIndex: pageSize.index,
          orientationIndex: orientation.index,
          colorValue: swatch.colorValue,
          pageCount: count,
          title: name.replaceAll('.pdf', ''),
        ),
      );
      sw.stop();

      final file = File('${outDir.path}/$name');
      await file.writeAsBytes(bytes);
      expect(bytes.lengthInBytes, greaterThan(100));
    }
  });
}
