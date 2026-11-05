import 'package:docview/app.dart';
import 'package:docview/core/constants/file_types.dart';
import 'package:docview/features/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
      'App navigation, tools count, and search input integration test',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          categoryCountsProvider.overrideWith((ref) async => {
                FileCategory.pdf: 1,
                FileCategory.word: 0,
                FileCategory.excel: 0,
                FileCategory.ppt: 0,
                FileCategory.txt: 0,
                FileCategory.image: 0,
                FileCategory.other: 0,
              }),
          recentsProvider.overrideWith((ref) async => []),
          bookmarksProvider.overrideWith((ref) async => []),
        ],
        child: const DocReaderApp(),
      ),
    );
    await tester.pumpAndSettle();

    // 1. Verify Home Screen loaded
    expect(find.text('Doc View'), findsOneWidget);

    // 2. Navigate to Tools tab
    final toolsTab = find.byIcon(Icons.grid_view);
    expect(toolsTab, findsOneWidget);
    await tester.tap(toolsTab);
    await tester.pumpAndSettle();

    // Verify Tools screen header and exactly 4 tool tiles
    expect(find.text('Tools'), findsOneWidget);
    expect(find.byKey(const Key('tool_image_to_pdf')), findsOneWidget);
    expect(find.byKey(const Key('tool_scan_to_pdf')), findsOneWidget);
    expect(find.byKey(const Key('tool_merge_pdf')), findsOneWidget);
    expect(find.byKey(const Key('tool_split_pdf')), findsOneWidget);

    final toolsCount = find.byWidgetPredicate((widget) {
      if (widget.key is ValueKey<String>) {
        final keyVal = (widget.key as ValueKey<String>).value;
        return keyVal.startsWith('tool_');
      }
      return false;
    });
    expect(toolsCount, findsNWidgets(4));

    // 3. Navigate back to All files / Home
    final filesTab = find.byIcon(Icons.folder);
    expect(filesTab, findsOneWidget);
    await tester.tap(filesTab);
    await tester.pumpAndSettle();

    // 4. Test Search navigation and text input
    final searchButton = find.byTooltip('Search');
    expect(searchButton, findsOneWidget);
    await tester.tap(searchButton);
    await tester.pumpAndSettle();

    final searchField = find.byType(TextField);
    expect(searchField, findsOneWidget);

    await tester.enterText(searchField, 'invoice');
    await tester.pumpAndSettle();
    expect(find.text('invoice'), findsOneWidget);
  });
}

