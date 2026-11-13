import 'package:docview/core/constants/app_constants.dart';
import 'package:docview/core/theme/app_theme.dart';
import 'package:docview/data/models/app_settings.dart';
import 'package:docview/features/providers/providers.dart';
import 'package:docview/features/settings/faq_screen.dart';
import 'package:docview/features/settings/scan_settings_screen.dart';
import 'package:docview/features/settings/settings_screen.dart';
import 'package:docview/features/settings/widgets/theme_selection_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeFileActionsController extends FileActionsController {
  _FakeFileActionsController(super.ref);

  @override
  Future<int> clearRecentHistory() async => 5;
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Settings Tab Redesign Tests (07_settings/01_settings_tab)', () {
    testWidgets('SettingsScreen renders correct structure, row subtitles, and zero forbidden terms', (tester) async {
      tester.view.physicalSize = const Size(393 * 2, 1200 * 2);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const SettingsScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Header "Settings"
      expect(find.text('Settings'), findsOneWidget);

      // Section Headers
      expect(find.text('GENERAL'), findsOneWidget);
      expect(find.text('HELP'), findsOneWidget);
      expect(find.text('ABOUT'), findsOneWidget);

      // Core rows
      expect(find.byKey(const Key('settings_file_manager')), findsOneWidget);
      expect(find.byKey(const Key('settings_import_files')), findsOneWidget);
      expect(find.byKey(const Key('settings_scan_settings')), findsOneWidget);
      expect(find.byKey(const Key('settings_app_theme')), findsOneWidget);
      expect(find.byKey(const Key('settings_clear_history')), findsOneWidget);
      expect(find.byKey(const Key('settings_faq')), findsOneWidget);
      expect(find.byKey(const Key('settings_licenses')), findsOneWidget);
      expect(find.byKey(const Key('settings_version')), findsOneWidget);

      // Exact Subtitles
      expect(find.text('Browse storage directories and folders'), findsOneWidget);
      expect(find.text('Import documents into Doc View private storage'), findsOneWidget);
      expect(find.text('Scan on open'), findsOneWidget);
      expect(find.text('System default'), findsOneWidget);
      expect(find.text('Clear opened document history'), findsOneWidget);
      expect(find.text('Frequently asked questions'), findsOneWidget);
      expect(find.text('Third-party software libraries'), findsOneWidget);

      // FORBIDDEN STRINGS: strictly ZERO hits
      expect(find.textContaining('Premium'), findsNothing);
      expect(find.textContaining('premium'), findsNothing);
      expect(find.textContaining('Remove ads'), findsNothing);
      expect(find.textContaining('Language'), findsNothing);
      expect(find.textContaining('OCR'), findsNothing);
      expect(find.textContaining('Print'), findsNothing);
      expect(find.textContaining('JetBrains Mono'), findsNothing);
    });

    testWidgets('SettingsScreen hides rows when corresponding AppConstants are empty', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const SettingsScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Constants are empty by default in AppConstants
      expect(AppConstants.supportEmail, isEmpty);
      expect(AppConstants.storeShareUrl, isEmpty);
      expect(AppConstants.storeRateUrl, isEmpty);
      expect(AppConstants.privacyPolicyUrl, isEmpty);

      expect(find.byKey(const Key('settings_send_feedback')), findsNothing);
      expect(find.byKey(const Key('settings_share_app')), findsNothing);
      expect(find.byKey(const Key('settings_rate_us')), findsNothing);
      expect(find.byKey(const Key('settings_privacy_policy')), findsNothing);
    });

    testWidgets('Version row tap does nothing; long press in kDebugMode is handled', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const SettingsScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final versionFinder = find.byKey(const Key('settings_version'));
      expect(versionFinder, findsOneWidget);

      // Tap does nothing
      await tester.tap(versionFinder);
      await tester.pumpAndSettle();
      expect(find.text('Settings'), findsOneWidget);
    });
  });

  group('App Theme Bottom Sheet Tests (07_settings/02_settings_sub_screens)', () {
    testWidgets('ThemeSelectionSheet displays 3 preview cards and updates theme mode live on Apply', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const Scaffold(
              body: ThemeSelectionSheet(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('App theme'), findsOneWidget);
      expect(find.text('Select visual appearance for Doc View'), findsOneWidget);

      // 3 preview cards
      expect(find.byKey(const Key('theme_card_system')), findsOneWidget);
      expect(find.byKey(const Key('theme_card_light')), findsOneWidget);
      expect(find.byKey(const Key('theme_card_dark')), findsOneWidget);

      // Initial theme mode is system
      expect(container.read(settingsProvider).themeMode, ThemeMode.system);

      // Select Dark card
      await tester.tap(find.byKey(const Key('theme_card_dark')));
      await tester.pumpAndSettle();

      // Tap Apply theme button
      await tester.tap(find.byKey(const Key('btn_apply_theme')));
      await tester.pumpAndSettle();

      // Theme mode updated live
      expect(container.read(settingsProvider).themeMode, ThemeMode.dark);
    });
  });

  group('Scan Settings Screen Tests', () {
    testWidgets('ScanSettingsScreen toggles radio modes and include images snackbar with action', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const ScanSettingsScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Radios
      expect(find.byKey(const Key('radio_scan_on_open')), findsOneWidget);
      expect(find.byKey(const Key('radio_scan_manual_only')), findsOneWidget);

      // Default is onOpen
      expect(container.read(settingsProvider).autoScanMode, AutoScanMode.onOpen);

      // Select Manual only
      await tester.tap(find.byKey(const Key('radio_scan_manual_only')));
      await tester.pumpAndSettle();
      expect(container.read(settingsProvider).autoScanMode, AutoScanMode.manualOnly);

      // Toggle include images switch
      final switchFinder = find.byKey(const Key('switch_include_images'));
      expect(switchFinder, findsOneWidget);
      await tester.tap(switchFinder);
      await tester.pumpAndSettle();

      // Snackbar "Image list updated" with "Rescan now" action
      expect(find.text('Image list updated'), findsOneWidget);
      expect(find.text('Rescan now'), findsWidgets);
    });
  });

  group('FAQ Screen Tests (07_settings/03_faq)', () {
    testWidgets('FaqScreen renders 6 Topics chip, second question expanded by default with exact privacy text', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const FaqScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // 6 Topics header count
      expect(find.text('6 Topics'), findsOneWidget);

      // 6 FAQ accordion cards
      for (var i = 0; i < 6; i++) {
        expect(find.byKey(Key('faq_card_$i')), findsOneWidget);
      }

      // Second question (index 1: "Is my data uploaded anywhere?") is expanded by default
      expect(find.text('Is my data uploaded anywhere?'), findsOneWidget);
      final exactRequiredPrivacyAnswer =
          'Your documents never leave your device. Doc View opens, converts and stores files locally. The app shows ads served by Google AdMob, which can use limited device data as described in our Privacy Policy.';
      expect(find.text(exactRequiredPrivacyAnswer), findsOneWidget);

      // Single-expand accordion behavior: tap question 0
      await tester.tap(find.text('Why does Doc View need All files access on Android?'));
      await tester.pumpAndSettle();

      // Question 0 expanded, question 1 collapsed
      expect(find.textContaining('MANAGE_EXTERNAL_STORAGE'), findsOneWidget);
      expect(find.text(exactRequiredPrivacyAnswer), findsNothing);

      // "Still need help? Send feedback" is hidden when supportEmail is empty
      expect(find.byKey(const Key('btn_faq_feedback')), findsNothing);
    });
  });

  group('Clear Recent History Dialog Flow Tests', () {
    testWidgets('Clear recent history dialog prompts user and executes clear logic with snackbar', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            fileActionsControllerProvider.overrideWith(
              (ref) => _FakeFileActionsController(ref),
            ),
          ],
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const SettingsScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap Clear recent history row
      await tester.tap(find.byKey(const Key('settings_clear_history')));
      await tester.pumpAndSettle();

      // Dialog title and body match exact owner decision
      expect(find.text('Clear recent history?'), findsOneWidget);
      expect(
        find.text(
          'Files will be removed from Recent. Your files and bookmarks are not affected.',
        ),
        findsOneWidget,
      );

      // Tap Cancel dismisses without snackbar
      await tester.tap(find.byKey(const Key('btn_dialog_cancel')));
      await tester.pumpAndSettle();
      expect(find.text('Clear recent history?'), findsNothing);
      expect(find.text('Recent history cleared'), findsNothing);

      // Open dialog again and tap Clear
      await tester.tap(find.byKey(const Key('settings_clear_history')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('btn_dialog_confirm')));
      await tester.pumpAndSettle();

      // Snackbar "Recent history cleared" appears
      expect(find.text('Recent history cleared'), findsOneWidget);
    });
  });
}
