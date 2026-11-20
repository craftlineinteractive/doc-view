import 'dart:io';

import 'package:docview/core/constants/file_types.dart';
import 'package:docview/data/db/app_database.dart';
import 'package:docview/data/models/trash_item.dart';
import 'package:docview/data/services/trash_purge_service.dart';
import 'package:docview/data/services/trash_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/fake_database.dart';

void main() {
  late Directory tempDir;
  late Directory binDir;
  late FakeDatabase fakeDb;
  late AppDatabase appDb;
  late TrashService trashService;
  late TrashPurgeService purgeService;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    tempDir = Directory.systemTemp.createTempSync('trash_purge_test_');
    binDir = Directory(p.join(tempDir.path, 'recycle_bin'))..createSync(recursive: true);

    fakeDb = FakeDatabase();
    appDb = AppDatabase.withDatabase(fakeDb);

    trashService = TrashService(
      database: appDb,
      binDirectoryProvider: () async => binDir,
    );

    purgeService = TrashPurgeService(
      database: appDb,
      trashService: trashService,
    );
  });

  tearDown(() {
    try {
      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
      }
    } catch (_) {}
  });

  group('TrashPurgeService Purge & Consistency Tests', () {
    test('purgeExpired removes only expired items from disk and DB', () async {
      final now = DateTime(2026, 11, 20, 12, 0);

      // Expired item (expired 1 day ago)
      final expiredFile = File(p.join(binDir.path, 'expired.pdf'))..writeAsStringSync('Expired Data');
      final expiredItem = TrashItem(
        id: 'expired-1',
        trashPath: expiredFile.path,
        originalPath: '/docs/expired.pdf',
        originalName: 'expired.pdf',
        extension: 'pdf',
        sizeBytes: 12,
        category: FileCategory.pdf,
        originalModifiedMs: now.millisecondsSinceEpoch - 100000,
        deletedMs: now.subtract(const Duration(days: 31)).millisecondsSinceEpoch,
        expiresMs: now.subtract(const Duration(days: 1)).millisecondsSinceEpoch,
        wasBookmarked: false,
        wasImported: false,
      );

      // Active item (expires in 20 days)
      final activeFile = File(p.join(binDir.path, 'active.pdf'))..writeAsStringSync('Active Data');
      final activeItem = TrashItem(
        id: 'active-1',
        trashPath: activeFile.path,
        originalPath: '/docs/active.pdf',
        originalName: 'active.pdf',
        extension: 'pdf',
        sizeBytes: 11,
        category: FileCategory.pdf,
        originalModifiedMs: now.millisecondsSinceEpoch - 100000,
        deletedMs: now.subtract(const Duration(days: 10)).millisecondsSinceEpoch,
        expiresMs: now.add(const Duration(days: 20)).millisecondsSinceEpoch,
        wasBookmarked: false,
        wasImported: false,
      );

      await fakeDb.insert(AppDatabase.tableTrash, expiredItem.toMap());
      await fakeDb.insert(AppDatabase.tableTrash, activeItem.toMap());

      final purgedCount = await purgeService.purgeExpired(now: now);
      expect(purgedCount, 1);

      // Verify expired file deleted, active file remains
      expect(expiredFile.existsSync(), isFalse);
      expect(activeFile.existsSync(), isTrue);

      // Verify DB
      final remainingRows = await fakeDb.query(AppDatabase.tableTrash);
      expect(remainingRows.length, 1);
      expect(remainingRows.first['id'], 'active-1');
    });

    test('checkConsistency cleans ghost DB rows and deletes abandoned part/orphan files', () async {
      // Ghost DB row with no physical file
      final ghostItem = TrashItem(
        id: 'ghost-1',
        trashPath: p.join(binDir.path, 'non_existent.pdf'),
        originalPath: '/docs/non_existent.pdf',
        originalName: 'non_existent.pdf',
        extension: 'pdf',
        sizeBytes: 100,
        category: FileCategory.pdf,
        originalModifiedMs: 1000,
        deletedMs: 2000,
        expiresMs: 300000000,
        wasBookmarked: false,
        wasImported: false,
      );
      await fakeDb.insert(AppDatabase.tableTrash, ghostItem.toMap());

      // Abandoned .part file in bin
      final abandonedPart = File(p.join(binDir.path, 'interrupted.part'))..writeAsStringSync('Incomplete');

      // Valid tracked file in bin
      final trackedFile = File(p.join(binDir.path, 'tracked.pdf'))..writeAsStringSync('Valid');
      final trackedItem = TrashItem(
        id: 'tracked-1',
        trashPath: trackedFile.path,
        originalPath: '/docs/tracked.pdf',
        originalName: 'tracked.pdf',
        extension: 'pdf',
        sizeBytes: 5,
        category: FileCategory.pdf,
        originalModifiedMs: 1000,
        deletedMs: 2000,
        expiresMs: 300000000,
        wasBookmarked: false,
        wasImported: false,
      );
      await fakeDb.insert(AppDatabase.tableTrash, trackedItem.toMap());

      // Run consistency check
      await purgeService.checkConsistency();

      // Ghost DB row should be removed
      final dbRows = await fakeDb.query(AppDatabase.tableTrash);
      expect(dbRows.length, 1);
      expect(dbRows.first['id'], 'tracked-1');

      // Abandoned part file should be removed
      expect(abandonedPart.existsSync(), isFalse);

      // Tracked file should remain intact
      expect(trackedFile.existsSync(), isTrue);
    });

    test('runAutoPurgeIfDue respects 6-hour throttling', () async {
      final now = DateTime(2026, 11, 20, 10, 0);

      // Run 1: initial run should execute
      final ranFirst = await purgeService.runAutoPurgeIfDue(now: now);
      expect(ranFirst, isTrue);

      // Run 2: after 2 hours, should be throttled
      final ranSecond = await purgeService.runAutoPurgeIfDue(
        now: now.add(const Duration(hours: 2)),
      );
      expect(ranSecond, isFalse);

      // Run 3: after 6 hours and 1 minute, should execute again
      final ranThird = await purgeService.runAutoPurgeIfDue(
        now: now.add(const Duration(hours: 6, minutes: 1)),
      );
      expect(ranThird, isTrue);
    });

    test('ageAllTrashItems shifts deletedMs and expiresMs backwards by given days', () async {
      final now = DateTime(2026, 11, 20, 10, 0);
      final item = TrashItem(
        id: 'item-1',
        trashPath: '/bin/file.pdf',
        originalPath: '/docs/file.pdf',
        originalName: 'file.pdf',
        extension: 'pdf',
        sizeBytes: 100,
        category: FileCategory.pdf,
        originalModifiedMs: now.millisecondsSinceEpoch,
        deletedMs: now.millisecondsSinceEpoch,
        expiresMs: now.add(const Duration(days: 30)).millisecondsSinceEpoch,
        wasBookmarked: false,
        wasImported: false,
      );

      await fakeDb.insert(AppDatabase.tableTrash, item.toMap());

      final updatedCount = await purgeService.ageAllTrashItems(days: 29);
      expect(updatedCount, 1);

      final rows = await fakeDb.query(AppDatabase.tableTrash);
      final aged = TrashItem.fromMap(rows.first);

      // Before aging: 30 days left; after aging 29 days: 1 day left!
      expect(aged.daysLeft(now: now), 1);
      expect(aged.isExpiringSoon(now: now), isTrue);
    });
  });
}
