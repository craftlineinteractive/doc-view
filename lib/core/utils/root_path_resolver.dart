import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// Pure helper function that cuts an Android external storage path at '/Android'
/// to recover the base emulated storage root (e.g. '/storage/emulated/0').
///
/// If [path] is null, empty, or does not contain '/Android', it returns [fallback].
String deriveAndroidRoot(
  String? path, {
  String fallback = '/storage/emulated/0',
}) {
  if (path == null) return fallback;
  final trimmed = path.trim();
  if (trimmed.isEmpty) return fallback;

  // Normalize Windows-style backslashes if any
  final normalized = trimmed.replaceAll(r'\', '/');
  final androidIndex = normalized.indexOf('/Android');
  if (androidIndex != -1) {
    final root = normalized.substring(0, androidIndex);
    return root.isNotEmpty ? root : fallback;
  }

  // If path doesn't contain /Android, return normalized or fallback if relative
  if (normalized.startsWith('/')) {
    return normalized;
  }
  return fallback;
}

/// Resolves the root directory path dynamically depending on platform capabilities.
///
/// On Android, queries [getExternalStorageDirectory] and extracts the emulated root.
/// On iOS, queries [getApplicationDocumentsDirectory] for the app documents sandbox.
/// Injectable function parameters allow deterministic unit-testing without platform channels.
Future<String> resolveRootDirectory({
  Future<Directory?> Function()? getExternalStorageDir,
  Future<Directory> Function()? getAppDocumentsDir,
  bool? isAndroid,
  bool? isIOS,
}) async {
  final android = isAndroid ?? Platform.isAndroid;
  final ios = isIOS ?? Platform.isIOS;

  if (android) {
    try {
      final dir = getExternalStorageDir != null
          ? await getExternalStorageDir()
          : await getExternalStorageDirectory();
      if (dir != null) {
        return deriveAndroidRoot(dir.path);
      }
    } catch (_) {}
    return '/storage/emulated/0';
  }

  if (ios) {
    try {
      final dir = getAppDocumentsDir != null
          ? await getAppDocumentsDir()
          : await getApplicationDocumentsDirectory();
      return dir.path;
    } catch (_) {}
    return '';
  }

  // Non-mobile platforms (e.g. unit tests / host runner)
  try {
    final dir = getAppDocumentsDir != null
        ? await getAppDocumentsDir()
        : await getApplicationDocumentsDirectory();
    return dir.path;
  } catch (_) {
    return Directory.current.path;
  }
}

