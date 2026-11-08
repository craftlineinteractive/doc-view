import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pdfrx/pdfrx.dart';

import 'file_thumbnail.dart';

/// Production-ready PDF thumbnail source utilizing pdfrx engine.
/// Features:
/// - Concurrency queue limiting active PDF renders to at most 2.
/// - Downscales to small thumbnails (~144px width) for 60fps scrolling.
/// - Persistent disk caching in app cache dir (`/cache/pdf_thumbnails/`).
/// - Cache eviction cap at 100 MB with oldest-first pruning.
/// - Strict 3-second timeout with graceful fallback to null (red PDF badge).
class PdfThumbnailSource implements ThumbnailSource {
  static final PdfThumbnailSource instance = PdfThumbnailSource._();
  PdfThumbnailSource._();

  Directory? _cacheDir;
  bool _cleanedUp = false;

  int _activeRenders = 0;
  static const int _maxConcurrentRenders = 2;
  final List<Completer<void>> _renderQueue = [];

  Future<void> _acquireSlot() async {
    if (_activeRenders < _maxConcurrentRenders) {
      _activeRenders++;
      return;
    }
    final completer = Completer<void>();
    _renderQueue.add(completer);
    await completer.future;
  }

  void _releaseSlot() {
    if (_renderQueue.isNotEmpty) {
      final next = _renderQueue.removeAt(0);
      next.complete();
    } else {
      _activeRenders--;
    }
  }

  Future<Directory> _getCacheDirectory() async {
    if (_cacheDir != null) return _cacheDir!;
    final baseDir = await getTemporaryDirectory();
    final dir = Directory(p.join(baseDir.path, 'pdf_thumbnails'));
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    _cacheDir = dir;
    if (!_cleanedUp) {
      _cleanedUp = true;
      _cleanupCache(dir);
    }
    return dir;
  }

  Future<void> _cleanupCache(Directory dir) async {
    try {
      final entities =
          await dir.list().where((e) => e is File).cast<File>().toList();
      int totalSize = 0;
      final fileStats = <File, int>{};
      for (final file in entities) {
        final stat = await file.stat();
        fileStats[file] = stat.size;
        totalSize += stat.size;
      }

      const int maxCacheBytes = 100 * 1024 * 1024; // 100 MB
      if (totalSize > maxCacheBytes) {
        final sorted = entities
          ..sort((a, b) =>
              a.lastModifiedSync().compareTo(b.lastModifiedSync()));
        for (final file in sorted) {
          if (totalSize <= (maxCacheBytes * 0.8)) break; // prune down to 80MB
          final size = fileStats[file] ?? 0;
          await file.delete();
          totalSize -= size;
        }
      }
    } catch (_) {
      // Non-fatal cache eviction failure
    }
  }

  String _cacheKey(String filePath, int modifiedMs, int sizeBytes) {
    var hash = 0xcbf29ce484222325;
    for (final codeUnit in '$filePath:$modifiedMs:$sizeBytes'.codeUnits) {
      hash ^= codeUnit;
      hash = (hash * 0x100000001b3) & 0xFFFFFFFFFFFFFFFF;
    }
    return hash.toRadixString(16);
  }

  @override
  Future<ImageProvider?> loadThumbnail({
    required String filePath,
    required double width,
    required double height,
  }) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) return null;

      final stat = await file.stat();
      final key = _cacheKey(
        filePath,
        stat.modified.millisecondsSinceEpoch,
        stat.size,
      );
      final cacheDir = await _getCacheDirectory();
      final cacheFile = File(p.join(cacheDir.path, '$key.png'));

      if (await cacheFile.exists()) {
        return FileImage(cacheFile);
      }

      return await _renderWithTimeout(file, cacheFile, width, height);
    } catch (_) {
      return null;
    }
  }

  Future<ImageProvider?> _renderWithTimeout(
    File file,
    File cacheFile,
    double targetWidth,
    double targetHeight,
  ) async {
    await _acquireSlot();
    try {
      return await _renderFirstPage(file, cacheFile, targetWidth, targetHeight)
          .timeout(const Duration(seconds: 3));
    } catch (_) {
      return null;
    } finally {
      _releaseSlot();
    }
  }

  Future<ImageProvider?> _renderFirstPage(
    File file,
    File cacheFile,
    double targetWidth,
    double targetHeight,
  ) async {
    PdfDocument? doc;
    try {
      doc = await PdfDocument.openFile(file.path);
      if (doc.pages.isEmpty) return null;

      final page = doc.pages.first;
      const renderWidth = 144;
      final renderHeight = ((renderWidth / page.width) * page.height).round();

      final pdfImage = await page.render(
        width: renderWidth,
        height: renderHeight,
      );
      if (pdfImage == null) return null;

      try {
        final uiImage = await pdfImage.createImage();
        try {
          final byteData =
              await uiImage.toByteData(format: ui.ImageByteFormat.png);
          if (byteData == null) return null;
          final pngBytes = byteData.buffer.asUint8List();
          await cacheFile.writeAsBytes(pngBytes, flush: true);
          return FileImage(cacheFile);
        } finally {
          uiImage.dispose();
        }
      } finally {
        pdfImage.dispose();
      }
    } catch (_) {
      return null;
    } finally {
      await doc?.dispose();
    }
  }
}

