import 'dart:io';
import 'dart:isolate';

import 'package:path/path.dart' as p;

import '../../../core/constants/file_types.dart';

/// Serializable plain data transfer object representing a directory or file entry.
class DirectoryEntryDto {
  const DirectoryEntryDto({
    required this.path,
    required this.name,
    required this.isDirectory,
    required this.sizeBytes,
    required this.modifiedMs,
    this.categoryName,
    this.itemCount,
  });

  final String path;
  final String name;
  final bool isDirectory;
  final int sizeBytes;
  final int modifiedMs;
  final String? categoryName;
  final int? itemCount;

  FileCategory? get category {
    if (categoryName == null) return null;
    return FileCategory.values
        .where((e) => e.name == categoryName)
        .firstOrNull;
  }
}

/// Sealed hierarchy of distinct directory browsing UI states.
sealed class DirectoryViewState {
  const DirectoryViewState();
}

/// Directory is currently being read/indexed in the background isolate.
class DirectoryLoadingState extends DirectoryViewState {
  const DirectoryLoadingState();
}

/// Storage permission is required to browse (Android only).
class DirectoryPermissionRequiredState extends DirectoryViewState {
  const DirectoryPermissionRequiredState();
}

/// A specific folder (such as Android/data) is protected by OS security policies.
class DirectoryFolderAccessDeniedState extends DirectoryViewState {
  const DirectoryFolderAccessDeniedState(this.path);
  final String path;
}

/// The targeted directory does not exist or was deleted.
class DirectoryNotFoundState extends DirectoryViewState {
  const DirectoryNotFoundState(this.path);
  final String path;
}

/// Directory is valid and accessible, but contains no supported files or subfolders.
class DirectoryEmptyState extends DirectoryViewState {
  const DirectoryEmptyState(this.path);
  final String path;
}

/// Directory contains supported files and/or subfolders.
class DirectoryContentState extends DirectoryViewState {
  const DirectoryContentState({
    required this.path,
    required this.entries,
  });

  final String path;
  final List<DirectoryEntryDto> entries;
}

/// An unexpected error occurred while listing the directory.
class DirectoryUnknownErrorState extends DirectoryViewState {
  const DirectoryUnknownErrorState(this.message);
  final String message;
}

/// Pure error mapper converting filesystem exceptions into typed [DirectoryViewState].
DirectoryViewState mapListingExceptionToState(Object error, String path) {
  if (error is PathAccessException) {
    return DirectoryFolderAccessDeniedState(path);
  }

  if (error is FileSystemException) {
    final msg = error.message.toLowerCase();
    final osMsg = error.osError?.message.toLowerCase() ?? '';
    final code = error.osError?.errorCode;

    // errno 13: Permission denied (EACCES)
    if (code == 13 ||
        msg.contains('permission denied') ||
        osMsg.contains('permission denied') ||
        msg.contains('access is denied')) {
      return DirectoryFolderAccessDeniedState(path);
    }

    // errno 2: No such file or directory (ENOENT)
    if (code == 2 ||
        msg.contains('no such file') ||
        osMsg.contains('no such file') ||
        msg.contains('cannot find the path')) {
      return DirectoryNotFoundState(path);
    }

    final displayMsg = error.osError?.message.isNotEmpty == true
        ? error.osError!.message
        : error.message;
    return DirectoryUnknownErrorState(
      displayMsg.isNotEmpty ? displayMsg : error.toString(),
    );
  }

  return DirectoryUnknownErrorState(error.toString());
}

/// Top-level synchronous worker function executed inside [Isolate.run].
///
/// Features per-entry resilience: stat reads for individual entries are isolated
/// in try/catch blocks so one corrupt file or broken symlink never fails the listing.
List<DirectoryEntryDto> listDirectorySync(String dirPath) {
  final dir = Directory(dirPath);
  if (!dir.existsSync()) {
    throw FileSystemException('Directory does not exist', dirPath);
  }

  final entities = dir.listSync(followLinks: false);

  final folders = <DirectoryEntryDto>[];
  final files = <DirectoryEntryDto>[];

  for (final entity in entities) {
    try {
      final name = p.basename(entity.path);

      // Skip hidden files and hidden folders (starting with '.')
      if (name.startsWith('.')) {
        continue;
      }

      if (entity is Directory) {
        int? childCount;
        try {
          // Attempt a fast count of non-hidden items
          final children = entity.listSync(followLinks: false);
          childCount = children
              .where((c) => !p.basename(c.path).startsWith('.'))
              .length;
        } catch (_) {
          // Keep childCount null if restricted or inaccessible
          childCount = null;
        }

        folders.add(
          DirectoryEntryDto(
            path: entity.path,
            name: name,
            isDirectory: true,
            sizeBytes: 0,
            modifiedMs: 0,
            itemCount: childCount,
          ),
        );
      } else if (entity is File) {
        final category = categoryFromPath(entity.path);
        // Exclude unsupported document formats
        if (category == null) {
          continue;
        }

        int size = 0;
        int modified = 0;
        try {
          final stat = entity.statSync();
          size = stat.size;
          modified = stat.modified.millisecondsSinceEpoch;
        } catch (_) {
          // Skip file if its stat is unreadable
          continue;
        }

        files.add(
          DirectoryEntryDto(
            path: entity.path,
            name: name,
            isDirectory: false,
            sizeBytes: size,
            modifiedMs: modified,
            categoryName: category.name,
          ),
        );
      }
    } catch (_) {
      // Per-entry resilience: ignore single entry failure
    }
  }

  folders.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  files.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

  return [...folders, ...files];
}

/// Dispatches [listDirectorySync] in a dedicated background isolate via [Isolate.run].
Future<List<DirectoryEntryDto>> listDirectoryEntries(String dirPath) {
  return Isolate.run(() => listDirectorySync(dirPath));
}

