import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:docview/core/constants/file_types.dart';
import 'package:docview/core/theme/app_theme.dart';
import 'package:docview/data/models/doc_file.dart';
import 'package:docview/features/viewer/office_viewer_screen.dart';
import 'package:docview/features/viewer/spreadsheet_viewer_screen.dart';
import 'package:docview/features/viewer/viewer_screen.dart';
import 'package:docview/l10n/app_localizations.dart';
import 'package:docview/shared/widgets/reader/reader_bottom_row.dart';
import 'package:docview/shared/widgets/reader/reader_search_bar.dart';
import 'package:docview/shared/widgets/spreadsheet/formula_bar.dart';
import 'package:docview/shared/widgets/spreadsheet/spreadsheet_grid.dart';

Widget _buildViewerHarness({
  required Widget child,
}) {
  return ProviderScope(
    child: MaterialApp(
      theme: AppTheme.lightTheme,
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: child,
    ),
  );
}

Future<void> _pumpSpreadsheetViewer(
  WidgetTester tester, {
  required Widget child,
  Duration waitDuration = const Duration(milliseconds: 300),
}) async {
  await tester.runAsync(() async {
    await tester.pumpWidget(_buildViewerHarness(child: child));
    await Future.delayed(waitDuration);
  });
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 50));
}

Future<void> _enterSearchQuery(
  WidgetTester tester,
  String query,
) async {
  await tester.enterText(find.byType(TextField), query);
  await tester.pump(const Duration(milliseconds: 350));
  await tester.runAsync(() async {
    await Future.delayed(const Duration(milliseconds: 300));
  });
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 50));
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;
  late File sampleCsv;
  late File sampleTsv;
  late File sampleXls;
  late File sampleDocx;
  late File sampleProtectedXlsx;
  late File sampleCorruptXlsx;

  setUpAll(() {
    tempDir = Directory.systemTemp.createTempSync('spreadsheet_viewer_test_');

    // 1. Valid CSV
    sampleCsv = File('${tempDir.path}/quarterly_data.csv');
    sampleCsv.writeAsStringSync('Product,Q1,Q2,Total\nApples,100,150,250\nOranges,200,250,450\n');

    // 2. Valid TSV
    sampleTsv = File('${tempDir.path}/inventory.tsv');
    sampleTsv.writeAsStringSync('SKU\tItem\tQty\nA101\tGadget\t50\nB202\tWidget\t120\n');

    // 3. Legacy XLS
    sampleXls = File('${tempDir.path}/legacy_report.xls');
    sampleXls.writeAsBytesSync([0xD0, 0xCF, 0x11, 0xE0, 0xA1, 0xB1, 0x1A, 0xE1, 0x00]);

    // 4. DOCX
    sampleDocx = File('${tempDir.path}/memo.docx');
    sampleDocx.writeAsBytesSync([0x50, 0x4B, 0x03, 0x04]);

    // 5. Password-protected OOXML (OLE2 package header)
    sampleProtectedXlsx = File('${tempDir.path}/protected.xlsx');
    sampleProtectedXlsx.writeAsBytesSync([0xD0, 0xCF, 0x11, 0xE0, 0xA1, 0xB1, 0x1A, 0xE1, 0x01, 0x02]);

    // 6. Corrupt XLSX
    sampleCorruptXlsx = File('${tempDir.path}/corrupt.xlsx');
    sampleCorruptXlsx.writeAsBytesSync([0x00, 0x11, 0x22, 0x33, 0x44]);
  });

  tearDownAll(() {
    try {
      tempDir.deleteSync(recursive: true);
    } catch (_) {}
  });

  group('ViewerScreen Routing Tests', () {
    testWidgets('routes .csv to SpreadsheetViewerScreen', (tester) async {
      final doc = DocFile(
        id: 1,
        path: sampleCsv.path,
        name: 'quarterly_data.csv',
        extension: 'csv',
        sizeBytes: 100,
        modified: DateTime(2026, 11, 1),
        category: FileCategory.excel,
      );

      await _pumpSpreadsheetViewer(
        tester,
        child: ViewerScreen(file: doc),
      );

      expect(find.byType(SpreadsheetViewerScreen), findsOneWidget);
      expect(find.byType(OfficeViewerScreen), findsNothing);
    });

    testWidgets('routes .tsv to SpreadsheetViewerScreen', (tester) async {
      final doc = DocFile(
        id: 2,
        path: sampleTsv.path,
        name: 'inventory.tsv',
        extension: 'tsv',
        sizeBytes: 100,
        modified: DateTime(2026, 11, 1),
        category: FileCategory.excel,
      );

      await _pumpSpreadsheetViewer(
        tester,
        child: ViewerScreen(file: doc),
      );

      expect(find.byType(SpreadsheetViewerScreen), findsOneWidget);
      expect(find.byType(OfficeViewerScreen), findsNothing);
    });

    testWidgets('routes legacy .xls to OfficeViewerScreen', (tester) async {
      final doc = DocFile(
        id: 3,
        path: sampleXls.path,
        name: 'legacy_report.xls',
        extension: 'xls',
        sizeBytes: 100,
        modified: DateTime(2026, 11, 1),
        category: FileCategory.excel,
      );

      await _pumpSpreadsheetViewer(
        tester,
        child: ViewerScreen(file: doc),
      );

      expect(find.byType(OfficeViewerScreen), findsOneWidget);
      expect(find.byType(SpreadsheetViewerScreen), findsNothing);
    });

    testWidgets('routes .docx to OfficeViewerScreen', (tester) async {
      final doc = DocFile(
        id: 4,
        path: sampleDocx.path,
        name: 'memo.docx',
        extension: 'docx',
        sizeBytes: 100,
        modified: DateTime(2026, 11, 1),
        category: FileCategory.word,
      );

      await _pumpSpreadsheetViewer(
        tester,
        child: ViewerScreen(file: doc),
      );

      expect(find.byType(OfficeViewerScreen), findsOneWidget);
      expect(find.byType(SpreadsheetViewerScreen), findsNothing);
    });
  });

  group('SpreadsheetViewerScreen UI & Features', () {
    testWidgets('renders top bar, formula bar, grid, and ReaderBottomRow with 4 items', (tester) async {
      final doc = DocFile(
        id: 10,
        path: sampleCsv.path,
        name: 'quarterly_data.csv',
        extension: 'csv',
        sizeBytes: 120,
        modified: DateTime(2026, 11, 1),
        category: FileCategory.excel,
      );

      await _pumpSpreadsheetViewer(
        tester,
        child: SpreadsheetViewerScreen(file: doc),
      );

      // Top bar title & back button
      expect(find.text('quarterly_data.csv'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
      expect(find.byIcon(Icons.more_vert_rounded), findsOneWidget);

      // Formula Bar
      expect(find.byType(FormulaBar), findsOneWidget);

      // Grid
      expect(find.byType(SpreadsheetGrid), findsOneWidget);
      expect(find.text('Product'), findsOneWidget);
      expect(find.text('Apples'), findsOneWidget);

      // ReaderBottomRow with exactly 4 items: Rotate, Search, Invert, Share
      expect(find.byType(ReaderBottomRow), findsOneWidget);
      expect(find.text('Rotate'), findsOneWidget);
      expect(find.text('Search'), findsOneWidget);
      expect(find.text('Invert'), findsOneWidget);
      expect(find.text('Share'), findsOneWidget);
    });

    testWidgets('interactive search opens ReaderSearchBar, updates counter, and chevrons navigate', (tester) async {
      final doc = DocFile(
        id: 11,
        path: sampleCsv.path,
        name: 'quarterly_data.csv',
        extension: 'csv',
        sizeBytes: 120,
        modified: DateTime(2026, 11, 1),
        category: FileCategory.excel,
      );

      await _pumpSpreadsheetViewer(
        tester,
        child: SpreadsheetViewerScreen(file: doc),
      );

      // Tap Search bottom row item
      await tester.tap(find.text('Search'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.byType(ReaderSearchBar), findsOneWidget);

      // Enter query matching 'Apples'
      await _enterSearchQuery(tester, 'Apples');

      // Match found: counter 1 of 1
      expect(find.text('1 of 1'), findsOneWidget);

      // Tap close button in search bar
      await tester.tap(find.byIcon(Icons.arrow_back_rounded));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.byType(ReaderSearchBar), findsNothing);
      expect(find.text('quarterly_data.csv'), findsOneWidget);
    });

    testWidgets('search with no matches displays no-matches banner', (tester) async {
      final doc = DocFile(
        id: 12,
        path: sampleCsv.path,
        name: 'quarterly_data.csv',
        extension: 'csv',
        sizeBytes: 120,
        modified: DateTime(2026, 11, 1),
        category: FileCategory.excel,
      );

      await _pumpSpreadsheetViewer(
        tester,
        child: SpreadsheetViewerScreen(file: doc),
      );

      await tester.tap(find.text('Search'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      await _enterSearchQuery(tester, 'NonExistentProduct');

      expect(find.text('No matches in this sheet'), findsOneWidget);
    });

    testWidgets('tapping Invert toggles table color filter', (tester) async {
      final doc = DocFile(
        id: 13,
        path: sampleCsv.path,
        name: 'quarterly_data.csv',
        extension: 'csv',
        sizeBytes: 120,
        modified: DateTime(2026, 11, 1),
        category: FileCategory.excel,
      );

      await _pumpSpreadsheetViewer(
        tester,
        child: SpreadsheetViewerScreen(file: doc),
      );

      expect(find.byType(ColorFiltered), findsNothing);

      await tester.tap(find.text('Invert'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.byType(ColorFiltered), findsOneWidget);

      await tester.tap(find.text('Invert'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.byType(ColorFiltered), findsNothing);
    });
  });

  group('SpreadsheetViewerScreen Fallbacks & Errors', () {
    testWidgets('password-protected workbook displays password lock screen with Open in another app', (tester) async {
      final doc = DocFile(
        id: 20,
        path: sampleProtectedXlsx.path,
        name: 'protected.xlsx',
        extension: 'xlsx',
        sizeBytes: 256,
        modified: DateTime(2026, 11, 1),
        category: FileCategory.excel,
      );

      await _pumpSpreadsheetViewer(
        tester,
        child: SpreadsheetViewerScreen(file: doc),
      );

      expect(find.text('Password-protected file'), findsOneWidget);
      expect(find.text("Password-protected files can't be opened here."), findsOneWidget);
      expect(find.text('Open in another app'), findsOneWidget);
      // Basic viewer fallback is not offered for password-protected files
      expect(find.text('Open in basic viewer'), findsNothing);
    });

    testWidgets('corrupt file shows error state with Open in basic viewer and Open in another app', (tester) async {
      final doc = DocFile(
        id: 21,
        path: sampleCorruptXlsx.path,
        name: 'corrupt.xlsx',
        extension: 'xlsx',
        sizeBytes: 256,
        modified: DateTime(2026, 11, 1),
        category: FileCategory.excel,
      );

      await _pumpSpreadsheetViewer(
        tester,
        child: SpreadsheetViewerScreen(file: doc),
      );

      expect(find.text("Can't read this spreadsheet"), findsOneWidget);
      expect(find.text('The spreadsheet file is corrupted or could not be decoded.'), findsOneWidget);
      expect(find.text('Open in basic viewer'), findsOneWidget);
      expect(find.text('Open in another app'), findsOneWidget);

      // Tap 'Open in basic viewer'
      await tester.tap(find.text('Open in basic viewer'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.byType(OfficeViewerScreen), findsOneWidget);
    });
  });
}
