import 'dart:io';

import 'package:pdfrx/pdfrx.dart';

import '../../../core/errors/app_errors.dart';

/// Descriptor for a single page in a PDF editing session.
class PdfPageEditSpec {
  /// Path to the source PDF file where this page originates.
  final String sourcePath;

  /// 0-based page index in the source PDF file.
  final int sourcePageIndex;

  /// Additional rotation in degrees (0, 90, 180, 270) added to the page.
  final int rotationDegrees;

  const PdfPageEditSpec({
    required this.sourcePath,
    required this.sourcePageIndex,
    this.rotationDegrees = 0,
  });

  PdfPageEditSpec copyWith({
    String? sourcePath,
    int? sourcePageIndex,
    int? rotationDegrees,
  }) {
    return PdfPageEditSpec(
      sourcePath: sourcePath ?? this.sourcePath,
      sourcePageIndex: sourcePageIndex ?? this.sourcePageIndex,
      rotationDegrees: rotationDegrees ?? this.rotationDegrees,
    );
  }

  Map<String, dynamic> toMap() => {
        'sourcePath': sourcePath,
        'sourcePageIndex': sourcePageIndex,
        'rotationDegrees': rotationDegrees,
      };

  factory PdfPageEditSpec.fromMap(Map<String, dynamic> map) => PdfPageEditSpec(
        sourcePath: map['sourcePath'] as String,
        sourcePageIndex: map['sourcePageIndex'] as int,
        rotationDegrees: (map['rotationDegrees'] as int?) ?? 0,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PdfPageEditSpec &&
          runtimeType == other.runtimeType &&
          sourcePath == other.sourcePath &&
          sourcePageIndex == other.sourcePageIndex &&
          rotationDegrees == other.rotationDegrees;

  @override
  int get hashCode => Object.hash(sourcePath, sourcePageIndex, rotationDegrees);

  @override
  String toString() =>
      'PdfPageEditSpec($sourcePath, index: $sourcePageIndex, rot: $rotationDegrees°)';
}

/// Service that executes PDF page modifications (reorder, rotate, delete, insert, extract)
/// in a background isolate using pdfrx native PDFium bindings.
class PdfPageEditService {
  const PdfPageEditService();

  /// Reads and returns the total number of pages in [filePath].
  Future<int> getPageCount(String filePath) async {
    final file = File(filePath);
    if (!file.existsSync()) {
      throw PdfPageEditException(
        PdfPageEditErrorReason.sourceFileNotFound,
        filePath,
      );
    }

    try {
      final doc = await PdfDocument.openFile(filePath);
      final count = doc.pages.length;
      doc.dispose();
      return count;
    } catch (e) {
      throw PdfPageEditException(
        PdfPageEditErrorReason.passwordProtectedOrCorrupt,
        'Failed to read page count of $filePath: $e',
      );
    }
  }

  /// Saves the edited sequence of [pages] to [outputPath].
  ///
  /// If [replaceOriginal] is true, writes to a temporary file first and atomically
  /// replaces [originalPath] (or [outputPath] if [originalPath] is null).
  Future<File> saveDocument({
    required List<PdfPageEditSpec> pages,
    required String outputPath,
    bool replaceOriginal = false,
    String? originalPath,
  }) async {
    if (pages.isEmpty) {
      throw const PdfPageEditException(PdfPageEditErrorReason.allPagesDeleted);
    }

    final params = _PdfEditWorkerParams(
      pages: pages.map((p) => p.toMap()).toList(growable: false),
      outputPath: outputPath,
      replaceOriginal: replaceOriginal,
      originalPath: originalPath ?? (replaceOriginal ? outputPath : null),
    );

    try {
      final finalPath = await _executeEditWorker(params);
      return File(finalPath);
    } on PdfPageEditException {
      rethrow;
    } catch (e) {
      throw PdfPageEditException(
        PdfPageEditErrorReason.saveFailed,
        e.toString(),
      );
    }
  }

  /// Extracts the given [pages] into a new PDF document at [outputPath].
  Future<File> extractPages({
    required List<PdfPageEditSpec> pages,
    required String outputPath,
  }) async {
    return saveDocument(
      pages: pages,
      outputPath: outputPath,
      replaceOriginal: false,
    );
  }
}

class _PdfEditWorkerParams {
  final List<Map<String, dynamic>> pages;
  final String outputPath;
  final bool replaceOriginal;
  final String? originalPath;

  const _PdfEditWorkerParams({
    required this.pages,
    required this.outputPath,
    this.replaceOriginal = false,
    this.originalPath,
  });
}

Future<String> _executeEditWorker(_PdfEditWorkerParams params) async {
  if (params.pages.isEmpty) {
    throw const PdfPageEditException(PdfPageEditErrorReason.allPagesDeleted);
  }

  final sourceDocs = <String, PdfDocument>{};
  PdfDocument? outputDoc;
  final tempOutputFile = File('${params.outputPath}.tmp');

  try {
    for (final pageMap in params.pages) {
      final path = pageMap['sourcePath'] as String;
      if (!sourceDocs.containsKey(path)) {
        final file = File(path);
        if (!file.existsSync()) {
          throw PdfPageEditException(
            PdfPageEditErrorReason.sourceFileNotFound,
            path,
          );
        }
        try {
          final doc = await PdfDocument.openFile(path);
          sourceDocs[path] = doc;
        } catch (e) {
          throw PdfPageEditException(
            PdfPageEditErrorReason.passwordProtectedOrCorrupt,
            'Could not open $path: $e',
          );
        }
      }
    }

    final targetPages = <PdfPage>[];
    for (final pageMap in params.pages) {
      final path = pageMap['sourcePath'] as String;
      final index = pageMap['sourcePageIndex'] as int;
      final rotDeg = (pageMap['rotationDegrees'] as int?) ?? 0;
      final doc = sourceDocs[path]!;
      if (index < 0 || index >= doc.pages.length) {
        throw PdfPageEditException(
          PdfPageEditErrorReason.unsupportedSourcePage,
          'Page index $index out of bounds for $path (length: ${doc.pages.length})',
        );
      }
      var page = doc.pages[index];
      if (rotDeg != 0) {
        final baseRot = _rotationToDegrees(page.rotation);
        final totalRot = (baseRot + rotDeg) % 360;
        page = page.rotatedTo(_degreesToRotation(totalRot));
      }
      targetPages.add(page);
    }

    if (tempOutputFile.existsSync()) {
      tempOutputFile.deleteSync();
    }

    outputDoc = await PdfDocument.createNew(sourceName: tempOutputFile.path);
    outputDoc.pages = targetPages;
    final bytes = await outputDoc.encodePdf();
    outputDoc.dispose();
    outputDoc = null;

    // Release source document file handles before renaming (required on Windows)
    for (final doc in sourceDocs.values) {
      doc.dispose();
    }
    sourceDocs.clear();

    await tempOutputFile.writeAsBytes(bytes, flush: true);

    if (params.replaceOriginal && params.originalPath != null) {
      final originalFile = File(params.originalPath!);
      if (originalFile.existsSync()) {
        final backup = File('${params.originalPath!}.bak');
        if (backup.existsSync()) backup.deleteSync();
        originalFile.renameSync(backup.path);
        try {
          tempOutputFile.renameSync(originalFile.path);
          if (backup.existsSync()) backup.deleteSync();
        } catch (e) {
          if (backup.existsSync()) {
            backup.renameSync(originalFile.path);
          }
          rethrow;
        }
      } else {
        tempOutputFile.renameSync(originalFile.path);
      }
      return params.originalPath!;
    } else {
      final targetFile = File(params.outputPath);
      if (targetFile.existsSync()) {
        targetFile.deleteSync();
      }
      tempOutputFile.renameSync(targetFile.path);
      return params.outputPath;
    }
  } catch (e) {
    if (tempOutputFile.existsSync()) {
      try {
        tempOutputFile.deleteSync();
      } catch (_) {}
    }
    if (e is PdfPageEditException) {
      rethrow;
    }
    throw PdfPageEditException(
      PdfPageEditErrorReason.saveFailed,
      e.toString(),
    );
  } finally {
    outputDoc?.dispose();
    for (final doc in sourceDocs.values) {
      doc.dispose();
    }
  }
}

int _rotationToDegrees(PdfPageRotation rotation) {
  switch (rotation) {
    case PdfPageRotation.none:
      return 0;
    case PdfPageRotation.clockwise90:
      return 90;
    case PdfPageRotation.clockwise180:
      return 180;
    case PdfPageRotation.clockwise270:
      return 270;
  }
}

PdfPageRotation _degreesToRotation(int degrees) {
  final normalized = ((degrees % 360) + 360) % 360;
  switch (normalized) {
    case 90:
      return PdfPageRotation.clockwise90;
    case 180:
      return PdfPageRotation.clockwise180;
    case 270:
      return PdfPageRotation.clockwise270;
    default:
      return PdfPageRotation.none;
  }
}
