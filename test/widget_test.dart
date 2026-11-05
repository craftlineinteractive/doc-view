import 'package:docview/app.dart';
import 'package:docview/core/constants/file_types.dart';
import 'package:docview/data/services/permission_service.dart';
import 'package:docview/features/directories/directories_screen.dart';
import 'package:docview/features/providers/providers.dart';
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

    expect(find.text('Doc Reader'), findsOneWidget);
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
      find.text('Doc Reader needs All files access to browse your folders.'),
      findsOneWidget,
    );
    expect(find.text('Grant access'), findsOneWidget);
    expect(find.text('Import files instead'), findsOneWidget);
  });
}
