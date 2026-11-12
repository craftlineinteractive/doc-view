import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:pdfrx/pdfrx.dart' as pdfrx;

/// In-memory cache and queue for loading PDF page counts and detecting encrypted/damaged files.
/// Concurrency is strictly capped at 2 parallel PDF operations.
class PdfPageCountService {
  static final PdfPageCountService instance = PdfPageCountService._();
  PdfPageCountService._();

  @visibleForTesting
  factory PdfPageCountService.createForTesting() => PdfPageCountService._();

  final Map<String, int?> _pageCountCache = <String, int?>{};
  final Set<String> _flaggedErrors = <String>{};
  int _activeLoaders = 0;
  static const int _maxConcurrency = 2;
  final List<void Function()> _queue = [];

  /// Resets in-memory state. Used during testing.
  @visibleForTesting
  void reset() {
    _pageCountCache.clear();
    _flaggedErrors.clear();
    _activeLoaders = 0;
    _queue.clear();
  }

  /// Sets cached count directly for testing.
  @visibleForTesting
  void setCachedCountForTesting(String path, int count) {
    _pageCountCache[path] = count;
  }

  /// Flags a file path as error/damaged directly for testing.
  @visibleForTesting
  void setFlaggedErrorForTesting(String path) {
    _flaggedErrors.add(path);
  }

  /// Whether the file is cached and known to be encrypted or unreadable/damaged.
  bool isFlaggedError(String path) => _flaggedErrors.contains(path);

  /// Returns cached page count if already loaded, or null if loading/failed.
  int? getCachedCount(String path) => _pageCountCache[path];

  /// Loads the page count asynchronously.
  /// If already cached, returns immediately.
  /// Otherwise queues the task respecting the max concurrency limit of 2.
  Future<int?> loadPageCount(String path, {VoidCallback? onLoaded}) async {
    if (_flaggedErrors.contains(path)) {
      return null;
    }
    if (_pageCountCache.containsKey(path)) {
      return _pageCountCache[path];
    }

    final completer = Completer<int?>();

    void runTask() async {
      _activeLoaders++;
      try {
        final doc = await pdfrx.PdfDocument.openFile(path);
        if (doc.isEncrypted) {
          _flaggedErrors.add(path);
          _pageCountCache[path] = null;
          await doc.dispose();
          completer.complete(null);
        } else {
          final count = doc.pages.length;
          await doc.dispose();
          _pageCountCache[path] = count;
          completer.complete(count);
        }
      } catch (e) {
        _flaggedErrors.add(path);
        _pageCountCache[path] = null;
        completer.complete(null);
      } finally {
        _activeLoaders--;
        onLoaded?.call();
        if (_queue.isNotEmpty) {
          final next = _queue.removeAt(0);
          next();
        }
      }
    }

    if (_activeLoaders < _maxConcurrency) {
      runTask();
    } else {
      _queue.add(runTask);
    }

    return completer.future;
  }
}
