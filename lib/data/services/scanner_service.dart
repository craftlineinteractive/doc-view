import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:path/path.dart' as p;

import '../../core/constants/file_types.dart';
import '../models/doc_file.dart';
import '../repositories/file_repository.dart';

/// Represents the current progress of a filesystem scan.
class ScanProgress {
  const ScanProgress({
    required this.isScanning,
    required this.filesFound,
    required this.isDone,
  });

  final bool isScanning;
  final int filesFound;
  final bool isDone;

  static const ScanProgress idle = ScanProgress(
    isScanning: false,
    filesFound: 0,
    isDone: false,
  );
}

/// Pure function determining whether a file path is a supported document during filesystem scans.
/// When [includeImages] is false, image file extensions are excluded.
FileCategory? resolveScannedCategory(
  String filePath, {
  required bool includeImages,
}) {
  final category = categoryFromPath(filePath);
  if (category == null) return null;
  if (!includeImages && category == FileCategory.image) {
    return null;
  }
  return category;
}

/// Service that walks the Android filesystem in a background Isolate to index documents.
class ScannerService {
  ScannerService({FileRepository? repository})
      : _repository = repository ?? FileRepository();

  final FileRepository _repository;

  static const String androidRoot = '/storage/emulated/0';

  bool _isScanning = false;
  bool get isScanning => _isScanning;

  final StreamController<ScanProgress> _progressController =
      StreamController<ScanProgress>.broadcast();

  Stream<ScanProgress> get progressStream => _progressController.stream;

  /// Starts a full filesystem scan on Android.
  /// If a scan is already running, or if the platform is not Android, this is a no-op.
  Future<void> startScan({
    String rootPath = androidRoot,
    bool includeImages = true,
  }) async {
    if (_isScanning) {
      return;
    }

    if (!Platform.isAndroid) {
      _progressController.add(
        const ScanProgress(isScanning: false, filesFound: 0, isDone: true),
      );
      return;
    }

    final rootDir = Directory(rootPath);
    if (!rootDir.existsSync()) {
      _progressController.add(
        const ScanProgress(isScanning: false, filesFound: 0, isDone: true),
      );
      return;
    }

    _isScanning = true;
    int totalFilesFound = 0;

    _progressController.add(
      const ScanProgress(isScanning: true, filesFound: 0, isDone: false),
    );

    final receivePort = ReceivePort();
    Isolate? isolate;

    try {
      isolate = await Isolate.spawn(
        _scannerIsolateEntryPoint,
        _IsolateConfig(
          rootPath: rootPath,
          sendPort: receivePort.sendPort,
          includeImages: includeImages,
        ),
      );

      await for (final message in receivePort) {
        if (message is Map<String, dynamic>) {
          final type = message['type'] as String?;

          if (type == 'batch') {
            final rawFiles = (message['files'] as List)
                .cast<Map<String, dynamic>>();
            final docFiles = rawFiles.map(DocFile.fromMap).toList();

            await _repository.upsertBatch(docFiles);
            totalFilesFound += docFiles.length;

            _progressController.add(
              ScanProgress(
                isScanning: true,
                filesFound: totalFilesFound,
                isDone: false,
              ),
            );
          } else if (type == 'done') {
            final seenList = (message['seenPaths'] as List).cast<String>();
            final seenPaths = seenList.toSet();

            await _repository.removeMissing(seenPaths, onlyScanned: true);

            _progressController.add(
              ScanProgress(
                isScanning: false,
                filesFound: totalFilesFound,
                isDone: true,
              ),
            );
            break;
          } else if (type == 'error') {
            _progressController.add(
              ScanProgress(
                isScanning: false,
                filesFound: totalFilesFound,
                isDone: true,
              ),
            );
            break;
          }
        }
      }
    } catch (_) {
      _progressController.add(
        ScanProgress(
          isScanning: false,
          filesFound: totalFilesFound,
          isDone: true,
        ),
      );
    } finally {
      receivePort.close();
      isolate?.kill(priority: Isolate.immediate);
      _isScanning = false;
    }
  }

  /// Cancels and cleans up the scanner service stream.
  void dispose() {
    _progressController.close();
  }
}

class _IsolateConfig {
  const _IsolateConfig({
    required this.rootPath,
    required this.sendPort,
    required this.includeImages,
  });

  final String rootPath;
  final SendPort sendPort;
  final bool includeImages;
}

/// Entry point executed inside the spawned background [Isolate].
void _scannerIsolateEntryPoint(_IsolateConfig config) {
  final sendPort = config.sendPort;
  final rootDir = Directory(config.rootPath);

  final buffer = <Map<String, dynamic>>[];
  final seenPaths = <String>{};

  try {
    _walkDirectory(
      rootDir,
      sendPort,
      buffer,
      seenPaths,
      config.includeImages,
    );

    // Flush any remaining items in the buffer
    if (buffer.isNotEmpty) {
      sendPort.send({
        'type': 'batch',
        'files': List<Map<String, dynamic>>.from(buffer),
      });
      buffer.clear();
    }

    sendPort.send({
      'type': 'done',
      'seenPaths': seenPaths.toList(),
    });
  } catch (error) {
    sendPort.send({
      'type': 'error',
      'message': error.toString(),
    });
  }
}

/// Recursively walks a directory, collecting supported documents.
void _walkDirectory(
  Directory currentDir,
  SendPort sendPort,
  List<Map<String, dynamic>> buffer,
  Set<String> seenPaths,
  bool includeImages,
) {
  try {
    final entities = currentDir.listSync(followLinks: false);
    for (final entity in entities) {
      if (entity is Directory) {
        if (!_shouldSkipDirectory(entity)) {
          _walkDirectory(
            entity,
            sendPort,
            buffer,
            seenPaths,
            includeImages,
          );
        }
      } else if (entity is File) {
        final filePath = entity.path;
        final category = resolveScannedCategory(
          filePath,
          includeImages: includeImages,
        );

        if (category != null) {
          try {
            final stat = entity.statSync();
            final name = p.basename(filePath);
            final extension =
                p.extension(filePath).replaceFirst('.', '').toLowerCase();

            final fileMap = DocFile(
              path: filePath,
              name: name,
              extension: extension,
              sizeBytes: stat.size,
              modified: stat.modified,
              category: category,
              isImported: false,
            ).toMap();

            seenPaths.add(filePath);
            buffer.add(fileMap);

            if (buffer.length >= 500) {
              sendPort.send({
                'type': 'batch',
                'files': List<Map<String, dynamic>>.from(buffer),
              });
              buffer.clear();
            }
          } catch (_) {
            // Skip files that cannot be stated due to permission or concurrency
          }
        }
      }
    }
  } catch (_) {
    // Skip directories that cannot be listed due to permission issues
  }
}

/// Determines whether a directory should be skipped during external storage scanning.
bool _shouldSkipDirectory(Directory dir) {
  final name = p.basename(dir.path).toLowerCase();

  // Skip hidden folders
  if (name.startsWith('.')) {
    return true;
  }

  // Skip explicit cache/thumbnail folders
  if (name == 'cache' || name == 'thumbnails' || name == '.thumbnails') {
    return true;
  }

  // Skip Android restricted private folders
  final normalized = dir.path.replaceAll(r'\', '/');
  if (normalized.contains('/Android/data') ||
      normalized.contains('/Android/obb') ||
      normalized.endsWith('/Android/data') ||
      normalized.endsWith('/Android/obb')) {
    return true;
  }

  return false;
}

