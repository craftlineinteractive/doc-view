import 'dart:io';
import 'dart:typed_data';

import 'package:docview/data/repositories/signature_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SignatureRepository Unit & Backup Exclusion Tests', () {
    late Directory tempDir;
    late SignatureRepository repository;

    setUp(() {
      tempDir = Directory.systemTemp.createTempSync('sig_repo_test_');
      repository = SignatureRepository(
        getDirectoryOverride: () async => tempDir,
      );
    });

    tearDown(() {
      try {
        if (tempDir.existsSync()) {
          tempDir.deleteSync(recursive: true);
        }
      } catch (_) {}
    });

    test('saves signature to disk and loads it correctly', () async {
      final fakePng = Uint8List.fromList([1, 2, 3, 4, 5]);

      final saved = await repository.saveSignature(fakePng, width: 220, height: 80);

      expect(saved.id, startsWith('sig_'));
      expect(File(saved.filePath).existsSync(), isTrue);

      final list = await repository.getSignatures();
      expect(list.length, 1);
      expect(list.first.id, saved.id);
      expect(list.first.width, 220);
      expect(list.first.height, 80);
    });

    test('enforces max 5 saved signatures limit', () async {
      final fakePng = Uint8List.fromList([1, 2, 3]);

      for (var i = 0; i < 5; i++) {
        await repository.saveSignature(fakePng);
      }

      final list = await repository.getSignatures();
      expect(list.length, 5);

      // 6th attempt must throw
      expect(
        () => repository.saveSignature(fakePng),
        throwsA(isA<StateError>().having(
          (e) => e.message,
          'message',
          contains('Maximum 5 saved signatures'),
        )),
      );
    });

    test('deleteSignature removes file and updates index', () async {
      final fakePng = Uint8List.fromList([1, 2, 3]);
      final sig1 = await repository.saveSignature(fakePng);
      final sig2 = await repository.saveSignature(fakePng);

      expect((await repository.getSignatures()).length, 2);

      await repository.deleteSignature(sig1.id);

      final remaining = await repository.getSignatures();
      expect(remaining.length, 1);
      expect(remaining.first.id, sig2.id);
      expect(File(sig1.filePath).existsSync(), isFalse);
    });

    test('backup_rules.xml explicitly excludes signatures directory', () {
      final backupRulesFile = File('android/app/src/main/res/xml/backup_rules.xml');
      expect(backupRulesFile.existsSync(), isTrue);

      final content = backupRulesFile.readAsStringSync();
      expect(content, contains('<exclude domain="file" path="signatures"'));

      final dataExtractionFile = File('android/app/src/main/res/xml/data_extraction_rules.xml');
      expect(dataExtractionFile.existsSync(), isTrue);
      final deContent = dataExtractionFile.readAsStringSync();
      expect(deContent, contains('path="signatures"'));
    });
  });
}
