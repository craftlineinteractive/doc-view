import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart';

import 'package:docview/core/theme/app_theme.dart';
import 'package:docview/data/models/spreadsheet_data.dart';
import 'package:docview/l10n/app_localizations.dart';
import 'package:docview/shared/widgets/spreadsheet/formula_bar.dart';
import 'package:docview/shared/widgets/spreadsheet/sheet_tab_bar.dart';
import 'package:docview/shared/widgets/spreadsheet/spreadsheet_grid.dart';
import 'package:docview/shared/widgets/spreadsheet/zoom_pill.dart';

Widget _buildTestHarness({
  required Widget child,
  Locale locale = const Locale('en'),
}) {
  return MaterialApp(
    theme: AppTheme.lightTheme,
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(
      body: child,
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final sampleSheet = SheetData(
    name: 'Sales',
    rowCount: 5,
    columnCount: 4,
    cells: {
      const CellCoordinate(0, 0): const SpreadsheetCell(rawValue: 'Product', style: CellStyleData(isBold: true)),
      const CellCoordinate(0, 1): const SpreadsheetCell(rawValue: 'Q1', style: CellStyleData(isBold: true)),
      const CellCoordinate(0, 2): const SpreadsheetCell(rawValue: 'Q2', style: CellStyleData(isBold: true)),
      const CellCoordinate(0, 3): const SpreadsheetCell(rawValue: 'Total', style: CellStyleData(isBold: true)),
      const CellCoordinate(1, 0): const SpreadsheetCell(rawValue: 'Widget A'),
      const CellCoordinate(1, 1): const SpreadsheetCell(rawValue: '100', type: CellDataType.number),
      const CellCoordinate(1, 2): const SpreadsheetCell(rawValue: '150', type: CellDataType.number),
      const CellCoordinate(1, 3): const SpreadsheetCell(rawValue: '250', formula: '=SUM(B2:C2)', type: CellDataType.number),
      const CellCoordinate(2, 0): const SpreadsheetCell(rawValue: 'Widget B'),
      const CellCoordinate(2, 1): const SpreadsheetCell(rawValue: '200', type: CellDataType.number),
      const CellCoordinate(2, 2): const SpreadsheetCell(rawValue: '250', type: CellDataType.number),
      const CellCoordinate(2, 3): const SpreadsheetCell(rawValue: '450', formula: '=SUM(B3:C3)', type: CellDataType.number),
    },
    mergedRanges: [
      const MergedCellRange(startRow: 3, startColumn: 0, rowSpan: 2, columnSpan: 2),
    ],
  );

  group('SpreadsheetGrid Widget Tests', () {
    testWidgets('renders pinned column headers (A, B, C...) and row headers (1, 2...)', (tester) async {
      await tester.pumpWidget(
        _buildTestHarness(
          child: SpreadsheetGrid(
            sheet: sampleSheet,
            selection: const SpreadsheetSelection.none(),
            onSelectionChanged: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(TableView), findsOneWidget);
      expect(find.text('A'), findsOneWidget);
      expect(find.text('B'), findsOneWidget);
      expect(find.text('C'), findsOneWidget);
      expect(find.text('1'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
      expect(find.text('Product'), findsOneWidget);
    });

    testWidgets('shows empty state when sheet has 0 rows and 0 columns', (tester) async {
      const emptySheet = SheetData(
        name: 'Empty',
        rowCount: 0,
        columnCount: 0,
        cells: {},
      );

      await tester.pumpWidget(
        _buildTestHarness(
          child: SpreadsheetGrid(
            sheet: emptySheet,
            selection: const SpreadsheetSelection.none(),
            onSelectionChanged: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('This sheet is empty'), findsOneWidget);
      expect(find.byIcon(Icons.grid_off_rounded), findsOneWidget);
    });

    testWidgets('tap cell triggers onSelectionChanged with cell coordinate', (tester) async {
      SpreadsheetSelection? captured;

      await tester.pumpWidget(
        _buildTestHarness(
          child: SpreadsheetGrid(
            sheet: sampleSheet,
            selection: const SpreadsheetSelection.none(),
            onSelectionChanged: (sel) => captured = sel,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Product'));
      await tester.pumpAndSettle();

      expect(captured, isNotNull);
      expect(captured!.selectedRow, 0);
      expect(captured!.selectedColumn, 0);
      expect(captured!.isEntireRow, isFalse);
      expect(captured!.isEntireColumn, isFalse);
    });

    testWidgets('tap already selected cell clears selection', (tester) async {
      SpreadsheetSelection? captured;

      await tester.pumpWidget(
        _buildTestHarness(
          child: SpreadsheetGrid(
            sheet: sampleSheet,
            selection: const SpreadsheetSelection.cell(0, 0),
            onSelectionChanged: (sel) => captured = sel,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Product'));
      await tester.pumpAndSettle();

      expect(captured, isNotNull);
      expect(captured!.hasSelection, isFalse);
    });

    testWidgets('tap column header selects column; tap row header selects row', (tester) async {
      SpreadsheetSelection? capturedCol;
      SpreadsheetSelection? capturedRow;

      await tester.pumpWidget(
        _buildTestHarness(
          child: SpreadsheetGrid(
            sheet: sampleSheet,
            selection: const SpreadsheetSelection.none(),
            onSelectionChanged: (sel) {
              if (sel.isEntireColumn) capturedCol = sel;
              if (sel.isEntireRow) capturedRow = sel;
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap Column 'B' (index 1)
      await tester.tap(find.text('B'));
      await tester.pumpAndSettle();
      expect(capturedCol, isNotNull);
      expect(capturedCol!.selectedColumn, 1);
      expect(capturedCol!.isEntireColumn, isTrue);

      // Tap Row '2' (index 1)
      await tester.tap(find.text('2'));
      await tester.pumpAndSettle();
      expect(capturedRow, isNotNull);
      expect(capturedRow!.selectedRow, 1);
      expect(capturedRow!.isEntireRow, isTrue);
    });

    testWidgets('tap corner cell selects entire sheet', (tester) async {
      SpreadsheetSelection? captured;

      await tester.pumpWidget(
        _buildTestHarness(
          child: SpreadsheetGrid(
            sheet: sampleSheet,
            selection: const SpreadsheetSelection.none(),
            onSelectionChanged: (sel) => captured = sel,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.select_all_rounded));
      await tester.pumpAndSettle();

      expect(captured, isNotNull);
      expect(captured!.isEntireSheet, isTrue);
    });

    testWidgets('renders shimmer skeleton when isLoading is true', (tester) async {
      await tester.pumpWidget(
        _buildTestHarness(
          child: SpreadsheetGrid(
            sheet: sampleSheet,
            selection: const SpreadsheetSelection.none(),
            onSelectionChanged: (_) {},
            isLoading: true,
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(TableView), findsOneWidget);
      expect(find.text('Product'), findsNothing);
    });

    testWidgets('applies ColorFiltered matrix when isTableInverted is true', (tester) async {
      await tester.pumpWidget(
        _buildTestHarness(
          child: SpreadsheetGrid(
            sheet: sampleSheet,
            selection: const SpreadsheetSelection.none(),
            onSelectionChanged: (_) {},
            isTableInverted: true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ColorFiltered), findsOneWidget);
    });
  });

  group('FormulaBar Widget Tests', () {
    testWidgets('displays chip text and cell value or formula correctly', (tester) async {
      await tester.pumpWidget(
        _buildTestHarness(
          child: FormulaBar(
            sheet: sampleSheet,
            selection: const SpreadsheetSelection.cell(1, 3),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Cell 1, 3 is D2 with formula '=SUM(B2:C2)'
      expect(find.text('D2'), findsOneWidget);
      expect(find.text('=SUM(B2:C2)'), findsOneWidget);
      expect(find.byIcon(Icons.copy_rounded), findsOneWidget);
    });

    testWidgets('displays - when selection is none', (tester) async {
      await tester.pumpWidget(
        _buildTestHarness(
          child: FormulaBar(
            sheet: sampleSheet,
            selection: const SpreadsheetSelection.none(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('-'), findsOneWidget);
    });

    testWidgets('displays Row 2 when row is selected', (tester) async {
      await tester.pumpWidget(
        _buildTestHarness(
          child: FormulaBar(
            sheet: sampleSheet,
            selection: const SpreadsheetSelection.row(1),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Row 2'), findsOneWidget);
    });

    testWidgets('displays Column B when column is selected', (tester) async {
      await tester.pumpWidget(
        _buildTestHarness(
          child: FormulaBar(
            sheet: sampleSheet,
            selection: const SpreadsheetSelection.column(1),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Column B'), findsOneWidget);
    });

    testWidgets('tap formula bar opens cell inspector bottom sheet', (tester) async {
      await tester.pumpWidget(
        _buildTestHarness(
          child: FormulaBar(
            sheet: sampleSheet,
            selection: const SpreadsheetSelection.cell(1, 3),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('=SUM(B2:C2)'));
      await tester.pumpAndSettle();

      expect(find.text('D2 • Cell Content'), findsOneWidget);
      expect(find.text('Close'), findsOneWidget);
      expect(find.text('Copy'), findsOneWidget);
    });
  });

  group('SheetTabBar Widget Tests', () {
    testWidgets('hidden when only 1 sheet exists', (tester) async {
      await tester.pumpWidget(
        _buildTestHarness(
          child: SheetTabBar(
            sheetNames: const ['Sheet1'],
            activeIndex: 0,
            onSheetSelected: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ListView), findsNothing);
      expect(find.text('Sheet1'), findsNothing);
    });

    testWidgets('renders all sheet names when multiple sheets exist', (tester) async {
      int? selectedIndex;

      await tester.pumpWidget(
        _buildTestHarness(
          child: SheetTabBar(
            sheetNames: const ['Summary', 'Expenses', 'Profit'],
            activeIndex: 0,
            onSheetSelected: (i) => selectedIndex = i,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Summary'), findsOneWidget);
      expect(find.text('Expenses'), findsOneWidget);
      expect(find.text('Profit'), findsOneWidget);

      await tester.tap(find.text('Expenses'));
      await tester.pumpAndSettle();

      expect(selectedIndex, 1);
    });
  });

  group('ZoomPill Widget Tests', () {
    testWidgets('displays percentage and invokes onReset when tapped', (tester) async {
      var resetCalled = false;

      await tester.pumpWidget(
        _buildTestHarness(
          child: ZoomPill(
            scale: 1.5,
            onReset: () => resetCalled = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('150%'), findsOneWidget);
      expect(find.byIcon(Icons.restart_alt_rounded), findsOneWidget);

      await tester.tap(find.byType(ZoomPill));
      await tester.pumpAndSettle();

      expect(resetCalled, isTrue);
    });
  });
}
