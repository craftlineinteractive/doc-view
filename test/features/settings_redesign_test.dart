import 'package:docview/core/config/feature_flags.dart';
import 'package:docview/core/constants/app_constants.dart';
import 'package:docview/data/models/app_settings.dart';
import 'package:docview/data/repositories/settings_repository.dart';
import 'package:docview/data/services/file_manager_service.dart';
import 'package:docview/features/providers/providers.dart';
import 'package:docview/features/settings/faq_screen.dart';
import 'package:docview/features/settings/language_screen.dart';
import 'package:docview/features/settings/scan_settings_screen.dart';
import 'package:docview/features/settings/settings_screen.dart';
import 'package:docview/features/settings/widgets/rate_us_sheet.dart';
import 'package:docview/features/settings/widgets/theme_selection_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/pump_app.dart';

class _FakeFileActionsController extends FileActionsController {
  _FakeFileActionsController(super.ref);

  @override
  Future<int> clearRecentHistory() async => 5;
}

class _FakeFileManagerService extends FileManagerService {
  _FakeFileManagerService({required this.result});

  final bool result;
  int callCount = 0;

  @override
  Future<bool> openSystemFileManager() async {
    callCount++;
    return result;
  }
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('G2 Settings Tab Restructure Tests', () {
    testWidgets(
      'SettingsScreen renders exact G2 sections, row order, footer semantics, and zero forbidden terms in default build',
      (tester) async {
        tester.view.physicalSize = const Size(393 * 2, 1200 * 2);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpApp(
          const SettingsScreen(isReleaseOverride: true),
        );
        await tester.pumpAndSettle();

        // Header "Settings"
        expect(find.text('Settings'), findsOneWidget);

        // Section Header: GENERAL visible; OTHERS hidden when all its rows are hidden
        expect(find.text('GENERAL'), findsOneWidget);
        expect(find.text('OTHERS'), findsNothing);

        // Top group & General rows
        final fileManager = find.byKey(const Key('settings_file_manager'));
        final faq = find.byKey(const Key('settings_faq'));
        final scanSettings = find.byKey(const Key('settings_scan_settings'));
        final appTheme = find.byKey(const Key('settings_app_theme'));
        final rateUs = find.byKey(const Key('settings_rate_us'));
        final version = find.byKey(const Key('settings_version'));
        final licenses = find.byKey(const Key('settings_licenses'));

        expect(fileManager, findsOneWidget);
        expect(faq, findsOneWidget);
        expect(scanSettings, findsOneWidget);
        expect(appTheme, findsOneWidget);
        expect(rateUs, findsOneWidget);
        expect(version, findsOneWidget);
        expect(licenses, findsOneWidget);

        // Verify strict top-to-bottom ordering
        expect(tester.getTopLeft(fileManager).dy, lessThan(tester.getTopLeft(faq).dy));
        expect(tester.getTopLeft(faq).dy, lessThan(tester.getTopLeft(scanSettings).dy));
        expect(tester.getTopLeft(scanSettings).dy, lessThan(tester.getTopLeft(appTheme).dy));
        expect(tester.getTopLeft(appTheme).dy, lessThan(tester.getTopLeft(rateUs).dy));
        expect(tester.getTopLeft(rateUs).dy, lessThan(tester.getTopLeft(version).dy));
        expect(tester.getTopLeft(version).dy, lessThan(tester.getTopLeft(licenses).dy));

        // Version footer text & semantics
        expect(find.text('Version 1.0.0 (1)'), findsOneWidget);
        expect(find.text('Open-source licenses'), findsOneWidget);
        expect(
          find.bySemanticsLabel('Version 1.0.0 build 1'),
          findsOneWidget,
        );

        // Rows removed from Settings in G2
        expect(find.byKey(const Key('settings_import_files')), findsNothing);
        expect(find.byKey(const Key('settings_rescan_now')), findsNothing);
        expect(find.byKey(const Key('settings_clear_history')), findsNothing);
        expect(find.byKey(const Key('settings_send_feedback')), findsNothing);

        // Rows hidden when constants are empty, flags are off, or release has 1 language
        expect(premiumEnabled, isFalse);
        expect(widgetsEnabled, isFalse);
        expect(AppConstants.termsOfUseUrl, isEmpty);
        expect(AppConstants.privacyPolicyUrl, isEmpty);
        expect(AppConstants.storeShareUrl, isEmpty);
        expect(find.byKey(const Key('settings_add_widget')), findsNothing);
        expect(find.byKey(const Key('settings_manage_subscriptions')), findsNothing);
        expect(find.byKey(const Key('settings_terms_of_use')), findsNothing);
        expect(find.byKey(const Key('settings_privacy_policy')), findsNothing);
        expect(find.byKey(const Key('settings_share_app')), findsNothing);
        expect(find.byKey(const Key('settings_language')), findsNothing);

        // FORBIDDEN STRINGS in default build: strictly ZERO hits
        expect(find.textContaining('Premium'), findsNothing);
        expect(find.textContaining('premium'), findsNothing);
        expect(find.textContaining('Remove ads'), findsNothing);
        expect(find.textContaining('Widget'), findsNothing);
        expect(find.textContaining('OCR'), findsNothing);
      },
    );

    testWidgets(
      'SettingsScreen shows Others section and Share/Language rows in exact order when enabled',
      (tester) async {
        tester.view.physicalSize = const Size(393 * 2, 1600 * 2);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpApp(
          const SettingsScreen(
            isReleaseOverride: true,
            shippedLanguageCountOverride: 2,
            premiumEnabledOverride: true,
            widgetsEnabledOverride: true,
            storeShareUrlOverride: 'https://play.google.com/store/apps/details?id=com.example',
            termsOfUseUrlOverride: 'https://example.com/terms',
            privacyPolicyUrlOverride: 'https://example.com/privacy',
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('GENERAL'), findsOneWidget);
        expect(find.text('OTHERS'), findsOneWidget);

        final share = find.byKey(const Key('settings_share_app'));
        final language = find.byKey(const Key('settings_language'));
        final rateUs = find.byKey(const Key('settings_rate_us'));
        final addWidget = find.byKey(const Key('settings_add_widget'));
        final terms = find.byKey(const Key('settings_terms_of_use'));
        final privacy = find.byKey(const Key('settings_privacy_policy'));
        final subs = find.byKey(const Key('settings_manage_subscriptions'));

        expect(share, findsOneWidget);
        expect(language, findsOneWidget);
        expect(addWidget, findsOneWidget);
        expect(terms, findsOneWidget);
        expect(privacy, findsOneWidget);
        expect(subs, findsOneWidget);

        // Exact order inside General & Others
        expect(tester.getTopLeft(language).dy, lessThan(tester.getTopLeft(rateUs).dy));
        expect(tester.getTopLeft(addWidget).dy, lessThan(tester.getTopLeft(terms).dy));
        expect(tester.getTopLeft(terms).dy, lessThan(tester.getTopLeft(privacy).dy));
        expect(tester.getTopLeft(privacy).dy, lessThan(tester.getTopLeft(subs).dy));
      },
    );

    testWidgets(
      'File manager row falls back to Directories when MethodChannel returns false',
      (tester) async {
        final fakeFileManager = _FakeFileManagerService(result: false);
        var pushedDirectories = false;

        final router = GoRouter(
          initialLocation: '/settings',
          routes: [
            GoRoute(
              path: '/settings',
              builder: (_, _) => const SettingsScreen(),
            ),
            GoRoute(
              path: '/directories',
              builder: (_, _) {
                pushedDirectories = true;
                return const Scaffold(body: Text('Directories Fallback Target'));
              },
            ),
          ],
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              fileManagerServiceProvider.overrideWithValue(fakeFileManager),
            ],
            child: MaterialApp.router(routerConfig: router),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(const Key('settings_file_manager')));
        await tester.pumpAndSettle();

        expect(fakeFileManager.callCount, equals(1));
        expect(pushedDirectories, isTrue);
        expect(find.text('Directories Fallback Target'), findsOneWidget);
      },
    );

    testWidgets(
      'File manager row does NOT fall back when native file manager handles intent',
      (tester) async {
        final fakeFileManager = _FakeFileManagerService(result: true);
        var pushedDirectories = false;

        final router = GoRouter(
          initialLocation: '/settings',
          routes: [
            GoRoute(
              path: '/settings',
              builder: (_, _) => const SettingsScreen(),
            ),
            GoRoute(
              path: '/directories',
              builder: (_, _) {
                pushedDirectories = true;
                return const Scaffold(body: Text('Directories Fallback Target'));
              },
            ),
          ],
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              fileManagerServiceProvider.overrideWithValue(fakeFileManager),
            ],
            child: MaterialApp.router(routerConfig: router),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(const Key('settings_file_manager')));
        await tester.pumpAndSettle();

        expect(fakeFileManager.callCount, equals(1));
        expect(pushedDirectories, isFalse);
      },
    );
  });

  group('FileManagerService MethodChannel Unit Tests', () {
    test('returns false safely when Android MethodChannel returns false or is missing', () async {
      const channel = MethodChannel(FileManagerService.channelName);
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async => false);
      addTearDown(() {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(channel, null);
      });

      final service = FileManagerService(isAndroidOverride: true, isIOSOverride: false);
      expect(await service.openSystemFileManager(), isFalse);

      // Simulate missing handler
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null);
      expect(await service.openSystemFileManager(), isFalse);
    });

    test('returns true when Android MethodChannel handles openSystemFileManager', () async {
      const channel = MethodChannel(FileManagerService.channelName);
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
        expect(call.method, equals(FileManagerService.methodOpenSystemFileManager));
        return true;
      });
      addTearDown(() {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(channel, null);
      });

      final service = FileManagerService(isAndroidOverride: true, isIOSOverride: false);
      expect(await service.openSystemFileManager(), isTrue);
    });

    test('iOS invokes shareddocuments:// launcher and handles failure safely', () async {
      Uri? launchedUri;
      final iosOk = FileManagerService(
        isAndroidOverride: false,
        isIOSOverride: true,
        urlLauncher: (uri) async {
          launchedUri = uri;
          return true;
        },
      );
      expect(await iosOk.openSystemFileManager(), isTrue);
      expect(launchedUri, equals(Uri.parse('shareddocuments://')));

      final iosFail = FileManagerService(
        isAndroidOverride: false,
        isIOSOverride: true,
        urlLauncher: (_) async => false,
      );
      expect(await iosFail.openSystemFileManager(), isFalse);
    });
  });

  group('Rate Us Drawer Compliance Tests (Non-Gating)', () {
    testWidgets(
      'For EACH rating 1 to 5, both actions exist with identical size, Not now exists, and nothing opens automatically',
      (tester) async {
        var storeOpenedCount = 0;
        var helpOpenedCount = 0;

        await tester.pumpApp(
          Scaffold(
            body: RateUsSheet(
              storeRateUrlOverride: 'https://play.google.com/store/apps/details?id=com.example',
              onOpenStore: (_) async => storeOpenedCount++,
              onHelpFeedback: () => helpOpenedCount++,
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Rate Doc View'), findsOneWidget);
        expect(find.text('Your feedback helps us improve'), findsOneWidget);
        expect(find.byKey(const Key('btn_rate_not_now')), findsOneWidget);

        // Before selecting any star, actions are not yet shown
        expect(find.byKey(const Key('btn_rate_store')), findsNothing);
        expect(find.byKey(const Key('btn_rate_help_feedback')), findsNothing);

        final expectedMessages = <int, String>{
          1: 'Sorry it fell short. Tell us what to fix.',
          2: 'Sorry it fell short. Tell us what to fix.',
          3: 'Thanks! Tell us how we can do better.',
          4: 'Glad you like it!',
          5: 'Glad you like it!',
        };

        for (var stars = 1; stars <= 5; stars++) {
          await tester.tap(find.byKey(Key('rate_star_$stars')));
          await tester.pumpAndSettle();

          // Exact message for star bucket
          expect(find.text(expectedMessages[stars]!), findsOneWidget);

          // BOTH buttons must appear in exact order with IDENTICAL size
          final storeBtn = find.byKey(const Key('btn_rate_store'));
          final helpBtn = find.byKey(const Key('btn_rate_help_feedback'));
          final notNowBtn = find.byKey(const Key('btn_rate_not_now'));

          expect(storeBtn, findsOneWidget);
          expect(helpBtn, findsOneWidget);
          expect(notNowBtn, findsOneWidget);

          expect(
            tester.getTopLeft(storeBtn).dy,
            lessThan(tester.getTopLeft(helpBtn).dy),
          );
          expect(
            tester.getSize(storeBtn),
            equals(tester.getSize(helpBtn)),
            reason: 'Store and Help & feedback buttons must have identical size for rating $stars',
          );

          // Nothing opened automatically
          expect(storeOpenedCount, equals(0));
          expect(helpOpenedCount, equals(0));
        }
      },
    );

    testWidgets(
      'Rate on Google Play button is hidden when storeRateUrl is empty while Help & feedback remains',
      (tester) async {
        expect(AppConstants.storeRateUrl, isEmpty);

        await tester.pumpApp(
          const Scaffold(
            body: RateUsSheet(),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(const Key('rate_star_5')));
        await tester.pumpAndSettle();

        expect(find.byKey(const Key('btn_rate_store')), findsNothing);
        expect(find.byKey(const Key('btn_rate_help_feedback')), findsOneWidget);
        expect(find.byKey(const Key('btn_rate_not_now')), findsOneWidget);
      },
    );
  });

  group('FAQ Screen & Rating Highlight Banner Tests', () {
    testWidgets(
      'FaqScreen without fromRating hides highlight banner and renders 7 Topics with exact privacy text',
      (tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpApp(const FaqScreen());
        await tester.pumpAndSettle();

        // Highlight banner MUST NOT appear on normal FAQ
        expect(find.byKey(const Key('faq_rating_highlight_banner')), findsNothing);

        // 7 Topics header count & accordion cards
        expect(find.text('7 Topics'), findsOneWidget);
        for (var i = 0; i < 7; i++) {
          expect(find.byKey(Key('faq_card_$i')), findsOneWidget);
        }

        // Second question expanded by default
        expect(find.text('Why doesn\'t it scan my whole iPhone?'), findsOneWidget);
        expect(find.textContaining('iOS uses strict app sandboxing'), findsOneWidget);

        // Verify 7th question exists
        expect(find.text('Why did PDF to Word change my layout?'), findsOneWidget);

        // Tap 6th question to verify exact privacy text
        await tester.tap(find.text('Is my data uploaded anywhere?'));
        await tester.pumpAndSettle();

        const exactRequiredPrivacyAnswer =
            'Your documents never leave your device. Doc View opens, converts and stores files locally. The app shows ads served by Google AdMob, which can use limited device data as described in our Privacy Policy.';
        expect(find.text(exactRequiredPrivacyAnswer), findsOneWidget);
        expect(find.byKey(const Key('btn_faq_feedback')), findsNothing);
      },
    );

    testWidgets(
      'FaqScreen with fromRating=true shows InfoBanner and conditional Contact us button',
      (tester) async {
        await tester.pumpApp(
          const FaqScreen(fromRating: true),
        );
        await tester.pumpAndSettle();

        expect(find.byKey(const Key('faq_rating_highlight_banner')), findsOneWidget);
        expect(
          find.text(
            'Sorry to hear that. Browse the answers below or contact us; we read every message.',
          ),
          findsOneWidget,
        );
        // Hidden when supportEmail is empty
        expect(find.byKey(const Key('btn_faq_contact_us')), findsNothing);

        // Visible when supportEmail is provided
        await tester.pumpApp(
          const FaqScreen(
            fromRating: true,
            supportEmailOverride: 'support@docview.app',
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byKey(const Key('btn_faq_contact_us')), findsOneWidget);
        expect(find.text('Contact us'), findsOneWidget);
      },
    );
  });

  group('Language Screen & Live Locale Switching Tests', () {
    testWidgets(
      'Release config lists only System default and shipped languages',
      (tester) async {
        await tester.pumpApp(
          const LanguageScreen(isReleaseOverride: true),
        );
        await tester.pumpAndSettle();

        expect(find.byKey(const Key('lang_system_default')), findsOneWidget);
        expect(find.byKey(const Key('lang_en')), findsOneWidget);
        expect(find.byKey(const Key('lang_en_XA')), findsNothing);
        expect(find.byKey(const Key('lang_hi')), findsNothing);
        expect(find.text('(not translated)'), findsNothing);
      },
    );

    testWidgets(
      'Debug config lists pseudo-locale and unshipped planned languages; selecting persists and System default resets to null',
      (tester) async {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: const MaterialApp(
              home: LanguageScreen(isReleaseOverride: false),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byKey(const Key('lang_system_default')), findsOneWidget);
        expect(find.byKey(const Key('lang_en')), findsOneWidget);
        expect(find.byKey(const Key('lang_en_XA')), findsOneWidget);
        expect(find.text('(not translated)'), findsWidgets);

        // Select English -> applies live and persists
        await tester.tap(find.byKey(const Key('lang_en')));
        await tester.pumpAndSettle();
        expect(container.read(localeProvider), equals(const Locale('en')));
        expect(await SettingsRepository().getLocaleCode(), equals('en'));

        // Select en_XA -> applies live and persists
        await tester.tap(find.byKey(const Key('lang_en_XA')));
        await tester.pumpAndSettle();
        expect(container.read(localeProvider), equals(const Locale('en', 'XA')));
        expect(await SettingsRepository().getLocaleCode(), equals('en_XA'));

        // Select System default -> resets localeProvider to null and clears pref
        await tester.tap(find.byKey(const Key('lang_system_default')));
        await tester.pumpAndSettle();
        expect(container.read(localeProvider), isNull);
        expect(await SettingsRepository().getLocaleCode(), isNull);
      },
    );
  });

  group('App Theme Bottom Sheet Tests', () {
    testWidgets(
      'ThemeSelectionSheet displays 3 preview cards and updates theme mode live on Apply',
      (tester) async {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: const MaterialApp(
              home: Scaffold(
                body: ThemeSelectionSheet(),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('App theme'), findsOneWidget);
        expect(find.text('Select visual appearance for Doc View'), findsOneWidget);
        expect(find.byKey(const Key('theme_card_system')), findsOneWidget);
        expect(find.byKey(const Key('theme_card_light')), findsOneWidget);
        expect(find.byKey(const Key('theme_card_dark')), findsOneWidget);

        expect(container.read(settingsProvider).themeMode, ThemeMode.system);

        await tester.tap(find.byKey(const Key('theme_card_dark')));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(const Key('btn_apply_theme')));
        await tester.pumpAndSettle();

        expect(container.read(settingsProvider).themeMode, ThemeMode.dark);
      },
    );
  });

  group('Scan Settings & History Section Tests', () {
    testWidgets(
      'ScanSettingsScreen toggles radio modes, shows include images snackbar, and renders History section',
      (tester) async {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: const MaterialApp(
              home: ScanSettingsScreen(),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byKey(const Key('radio_scan_on_open')), findsOneWidget);
        expect(find.byKey(const Key('radio_scan_manual_only')), findsOneWidget);

        expect(container.read(settingsProvider).autoScanMode, AutoScanMode.onOpen);

        await tester.tap(find.byKey(const Key('radio_scan_manual_only')));
        await tester.pumpAndSettle();
        expect(container.read(settingsProvider).autoScanMode, AutoScanMode.manualOnly);

        final switchFinder = find.byKey(const Key('switch_include_images'));
        expect(switchFinder, findsOneWidget);
        await tester.tap(switchFinder);
        await tester.pumpAndSettle();

        expect(find.text('Image list updated'), findsOneWidget);
        expect(find.text('Rescan now'), findsWidgets);

        // Scroll to History section
        await tester.scrollUntilVisible(
          find.byKey(const Key('settings_clear_history')),
          200,
          scrollable: find.byType(Scrollable).first,
        );
        expect(find.text('HISTORY'), findsOneWidget);
        expect(find.byKey(const Key('settings_clear_history')), findsOneWidget);
      },
    );

    testWidgets(
      'Clear recent history dialog in ScanSettingsScreen prompts user and executes clear logic with snackbar',
      (tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpApp(
          const ScanSettingsScreen(),
          overrides: [
            fileActionsControllerProvider.overrideWith(
              (ref) => _FakeFileActionsController(ref),
            ),
          ],
        );
        await tester.pumpAndSettle();

        await tester.scrollUntilVisible(
          find.byKey(const Key('settings_clear_history')),
          200,
          scrollable: find.byType(Scrollable).first,
        );

        // Tap Clear recent history row
        await tester.tap(find.byKey(const Key('settings_clear_history')));
        await tester.pumpAndSettle();

        expect(find.text('Clear recent history?'), findsOneWidget);
        expect(
          find.text(
            'Files will be removed from Recent. Your files and bookmarks are not affected.',
          ),
          findsOneWidget,
        );

        // Cancel dismisses without snackbar
        await tester.tap(find.byKey(const Key('btn_dialog_cancel')));
        await tester.pumpAndSettle();
        expect(find.text('Clear recent history?'), findsNothing);
        expect(find.text('Recent history cleared'), findsNothing);

        // Open dialog again and tap Clear
        await tester.tap(find.byKey(const Key('settings_clear_history')));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(const Key('btn_dialog_confirm')));
        await tester.pumpAndSettle();

        expect(find.text('Recent history cleared'), findsOneWidget);
      },
    );
  });
}
