import 'package:docview/app.dart';
import 'package:docview/core/constants/file_types.dart';
import 'package:docview/features/providers/providers.dart';
import 'package:docview/features/tools/tool_registry.dart';
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

    // Verify Tools screen header and registry-driven tool tiles
    expect(find.text('Tools'), findsOneWidget);
    final visibleTools = getVisibleTools();
    for (final tool in visibleTools) {
      expect(find.byKey(Key('tool_${tool.id}')), findsOneWidget);
    }

    final toolsCount = find.byWidgetPredicate((widget) {
      if (widget.key is ValueKey<String>) {
        final keyVal = (widget.key as ValueKey<String>).value;
        return keyVal.startsWith('tool_');
      }
      return false;
    });
    expect(toolsCount, findsNWidgets(visibleTools.length));

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

