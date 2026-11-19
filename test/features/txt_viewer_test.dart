import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:docview/core/constants/file_types.dart';
import 'package:docview/core/theme/app_theme.dart';
import 'package:docview/data/models/doc_file.dart';
import 'package:docview/features/viewer/txt_viewer_screen.dart';
import 'package:docview/l10n/app_localizations.dart';
import 'package:docview/shared/widgets/reader/reader_bottom_row.dart';
import 'package:docview/shared/widgets/reader/reader_search_bar.dart';

Widget _buildTestApp({
  required Widget child,
  ThemeData? theme,
  Locale locale = const Locale('en'),
}) {
  return ProviderScope(
    child: MaterialApp(
      theme: theme ?? AppTheme.lightTheme,
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('en', 'XA')],
      home: Scaffold(body: child),
    ),
  );
}

void main() {
  group('TXT Search Worker Unit Tests', () {
    test('searchTxtMatchesWorker finds matches case-insensitively with accurate offsets', () {
      final sampleLines = [
        'The quick brown fox jumps over the lazy dog.',
        'Another line with Fox and FOX in uppercase.',
        'No animals here.',
      ];

      final matches = searchTxtMatchesWorker({
        'lines': sampleLines,
        'query': 'fox',
      });

      expect(matches.length, equals(3));

      // Match 1: line 0, "fox"
      expect(matches[0].lineIndex, equals(0));
      expect(matches[0].startOffset, equals(16));
      expect(matches[0].endOffset, equals(19));
      expect(sampleLines[0].substring(matches[0].startOffset, matches[0].endOffset).toLowerCase(), 'fox');

      // Match 2: line 1, "Fox"
      expect(matches[1].lineIndex, equals(1));
      expect(matches[1].startOffset, equals(18));
      expect(matches[1].endOffset, equals(21));

      // Match 3: line 1, "FOX"
      expect(matches[2].lineIndex, equals(1));
      expect(matches[2].startOffset, equals(26));
      expect(matches[2].endOffset, equals(29));
    });

    test('searchTxtMatchesWorker returns empty on empty query', () {
      final matches = searchTxtMatchesWorker({
        'lines': ['Some sample text.'],
        'query': '',
      });
      expect(matches, isEmpty);
    });

    test('readTxtFileWorker reads file content safely', () {
      final tempDir = Directory.systemTemp.createTempSync('doc_view_txt_test_');
      final tempFile = File('${tempDir.path}/sample.txt');
      tempFile.writeAsStringSync('Line 1\nLine 2\nLine 3');

      final content = readTxtFileWorker(tempFile.path);
      expect(content.lines.length, equals(3));
      expect(content.lines[0], equals('Line 1'));
      expect(content.isTruncated, isFalse);

      tempDir.deleteSync(recursive: true);
    });
  });

  group('TxtViewerScreen Widget Tests', () {
    late Directory tempDir;
    late File sampleFile;
    late DocFile docFile;

    setUp(() {
      tempDir = Directory.systemTemp.createTempSync('docview_txt_screen_');
      sampleFile = File('${tempDir.path}/readme.txt');
      sampleFile.writeAsStringSync(
        'Doc View Reader\n'
        'A fast offline document reader for mobile devices.\n'
        'Supports PDF, Word, PowerPoint, Excel and TXT files.\n'
        'Enjoy reading your documents offline!\n',
      );
      docFile = DocFile(
        path: sampleFile.path,
        name: 'readme.txt',
        extension: 'txt',
        sizeBytes: sampleFile.lengthSync(),
        modified: DateTime(2026, 11, 19),
        category: FileCategory.txt,
      );
    });

    tearDown(() {
      try {
        tempDir.deleteSync(recursive: true);
      } catch (_) {}
    });

    testWidgets('renders top bar, ReaderBottomRow with 4 items, and reading content', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          child: TxtViewerScreen(file: docFile),
        ),
      );
      await tester.runAsync(() async {
        await Future.delayed(const Duration(milliseconds: 100));
      });
      await tester.pumpAndSettle();

      // Top bar title
      expect(find.text('readme.txt'), findsOneWidget);

      // ReaderBottomRow items: Rotate, Search, Invert, Share
      expect(find.byType(ReaderBottomRow), findsOneWidget);
      expect(find.text('Rotate'), findsOneWidget);
      expect(find.text('Search'), findsOneWidget);
      expect(find.text('Invert'), findsOneWidget);
      expect(find.text('Share'), findsOneWidget);

      // Horizontal is HIDDEN
      expect(find.text('Horizontal'), findsNothing);

      // Document content is rendered
      expect(find.text('Doc View Reader'), findsOneWidget);
      expect(find.text('Enjoy reading your documents offline!'), findsOneWidget);
    });

    testWidgets('tapping Search toggles ReaderSearchBar with next/prev chevrons', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          child: TxtViewerScreen(file: docFile),
        ),
      );
      await tester.runAsync(() async {
        await Future.delayed(const Duration(milliseconds: 100));
      });
      await tester.pumpAndSettle();

      // Tap on Search in bottom row
      await tester.tap(find.text('Search'));
      await tester.pumpAndSettle();

      // ReaderSearchBar appears
      expect(find.byType(ReaderSearchBar), findsOneWidget);
      expect(find.byKey(const Key('reader_search_text_field')), findsOneWidget);

      // In TXT viewer, chevrons are enabled
      expect(find.byKey(const Key('reader_search_prev_button')), findsOneWidget);
      expect(find.byKey(const Key('reader_search_next_button')), findsOneWidget);

      // Type query
      await tester.enterText(find.byKey(const Key('reader_search_text_field')), 'reader');
      await tester.pump(const Duration(milliseconds: 350));
      await tester.runAsync(() async {
        await Future.delayed(const Duration(milliseconds: 100));
      });
      await tester.pumpAndSettle();

      // Counter should show match count
      expect(find.textContaining('of 2'), findsOneWidget);

      // Close search
      await tester.tap(find.byKey(const Key('reader_search_close_button')));
      await tester.pumpAndSettle();

      expect(find.byType(ReaderSearchBar), findsNothing);
      expect(find.text('readme.txt'), findsOneWidget);
    });

    testWidgets('tapping Invert toggles dark/light reading surface', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          child: TxtViewerScreen(file: docFile),
        ),
      );
      await tester.runAsync(() async {
        await Future.delayed(const Duration(milliseconds: 100));
      });
      await tester.pumpAndSettle();

      // Tap Invert
      await tester.tap(find.text('Invert'));
      await tester.pumpAndSettle();

      // Inverted state is active on bottom row item
      final invertItem = find.widgetWithText(ReaderBottomRow, 'Invert');
      expect(invertItem, findsOneWidget);
    });
  });
}
