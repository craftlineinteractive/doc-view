import 'package:docview/core/constants/file_types.dart';
import 'package:docview/core/utils/format_utils.dart';
import 'package:docview/data/models/doc_file.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FileTypes & Category Classification Tests', () {
    test('categoryFromPath classifies common document types accurately', () {
      expect(categoryFromPath('report.pdf'), FileCategory.pdf);
      expect(categoryFromPath('/path/to/resume.doc'), FileCategory.word);
      expect(categoryFromPath('/path/to/contract.docx'), FileCategory.word);
      expect(categoryFromPath('data.xls'), FileCategory.excel);
      expect(categoryFromPath('spreadsheet.xlsx'), FileCategory.excel);
      expect(categoryFromPath('records.csv'), FileCategory.excel);
      expect(categoryFromPath('presentation.ppt'), FileCategory.ppt);
      expect(categoryFromPath('deck.pptx'), FileCategory.ppt);
      expect(categoryFromPath('readme.txt'), FileCategory.txt);
      expect(categoryFromPath('notes.md'), FileCategory.txt);
      expect(categoryFromPath('photo.jpg'), FileCategory.image);
      expect(categoryFromPath('graphic.png'), FileCategory.image);
      expect(categoryFromPath('animation.gif'), FileCategory.image);
    });

    test('categoryFromPath ignores unsupported or hidden files', () {
      expect(categoryFromPath('archive.zip'), isNull);
      expect(categoryFromPath('application.exe'), isNull);
      expect(categoryFromPath('package.apk'), isNull);
      expect(categoryFromPath('.gitignore'), isNull);
      expect(categoryFromPath('/storage/emulated/0/.thumbnails'), isNull);
      expect(categoryFromPath('no_extension'), isNull);
    });

    test('FileCategory properties (label, icon, color) are non-null', () {
      for (final cat in FileCategory.values) {
        expect(cat.label, isNotEmpty);
        expect(cat.icon, isNotNull);
        expect(cat.color, isNotNull);
      }
    });
  });

  group('DocFile Model Tests', () {
    test('toMap and fromMap retain all fields and state', () {
      final now = DateTime(2026, 11, 1, 12, 30);
      final doc = DocFile(
        id: 42,
        path: '/storage/emulated/0/Documents/report.pdf',
        name: 'report.pdf',
        extension: 'pdf',
        sizeBytes: 1048576,
        modified: now,
        category: FileCategory.pdf,
        isBookmarked: true,
        lastOpened: now,
        isImported: true,
      );

      final map = doc.toMap();
      expect(map['id'], 42);
      expect(map['path'], '/storage/emulated/0/Documents/report.pdf');
      expect(map['name'], 'report.pdf');
      expect(map['extension'], 'pdf');
      expect(map['size_bytes'], 1048576);
      expect(map['modified'], now.millisecondsSinceEpoch);
      expect(map['category'], 'pdf');
      expect(map['is_bookmarked'], 1);
      expect(map['last_opened'], now.millisecondsSinceEpoch);
      expect(map['is_imported'], 1);

      final restored = DocFile.fromMap(map);
      expect(restored, equals(doc));
    });

    test('copyWith updates specified fields only', () {
      final now = DateTime(2026, 11, 1);
      final original = DocFile(
        path: '/a.txt',
        name: 'a.txt',
        extension: 'txt',
        sizeBytes: 100,
        modified: DateTime(2026, 1, 1),
        category: FileCategory.txt,
      );

      final updated = original.copyWith(
        isBookmarked: true,
        sizeBytes: 250,
        modified: now,
      );

      expect(updated.path, '/a.txt');
      expect(updated.name, 'a.txt');
      expect(updated.sizeBytes, 250);
      expect(updated.isBookmarked, isTrue);
      expect(updated.modified, now);
      expect(updated.category, FileCategory.txt);
    });
  });

  group('FormatUtils Tests', () {
    test('formatFileSize produces human-friendly representations', () {
      expect(FormatUtils.formatFileSize(0), '0 B');
      expect(FormatUtils.formatFileSize(500), '500 B');
      expect(FormatUtils.formatFileSize(1024), '1.0 KB');
      expect(FormatUtils.formatFileSize(1536), '1.5 KB');
      expect(FormatUtils.formatFileSize(1048576), '1.0 MB');
      expect(FormatUtils.formatFileSize(2621440), '2.5 MB');
      expect(FormatUtils.formatFileSize(1073741824), '1.0 GB');
    });

    test('formatDate formats DateTime as MM/dd/yyyy', () {
      final date = DateTime(2026, 11, 1);
      expect(FormatUtils.formatDate(date), '11/01/2026');
    });

    test('formatSubtitle combines date and size', () {
      final date = DateTime(2026, 5, 15);
      expect(
        FormatUtils.formatSubtitle(date, 2097152),
        '05/15/2026 · 2.0 MB',
      );
    });
  });
}
