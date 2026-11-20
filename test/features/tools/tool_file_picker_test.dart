import 'package:docview/core/constants/file_types.dart';
import 'package:docview/core/theme/app_theme.dart';
import 'package:docview/data/models/doc_file.dart';
import 'package:docview/features/providers/providers.dart';
import 'package:docview/features/tools/widgets/tool_file_picker_screen.dart';
import 'package:docview/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final fileA = DocFile(
    id: 1,
    path: '/path/fileA.pdf',
    name: 'Alpha Document.pdf',
    extension: '.pdf',
    sizeBytes: 1024 * 500,
    modified: DateTime.now().subtract(const Duration(days: 1)),
    category: FileCategory.pdf,
  );

  final fileB = DocFile(
    id: 2,
    path: '/path/fileB.pdf',
    name: 'Beta Report.pdf',
    extension: '.pdf',
    sizeBytes: 1024 * 1024 * 2,
    modified: DateTime.now().subtract(const Duration(days: 20)),
    category: FileCategory.pdf,
  );

  Widget createWidget({
    bool allowMultiple = false,
    int minSelection = 1,
    String? title,
    String? actionLabel,
  }) {
    return ProviderScope(
      overrides: [
        filesProvider(FileCategory.pdf).overrideWith(
          (ref) => Future.value([fileA, fileB]),
        ),
      ],
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: ToolFilePickerScreen(
          allowMultiple: allowMultiple,
          minSelection: minSelection,
          title: title,
          actionLabel: actionLabel,
        ),
      ),
    );
  }

  group('ToolFilePickerScreen Widget Tests', () {
    testWidgets('Renders header, tabs, and file list items', (tester) async {
      await tester.pumpWidget(createWidget());
      await tester.pumpAndSettle();

      expect(find.text('Select PDF'), findsOneWidget);
      expect(find.text('All PDFs'), findsOneWidget);
      expect(find.text('Recent'), findsOneWidget);
      expect(find.text('Browse files'), findsOneWidget);

      expect(find.text('Alpha Document.pdf'), findsOneWidget);
      expect(find.text('Beta Report.pdf'), findsOneWidget);
    });

    testWidgets('Single-select mode selects one item at a time', (tester) async {
      await tester.pumpWidget(createWidget(allowMultiple: false));
      await tester.pumpAndSettle();

      final confirmBtn = find.byKey(const Key('tool_picker_confirm_btn'));
      expect(tester.widget<ElevatedButton>(confirmBtn).onPressed, isNull);

      // Tap fileA
      await tester.tap(find.byKey(Key('picker_item_${fileA.path}')));
      await tester.pumpAndSettle();

      expect(find.text('1 selected'), findsOneWidget);
      expect(tester.widget<ElevatedButton>(confirmBtn).onPressed, isNotNull);

      // Tap fileB -> fileA deselected, fileB selected
      await tester.tap(find.byKey(Key('picker_item_${fileB.path}')));
      await tester.pumpAndSettle();

      expect(find.text('1 selected'), findsOneWidget);
      expect(tester.widget<ElevatedButton>(confirmBtn).onPressed, isNotNull);
    });

    testWidgets('Multi-select mode allows selecting multiple items', (tester) async {
      await tester.pumpWidget(createWidget(allowMultiple: true, minSelection: 2));
      await tester.pumpAndSettle();

      final confirmBtn = find.byKey(const Key('tool_picker_confirm_btn'));
      expect(tester.widget<ElevatedButton>(confirmBtn).onPressed, isNull);
      expect(find.text('Select at least 2 files'), findsOneWidget);

      // Select first
      await tester.tap(find.byKey(Key('picker_item_${fileA.path}')));
      await tester.pumpAndSettle();

      expect(find.text('1 selected'), findsOneWidget);
      expect(tester.widget<ElevatedButton>(confirmBtn).onPressed, isNull);

      // Select second
      await tester.tap(find.byKey(Key('picker_item_${fileB.path}')));
      await tester.pumpAndSettle();

      expect(find.text('2 selected'), findsOneWidget);
      expect(tester.widget<ElevatedButton>(confirmBtn).onPressed, isNotNull);
    });

    testWidgets('Search query filters file list', (tester) async {
      await tester.pumpWidget(createWidget());
      await tester.pumpAndSettle();

      expect(find.text('Alpha Document.pdf'), findsOneWidget);
      expect(find.text('Beta Report.pdf'), findsOneWidget);

      // Open search
      await tester.tap(find.byTooltip('Search documents'));
      await tester.pumpAndSettle();

      // Enter query
      await tester.enterText(find.byType(TextField), 'Alpha');
      await tester.pumpAndSettle();

      expect(find.text('Alpha Document.pdf'), findsOneWidget);
      expect(find.text('Beta Report.pdf'), findsNothing);
    });
  });
}
