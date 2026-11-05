import 'dart:convert';
import 'dart:io';

import 'package:docview/core/constants/file_types.dart';
import 'package:docview/core/utils/file_name_utils.dart';
import 'package:docview/core/utils/format_utils.dart';
import 'package:docview/core/utils/page_range_parser.dart';
import 'package:docview/core/utils/root_path_resolver.dart';
import 'package:docview/data/models/doc_file.dart';
import 'package:docview/data/models/sort_option.dart';
import 'package:docview/data/services/pdf/image_to_pdf_service.dart';
import 'package:docview/data/services/pdf/pdf_output_service.dart';
import 'package:docview/features/directories/services/directory_lister.dart';
import 'package:docview/features/viewer/txt_viewer_screen.dart';
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

  group('FileNameUtils Tests', () {
    test('validateFileName accepts valid base names', () {
      expect(validateFileName('valid_document'), isNull);
      expect(validateFileName('My Report 2026'), isNull);
      expect(validateFileName('Invoice.v2.draft'), isNull);
      expect(validateFileName('12345'), isNull);
    });

    test('validateFileName rejects empty or whitespace-only names', () {
      expect(validateFileName(''), isNotNull);
      expect(validateFileName('   '), isNotNull);
    });

    test('validateFileName rejects names longer than 120 chars', () {
      final longName = 'a' * 121;
      expect(validateFileName(longName), isNotNull);
      expect(validateFileName('a' * 120), isNull);
    });

    test('validateFileName rejects illegal characters and control chars', () {
      expect(validateFileName('file/name'), isNotNull);
      expect(validateFileName('file\\name'), isNotNull);
      expect(validateFileName('file:name'), isNotNull);
      expect(validateFileName('file*name'), isNotNull);
      expect(validateFileName('file?name'), isNotNull);
      expect(validateFileName('file"name'), isNotNull);
      expect(validateFileName('file<name'), isNotNull);
      expect(validateFileName('file>name'), isNotNull);
      expect(validateFileName('file|name'), isNotNull);
      expect(validateFileName('file\x00name'), isNotNull);
      expect(validateFileName('file\x1Fname'), isNotNull);
    });

    test('validateFileName rejects leading dot, single dot, and double dot', () {
      expect(validateFileName('.'), isNotNull);
      expect(validateFileName('..'), isNotNull);
      expect(validateFileName('.hidden'), isNotNull);
      expect(validateFileName('.bashrc'), isNotNull);
    });

    test('buildRenamedPath preserves original extension, spaces, and multiple dots', () {
      expect(
        buildRenamedPath('/docs/report.pdf', 'financial_report'),
        '/docs/financial_report.pdf',
      );
      expect(
        buildRenamedPath('/folder/my file.docx', 'new file with spaces'),
        '/folder/new file with spaces.docx',
      );
      expect(
        buildRenamedPath('/folder/app.v1.0.txt', 'app.v2.0.beta'),
        '/folder/app.v2.0.beta.txt',
      );
      expect(
        buildRenamedPath('/docs/sheet.xlsx', 'sheet_renamed.xlsx'),
        '/docs/sheet_renamed.xlsx',
      );
    });
  });

  group('Root Path Resolver Tests', () {
    test('deriveAndroidRoot cuts at /Android correctly', () {
      expect(
        deriveAndroidRoot('/storage/emulated/0/Android/data/com.craftline/files'),
        '/storage/emulated/0',
      );
      expect(
        deriveAndroidRoot(r'C:\storage\emulated\0\Android\data'),
        'C:/storage/emulated/0',
      );
      expect(
        deriveAndroidRoot('/storage/emulated/0/Android/obb'),
        '/storage/emulated/0',
      );
      expect(
        deriveAndroidRoot('/custom/mount/point'),
        '/custom/mount/point',
      );
      expect(
        deriveAndroidRoot(null),
        '/storage/emulated/0',
      );
      expect(
        deriveAndroidRoot('   '),
        '/storage/emulated/0',
      );
    });

    test('resolveRootDirectory resolves mock Android external root', () async {
      final root = await resolveRootDirectory(
        isAndroid: true,
        isIOS: false,
        getExternalStorageDir: () async =>
            Directory('/storage/emulated/0/Android/data/com.example/files'),
      );
      expect(root, '/storage/emulated/0');
    });

    test('resolveRootDirectory resolves mock iOS documents path', () async {
      final root = await resolveRootDirectory(
        isAndroid: false,
        isIOS: true,
        getAppDocumentsDir: () async =>
            Directory('/var/mobile/Containers/Data/Application/app/Documents'),
      );
      expect(root, '/var/mobile/Containers/Data/Application/app/Documents');
    });
  });

  group('Directory State Mapping Tests', () {
    test('mapListingExceptionToState maps PathAccessException to folderAccessDenied', () {
      final state = mapListingExceptionToState(
        PathAccessException('/Android/data', const OSError('Permission denied', 13)),
        '/Android/data',
      );
      expect(state, isA<DirectoryFolderAccessDeniedState>());
      expect((state as DirectoryFolderAccessDeniedState).path, '/Android/data');
    });

    test('mapListingExceptionToState maps FileSystemException errno 13 to folderAccessDenied', () {
      final state = mapListingExceptionToState(
        FileSystemException('Access is denied', '/Android/obb', const OSError('Access denied', 13)),
        '/Android/obb',
      );
      expect(state, isA<DirectoryFolderAccessDeniedState>());
    });

    test('mapListingExceptionToState maps FileSystemException errno 2 to notFound', () {
      final state = mapListingExceptionToState(
        FileSystemException('Cannot find path', '/deleted/folder', const OSError('No such file', 2)),
        '/deleted/folder',
      );
      expect(state, isA<DirectoryNotFoundState>());
      expect((state as DirectoryNotFoundState).path, '/deleted/folder');
    });

    test('mapListingExceptionToState maps general errors to unknownError', () {
      final state = mapListingExceptionToState(
        const FormatException('Malformed payload'),
        '/some/folder',
      );
      expect(state, isA<DirectoryUnknownErrorState>());
      expect((state as DirectoryUnknownErrorState).message, contains('Malformed payload'));
    });
  });

  group('Isolate Safety & Regression Tests', () {
    test('listDirectoryEntries runs via real Isolate.run and filters correctly', () async {
      final tempDir = Directory.systemTemp.createTempSync('docview_isolate_test_');

      try {
        // Subfolder
        final subDir = Directory('${tempDir.path}/subfolder');
        subDir.createSync();
        File('${subDir.path}/child.pdf').writeAsStringSync('dummy child pdf');

        // Supported document
        File('${tempDir.path}/sample.pdf').writeAsStringSync('%PDF-1.4 sample content');

        // Hidden file & hidden folder (should be excluded)
        File('${tempDir.path}/.secret').writeAsStringSync('hidden secret');
        Directory('${tempDir.path}/.hidden_dir').createSync();

        // Unsupported extension file (should be excluded)
        File('${tempDir.path}/data.xyz').writeAsStringSync('unsupported extension');

        final entries = await listDirectoryEntries(tempDir.path);

        expect(entries.length, 2);

        final folderEntry = entries.firstWhere((e) => e.isDirectory);
        expect(folderEntry.name, 'subfolder');
        expect(folderEntry.itemCount, 1);

        final fileEntry = entries.firstWhere((e) => !e.isDirectory);
        expect(fileEntry.name, 'sample.pdf');
        expect(fileEntry.category, FileCategory.pdf);
      } finally {
        tempDir.deleteSync(recursive: true);
      }
    });

    test('readTxtFileContent reads text lines via Isolate.run safely', () async {
      final tempFile = File('${Directory.systemTemp.path}/sample_test.txt');
      try {
        tempFile.writeAsStringSync('First Line\nSecond Line\nThird Line');

        final content = await readTxtFileContent(tempFile.path);

        expect(content.lines, ['First Line', 'Second Line', 'Third Line']);
        expect(content.isTruncated, isFalse);
      } finally {
        if (tempFile.existsSync()) {
          tempFile.deleteSync();
        }
      }
    });

    test('compilePdfInIsolate produces valid PDF bytes via Isolate.run safely', () async {
      // 1x1 base64 transparent PNG
      final samplePng = base64Decode(
        'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+M9QDwADhgGAWjR9awAAAABJRU5ErkJggg==',
      );

      final payload = PdfCompilationPayload(
        images: [samplePng],
        fitImage: false,
      );

      final pdfBytes = await compilePdfInIsolate(payload);

      expect(pdfBytes.isNotEmpty, isTrue);
      final header = utf8.decode(pdfBytes.sublist(0, 5));
      expect(header, '%PDF-');
    });
  });
}


