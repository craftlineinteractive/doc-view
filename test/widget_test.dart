import 'package:docview/app.dart';
import 'package:docview/core/constants/app_constants.dart';
import 'package:docview/core/constants/file_types.dart';
import 'package:docview/core/theme/app_theme.dart';
import 'package:docview/data/services/billing/billing_providers.dart';
import 'package:docview/data/services/permission_service.dart';
import 'package:docview/features/directories/directories_screen.dart';
import 'package:docview/features/providers/providers.dart';
import 'package:docview/features/settings/settings_screen.dart';
import 'package:docview/features/tools/tools_screen.dart';
import 'package:docview/l10n/app_localizations.dart';
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
    expect(find.text('PDF'), findsWidgets);
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
      'ToolsScreen shows exactly 9 G4c tool tiles with stable keys and accessibility',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          isPremiumProvider.overrideWithValue(true),
        ],
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const ToolsScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify presence of all 13 enabled G6 tool tiles
    final imageTile = find.byKey(const Key('tool_image_to_pdf'));
    final scanTile = find.byKey(const Key('tool_scan_to_pdf'));
    final createTile = find.byKey(const Key('tool_create_pdf'));
    final pdfToWordTile = find.byKey(const Key('tool_pdf_to_word'));
    final annotateTile = find.byKey(const Key('tool_annotate'));
    final signTile = find.byKey(const Key('tool_sign'));
    final manageTile = find.byKey(const Key('tool_manage_pages'));
    final mergeTile = find.byKey(const Key('tool_merge_pdf'));
    final splitTile = find.byKey(const Key('tool_split_pdf'));
    final importTile = find.byKey(const Key('tool_import_files'));
    final recycleBinTile = find.byKey(const Key('tool_recycle_bin'));
    final printTile = find.byKey(const Key('tool_print_pdf'));

    expect(imageTile, findsOneWidget);
    expect(scanTile, findsOneWidget);
    expect(createTile, findsOneWidget);
    expect(pdfToWordTile, findsOneWidget);
    expect(annotateTile, findsOneWidget);
    expect(signTile, findsOneWidget);
    expect(manageTile, findsOneWidget);
    expect(mergeTile, findsOneWidget);
    expect(splitTile, findsOneWidget);
    expect(importTile, findsOneWidget);
    expect(recycleBinTile, findsOneWidget);
    expect(printTile, findsOneWidget);

    // Verify corresponding labels
    expect(find.text('Image to PDF'), findsOneWidget);
    expect(find.text('Scan to PDF'), findsOneWidget);
    expect(find.text('Create PDF'), findsOneWidget);
    expect(find.text('PDF to Word'), findsOneWidget);
    expect(find.text('Annotate'), findsOneWidget);
    expect(find.text('Add Text'), findsOneWidget);
    expect(find.text('Sign'), findsOneWidget);
    expect(find.text('Manage Pages'), findsOneWidget);
    expect(find.text('Merge PDF'), findsOneWidget);
    expect(find.text('Split PDF'), findsOneWidget);
    expect(find.text('Import files'), findsOneWidget);
    expect(find.text('Recycle bin'), findsOneWidget);
    expect(find.text('Print PDF'), findsOneWidget);

    // Assert exactly 13 tool tiles exist in G6
    final foundToolTiles = find.byWidgetPredicate((widget) {
      if (widget.key is ValueKey<String>) {
        final keyVal = (widget.key as ValueKey<String>).value;
        return keyVal.startsWith('tool_');
      }
      return false;
    });
    expect(foundToolTiles, findsNWidgets(13));

    // Verify accessibility guidelines on ToolsScreen
    final handle = tester.ensureSemantics();
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    await expectLater(tester, meetsGuideline(textContrastGuideline));
    handle.dispose();
  });

  testWidgets(
      'SettingsScreen hides rows when corresponding AppConstants are empty',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: SettingsScreen(
            isReleaseOverride: true,
            premiumEnabledOverride: false,
            widgetsEnabledOverride: false,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify presence of core, non-conditional settings rows & footer
    expect(find.byKey(const Key('settings_file_manager')), findsOneWidget);
    expect(find.byKey(const Key('settings_faq')), findsOneWidget);
    expect(find.byKey(const Key('settings_scan_settings')), findsOneWidget);
    expect(find.byKey(const Key('settings_app_theme')), findsOneWidget);
    expect(find.byKey(const Key('settings_rate_us')), findsOneWidget);
    expect(find.byKey(const Key('settings_licenses')), findsOneWidget);
    expect(find.byKey(const Key('settings_version')), findsOneWidget);

    // Conditional rows whose constants are empty ('') or flags are off MUST NOT appear
    expect(AppConstants.supportEmail, isEmpty);
    expect(AppConstants.termsOfUseUrl, isEmpty);
    expect(AppConstants.storeShareUrl, isEmpty);
    expect(AppConstants.storeRateUrl, isEmpty);
    expect(AppConstants.privacyPolicyUrl, isEmpty);

    expect(find.byKey(const Key('settings_share_app')), findsNothing);
    expect(find.byKey(const Key('settings_terms_of_use')), findsNothing);
    expect(find.byKey(const Key('settings_privacy_policy')), findsNothing);
    expect(find.byKey(const Key('settings_add_widget')), findsNothing);
    expect(find.byKey(const Key('settings_manage_subscriptions')), findsNothing);
    expect(find.byKey(const Key('settings_language')), findsNothing);
  });
}
