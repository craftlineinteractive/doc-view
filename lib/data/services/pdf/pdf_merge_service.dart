import 'package:path/path.dart' as p;
import 'package:pdfrx/pdfrx.dart' as pdfrx;

import '../../models/doc_file.dart';
import 'pdf_output_service.dart';

/// Thrown when PDF merging cannot proceed due to invalid, damaged, or encrypted files.
class PdfMergeException implements Exception {
  const PdfMergeException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Service that combines multiple PDF documents in sequential order using native PDF page manipulation.
class PdfMergeService {
  PdfMergeService({required this.outputService});

  final PdfOutputService outputService;

  /// Merges all pages from [pdfPaths] in the supplied order into a single PDF titled [name].
  ///
  /// - Throws [PdfMergeException] if any PDF is password-protected or corrupted.
  /// - Reports progress via [onProgress] as files are loaded and prepared.
  /// - Never rasterizes pages into images; preserves original vector text and layouts.
  Future<DocFile> merge(
    List<String> pdfPaths, {
    required String name,
    void Function(int done, int total)? onProgress,
  }) async {
    if (pdfPaths.length < 2) {
      throw const PdfMergeException('Please select at least 2 PDF files to merge');
    }

    final openDocs = <pdfrx.PdfDocument>[];
    final allPages = <pdfrx.PdfPage>[];

    try {
      final total = pdfPaths.length;
      for (var i = 0; i < total; i++) {
        final path = pdfPaths[i];
        final fileName = p.basename(path);
        final pdfrx.PdfDocument doc;

        try {
          doc = await pdfrx.PdfDocument.openFile(path);
        } catch (_) {
          throw PdfMergeException('$fileName is password-protected or damaged');
        }

        if (doc.isEncrypted) {
          await doc.dispose();
          throw PdfMergeException('$fileName is password-protected or damaged');
        }

        openDocs.add(doc);
        allPages.addAll(doc.pages);
        onProgress?.call(i + 1, total);
      }

      if (allPages.isEmpty) {
        throw const PdfMergeException('Selected documents contain no pages');
      }

      final mergedDoc = await pdfrx.PdfDocument.createNew(
        sourceName: 'merged_document',
      );
      mergedDoc.pages = allPages;

      final encodedBytes = await mergedDoc.encodePdf();
      await mergedDoc.dispose();

      final targetFile = await outputService.uniqueFile(name);
      await targetFile.writeAsBytes(encodedBytes);

      return outputService.registerOutput(targetFile);
    } finally {
      for (final doc in openDocs) {
        try {
          await doc.dispose();
        } catch (_) {}
      }
    }
  }
}

