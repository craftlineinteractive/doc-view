import 'dart:convert';
import 'dart:io';

import 'package:docview/core/constants/file_types.dart';
import 'package:docview/core/utils/format_utils.dart';
import 'package:docview/core/utils/page_range_parser.dart';
import 'package:docview/data/models/doc_file.dart';
import 'package:docview/data/models/sort_option.dart';
import 'package:docview/data/services/pdf/pdf_output_service.dart';
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

  group('PageRangeParser Tests', () {
    test('parses valid single pages and ranges preserving user order', () {
      final ranges = parsePageRanges('1-3, 5, 8-10', 10);
      expect(ranges, [
        const PageRange(1, 3),
        const PageRange(5, 5),
        const PageRange(8, 10),
      ]);
    });

    test('handles whitespace around numbers and hyphens', () {
      final ranges = parsePageRanges('  2 - 4 ,  7  , 9 - 10 ', 12);
      expect(ranges, [
        const PageRange(2, 4),
        const PageRange(7, 7),
        const PageRange(9, 10),
      ]);
    });

    test('allows non-sequential and overlapping ranges without auto-merging', () {
      final ranges = parsePageRanges('5, 1-3, 2-4', 10);
      expect(ranges, [
        const PageRange(5, 5),
        const PageRange(1, 3),
        const PageRange(2, 4),
      ]);
    });

    test('rejects empty inputs or empty segments', () {
      expect(() => parsePageRanges('', 5), throwsA(isA<PageRangeParseException>()));
      expect(() => parsePageRanges('   ', 5), throwsA(isA<PageRangeParseException>()));
      expect(() => parsePageRanges('1, , 3', 5), throwsA(isA<PageRangeParseException>()));
      expect(() => parsePageRanges('1, 2,', 5), throwsA(isA<PageRangeParseException>()));
    });

    test('rejects zero or negative page numbers', () {
      expect(() => parsePageRanges('0', 5), throwsA(isA<PageRangeParseException>()));
      expect(() => parsePageRanges('0-3', 5), throwsA(isA<PageRangeParseException>()));
      expect(() => parsePageRanges('-1', 5), throwsA(isA<PageRangeParseException>()));
    });

    test('rejects reversed ranges (start > end)', () {
      expect(() => parsePageRanges('5-2', 10), throwsA(isA<PageRangeParseException>()));
      expect(() => parsePageRanges('3-1', 5), throwsA(isA<PageRangeParseException>()));
    });

    test('rejects out of range pages exceeding total page count', () {
      expect(() => parsePageRanges('11', 10), throwsA(isA<PageRangeParseException>()));
      expect(() => parsePageRanges('8-12', 10), throwsA(isA<PageRangeParseException>()));
    });

    test('rejects non-numeric tokens and malformed hyphens', () {
      expect(() => parsePageRanges('abc', 5), throwsA(isA<PageRangeParseException>()));
      expect(() => parsePageRanges('1-two', 5), throwsA(isA<PageRangeParseException>()));
      expect(() => parsePageRanges('1--3', 5), throwsA(isA<PageRangeParseException>()));
      expect(() => parsePageRanges('1-2-3', 5), throwsA(isA<PageRangeParseException>()));
    });

    test('validatePageRanges returns null for valid and error string for invalid', () {
      expect(validatePageRanges('1-3, 5', 5), isNull);
      expect(validatePageRanges('5-2', 5), isNotNull);
      expect(validatePageRanges('6', 5), isNotNull);
    });
  });

  group('PdfOutputService Naming & Sanitizing Tests', () {
    test('sanitizeFileName removes illegal characters and trims', () {
      expect(PdfOutputService.sanitizeFileName('report/2026:final*?.pdf'), 'report2026final');
      expect(PdfOutputService.sanitizeFileName('my <file> | "quote"'), 'my file  quote');
      expect(PdfOutputService.sanitizeFileName(''), 'Document');
      expect(PdfOutputService.sanitizeFileName(':::'), 'Document');
      expect(PdfOutputService.sanitizeFileName('MyInvoice.PDF'), 'MyInvoice');
    });

    test('uniqueFileInDir appends numbers sequentially when collision occurs', () {
      final tempDir = Directory.systemTemp.createTempSync('pdf_output_test_');
      try {
        final f1 = PdfOutputService.uniqueFileInDir(tempDir, 'Invoice');
        expect(f1.path.endsWith('Invoice.pdf'), isTrue);
        f1.writeAsStringSync('dummy');

        final f2 = PdfOutputService.uniqueFileInDir(tempDir, 'Invoice');
        expect(f2.path.endsWith('Invoice (1).pdf'), isTrue);
        f2.writeAsStringSync('dummy');

        final f3 = PdfOutputService.uniqueFileInDir(tempDir, 'Invoice');
        expect(f3.path.endsWith('Invoice (2).pdf'), isTrue);
      } finally {
        tempDir.deleteSync(recursive: true);
      }
    });
  });
}


