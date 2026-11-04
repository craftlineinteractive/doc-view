import 'dart:convert';

import 'package:docview/core/constants/file_types.dart';
import 'package:docview/core/utils/format_utils.dart';
import 'package:docview/data/models/doc_file.dart';
import 'package:docview/data/models/sort_option.dart';
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

    test('isOfficeViewerSupported recognizes supported office formats and excludes others', () {
      // Supported Office formats
      expect(isOfficeViewerSupported('document.docx'), isTrue);
      expect(isOfficeViewerSupported('macro.docm'), isTrue);
      expect(isOfficeViewerSupported('sheet.xlsx'), isTrue);
      expect(isOfficeViewerSupported('macro_sheet.xlsm'), isTrue);
      expect(isOfficeViewerSupported('slides.pptx'), isTrue);
      expect(isOfficeViewerSupported('macro_slides.pptm'), isTrue);
      expect(isOfficeViewerSupported('legacy.xls'), isTrue);
      expect(isOfficeViewerSupported('data.csv'), isTrue);
      expect(isOfficeViewerSupported('data.tsv'), isTrue);
      expect(isOfficeViewerSupported('document.rtf'), isTrue);
      expect(isOfficeViewerSupported('old.doc'), isTrue);
      expect(isOfficeViewerSupported('old.ppt'), isTrue);

      // Excluded formats (open externally or other viewers)
      expect(isOfficeViewerSupported('document.odt'), isFalse);
      expect(isOfficeViewerSupported('sheet.ods'), isFalse);
      expect(isOfficeViewerSupported('slides.odp'), isFalse);
      expect(isOfficeViewerSupported('manual.pdf'), isFalse);
      expect(isOfficeViewerSupported('photo.png'), isFalse);
      expect(isOfficeViewerSupported('notes.txt'), isFalse);
      expect(isOfficeViewerSupported('unknown.xyz'), isFalse);
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

    test('escapeLike escapes %, _, and backslash properly', () {
      expect(escapeLike('document'), 'document');
      expect(escapeLike('100%'), r'100\%');
      expect(escapeLike('my_file'), r'my\_file');
      expect(escapeLike(r'folder\path'), r'folder\\path');
      expect(escapeLike(r'100%_done\doc'), r'100\%\_done\\doc');
    });
  });

  group('SortOption Tests', () {
    test('toOrderBy produces whitelisted SQL clauses', () {
      const dateDesc = SortOption(
        field: SortField.date,
        direction: SortDirection.desc,
      );
      expect(dateDesc.toOrderBy(), 'modified DESC');

      const dateAsc = SortOption(
        field: SortField.date,
        direction: SortDirection.asc,
      );
      expect(dateAsc.toOrderBy(), 'modified ASC');

      const nameAsc = SortOption(
        field: SortField.name,
        direction: SortDirection.asc,
      );
      expect(nameAsc.toOrderBy(), 'name COLLATE NOCASE ASC');

      const nameDesc = SortOption(
        field: SortField.name,
        direction: SortDirection.desc,
      );
      expect(nameDesc.toOrderBy(), 'name COLLATE NOCASE DESC');

      const sizeAsc = SortOption(
        field: SortField.size,
        direction: SortDirection.asc,
      );
      expect(sizeAsc.toOrderBy(), 'size_bytes ASC');

      const sizeDesc = SortOption(
        field: SortField.size,
        direction: SortDirection.desc,
      );
      expect(sizeDesc.toOrderBy(), 'size_bytes DESC');
    });

    test('SortOption equality and copyWith work as expected', () {
      const opt1 = SortOption(
        field: SortField.date,
        direction: SortDirection.desc,
      );
      final opt2 = opt1.copyWith(direction: SortDirection.asc);

      expect(opt1 == SortOption.defaultOption, isTrue);
      expect(opt2.direction, SortDirection.asc);
      expect(opt2.field, SortField.date);
      expect(opt1 == opt2, isFalse);
    });
  });

  group('Viewer & Encoding Tests', () {
    test('utf8 decode handles malformed bytes without crashing', () {
      final invalidBytes = [0xFF, 0xFE, 0xFD, 65, 66, 67]; // malformed + 'ABC'
      final decoded = utf8.decode(invalidBytes, allowMalformed: true);
      expect(decoded.contains('ABC'), isTrue);
    });

    test('LineSplitter splits multi-line text cleanly', () {
      const multiline = 'Line 1\nLine 2\r\nLine 3\n';
      final lines = const LineSplitter().convert(multiline);
      expect(lines.length, 3);
      expect(lines[0], 'Line 1');
      expect(lines[1], 'Line 2');
      expect(lines[2], 'Line 3');
    });
  });
}


