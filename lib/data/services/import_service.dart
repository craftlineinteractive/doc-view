import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../core/constants/file_types.dart';
import '../models/doc_file.dart';
import '../repositories/file_repository.dart';

/// Service managing manual file imports and iOS Application Documents folder synchronization.
class ImportService {
  ImportService({FileRepository? repository})
      : _repository = repository ?? FileRepository();

  final FileRepository _repository;

  /// Prompts the user to pick files and copies them into the permanent app storage.
  /// Returns the number of successfully imported files.
  Future<int> importFiles() async {
    final pickedFiles = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: supportedFileExtensions.toList(),
    );

    if (pickedFiles.isEmpty) {
      return 0;
    }

    final docsDir = await getApplicationDocumentsDirectory();
    final importedDir = Directory(p.join(docsDir.path, 'imported'));
    if (!importedDir.existsSync()) {
      await importedDir.create(recursive: true);
    }

    final importedDocFiles = <DocFile>[];

    for (final pickedFile in pickedFiles) {
      final sourcePath = pickedFile.path;
      if (sourcePath == null) continue;

      final originalName = pickedFile.name;
      final uniquePath =
          _generateUniqueFilePath(importedDir.path, originalName);

      try {
        final source = File(sourcePath);
        final destination = await source.copy(uniquePath);
        final stat = await destination.stat();

        final fileName = p.basename(uniquePath);
        final ext = p.extension(uniquePath).replaceFirst('.', '').toLowerCase();
        final category = categoryFromPath(uniquePath) ?? FileCategory.other;

        importedDocFiles.add(
          DocFile(
            path: destination.path,
            name: fileName,
            extension: ext,
            sizeBytes: stat.size,
            modified: stat.modified,
            category: category,
            isImported: true,
          ),
        );
      } catch (_) {
        // Individual file copy error, skip and continue
      }
    }

    if (importedDocFiles.isNotEmpty) {
      await _repository.upsertBatch(importedDocFiles);
    }

    return importedDocFiles.length;
  }

  /// Scans the iOS Application Documents directory for documents placed via the iOS Files app or iTunes.
  Future<int> scanAppDocuments() async {
    try {
      final docsDir = await getApplicationDocumentsDirectory();
      if (!docsDir.existsSync()) {
        return 0;
      }

      final entities = docsDir.listSync(recursive: true, followLinks: false);
      final discoveredFiles = <DocFile>[];

      for (final entity in entities) {
        if (entity is File) {
          final filePath = entity.path;
          final category = categoryFromPath(filePath);

          if (category != null) {
            try {
              final stat = entity.statSync();
              final name = p.basename(filePath);
              final ext =
                  p.extension(filePath).replaceFirst('.', '').toLowerCase();

              discoveredFiles.add(
                DocFile(
                  path: filePath,
                  name: name,
                  extension: ext,
                  sizeBytes: stat.size,
                  modified: stat.modified,
                  category: category,
                  isImported: true,
                ),
              );
            } catch (_) {}
          }
        }
      }

      if (discoveredFiles.isNotEmpty) {
        await _repository.upsertBatch(discoveredFiles);
      }

      return discoveredFiles.length;
    } catch (_) {
      return 0;
    }
  }

  /// Generates a unique file path in [targetDirectoryPath], appending ` (N)` if a collision exists.
  String _generateUniqueFilePath(
    String targetDirectoryPath,
    String originalFileName,
  ) {
    String candidatePath = p.join(targetDirectoryPath, originalFileName);
    if (!File(candidatePath).existsSync()) {
      return candidatePath;
    }

    final base = p.basenameWithoutExtension(originalFileName);
    final ext = p.extension(originalFileName);
    int counter = 1;

    while (
        File(p.join(targetDirectoryPath, '$base ($counter)$ext')).existsSync()) {
      counter++;
    }

    return p.join(targetDirectoryPath, '$base ($counter)$ext');
  }
}
