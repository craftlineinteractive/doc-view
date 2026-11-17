import 'package:flutter/widgets.dart';
import 'package:path/path.dart' as p;
import 'package:pdfrx/pdfrx.dart' as pdfrx;

import '../../../core/errors/app_errors.dart';
import '../../../core/utils/page_range_parser.dart';
import '../../models/doc_file.dart';
import 'pdf_output_service.dart';

/// Thrown when PDF splitting cannot proceed due to invalid, damaged, or encrypted files.
class PdfSplitException implements Exception {
  final PdfSplitErrorReason reason;
  final String? fileName;
  final int? start;
  final int? end;
  final String? details;

  const PdfSplitException(
    this.reason, {
    this.fileName,
    this.start,
    this.end,
    this.details,
  });

  /// Backward-compatible string message.
  String get message => reason.name;

  String localizedMessage(BuildContext context) =>
      reason.localizedMessage(
        context,
        fileName: fileName,
        start: start,
        end: end,
        details: details,
      );

  @override
  String toString() =>
      'PdfSplitException: $reason ($fileName, $start-$end, $details)';
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
      throw const PdfSplitException(PdfSplitErrorReason.noRangesSpecified);
    }

    final fileName = p.basename(pdfPath);
    final pdfrx.PdfDocument sourceDoc;

    try {
      sourceDoc = await pdfrx.PdfDocument.openFile(pdfPath);
    } catch (_) {
      throw PdfSplitException(
        PdfSplitErrorReason.passwordProtectedOrDamaged,
        fileName: fileName,
      );
    }

    if (sourceDoc.isEncrypted) {
      await sourceDoc.dispose();
      throw PdfSplitException(
        PdfSplitErrorReason.passwordProtectedOrDamaged,
        fileName: fileName,
      );
    }

    final createdFiles = <DocFile>[];
    final totalRanges = ranges.length;

    try {
      for (var i = 0; i < totalRanges; i++) {
        final range = ranges[i];
        // Ensure range is within source page bounds (1-based index)
        if (range.start < 1 || range.end > sourceDoc.pages.length) {
          throw PdfSplitException(
            PdfSplitErrorReason.rangeOutOfBounds,
            fileName: fileName,
            start: range.start,
            end: range.end,
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
    } catch (e) {
      if (e is PdfSplitException) rethrow;
      throw PdfSplitException(
        PdfSplitErrorReason.splitFailed,
        details: e.toString(),
      );
    } finally {
      await sourceDoc.dispose();
    }
  }
}

