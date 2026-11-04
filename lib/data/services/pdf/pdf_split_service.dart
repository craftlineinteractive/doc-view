import 'package:path/path.dart' as p;
import 'package:pdfrx/pdfrx.dart' as pdfrx;

import '../../../core/utils/page_range_parser.dart';
import '../../models/doc_file.dart';
import 'pdf_output_service.dart';

/// Thrown when PDF splitting cannot proceed due to invalid, damaged, or encrypted files.
class PdfSplitException implements Exception {
  const PdfSplitException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Service that extracts specified page ranges from a PDF document into distinct PDF files.
class PdfSplitService {
  PdfSplitService({required this.outputService});

  final PdfOutputService outputService;

  /// Splits [pdfPath] into multiple PDF files matching each range in [ranges].
  ///
  /// - File names are formed as `${namePrefix}_page_${start}` or `${namePrefix}_pages_${start}_${end}`.
  /// - Throws [PdfSplitException] if the source PDF is password-protected or corrupt.
  /// - Preserves vector graphics and text without rasterization.
  Future<List<DocFile>> split(
    String pdfPath,
    List<PageRange> ranges, {
    required String namePrefix,
    void Function(int done, int total)? onProgress,
  }) async {
    if (ranges.isEmpty) {
      throw const PdfSplitException('Please specify at least one page range');
    }

    final fileName = p.basename(pdfPath);
    final pdfrx.PdfDocument sourceDoc;

    try {
      sourceDoc = await pdfrx.PdfDocument.openFile(pdfPath);
    } catch (_) {
      throw PdfSplitException('$fileName is password-protected or damaged');
    }

    if (sourceDoc.isEncrypted) {
      await sourceDoc.dispose();
      throw PdfSplitException('$fileName is password-protected or damaged');
    }

    final createdFiles = <DocFile>[];
    final totalRanges = ranges.length;

    try {
      for (var i = 0; i < totalRanges; i++) {
        final range = ranges[i];
        // Ensure range is within source page bounds (1-based index)
        if (range.start < 1 || range.end > sourceDoc.pages.length) {
          throw PdfSplitException(
            'Range ${range.toString()} is out of bounds (1 - ${sourceDoc.pages.length})',
          );
        }

        final slice = sourceDoc.pages.sublist(range.start - 1, range.end);
        final splitDoc = await pdfrx.PdfDocument.createNew(
          sourceName: 'split_${range.start}_${range.end}',
        );
        splitDoc.pages = slice;

        final encodedBytes = await splitDoc.encodePdf();
        await splitDoc.dispose();

        final baseOutputName = range.start == range.end
            ? '${namePrefix}_page_${range.start}'
            : '${namePrefix}_pages_${range.start}_${range.end}';

        final targetFile = await outputService.uniqueFile(baseOutputName);
        await targetFile.writeAsBytes(encodedBytes);

        final docFile = await outputService.registerOutput(targetFile);
        createdFiles.add(docFile);

        onProgress?.call(i + 1, totalRanges);
      }

      return createdFiles;
    } finally {
      await sourceDoc.dispose();
    }
  }
}

