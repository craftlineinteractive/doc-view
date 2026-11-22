import 'dart:io';

import 'package:docview/core/constants/file_types.dart';
import 'package:docview/core/errors/app_errors.dart';
import 'package:docview/data/db/app_database.dart';
import 'package:docview/data/models/doc_file.dart';
import 'package:docview/data/services/trash_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

import '../helpers/fake_database.dart';

void main() {
  late Directory tempDir;
  late Directory binDir;
  late Directory docsDir;
  late FakeDatabase fakeDb;
  late AppDatabase appDb;
  late TrashService trashService;

  setUp(() async {
    tempDir = Directory.systemTemp.createTempSync('trash_test_');
    binDir = Directory(p.join(tempDir.path, 'recycle_bin'))..createSync(recursive: true);
    docsDir = Directory(p.join(tempDir.path, 'documents'))..createSync(recursive: true);

    fakeDb = FakeDatabase();
    appDb = AppDatabase.withDatabase(fakeDb);

    trashService = TrashService(
      database: appDb,
      binDirectoryProvider: () async => binDir,
      fallbackRestoreDirectoryProvider: () async => Directory(p.join(tempDir.path, 'fallback')),
    );
  });

  tearDown(() {
    try {
      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
      }
    } catch (_) {}
  });

  group('TrashService Move Tests', () {
    test('moves single file to trash with data integrity and removes original', () async {
      final originalFilePath = p.join(docsDir.path, 'invoice.pdf');
      final originalFile = File(originalFilePath)..writeAsStringSync('PDF Content Payload 12345');
      final originalSize = originalFile.lengthSync();
      final originalModTime = originalFile.lastModifiedSync();

      // Prepopulate files table
      await fakeDb.insert(AppDatabase.tableFiles, {
        'id': 101,
        'path': originalFilePath,
        'name': 'invoice.pdf',
        'extension': 'pdf',
        'size_bytes': originalSize,
        'modified': originalModTime.millisecondsSinceEpoch,
        'category': 'pdf',
        'is_bookmarked': 1,
        'last_opened': 1234567,
        'is_imported': 0,
      });

      final docFile = DocFile(
        id: 101,
        path: originalFilePath,
        name: 'invoice.pdf',
        extension: 'pdf',
        sizeBytes: originalSize,
        modified: originalModTime,
        category: FileCategory.pdf,
        isBookmarked: true,
        lastOpened: DateTime.fromMillisecondsSinceEpoch(1234567),
        isImported: false,
      );

      final trashItem = await trashService.moveSingleToTrash(docFile);

      // Verify original file on disk is deleted
      expect(originalFile.existsSync(), isFalse);

      // Verify copy exists in trash bin
      final trashCopy = File(trashItem.trashPath);
      expect(trashCopy.existsSync(), isTrue);
      expect(trashCopy.lengthSync(), originalSize);
      expect(trashCopy.readAsStringSync(), 'PDF Content Payload 12345');

      // Verify no temporary .part files remain
      final parts = binDir.listSync().where((e) => e.path.endsWith('.part'));
      expect(parts, isEmpty);

      // Verify database state: row in trash, row removed from files
      final trashRows = await fakeDb.query(AppDatabase.tableTrash);
      expect(trashRows.length, 1);
      expect(trashRows.first['id'], trashItem.id);
      expect(trashRows.first['was_bookmarked'], 1);
      expect(trashRows.first['was_imported'], 0);

      final fileRows = await fakeDb.query(AppDatabase.tableFiles);
      expect(fileRows, isEmpty);
    });

    test('throws fileMissing when source file does not exist on disk', () async {
      final missingDoc = DocFile(
        path: p.join(docsDir.path, 'ghost.pdf'),
        name: 'ghost.pdf',
        extension: 'pdf',
        sizeBytes: 100,
        modified: DateTime.now(),
        category: FileCategory.pdf,
      );

      expect(
        () => trashService.moveSingleToTrash(missingDoc),
        throwsA(isA<TrashException>().having(
          (e) => e.reason,
          'reason',
          TrashErrorReason.fileMissing,
        )),
      );
    });

    test('throws tooLarge when file exceeds max trash file bytes', () async {
      final bigFilePath = p.join(docsDir.path, 'huge.pdf');
      File(bigFilePath).writeAsStringSync('This content has more than 20 bytes');

      final serviceWithLimit = TrashService(
        database: appDb,
        binDirectoryProvider: () async => binDir,
        maxFileBytes: 20, // 20 bytes limit
      );

      final bigDoc = DocFile(
        path: bigFilePath,
        name: 'huge.pdf',
        extension: 'pdf',
        sizeBytes: 36,
        modified: DateTime.now(),
        category: FileCategory.pdf,
      );

      expect(
        () => serviceWithLimit.moveSingleToTrash(bigDoc),
        throwsA(isA<TrashException>().having(
          (e) => e.reason,
          'reason',
          TrashErrorReason.tooLarge,
        )),
      );

      // Verify file was not moved
      expect(File(bigFilePath).existsSync(), isTrue);
      final binFiles = binDir.listSync();
      expect(binFiles, isEmpty);
    });

    test('moveToTrash batch handles partial failures and aggregates results', () async {
      final file1Path = p.join(docsDir.path, 'file1.txt');
      File(file1Path).writeAsStringSync('F1');
      final file2Path = p.join(docsDir.path, 'missing_file.txt');

      final doc1 = DocFile(
        path: file1Path,
        name: 'file1.txt',
        extension: 'txt',
        sizeBytes: 2,
        modified: DateTime.now(),
        category: FileCategory.txt,
      );

      final doc2 = DocFile(
        path: file2Path,
        name: 'missing_file.txt',
        extension: 'txt',
        sizeBytes: 2,
        modified: DateTime.now(),
        category: FileCategory.txt,
      );

      final batchResult = await trashService.moveToTrash([doc1, doc2]);
      expect(batchResult.successfulItems.length, 1);
      expect(batchResult.failedFiles.length, 1);
      expect(batchResult.hasSuccesses, isTrue);
      expect(batchResult.isFullSuccess, isFalse);
      expect(batchResult.firstErrorReason, TrashErrorReason.fileMissing);
    });
  });

  group('TrashService Failure-Injection Proof Tests', () {
    late String testFilePath;
    late DocFile testDoc;
    const String fileContent = 'CRITICAL USER DATA TO PRESERVE';

    setUp(() async {
      testFilePath = p.join(docsDir.path, 'vital.pdf');
      final f = File(testFilePath)..writeAsStringSync(fileContent);

      await fakeDb.insert(AppDatabase.tableFiles, {
        'id': 555,
        'path': testFilePath,
        'name': 'vital.pdf',
        'extension': 'pdf',
        'size_bytes': f.lengthSync(),
        'modified': f.lastModifiedSync().millisecondsSinceEpoch,
        'category': 'pdf',
        'is_bookmarked': 1,
      });

      testDoc = DocFile(
        id: 555,
        path: testFilePath,
        name: 'vital.pdf',
        extension: 'pdf',
        sizeBytes: f.lengthSync(),
        modified: f.lastModifiedSync(),
        category: FileCategory.pdf,
        isBookmarked: true,
      );
    });

    test('failure at copy step: original intact, no trash row, no bin/part file, files row intact', () async {
      trashService.testCopyHook = (src, dst) async {
        throw const FileSystemException('Injected copy disk full / IO error');
      };

      await expectLater(
        () => trashService.moveSingleToTrash(testDoc),
        throwsA(isA<TrashException>().having(
          (e) => e.reason,
          'reason',
          TrashErrorReason.copyFailed,
        )),
      );

      // (1) Original exists with unchanged content
      expect(File(testFilePath).existsSync(), isTrue);
      expect(File(testFilePath).readAsStringSync(), fileContent);

      // (2) No trash row in DB
      final trashRows = await fakeDb.query(AppDatabase.tableTrash);
      expect(trashRows, isEmpty);

      // (3) No leftover .part or bin file
      final binFiles = binDir.listSync();
      expect(binFiles, isEmpty);

      // (4) Files row is intact in DB
      final fileRows = await fakeDb.query(AppDatabase.tableFiles);
      expect(fileRows.length, 1);
      expect(fileRows.first['path'], testFilePath);
    });

    test('failure at verify step (size mismatch): original intact, no trash row, no bin/part file, files row intact', () async {
      trashService.testVerifyHook = (partFile) async {
        // Corrupt size by appending extra bytes
        partFile.writeAsStringSync('CORRUPTED_EXTRA_BYTES', mode: FileMode.append);
        throw const TrashException(
          TrashErrorReason.verifyFailed,
          'Size mismatch between original and copy',
        );
      };

      await expectLater(
        () => trashService.moveSingleToTrash(testDoc),
        throwsA(isA<TrashException>().having(
          (e) => e.reason,
          'reason',
          TrashErrorReason.verifyFailed,
        )),
      );

      expect(File(testFilePath).existsSync(), isTrue);
      expect(File(testFilePath).readAsStringSync(), fileContent);
      expect(await fakeDb.query(AppDatabase.tableTrash), isEmpty);
      expect(binDir.listSync(), isEmpty);
      final fileRows = await fakeDb.query(AppDatabase.tableFiles);
      expect(fileRows.length, 1);
      expect(fileRows.first['path'], testFilePath);
    });

    test('failure at verify step (hash mismatch): original intact, no trash row, no bin/part file, files row intact', () async {
      trashService.testVerifyHook = (partFile) async {
        throw const TrashException(
          TrashErrorReason.verifyFailed,
          'SHA-256 hash mismatch: integrity verification failed',
        );
      };

      await expectLater(
        () => trashService.moveSingleToTrash(testDoc),
        throwsA(isA<TrashException>().having(
          (e) => e.reason,
          'reason',
          TrashErrorReason.verifyFailed,
        )),
      );

      expect(File(testFilePath).existsSync(), isTrue);
      expect(File(testFilePath).readAsStringSync(), fileContent);
      expect(await fakeDb.query(AppDatabase.tableTrash), isEmpty);
      expect(binDir.listSync(), isEmpty);
      final fileRows = await fakeDb.query(AppDatabase.tableFiles);
      expect(fileRows.length, 1);
      expect(fileRows.first['path'], testFilePath);
    });

    test('failure at rename step: original intact, no trash row, no bin/part file, files row intact', () async {
      trashService.testRenameHook = (partPath, finalPath) async {
        throw const FileSystemException('Injected atomic rename failure');
      };

      await expectLater(
        () => trashService.moveSingleToTrash(testDoc),
        throwsA(isA<TrashException>().having(
          (e) => e.reason,
          'reason',
          TrashErrorReason.copyFailed,
        )),
      );

      expect(File(testFilePath).existsSync(), isTrue);
      expect(File(testFilePath).readAsStringSync(), fileContent);
      expect(await fakeDb.query(AppDatabase.tableTrash), isEmpty);
      expect(binDir.listSync(), isEmpty);
      final fileRows = await fakeDb.query(AppDatabase.tableFiles);
      expect(fileRows.length, 1);
      expect(fileRows.first['path'], testFilePath);
    });

    test('failure at DB transaction step: original intact, no trash row, no bin/part file, files row intact', () async {
      trashService.testDbTransactionHook = () async {
        throw Exception('Injected SQLite write failure / disk full');
      };

      await expectLater(
        () => trashService.moveSingleToTrash(testDoc),
        throwsA(isA<TrashException>().having(
          (e) => e.reason,
          'reason',
          TrashErrorReason.unknown,
        )),
      );

      expect(File(testFilePath).existsSync(), isTrue);
      expect(File(testFilePath).readAsStringSync(), fileContent);
      expect(await fakeDb.query(AppDatabase.tableTrash), isEmpty);
      expect(binDir.listSync(), isEmpty);
      final fileRows = await fakeDb.query(AppDatabase.tableFiles);
      expect(fileRows.length, 1);
      expect(fileRows.first['path'], testFilePath);
    });

    test('failure at original delete step: original intact, no trash row, no bin/part file, files row restored', () async {
      trashService.testOriginalDeleteHook = (origFile) async {
        throw const FileSystemException('Injected permission denied deleting original');
      };

      await expectLater(
        () => trashService.moveSingleToTrash(testDoc),
        throwsA(isA<TrashException>().having(
          (e) => e.reason,
          'reason',
          TrashErrorReason.deleteOriginalFailed,
        )),
      );

      // Rollback must restore everything
      expect(File(testFilePath).existsSync(), isTrue);
      expect(File(testFilePath).readAsStringSync(), fileContent);
      expect(await fakeDb.query(AppDatabase.tableTrash), isEmpty);
      expect(binDir.listSync(), isEmpty);
      final fileRows = await fakeDb.query(AppDatabase.tableFiles);
      expect(fileRows.length, 1);
      expect(fileRows.first['path'], testFilePath);
      expect(fileRows.first['is_bookmarked'], 1);
    });

    test('restore failure when destination is unavailable: trash file intact, DB trash row intact', () async {
      // First move to trash successfully
      final trashItem = await trashService.moveSingleToTrash(testDoc);
      expect(File(testFilePath).existsSync(), isFalse);
      expect(File(trashItem.trashPath).existsSync(), isTrue);
      expect((await fakeDb.query(AppDatabase.tableTrash)).length, 1);

      // Now inject restore copy failure
      trashService.testRestoreCopyHook = (trashFile, partPath) async {
        throw const FileSystemException('Injected destination read-only / unavailable');
      };

      await expectLater(
        () => trashService.restoreItem(trashItem),
        throwsA(isA<TrashException>().having(
          (e) => e.reason,
          'reason',
          TrashErrorReason.copyFailed,
        )),
      );

      // Verify trash copy was NOT deleted
      expect(File(trashItem.trashPath).existsSync(), isTrue);
      expect(File(trashItem.trashPath).readAsStringSync(), fileContent);

      // Verify DB trash row is preserved
      final trashRows = await fakeDb.query(AppDatabase.tableTrash);
      expect(trashRows.length, 1);
      expect(trashRows.first['id'], trashItem.id);

      // Verify no temporary .part file left at destination
      final docDirParts = docsDir.listSync().where((e) => e.path.endsWith('.part'));
      expect(docDirParts, isEmpty);
    });
  });

  group('TrashService Restore Tests', () {
    test('restores file back to original location and removes from trash', () async {
      final originalFilePath = p.join(docsDir.path, 'sheet.xlsx');
      final originalFile = File(originalFilePath)..writeAsStringSync('Excel Data Bytes');

      final docFile = DocFile(
        id: 202,
        path: originalFilePath,
        name: 'sheet.xlsx',
        extension: 'xlsx',
        sizeBytes: originalFile.lengthSync(),
        modified: DateTime(2026, 5, 1),
        category: FileCategory.excel,
        isBookmarked: true,
      );

      // Move to trash
      final trashItem = await trashService.moveSingleToTrash(docFile);
      expect(File(originalFilePath).existsSync(), isFalse);

      // Restore
      final restoredDoc = await trashService.restoreItem(trashItem);

      // Verify restored file exists at original path
      expect(restoredDoc.path, originalFilePath);
      expect(File(originalFilePath).existsSync(), isTrue);
      expect(File(originalFilePath).readAsStringSync(), 'Excel Data Bytes');

      // Verify trash copy is removed
      expect(File(trashItem.trashPath).existsSync(), isFalse);

      // Verify DB: item removed from trash, row added to files
      final trashRows = await fakeDb.query(AppDatabase.tableTrash);
      expect(trashRows, isEmpty);

      final fileRows = await fakeDb.query(AppDatabase.tableFiles);
      expect(fileRows.length, 1);
      expect(fileRows.first['path'], originalFilePath);
      expect(fileRows.first['is_bookmarked'], 1);
    });

    test('restores with renamed path when original path is occupied on disk', () async {
      final originalFilePath = p.join(docsDir.path, 'contract.pdf');
      File(originalFilePath).writeAsStringSync('Contract V1');

      final doc = DocFile(
        path: originalFilePath,
        name: 'contract.pdf',
        extension: 'pdf',
        sizeBytes: 11,
        modified: DateTime.now(),
        category: FileCategory.pdf,
      );

      final trashItem = await trashService.moveSingleToTrash(doc);

      // Someone creates a new file at contract.pdf while it is in the bin!
      File(originalFilePath).writeAsStringSync('New Conflicting Contract');

      final restoredDoc = await trashService.restoreItem(trashItem);

      final expectedPath = p.join(docsDir.path, 'contract (restored).pdf');
      expect(restoredDoc.path, expectedPath);
      expect(restoredDoc.name, 'contract (restored).pdf');
      expect(File(expectedPath).existsSync(), isTrue);
      expect(File(expectedPath).readAsStringSync(), 'Contract V1');

      // The conflicting original remains unharmed
      expect(File(originalFilePath).readAsStringSync(), 'New Conflicting Contract');
    });

    test('recreates parent directory if it was deleted while file was in trash', () async {
      final subFolder = Directory(p.join(docsDir.path, 'nested', 'sub'))..createSync(recursive: true);
      final filePath = p.join(subFolder.path, 'notes.txt');
      File(filePath).writeAsStringSync('Important Notes');

      final doc = DocFile(
        path: filePath,
        name: 'notes.txt',
        extension: 'txt',
        sizeBytes: 15,
        modified: DateTime.now(),
        category: FileCategory.txt,
      );

      final trashItem = await trashService.moveSingleToTrash(doc);

      // User deletes the nested folder
      subFolder.deleteSync(recursive: true);
      expect(subFolder.existsSync(), isFalse);

      final restoredDoc = await trashService.restoreItem(trashItem);
      expect(File(restoredDoc.path).existsSync(), isTrue);
      expect(File(restoredDoc.path).readAsStringSync(), 'Important Notes');
    });
  });

  group('TrashService Permanent Deletion & Empty Trash Tests', () {
    test('deleteForeverSingle removes physical file from bin and deletes DB row', () async {
      final filePath = p.join(docsDir.path, 'temp.txt');
      File(filePath).writeAsStringSync('Temp');

      final doc = DocFile(
        path: filePath,
        name: 'temp.txt',
        extension: 'txt',
        sizeBytes: 4,
        modified: DateTime.now(),
        category: FileCategory.txt,
      );

      final trashItem = await trashService.moveSingleToTrash(doc);
      expect(File(trashItem.trashPath).existsSync(), isTrue);

      await trashService.deleteForeverSingle(trashItem);

      expect(File(trashItem.trashPath).existsSync(), isFalse);
      final rows = await fakeDb.query(AppDatabase.tableTrash);
      expect(rows, isEmpty);
    });

    test('emptyTrash permanently wipes all trashed files, orphan files, and DB rows', () async {
      final f1 = File(p.join(docsDir.path, 'f1.pdf'))..writeAsStringSync('F1');
      final f2 = File(p.join(docsDir.path, 'f2.pdf'))..writeAsStringSync('F2');

      final doc1 = DocFile(
        path: f1.path,
        name: 'f1.pdf',
        extension: 'pdf',
        sizeBytes: 2,
        modified: DateTime.now(),
        category: FileCategory.pdf,
      );
      final doc2 = DocFile(
        path: f2.path,
        name: 'f2.pdf',
        extension: 'pdf',
        sizeBytes: 2,
        modified: DateTime.now(),
        category: FileCategory.pdf,
      );

      await trashService.moveSingleToTrash(doc1);
      await trashService.moveSingleToTrash(doc2);

      // Add an orphan file in binDir
      File(p.join(binDir.path, 'orphan.pdf')).writeAsStringSync('Orphan');

      final count = await trashService.emptyTrash();
      expect(count, 2);

      final binFiles = binDir.listSync();
      expect(binFiles, isEmpty);

      final rows = await fakeDb.query(AppDatabase.tableTrash);
      expect(rows, isEmpty);
    });

    test('slowCopyThrottleEnabled can never activate in release', () {
      TrashService.slowCopyThrottleEnabled = true;
      // In release builds isDebug would be false:
      expect(TrashService.isThrottleAllowed(isDebug: false), isFalse);
      // In debug builds with throttle set to true:
      expect(TrashService.isThrottleAllowed(isDebug: true), isTrue);

      TrashService.slowCopyThrottleEnabled = false;
      expect(TrashService.isThrottleAllowed(isDebug: true), isFalse);
      expect(TrashService.isThrottleAllowed(isDebug: false), isFalse);
    });

    test('throttledCopy copies full content accurately', () async {
      final src = File(p.join(tempDir.path, 'source_file.txt'))..writeAsStringSync('Hello World 12345');
      final dst = File(p.join(tempDir.path, 'dest_file.txt'));

      await TrashService.throttledCopy(src, dst);

      expect(dst.existsSync(), isTrue);
      expect(dst.readAsStringSync(), 'Hello World 12345');
    });
  });
}
