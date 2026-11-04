import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../../core/constants/file_types.dart';
import '../../models/doc_file.dart';
import '../../repositories/file_repository.dart';
import '../../../features/providers/providers.dart';

/// Service managing the creation directory, sanitized naming, and indexing of generated PDFs.
class PdfOutputService {
  PdfOutputService({
    required this.repository,
    required this.actionsController,
  });

  final FileRepository repository;
  final FileActionsController actionsController;

  /// Returns the `created/` output directory in application documents, creating it if missing.
  Future<Directory> getOutputDir() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final createdDir = Directory(p.join(docsDir.path, 'created'));
    if (!await createdDir.exists()) {
      await createdDir.create(recursive: true);
    }
    return createdDir;
  }

  /// Sanitizes a file name by removing illegal filesystem characters: / \ : * ? " < > |
  static String sanitizeFileName(String name) {
    var sanitized = name.replaceAll(RegExp(r'[\\/:*?"<>|]'), '').trim();
    // Strip trailing .pdf or .PDF if user typed it
    if (sanitized.toLowerCase().endsWith('.pdf')) {
      sanitized = sanitized.substring(0, sanitized.length - 4).trim();
    }
    if (sanitized.isEmpty) {
      return 'Document';
    }
    return sanitized;
  }

  /// Finds a non-colliding [File] in [dir] with the given [baseName], appending " (1)", " (2)" as needed.
  static File uniqueFileInDir(Directory dir, String baseName) {
    final cleanName = sanitizeFileName(baseName);
    var target = File(p.join(dir.path, '$cleanName.pdf'));
    var counter = 1;
    while (target.existsSync()) {
      target = File(p.join(dir.path, '$cleanName ($counter).pdf'));
      counter++;
    }
    return target;
  }

  /// Returns a non-colliding [File] in the application's `created/` directory.
  Future<File> uniqueFile(String baseName) async {
    final dir = await getOutputDir();
    return uniqueFileInDir(dir, baseName);
  }

  /// Builds a [DocFile] for the newly created PDF, upserts it into the SQLite repository,
  /// invalidates file list providers via [FileActionsController], and returns the persisted record.
  Future<DocFile> registerOutput(File file) async {
    final stat = await file.stat();
    final fileName = p.basename(file.path);

    final doc = DocFile(
      path: file.path,
      name: fileName,
      extension: 'pdf',
      sizeBytes: stat.size,
      modified: stat.modified,
      category: FileCategory.pdf,
      isBookmarked: false,
      lastOpened: null,
      isImported: true,
    );

    await repository.upsertBatch([doc]);
    actionsController.invalidateAll();

    final persisted = await repository.getFileByPath(file.path);
    return persisted ?? doc;
  }
}

