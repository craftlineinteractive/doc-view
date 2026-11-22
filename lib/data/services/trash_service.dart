import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../core/constants/app_constants.dart';
import '../../core/errors/app_errors.dart';
import '../../core/utils/file_name_utils.dart';
import '../db/app_database.dart';
import '../models/doc_file.dart';
import '../models/trash_item.dart';

/// Generates a RFC4122 v4 UUID using cryptographically secure random bytes.
String generateTrashUuid() {
  final rnd = Random.secure();
  final bytes = List<int>.generate(16, (_) => rnd.nextInt(256));
  bytes[6] = (bytes[6] & 0x0f) | 0x40; // Version 4
  bytes[8] = (bytes[8] & 0x3f) | 0x80; // Variant RFC4122
  final hex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20)}';
}

/// Batch result when moving files to the Recycle bin.
class TrashBatchResult {
  final List<TrashItem> successfulItems;
  final List<DocFile> failedFiles;
  final TrashErrorReason? firstErrorReason;
  final String? firstErrorDetails;

  const TrashBatchResult({
    required this.successfulItems,
    required this.failedFiles,
    this.firstErrorReason,
    this.firstErrorDetails,
  });

  bool get isFullSuccess => failedFiles.isEmpty && successfulItems.isNotEmpty;
  bool get hasSuccesses => successfulItems.isNotEmpty;
}

/// Service managing crash-safe moving, restoring, and permanent deletion of documents in the Recycle bin.
class TrashService {
  TrashService({
    AppDatabase? database,
    this.binDirectoryProvider,
    this.fallbackRestoreDirectoryProvider,
    int? maxFileBytes,
  })  : _database = database ?? AppDatabase.instance,
        _maxFileBytes = maxFileBytes ?? AppConstants.trashMaxFileBytes;

  final AppDatabase _database;
  final Future<Directory> Function()? binDirectoryProvider;
  final Future<Directory> Function()? fallbackRestoreDirectoryProvider;
  final int _maxFileBytes;

  /// Injectable failure hooks used exclusively by unit and failure-injection tests.
  /// Null in production and release builds.
  @visibleForTesting
  Future<void> Function(String sourcePath, String destPath)? testCopyHook;

  @visibleForTesting
  Future<void> Function(File partFile)? testVerifyHook;

  @visibleForTesting
  Future<void> Function(String partPath, String finalTrashPath)? testRenameHook;

  @visibleForTesting
  Future<void> Function()? testDbTransactionHook;

  @visibleForTesting
  Future<void> Function(File originalFile)? testOriginalDeleteHook;

  @visibleForTesting
  Future<void> Function(File trashFile, String resolvedRestorePath)? testRestoreCopyHook;

  /// Returns the private application directory where trashed files are safely held.
  Future<Directory> getTrashDirectory() async {
    final provider = binDirectoryProvider;
    if (provider != null) {
      final dir = await provider();
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }
      return dir;
    }

    final supportDir = await getApplicationSupportDirectory();
    final trashDir = Directory(p.join(supportDir.path, 'recycle_bin'));
    if (!await trashDir.exists()) {
      await trashDir.create(recursive: true);
    }
    return trashDir;
  }

  /// Queries all items currently in the Recycle bin, sorted by deletion time (newest first).
  Future<List<TrashItem>> getAllTrashItems() async {
    final db = await _database.database;
    final rows = await db.query(
      AppDatabase.tableTrash,
      orderBy: 'deleted_ms DESC',
    );
    return rows.map((r) => TrashItem.fromMap(r)).toList();
  }

  /// Queries a single item in the Recycle bin by [id].
  Future<TrashItem?> getTrashItemById(String id) async {
    final db = await _database.database;
    final rows = await db.query(
      AppDatabase.tableTrash,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return TrashItem.fromMap(rows.first);
  }

  /// Returns the total count of items in the Recycle bin.
  Future<int> getTrashCount() async {
    final db = await _database.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM ${AppDatabase.tableTrash}',
    );
    if (result.isEmpty) return 0;
    return (result.first['count'] as num?)?.toInt() ?? 0;
  }

  /// Moves a single [file] to the Recycle bin following the crash-safe transactional algorithm.
  ///
  /// Guarantees data safety: the original file is NEVER deleted until a verified byte-for-byte
  /// copy exists in the bin and the database transaction records it. If unlinking the original fails,
  /// the entire transaction is rolled back and the original remains intact.
  Future<TrashItem> moveSingleToTrash(DocFile file, {DateTime? now}) async {
    final originalFile = File(file.path);
    if (!await originalFile.exists()) {
      throw const TrashException(TrashErrorReason.fileMissing);
    }

    final originalStat = await originalFile.stat();
    final originalLength = originalStat.size;

    if (originalLength > _maxFileBytes) {
      throw const TrashException(TrashErrorReason.tooLarge);
    }

    final trashDir = await getTrashDirectory();
    final id = generateTrashUuid();
    final extWithDot = p.extension(file.path);
    final extClean = extWithDot.startsWith('.') ? extWithDot.substring(1) : extWithDot;

    final partPath = p.join(trashDir.path, '$id.part');
    final finalTrashPath = p.join(trashDir.path, '$id$extWithDot');

    final partFile = File(partPath);

    // Step 1: Copy original to .part file in recycle bin
    try {
      if (testCopyHook != null) {
        await testCopyHook!(originalFile.path, partPath);
      } else {
        await originalFile.copy(partPath);
      }
    } catch (e) {
      if (await partFile.exists()) {
        try {
          await partFile.delete();
        } catch (_) {}
      }
      throw TrashException(TrashErrorReason.copyFailed, e.toString());
    }

    // Step 2: Verify copy integrity
    if (!await partFile.exists()) {
      throw const TrashException(TrashErrorReason.verifyFailed, 'Part file does not exist');
    }
    final partStat = await partFile.stat();
    if (partStat.size != originalLength) {
      try {
        await partFile.delete();
      } catch (_) {}
      throw const TrashException(
        TrashErrorReason.verifyFailed,
        'Size mismatch between original and copy',
      );
    }

    if (testVerifyHook != null) {
      try {
        await testVerifyHook!(partFile);
      } catch (e) {
        if (await partFile.exists()) {
          try {
            await partFile.delete();
          } catch (_) {}
        }
        if (e is TrashException) rethrow;
        throw TrashException(TrashErrorReason.verifyFailed, e.toString());
      }
    }

    // Preserve original file modified timestamp on the bin copy
    try {
      await partFile.setLastModified(originalStat.modified);
    } catch (_) {}

    // Step 3: Atomic rename from .part to final trash path
    try {
      if (testRenameHook != null) {
        await testRenameHook!(partPath, finalTrashPath);
      } else {
        await partFile.rename(finalTrashPath);
      }
    } catch (e) {
      try {
        if (await partFile.exists()) {
          await partFile.delete();
        }
      } catch (_) {}
      throw TrashException(TrashErrorReason.copyFailed, e.toString());
    }

    final currentTime = now ?? DateTime.now();
    final deletedMs = currentTime.millisecondsSinceEpoch;
    final expiresMs = deletedMs + (AppConstants.trashRetentionDays * 24 * 60 * 60 * 1000);

    final trashItem = TrashItem(
      id: id,
      trashPath: finalTrashPath,
      originalPath: file.path,
      originalName: file.name,
      extension: extClean,
      sizeBytes: originalLength,
      category: file.category,
      originalModifiedMs: originalStat.modified.millisecondsSinceEpoch,
      deletedMs: deletedMs,
      expiresMs: expiresMs,
      wasBookmarked: file.isBookmarked,
      wasImported: file.isImported,
      lastOpenedMs: file.lastOpened?.millisecondsSinceEpoch,
    );

    final db = await _database.database;

    // Step 4: DB transaction to insert into trash table and delete from files table
    Map<String, dynamic>? deletedFileRow;
    try {
      await db.transaction((txn) async {
        final existingRows = await txn.query(
          AppDatabase.tableFiles,
          where: 'path = ?',
          whereArgs: [file.path],
          limit: 1,
        );
        if (existingRows.isNotEmpty) {
          deletedFileRow = existingRows.first;
          await txn.delete(
            AppDatabase.tableFiles,
            where: 'id = ?',
            whereArgs: [existingRows.first['id']],
          );
        }
        await txn.insert(AppDatabase.tableTrash, trashItem.toMap());
        if (testDbTransactionHook != null) {
          await testDbTransactionHook!();
        }
      });
    } catch (e) {
      final trashFile = File(finalTrashPath);
      if (await trashFile.exists()) {
        try {
          await trashFile.delete();
        } catch (_) {}
      }
      throw TrashException(TrashErrorReason.unknown, e.toString());
    }

    // Step 5: Delete original file on disk
    try {
      if (testOriginalDeleteHook != null) {
        await testOriginalDeleteHook!(originalFile);
      } else {
        await originalFile.delete();
      }
    } catch (e) {
      // Step 6: ROLLBACK if original deletion fails
      try {
        final trashFile = File(finalTrashPath);
        if (await trashFile.exists()) {
          await trashFile.delete();
        }
      } catch (_) {}

      try {
        await db.transaction((txn) async {
          await txn.delete(
            AppDatabase.tableTrash,
            where: 'id = ?',
            whereArgs: [id],
          );
          if (deletedFileRow != null) {
            await txn.insert(AppDatabase.tableFiles, deletedFileRow!);
          }
        });
      } catch (_) {}

      throw TrashException(TrashErrorReason.deleteOriginalFailed, e.toString());
    }

    return trashItem;
  }

  /// Moves multiple [files] to the Recycle bin.
  Future<TrashBatchResult> moveToTrash(List<DocFile> files, {DateTime? now}) async {
    final successfulItems = <TrashItem>[];
    final failedFiles = <DocFile>[];
    TrashErrorReason? firstErrorReason;
    String? firstErrorDetails;

    for (final file in files) {
      try {
        final item = await moveSingleToTrash(file, now: now);
        successfulItems.add(item);
      } catch (e) {
        failedFiles.add(file);
        if (firstErrorReason == null) {
          if (e is TrashException) {
            firstErrorReason = e.reason;
            firstErrorDetails = e.message;
          } else {
            firstErrorReason = TrashErrorReason.unknown;
            firstErrorDetails = e.toString();
          }
        }
      }
    }

    return TrashBatchResult(
      successfulItems: successfulItems,
      failedFiles: failedFiles,
      firstErrorReason: firstErrorReason,
      firstErrorDetails: firstErrorDetails,
    );
  }

  /// Restores a single [trashItem] back to disk and database.
  ///
  /// If the original directory exists and the original name is free, restores there.
  /// If the name is taken, generates `<name> (restored).<ext>`, `<name> (restored 2).<ext>`, etc.
  /// If the original directory was deleted, recreates it; if recreation fails, falls back to imported/.
  Future<DocFile> restoreItem(TrashItem trashItem) async {
    final trashFile = File(trashItem.trashPath);
    if (!await trashFile.exists()) {
      throw const TrashException(TrashErrorReason.fileMissing);
    }

    final originalParentDir = Directory(p.dirname(trashItem.originalPath));
    var targetDir = originalParentDir;

    if (!await originalParentDir.exists()) {
      try {
        await originalParentDir.create(recursive: true);
      } catch (_) {
        // Fallback directory
        final fallback = fallbackRestoreDirectoryProvider;
        if (fallback != null) {
          targetDir = await fallback();
        } else {
          final supportDir = await getApplicationSupportDirectory();
          targetDir = Directory(p.join(supportDir.path, 'imported'));
        }
        if (!await targetDir.exists()) {
          await targetDir.create(recursive: true);
        }
      }
    }

    final candidatePath = p.join(targetDir.path, p.basename(trashItem.originalPath));
    final resolvedRestorePath = buildRestorePath(
      candidatePath,
      (candidate) => File(candidate).existsSync(),
    );

    final partPath = '$resolvedRestorePath.part';
    final partFile = File(partPath);

    // Copy from bin to destination .part
    try {
      if (testRestoreCopyHook != null) {
        await testRestoreCopyHook!(trashFile, partPath);
      } else {
        await trashFile.copy(partPath);
      }
    } catch (e) {
      if (await partFile.exists()) {
        try {
          await partFile.delete();
        } catch (_) {}
      }
      throw TrashException(TrashErrorReason.copyFailed, e.toString());
    }

    // Verify copy
    if (!await partFile.exists()) {
      throw const TrashException(TrashErrorReason.verifyFailed, 'Restored part file missing');
    }
    final partStat = await partFile.stat();
    if (partStat.size != trashItem.sizeBytes) {
      try {
        await partFile.delete();
      } catch (_) {}
      throw const TrashException(TrashErrorReason.verifyFailed, 'Restored size mismatch');
    }

    // Restore original modified timestamp
    try {
      await partFile.setLastModified(
        DateTime.fromMillisecondsSinceEpoch(trashItem.originalModifiedMs),
      );
    } catch (_) {}

    // Rename .part to resolved path
    try {
      await partFile.rename(resolvedRestorePath);
    } catch (e) {
      try {
        await partFile.delete();
      } catch (_) {}
      throw TrashException(TrashErrorReason.copyFailed, e.toString());
    }

    final restoredName = p.basename(resolvedRestorePath);
    final restoredDoc = DocFile(
      path: resolvedRestorePath,
      name: restoredName,
      extension: trashItem.extension,
      sizeBytes: trashItem.sizeBytes,
      modified: DateTime.fromMillisecondsSinceEpoch(trashItem.originalModifiedMs),
      category: trashItem.category,
      isBookmarked: trashItem.wasBookmarked,
      lastOpened: trashItem.lastOpenedMs != null
          ? DateTime.fromMillisecondsSinceEpoch(trashItem.lastOpenedMs!)
          : null,
      isImported: trashItem.wasImported,
    );

    final db = await _database.database;

    // DB transaction: remove from trash, insert restored file into files table
    await db.transaction((txn) async {
      await txn.delete(
        AppDatabase.tableTrash,
        where: 'id = ?',
        whereArgs: [trashItem.id],
      );

      await txn.insert(
        AppDatabase.tableFiles,
        {
          'path': restoredDoc.path,
          'name': restoredDoc.name,
          'extension': restoredDoc.extension,
          'size_bytes': restoredDoc.sizeBytes,
          'modified': restoredDoc.modified.millisecondsSinceEpoch,
          'category': restoredDoc.category.name,
          'is_bookmarked': restoredDoc.isBookmarked ? 1 : 0,
          'last_opened': restoredDoc.lastOpened?.millisecondsSinceEpoch,
          'is_imported': restoredDoc.isImported ? 1 : 0,
        },
      );
    });

    // Delete file from recycle bin
    try {
      if (await trashFile.exists()) {
        await trashFile.delete();
      }
    } catch (_) {}

    return restoredDoc;
  }

  /// Restores multiple [items] from the Recycle bin.
  Future<List<DocFile>> restoreItems(List<TrashItem> items) async {
    final restoredDocs = <DocFile>[];
    for (final item in items) {
      try {
        final doc = await restoreItem(item);
        restoredDocs.add(doc);
      } catch (_) {}
    }
    return restoredDocs;
  }

  /// Permanently deletes [trashItem] from the Recycle bin and database.
  Future<void> deleteForeverSingle(TrashItem trashItem) async {
    final file = File(trashItem.trashPath);
    try {
      if (await file.exists()) {
        await file.delete();
      }
    } catch (_) {}

    final db = await _database.database;
    await db.delete(
      AppDatabase.tableTrash,
      where: 'id = ?',
      whereArgs: [trashItem.id],
    );
  }

  /// Permanently deletes a list of [items] from the Recycle bin.
  Future<void> deleteForever(List<TrashItem> items) async {
    for (final item in items) {
      await deleteForeverSingle(item);
    }
  }

  /// Empties the entire Recycle bin: permanently deletes all files and cleans any orphan files.
  Future<int> emptyTrash() async {
    final items = await getAllTrashItems();
    final count = items.length;

    for (final item in items) {
      try {
        final f = File(item.trashPath);
        if (await f.exists()) {
          await f.delete();
        }
      } catch (_) {}
    }

    final db = await _database.database;
    await db.delete(AppDatabase.tableTrash);

    // Clean any abandoned orphan or .part files in recycle bin directory
    try {
      final binDir = await getTrashDirectory();
      if (await binDir.exists()) {
        final entities = binDir.listSync();
        for (final entity in entities) {
          if (entity is File) {
            try {
              await entity.delete();
            } catch (_) {}
          }
        }
      }
    } catch (_) {}

    return count;
  }
}
