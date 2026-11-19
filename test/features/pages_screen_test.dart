import 'dart:io';

import 'package:docview/core/constants/file_types.dart';
import 'package:docview/core/theme/doc_view_tokens.dart';
import 'package:docview/data/models/doc_file.dart';
import 'package:docview/data/services/pdf/pdf_page_edit_service.dart';
import 'package:docview/features/viewer/pages_screen.dart';
import 'package:docview/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdf/widgets.dart' as pw;

Future<File> _createMinimalPdf(String path, int count) async {
  final pdf = pw.Document();
  for (var i = 1; i <= count; i++) {
    pdf.addPage(
      pw.Page(
        build: (context) => pw.Center(
          child: pw.Text('Page $i', style: const pw.TextStyle(fontSize: 32)),
        ),
      ),
    );
  }
  final file = File(path);
  await file.writeAsBytes(await pdf.save());
  return file;
}

Widget _wrap(Widget child) {
  return ProviderScope(
    child: MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData.light().copyWith(
        extensions: const [DocViewTokens.light],
      ),
      home: child,
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;
  late File samplePdf;
  late DocFile docFile;
  late List<PdfPageEditSpec> initialPages;

  setUp(() async {
    tempDir = Directory.systemTemp.createTempSync('pages_screen_test_');
    samplePdf = await _createMinimalPdf('${tempDir.path}/sample.pdf', 3);
    docFile = DocFile(
      path: samplePdf.path,
      name: 'sample.pdf',
      extension: 'pdf',
      sizeBytes: samplePdf.lengthSync(),
      modified: DateTime(2026, 11, 19),
      category: FileCategory.pdf,
    );
    initialPages = List.generate(
      3,
      (i) => PdfPageEditSpec(sourcePath: samplePdf.path, sourcePageIndex: i),
    );
  });

  tearDown(() {
    try {
      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
      }
    } catch (_) {}
  });

  group('PagesScreen Widget Tests', () {
    testWidgets('renders top bar, page count, and action buttons', (tester) async {
      await tester.pumpWidget(
        _wrap(PagesScreen(file: docFile, initialPages: initialPages)),
      );
      await tester.pump();

      expect(find.text('Pages'), findsOneWidget);
      expect(find.text('3 Pages'), findsOneWidget);
      expect(find.text('Select all'), findsOneWidget);
      expect(find.text('Save'), findsOneWidget);
      expect(find.text('Insert'), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
    });

    testWidgets('toggles selection and shows bottom row actions', (tester) async {
      await tester.pumpWidget(
        _wrap(PagesScreen(file: docFile, initialPages: initialPages)),
      );
      await tester.pump();

      // Tap select all
      await tester.tap(find.text('Select all'));
      await tester.pump();

      // Should now show Clear, and bottom actions: Rotate, Extract, Delete
      expect(find.text('Clear'), findsOneWidget);
      expect(find.text('Rotate'), findsOneWidget);
      expect(find.text('Extract'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);
      expect(find.text('Insert'), findsNothing);

      // Tap Clear
      await tester.tap(find.text('Clear'));
      await tester.pump();

      expect(find.text('Select all'), findsOneWidget);
      expect(find.text('Insert'), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
    });

    testWidgets('deleting all pages shows blocked error snackbar', (tester) async {
      await tester.pumpWidget(
        _wrap(PagesScreen(file: docFile, initialPages: initialPages)),
      );
      await tester.pump();

      // Select all 3 pages
      await tester.tap(find.text('Select all'));
      await tester.pump();

      // Tap Delete
      await tester.tap(find.text('Delete'));
      await tester.pump();

      // Should show blocked snackbar
      expect(
        find.text('Cannot delete all pages. A document must have at least one page.'),
        findsOneWidget,
      );
      // Pages should remain 3
      expect(find.text('3 Pages'), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
    });

    testWidgets('rotating and single-level undo updates page count and state', (tester) async {
      await tester.pumpWidget(
        _wrap(PagesScreen(file: docFile, initialPages: initialPages)),
      );
      await tester.pump();

      // Tap tile 1 to select
      await tester.tap(find.text('1'));
      await tester.pump();

      expect(find.text('Rotate'), findsOneWidget);

      // Tap Rotate
      await tester.tap(find.text('Rotate'));
      await tester.pump();

      // Undo button should now be enabled
      final undoFinder = find.widgetWithIcon(IconButton, Icons.undo_rounded);
      expect(undoFinder, findsOneWidget);

      // Tap Undo
      await tester.tap(undoFinder);
      await tester.pump();

      // Undo reverts and resets undo snapshot
      final undoButton = tester.widget<IconButton>(undoFinder);
      expect(undoButton.onPressed, isNull);

      await tester.pumpWidget(const SizedBox.shrink());
    });
  });
}
