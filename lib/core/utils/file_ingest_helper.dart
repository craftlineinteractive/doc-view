import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'app_log.dart';

/// Helper to ingest input files and URIs into the app-private cache
/// so all tools function safely without requiring All Files access.
class FileIngestHelper {
  static const MethodChannel _openWithChannel =
      MethodChannel('com.craftlineinteractive.docview/open_with');

  /// Optional override for temporary cache directory in unit tests.
  static Directory? tempDirOverride;

  /// Resolves an input path or URI (content://, file://, or plain filesystem path)
  /// and copies the file into the app-private cache directory.
  ///
  /// Returns a clean, locally accessible [File].
  static Future<File> ingestToCache(
    String rawPathOrUri, {
    String subDir = 'tool_inputs',
  }) async {
    if (rawPathOrUri.isEmpty) {
      throw const FileSystemException('Path cannot be empty');
    }

    // 1. Handle content:// URIs via native platform channel
    if (rawPathOrUri.startsWith('content://')) {
      try {
        final copiedPath = await _openWithChannel.invokeMethod<String>(
          'copyUri',
          {'uri': rawPathOrUri},
        );
        if (copiedPath != null && copiedPath.isNotEmpty) {
          final file = File(copiedPath);
          if (await file.exists()) {
            return file;
          }
        }
      } catch (e, st) {
        AppLog.e('FileIngest', 'content_uri_failed', e, st);
      }
    }

    // 2. Normalize file:// URIs
    String cleanPath = rawPathOrUri;
    if (rawPathOrUri.startsWith('file://')) {
      try {
        final uri = Uri.tryParse(rawPathOrUri);
        if (uri != null) {
          cleanPath = uri.toFilePath();
        } else {
          cleanPath = rawPathOrUri.replaceFirst('file://', '');
        }
      } catch (_) {
        cleanPath = rawPathOrUri.replaceFirst('file://', '');
      }
    }

    final sourceFile = File(cleanPath);

    // 3. Stage into app-private cache
    try {
      final Directory tempDir;
      if (tempDirOverride != null) {
        tempDir = tempDirOverride!;
      } else if (Platform.environment.containsKey('FLUTTER_TEST')) {
        tempDir = Directory.systemTemp;
      } else {
        tempDir = await getTemporaryDirectory();
      }
      final targetDir = Directory(p.join(tempDir.path, subDir));
      if (!targetDir.existsSync()) {
        targetDir.createSync(recursive: true);
      }

      // If the file is already inside targetDir, return it directly
      if (p.isWithin(targetDir.path, cleanPath) && sourceFile.existsSync()) {
        return sourceFile;
      }

      final baseName = p.basename(cleanPath);
      final targetPath = p.join(targetDir.path, baseName);

      if (sourceFile.existsSync()) {
        return sourceFile.copySync(targetPath);
      } else {
        // Source file might be virtual or inaccessible via File.exists; return sourceFile
        return sourceFile;
      }
    } catch (e, st) {
      AppLog.e('FileIngest', 'cache_copy_failed', e, st);
      return sourceFile;
    }
  }

  /// Ingests a list of file paths or URIs in sequence, returning their cached paths.
  static Future<List<String>> ingestAll(
    List<String> rawPathsOrUris, {
    String subDir = 'tool_inputs',
  }) async {
    final results = <String>[];
    for (final item in rawPathsOrUris) {
      try {
        final ingested = await ingestToCache(item, subDir: subDir);
        results.add(ingested.path);
      } catch (e, st) {
        AppLog.e('FileIngest', 'ingest_all_item_failed', e, st);
        results.add(item);
      }
    }
    return results;
  }
}
