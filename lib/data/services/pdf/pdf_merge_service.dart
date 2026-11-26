import 'package:flutter/widgets.dart';
import 'package:path/path.dart' as p;
import 'package:pdfrx/pdfrx.dart' as pdfrx;

import '../../../core/errors/app_errors.dart';
import '../../../core/utils/file_ingest_helper.dart';
import '../../models/doc_file.dart';
import 'pdf_output_service.dart';

/// Thrown when PDF merging cannot proceed due to invalid, damaged, or encrypted files.
class PdfMergeException implements Exception {
  final PdfMergeErrorReason reason;
  final String? fileName;
  final String? details;

  const PdfMergeException(
    this.reason, {
    this.fileName,
    this.details,
  });

  /// Backward-compatible string message.
  String get message => reason.name;

  String localizedMessage(BuildContext context) =>
      reason.localizedMessage(context, fileName: fileName, details: details);

  @override
  String toString() => 'PdfMergeException: $reason ($fileName - $details)';
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
      throw const PdfMergeException(PdfMergeErrorReason.insufficientFiles);
    }

    final openDocs = <pdfrx.PdfDocument>[];
    final allPages = <pdfrx.PdfPage>[];

    try {
      final safePaths = await FileIngestHelper.ingestAll(pdfPaths, subDir: 'merge_inputs');
      final total = safePaths.length;
      for (var i = 0; i < total; i++) {
        final path = safePaths[i];
        final fileName = p.basename(pdfPaths[i]);
        final pdfrx.PdfDocument doc;

        try {
          doc = await pdfrx.PdfDocument.openFile(path);
        } catch (_) {
          throw PdfMergeException(
            PdfMergeErrorReason.passwordProtectedOrDamaged,
            fileName: fileName,
          );
        }

        if (doc.isEncrypted) {
          await doc.dispose();
          throw PdfMergeException(
            PdfMergeErrorReason.passwordProtectedOrDamaged,
            fileName: fileName,
          );
        }

        openDocs.add(doc);
        allPages.addAll(doc.pages);
        onProgress?.call(i + 1, total);
      }

      if (allPages.isEmpty) {
        throw const PdfMergeException(PdfMergeErrorReason.noPages);
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
    } catch (e) {
      if (e is PdfMergeException) rethrow;
      throw PdfMergeException(
        PdfMergeErrorReason.mergeFailed,
        details: e.toString(),
      );
    } finally {
      for (final doc in openDocs) {
        try {
          await doc.dispose();
        } catch (_) {}
      }
    }
  }
}

