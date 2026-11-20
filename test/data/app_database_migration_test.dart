import 'package:docview/data/db/app_database.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppDatabase v3 Schema & Migration Contract Tests', () {
    test('databaseVersion is bumped to 3 and tableTrash constant exists', () {
      expect(AppDatabase.databaseVersion, 3);
      expect(AppDatabase.tableTrash, 'trash');
      expect(AppDatabase.tableFiles, 'files');
    });
  });
}
