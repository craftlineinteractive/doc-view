import 'dart:io';

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

    test('saves vector signature to disk and loads it correctly', () async {
      final sampleStrokes = [
        [const Offset(0.1, 0.2), const Offset(0.5, 0.5), const Offset(0.9, 0.8)],
      ];

      final saved = await repository.saveSignature(
        strokes: sampleStrokes,
        aspectRatio: 2.5,
        width: 250,
        height: 100,
      );

      expect(saved.id, startsWith('sig_'));
      expect(saved.strokes.length, 1);
      expect(saved.strokes.first.length, 3);
      expect(saved.aspectRatio, 2.5);

      final list = await repository.getSignatures();
      expect(list.length, 1);
      expect(list.first.id, saved.id);
      expect(list.first.strokes.first.first, const Offset(0.1, 0.2));
      expect(list.first.aspectRatio, 2.5);
    });

    test('enforces max 5 saved signatures limit', () async {
      final sampleStrokes = [
        [const Offset(0.1, 0.1), const Offset(0.9, 0.9)],
      ];

      for (var i = 0; i < 5; i++) {
        await repository.saveSignature(
          strokes: sampleStrokes,
          aspectRatio: 2.0,
        );
      }

      final list = await repository.getSignatures();
      expect(list.length, 5);

      // 6th attempt must throw
      expect(
        () => repository.saveSignature(
          strokes: sampleStrokes,
          aspectRatio: 2.0,
        ),
        throwsA(isA<StateError>().having(
          (e) => e.message,
          'message',
          contains('Maximum 5 saved signatures'),
        )),
      );
    });

    test('deleteSignature removes signature and updates index', () async {
      final sampleStrokes = [
        [const Offset(0, 0), const Offset(1, 1)],
      ];
      final sig1 = await repository.saveSignature(strokes: sampleStrokes, aspectRatio: 2.0);
      final sig2 = await repository.saveSignature(strokes: sampleStrokes, aspectRatio: 2.0);

      expect((await repository.getSignatures()).length, 2);

      await repository.deleteSignature(sig1.id);

      final remaining = await repository.getSignatures();
      expect(remaining.length, 1);
      expect(remaining.first.id, sig2.id);
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
