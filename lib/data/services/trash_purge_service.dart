import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

import '../db/app_database.dart';
import '../models/trash_item.dart';
import 'trash_service.dart';

/// Preference key tracking the last automated trash purge execution.
const String keyLastTrashPurgeTime = 'last_trash_purge_timestamp';

/// Service responsible for background maintenance, expired item purging, and orphan reconciliation.
class TrashPurgeService {
  TrashPurgeService({
    AppDatabase? database,
    required this.trashService,
    this.preferences,
  })  : _database = database ?? AppDatabase.instance;

  final AppDatabase _database;
  final TrashService trashService;
  final SharedPreferences? preferences;

  Future<SharedPreferences> _getPrefs() async {
    final prefs = preferences;
    if (prefs != null) return prefs;
    return SharedPreferences.getInstance();
  }

  /// Deletes all items in the Recycle bin whose retention window has lapsed.
  Future<int> purgeExpired({DateTime? now}) async {
    final currentMs = (now ?? DateTime.now()).millisecondsSinceEpoch;
    final db = await _database.database;

    final expiredRows = await db.query(
      AppDatabase.tableTrash,
      where: 'expires_ms <= ?',
      whereArgs: [currentMs],
    );

    if (expiredRows.isEmpty) return 0;

    final expiredItems = expiredRows.map((r) => TrashItem.fromMap(r)).toList();
    for (final item in expiredItems) {
      try {
        final f = File(item.trashPath);
        if (await f.exists()) {
          await f.delete();
        }
      } catch (_) {}
    }

    final deletedCount = await db.delete(
      AppDatabase.tableTrash,
      where: 'expires_ms <= ?',
      whereArgs: [currentMs],
    );

    return deletedCount;
  }

  /// Verifies database rows against disk reality and clears orphan or abandoned part files.
  Future<void> checkConsistency() async {
    final db = await _database.database;

    // Rule 1: Clean DB rows whose physical file is missing from bin
    final allRows = await db.query(AppDatabase.tableTrash);
    final missingIds = <String>[];
    final knownTrashPaths = <String>{};

    for (final row in allRows) {
      final id = row['id'] as String;
      final path = row['trash_path'] as String;
      knownTrashPaths.add(path);
      if (!File(path).existsSync()) {
        missingIds.add(id);
      }
    }

    if (missingIds.isNotEmpty) {
      await db.transaction((txn) async {
        final batch = txn.batch();
        for (final id in missingIds) {
          batch.delete(
            AppDatabase.tableTrash,
            where: 'id = ?',
            whereArgs: [id],
          );
        }
        await batch.commit(noResult: true);
      });
    }

    // Rule 2: Clean files in bin directory not tracked by DB (orphans > 24h old or any .part)
    try {
      final binDir = await trashService.getTrashDirectory();
      if (await binDir.exists()) {
        final now = DateTime.now();
        final entities = binDir.listSync();
        for (final entity in entities) {
          if (entity is File) {
            final isPart = entity.path.endsWith('.part');
            final isTracked = knownTrashPaths.contains(entity.path);

            if (!isTracked) {
              if (isPart) {
                // Abandoned copy from interrupted move or restore
                try {
                  await entity.delete();
                } catch (_) {}
              } else {
                // Untracked file: remove if older than 24 hours
                final stat = entity.statSync();
                final age = now.difference(stat.modified);
                if (age > const Duration(hours: 24)) {
                  try {
                    await entity.delete();
                  } catch (_) {}
                }
              }
            }
          }
        }
      }
    } catch (_) {}
  }

  /// Automatically executes purge and consistency check if at least 6 hours have passed since last run.
  /// Consistency check always executes to clean up any abandoned .part files or ghost rows immediately.
  Future<bool> runAutoPurgeIfDue({DateTime? now}) async {
    await checkConsistency();

    final prefs = await _getPrefs();
    final lastPurgeMs = prefs.getInt(keyLastTrashPurgeTime);
    final currentTime = now ?? DateTime.now();

    if (lastPurgeMs != null) {
      final lastPurge = DateTime.fromMillisecondsSinceEpoch(lastPurgeMs);
      if (currentTime.difference(lastPurge) < const Duration(hours: 6)) {
        return false;
      }
    }

    await purgeExpired(now: currentTime);

    await prefs.setInt(keyLastTrashPurgeTime, currentTime.millisecondsSinceEpoch);
    return true;
  }

  /// Debug action: reduces retention timestamps on all trash items to simulate aging.
  /// Used in Component Gallery and QA verification to test 1-day warnings and auto-purge.
  Future<int> ageAllTrashItems({int days = 29}) async {
    final offsetMs = days * 24 * 60 * 60 * 1000;
    final db = await _database.database;

    final updated = await db.rawUpdate('''
      UPDATE ${AppDatabase.tableTrash}
      SET expires_ms = expires_ms - ?,
          deleted_ms = deleted_ms - ?
    ''', [offsetMs, offsetMs]);

    return updated;
  }
}
