import 'package:docview/app.dart';
import 'package:docview/core/constants/file_types.dart';
import 'package:docview/core/theme/app_theme.dart';
import 'package:docview/data/services/permission_service.dart';
import 'package:docview/features/directories/directories_screen.dart';
import 'package:docview/features/providers/providers.dart';
import 'package:docview/features/tools/tools_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeDeniedPermissionNotifier extends AllFilesAccessNotifier {
  @override
  Future<bool> build() async => false;

  @override
  Future<bool> refreshAccess() async => false;
}

void main() {
  testWidgets(
      'DocReaderApp smoke test - renders navigation tabs, grid and sections',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          categoryCountsProvider.overrideWith(
            (ref) async => {
              FileCategory.pdf: 5,
              FileCategory.word: 3,
              FileCategory.excel: 2,
              FileCategory.ppt: 1,
              FileCategory.txt: 4,
              FileCategory.image: 10,
              FileCategory.other: 0,
            },
          ),
          recentsProvider.overrideWith((ref) async => []),
          bookmarksProvider.overrideWith((ref) async => []),
        ],
        child: const DocReaderApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Doc View'), findsOneWidget);
    expect(find.text('All files'), findsWidgets);
    expect(find.text('Tools'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('PDF'), findsOneWidget);
    expect(find.text('Word'), findsOneWidget);
    expect(find.text('Recent'), findsOneWidget);
    expect(find.text('Bookmarks'), findsOneWidget);
  });

  testWidgets(
      'DirectoriesScreen renders permissionRequired state with Grant access button',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          permissionServiceProvider.overrideWithValue(
            PermissionService(isAndroidOverride: true, isIOSOverride: false),
          ),
          allFilesAccessProvider.overrideWith(
            _FakeDeniedPermissionNotifier.new,
          ),
        ],
        child: const MaterialApp(
          home: DirectoriesScreen(),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Directories'), findsOneWidget);
    expect(find.text('Storage Access Required'), findsOneWidget);
    expect(
      find.text('Doc View needs All files access to browse your folders.'),
      findsOneWidget,
    );
    expect(find.text('Grant access'), findsOneWidget);
    expect(find.text('Import files instead'), findsOneWidget);
  });

  testWidgets(
      'ToolsScreen shows exactly 4 tool tiles with stable keys and accessibility',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: const ToolsScreen(),
      ),
    );
    await tester.pumpAndSettle();

    // Verify presence of exactly 4 tool tiles
    final imageTile = find.byKey(const Key('tool_image_to_pdf'));
    final scanTile = find.byKey(const Key('tool_scan_to_pdf'));
    final mergeTile = find.byKey(const Key('tool_merge_pdf'));
    final splitTile = find.byKey(const Key('tool_split_pdf'));

    expect(imageTile, findsOneWidget);
    expect(scanTile, findsOneWidget);
    expect(mergeTile, findsOneWidget);
    expect(splitTile, findsOneWidget);

    // Verify corresponding labels and icons
    expect(find.text('Image to PDF'), findsOneWidget);
    expect(find.byIcon(Icons.image_rounded), findsOneWidget);

    expect(find.text('Scan to PDF'), findsOneWidget);
    expect(find.byIcon(Icons.document_scanner_rounded), findsOneWidget);

    expect(find.text('Merge PDF'), findsOneWidget);
    expect(find.byIcon(Icons.call_merge_rounded), findsOneWidget);

    expect(find.text('Split PDF'), findsOneWidget);
    expect(find.byIcon(Icons.call_split_rounded), findsOneWidget);

    // Assert no 5th tool exists
    final foundToolTiles = find.byWidgetPredicate((widget) {
      if (widget.key is ValueKey<String>) {
        final keyVal = (widget.key as ValueKey<String>).value;
        return keyVal.startsWith('tool_');
      }
      return false;
    });
    expect(foundToolTiles, findsNWidgets(4));

    // Verify accessibility guidelines on ToolsScreen
    final handle = tester.ensureSemantics();
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    await expectLater(tester, meetsGuideline(textContrastGuideline));
    handle.dispose();
  });
}
