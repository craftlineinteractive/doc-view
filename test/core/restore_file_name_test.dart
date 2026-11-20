import 'package:docview/core/utils/file_name_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('buildRestorePath Tests', () {
    test('returns original path when path is free on disk', () {
      final path = '/storage/documents/report.pdf';
      final result = buildRestorePath(path, (p) => false);
      expect(result, path);
    });

    test('appends " (restored)" on first name collision', () {
      final path = '/storage/documents/report.pdf';
      final existing = {'/storage/documents/report.pdf'};
      final result = buildRestorePath(path, (p) => existing.contains(p));
      expect(result, '/storage/documents/report (restored).pdf');
    });

    test('increments counter to " (restored 2)" when " (restored)" also exists', () {
      final path = '/storage/documents/report.pdf';
      final existing = {
        '/storage/documents/report.pdf',
        '/storage/documents/report (restored).pdf',
      };
      final result = buildRestorePath(path, (p) => existing.contains(p));
      expect(result, '/storage/documents/report (restored 2).pdf');
    });

    test('increments counter to " (restored 3)" when 1 and 2 exist', () {
      final path = '/storage/documents/report.pdf';
      final existing = {
        '/storage/documents/report.pdf',
        '/storage/documents/report (restored).pdf',
        '/storage/documents/report (restored 2).pdf',
      };
      final result = buildRestorePath(path, (p) => existing.contains(p));
      expect(result, '/storage/documents/report (restored 3).pdf');
    });

    test('handles files with multiple dots in base name', () {
      final path = '/storage/documents/my.notes.final.txt';
      final existing = {'/storage/documents/my.notes.final.txt'};
      final result = buildRestorePath(path, (p) => existing.contains(p));
      expect(result, '/storage/documents/my.notes.final (restored).txt');
    });

    test('handles files without an extension', () {
      final path = '/storage/documents/README';
      final existing = {'/storage/documents/README'};
      final result = buildRestorePath(path, (p) => existing.contains(p));
      expect(result, '/storage/documents/README (restored)');
    });
  });
}
