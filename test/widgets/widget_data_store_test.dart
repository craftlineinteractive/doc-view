import 'dart:convert';

import 'package:docview/core/constants/file_types.dart';
import 'package:docview/data/models/doc_file.dart';
import 'package:docview/data/services/widgets/widget_data_store.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeHomeWidgetStorage implements HomeWidgetStorage {
  final Map<String, dynamic> data = {};
  int updateWidgetCallCount = 0;

  @override
  Future<T?> getWidgetData<T>(String id, {T? defaultValue}) async {
    return (data[id] as T?) ?? defaultValue;
  }

  @override
  Future<bool?> saveWidgetData<T>(String id, T? value) async {
    data[id] = value;
    return true;
  }

  @override
  Future<bool?> updateWidget({String? name, String? androidName, String? iOSName}) async {
    updateWidgetCallCount++;
    return true;
  }
}

void main() {
  late FakeHomeWidgetStorage fakeStorage;
  late WidgetDataStore store;

  setUp(() {
    fakeStorage = FakeHomeWidgetStorage();
    store = WidgetDataStore(storage: fakeStorage);
  });

  DocFile createDocFile({
    required int id,
    required String name,
    required String path,
    required String extension,
    DateTime? modified,
  }) {
    return DocFile(
      id: id,
      path: path,
      name: name,
      extension: extension,
      sizeBytes: 1024,
      modified: modified ?? DateTime(2026, 11, 24, 12, 0, 0),
      category: FileCategory.pdf,
    );
  }

  group('WidgetDataStore Privacy & Operations Tests', () {
    test('CRITICAL PRIVACY TEST: updateRecentFiles NEVER stores file path in widget JSON', () async {
      final files = [
        createDocFile(
          id: 1,
          name: 'Confidential.pdf',
          path: '/data/user/0/com.craftlineinteractive.docview/files/Confidential.pdf',
          extension: 'pdf',
        ),
        createDocFile(
          id: 2,
          name: 'Budget_2026.xlsx',
          path: '/sdcard/Download/Secret/Budget_2026.xlsx',
          extension: 'xlsx',
        ),
      ];

      await store.updateRecentFiles(files);

      final rawJson = fakeStorage.data[WidgetDataStore.keyRecentFilesJson] as String?;
      expect(rawJson, isNotNull);

      final List decoded = jsonDecode(rawJson!);
      expect(decoded.length, 2);

      for (final item in decoded) {
        expect(item, isA<Map<String, dynamic>>());
        final map = item as Map<String, dynamic>;

        // Must strictly contain id, name, type, modified
        expect(map.containsKey('id'), isTrue);
        expect(map.containsKey('name'), isTrue);
        expect(map.containsKey('type'), isTrue);
        expect(map.containsKey('modified'), isTrue);

        // PRIVACY ENFORCEMENT: Never path or uri
        expect(map.containsKey('path'), isFalse);
        expect(map.containsKey('filePath'), isFalse);
        expect(map.containsKey('uri'), isFalse);

        // Verify the raw JSON string does not contain any file paths
        expect(rawJson.contains('/data/user/0/'), isFalse);
        expect(rawJson.contains('/sdcard/Download/Secret/'), isFalse);
      }
    });

    test('stores at most 5 files even if more are passed', () async {
      final files = List.generate(
        8,
        (i) => createDocFile(
          id: i + 1,
          name: 'Doc_$i.pdf',
          path: '/path/doc_$i.pdf',
          extension: 'pdf',
        ),
      );

      await store.updateRecentFiles(files);

      final rawJson = fakeStorage.data[WidgetDataStore.keyRecentFilesJson] as String?;
      final List decoded = jsonDecode(rawJson!);
      expect(decoded.length, 5);
      expect(decoded.first['id'], '1');
      expect(decoded.last['id'], '5');
      expect(fakeStorage.updateWidgetCallCount, 1);
    });

    test('removeFile removes only the target item and updates widget', () async {
      final files = [
        createDocFile(id: 10, name: 'File10.pdf', path: '/p1', extension: 'pdf'),
        createDocFile(id: 20, name: 'File20.pdf', path: '/p2', extension: 'pdf'),
        createDocFile(id: 30, name: 'File30.pdf', path: '/p3', extension: 'pdf'),
      ];

      await store.updateRecentFiles(files);
      expect(fakeStorage.updateWidgetCallCount, 1);

      await store.removeFile('20');

      final rawJson = fakeStorage.data[WidgetDataStore.keyRecentFilesJson] as String?;
      final List decoded = jsonDecode(rawJson!);
      expect(decoded.length, 2);
      expect(decoded.any((item) => item['id'] == '20'), isFalse);
      expect(decoded.any((item) => item['id'] == '10'), isTrue);
      expect(decoded.any((item) => item['id'] == '30'), isTrue);
      expect(fakeStorage.updateWidgetCallCount, 2);
    });

    test('clearRecentHistory empties the widget store and updates widget', () async {
      final files = [
        createDocFile(id: 100, name: 'File100.pdf', path: '/p1', extension: 'pdf'),
      ];

      await store.updateRecentFiles(files);
      await store.clearRecentHistory();

      final rawJson = fakeStorage.data[WidgetDataStore.keyRecentFilesJson] as String?;
      expect(rawJson, '[]');
      expect(fakeStorage.updateWidgetCallCount, 2);
    });
  });
}
