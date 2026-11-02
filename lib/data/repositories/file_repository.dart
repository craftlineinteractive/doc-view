import 'dart:io';

import '../../core/constants/file_types.dart';
import '../../core/utils/format_utils.dart';
import '../db/app_database.dart';
import '../models/doc_file.dart';
import '../models/sort_option.dart';

/// Repository interface and SQLite implementation for managing [DocFile] records.
class FileRepository {
  FileRepository({AppDatabase? database})
      : _database = database ?? AppDatabase.instance;

  final AppDatabase _database;

  /// Inserts or updates a batch of files in a single database transaction.
  /// Preserves [DocFile.isBookmarked] and [DocFile.lastOpened] for existing records.
  Future<void> upsertBatch(List<DocFile> files) async {
    if (files.isEmpty) return;

    final db = await _database.database;
    await db.transaction((txn) async {
      final batch = txn.batch();
      for (final file in files) {
        batch.rawInsert(
          '''
          INSERT INTO ${AppDatabase.tableFiles} (
            path, name, extension, size_bytes, modified, category, is_bookmarked, last_opened, is_imported
          ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
          ON CONFLICT(path) DO UPDATE SET
            name = excluded.name,
            extension = excluded.extension,
            size_bytes = excluded.size_bytes,
            modified = excluded.modified,
            category = excluded.category
          ''',
          [
            file.path,
            file.name,
            file.extension,
            file.sizeBytes,
            file.modified.millisecondsSinceEpoch,
            file.category.name,
            file.isBookmarked ? 1 : 0,
            file.lastOpened?.millisecondsSinceEpoch,
            file.isImported ? 1 : 0,
          ],
        );
      }
      await batch.commit(noResult: true);
    });
  }

  /// Removes database rows whose path was not seen in the latest full scan.
  /// Never deletes rows where [isImported] = true unless the file no longer exists on disk.
  Future<void> removeMissing(
    Set<String> seenPaths, {
    required bool onlyScanned,
  }) async {
    final db = await _database.database;

    final rows = await db.query(
      AppDatabase.tableFiles,
      columns: ['id', 'path', 'is_imported'],
    );

    final idsToDelete = <int>[];

    for (final row in rows) {
      final id = row['id'] as int;
      final path = row['path'] as String;
      final isImported = (row['is_imported'] as int? ?? 0) == 1;

      if (isImported) {
        // Only delete imported files if they were removed from the filesystem
        if (!File(path).existsSync()) {
          idsToDelete.add(id);
        }
      } else {
        // Scanned file: delete if not seen during scan
        if (!seenPaths.contains(path)) {
          idsToDelete.add(id);
        }
      }
    }

    if (idsToDelete.isNotEmpty) {
      await db.transaction((txn) async {
        final batch = txn.batch();
        for (final id in idsToDelete) {
          batch.delete(
            AppDatabase.tableFiles,
            where: 'id = ?',
            whereArgs: [id],
          );
        }
        await batch.commit(noResult: true);
      });
    }
  }

  /// Aggregates file counts grouped by [FileCategory].
  Future<Map<FileCategory, int>> countsByCategory() async {
    final db = await _database.database;

    final result = <FileCategory, int>{
      for (final cat in FileCategory.values) cat: 0,
    };

    final rows = await db.rawQuery(
      'SELECT category, COUNT(*) as count FROM ${AppDatabase.tableFiles} GROUP BY category',
    );

    for (final row in rows) {
      final categoryStr = row['category'] as String?;
      final count = (row['count'] as num?)?.toInt() ?? 0;
      if (categoryStr != null) {
        try {
          final cat = FileCategory.values.byName(categoryStr);
          result[cat] = count;
        } catch (_) {}
      }
    }

    return result;
  }

  /// Returns total count across all files.
  Future<int> totalFilesCount() async {
    final db = await _database.database;
    final res = await db.rawQuery(
      'SELECT COUNT(*) as total FROM ${AppDatabase.tableFiles}',
    );
    if (res.isNotEmpty) {
      return (res.first['total'] as num?)?.toInt() ?? 0;
    }
    return 0;
  }

  /// Queries indexed files with optional category filter, search query, sorting, and pagination.
  /// Defaults to sorting by [DocFile.modified] DESC if [sortOption] is null.
  Future<List<DocFile>> getFiles({
    FileCategory? category,
    String? query,
    SortOption? sortOption,
    int limit = 100,
    int offset = 0,
  }) async {
    final db = await _database.database;

    final whereClauses = <String>[];
    final whereArgs = <dynamic>[];

    if (category != null) {
      whereClauses.add('category = ?');
      whereArgs.add(category.name);
    }

    if (query != null && query.trim().isNotEmpty) {
      final escaped = escapeLike(query.trim());
      whereClauses.add("name LIKE ? ESCAPE '\\'");
      whereArgs.add('%$escaped%');
    }

    final whereString =
        whereClauses.isNotEmpty ? whereClauses.join(' AND ') : null;

    final orderBy = sortOption?.toOrderBy() ?? 'modified DESC';

    final rows = await db.query(
      AppDatabase.tableFiles,
      where: whereString,
      whereArgs: whereArgs.isNotEmpty ? whereArgs : null,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
    );

    return rows.map(DocFile.fromMap).toList();
  }

  /// Toggles the bookmark status of a file with [id].
  Future<bool> toggleBookmark(int id) async {
    final db = await _database.database;
    final rows = await db.query(
      AppDatabase.tableFiles,
      columns: ['is_bookmarked'],
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (rows.isEmpty) return false;

    final isCurrentlyBookmarked =
        (rows.first['is_bookmarked'] as int? ?? 0) == 1;
    final newBookmarkedValue = isCurrentlyBookmarked ? 0 : 1;

    await db.update(
      AppDatabase.tableFiles,
      {'is_bookmarked': newBookmarkedValue},
      where: 'id = ?',
      whereArgs: [id],
    );

    return newBookmarkedValue == 1;
  }

  /// Sets the last opened timestamp of a file to current time in milliseconds.
  Future<void> markOpened(int id) async {
    final db = await _database.database;
    final nowMs = DateTime.now().millisecondsSinceEpoch;

    await db.update(
      AppDatabase.tableFiles,
      {'last_opened': nowMs},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Returns all bookmarked files, newest modified first.
  Future<List<DocFile>> getBookmarks() async {
    final db = await _database.database;
    final rows = await db.query(
      AppDatabase.tableFiles,
      where: 'is_bookmarked = 1',
      orderBy: 'modified DESC',
    );
    return rows.map(DocFile.fromMap).toList();
  }

  /// Returns recently opened files up to [limit], ordered by last opened timestamp DESC.
  Future<List<DocFile>> getRecents({int limit = 30}) async {
    final db = await _database.database;
    final rows = await db.query(
      AppDatabase.tableFiles,
      where: 'last_opened IS NOT NULL',
      orderBy: 'last_opened DESC',
      limit: limit,
    );
    return rows.map(DocFile.fromMap).toList();
  }

  /// Searches files matching [query] on file name with LIKE, optional category filter, and limit.
  Future<List<DocFile>> searchFiles(
    String query, {
    FileCategory? category,
    int limit = 100,
  }) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return const [];

    final db = await _database.database;
    final escaped = escapeLike(trimmed);

    final whereClauses = <String>["name LIKE ? ESCAPE '\\'"];
    final whereArgs = <dynamic>['%$escaped%'];

    if (category != null) {
      whereClauses.add('category = ?');
      whereArgs.add(category.name);
    }

    final rows = await db.query(
      AppDatabase.tableFiles,
      where: whereClauses.join(' AND '),
      whereArgs: whereArgs,
      orderBy: 'modified DESC',
      limit: limit,
    );

    return rows.map(DocFile.fromMap).toList();
  }
}


