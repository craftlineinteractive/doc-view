import 'package:docview/app.dart';
import 'package:docview/data/repositories/settings_repository.dart';
import 'package:docview/features/providers/providers.dart';
import 'package:docview/features/settings/settings_screen.dart';
import 'package:docview/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Locale Settings Tests (Requirement 2)', () {
    test('default localeCode is null (system default)', () async {
      final repo = SettingsRepository();
      final code = await repo.getLocaleCode();
      expect(code, isNull);

      final settings = await repo.loadSettings();
      expect(settings.localeCode, isNull);
    });

    test('persistence round trip for valid locale codes', () async {
      final repo = SettingsRepository();

      // Save 'en'
      await repo.saveLocaleCode('en');
      expect(await repo.getLocaleCode(), equals('en'));
      var settings = await repo.loadSettings();
      expect(settings.localeCode, equals('en'));

      // Save 'en_XA' (debug pseudo-locale)
      await repo.saveLocaleCode('en_XA');
      expect(await repo.getLocaleCode(), equals('en_XA'));
      settings = await repo.loadSettings();
      expect(settings.localeCode, equals('en_XA'));

      // Save 'pt-BR' and normalized 'pt_BR'
      await repo.saveLocaleCode('pt-BR');
      expect(await repo.getLocaleCode(), equals('pt-BR'));
      await repo.saveLocaleCode('hi');
      expect(await repo.getLocaleCode(), equals('hi'));

      // Reset to null
      await repo.saveLocaleCode(null);
      expect(await repo.getLocaleCode(), isNull);
      settings = await repo.loadSettings();
      expect(settings.localeCode, isNull);
    });

    test('isValidLocaleCode accepts shipped languages and rejects invalid codes', () {
      for (final code in ['en', 'hi', 'gu', 'es', 'pt-BR', 'pt_BR', 'fr', 'de', 'ar', 'id', 'ru']) {
        expect(
          SettingsRepository.isValidLocaleCode(code),
          isTrue,
          reason: '$code should be valid once shipped',
        );
      }
      expect(SettingsRepository.isValidLocaleCode('zz_INVALID'), isFalse);
      expect(SettingsRepository.isValidLocaleCode(''), isFalse);
      expect(SettingsRepository.isValidLocaleCode(null), isFalse);
    });

    test('invalid or unsupported stored code falls back to null', () async {
      SharedPreferences.setMockInitialValues({
        SettingsRepository.keyLocaleCode: 'unsupported_fr_FR',
      });

      final repo = SettingsRepository();
      final code = await repo.getLocaleCode();
      expect(code, isNull);

      final settings = await repo.loadSettings();
      expect(settings.localeCode, isNull);
    });

    test('localeProvider updates live without restart', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Initial state
      expect(container.read(localeProvider), isNull);

      // Update to 'en'
      await container.read(settingsProvider.notifier).setLocaleCode('en');
      expect(container.read(localeProvider), equals(const Locale('en')));

      // Update to 'en_XA'
      await container.read(settingsProvider.notifier).setLocaleCode('en_XA');
      expect(container.read(localeProvider), equals(const Locale('en', 'XA')));

      // Update to 'hi' and 'pt-BR'
      await container.read(settingsProvider.notifier).setLocaleCode('hi');
      expect(container.read(localeProvider), equals(const Locale('hi')));
      await container.read(settingsProvider.notifier).setLocaleCode('pt-BR');
      expect(container.read(localeProvider), equals(const Locale('pt', 'BR')));

      // Reset to system default
      await container.read(settingsProvider.notifier).setLocaleCode(null);
      expect(container.read(localeProvider), isNull);
    });

    test('resolveAppLocale prioritizes exact language+country matches like en_XA', () {
      const supported = [
        Locale('en'),
        Locale('en', 'XA'),
        Locale('hi'),
        Locale('pt', 'BR'),
      ];

      expect(
        DocReaderApp.resolveAppLocale(const Locale('en', 'XA'), supported),
        equals(const Locale('en', 'XA')),
      );
      expect(
        DocReaderApp.resolveAppLocale(const Locale('en', 'US'), supported),
        equals(const Locale('en')),
      );
      expect(
        DocReaderApp.resolveAppLocale(const Locale('hi', 'IN'), supported),
        equals(const Locale('hi')),
      );
      expect(
        DocReaderApp.resolveAppLocale(const Locale('pt', 'PT'), supported),
        equals(const Locale('pt', 'BR')),
      );
      expect(
        DocReaderApp.resolveAppLocale(const Locale('ja'), supported),
        equals(const Locale('en')),
      );
    });

    testWidgets(
      'switching localeProvider updates MaterialApp localized strings live in release mode',
      (tester) async {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: Consumer(
              builder: (context, ref, _) {
                final locale = ref.watch(localeProvider);
                return MaterialApp(
                  locale: locale,
                  localizationsDelegates:
                      AppLocalizations.localizationsDelegates,
                  supportedLocales: AppLocalizations.supportedLocales
                      .where(
                        (l) =>
                            !(l.languageCode == 'en' && l.countryCode == 'XA'),
                      )
                      .toList(growable: false),
                  localeResolutionCallback: DocReaderApp.resolveAppLocale,
                  home: const SettingsScreen(
                    isReleaseOverride: true,
                    premiumEnabledOverride: false,
                    widgetsEnabledOverride: false,
                  ),
                );
              },
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Settings'), findsOneWidget);
        expect(find.byKey(const Key('settings_language')), findsOneWidget);

        await container.read(settingsProvider.notifier).setLocaleCode('hi');
        await tester.pumpAndSettle();
        expect(find.text('सेटिंग्स'), findsOneWidget);

        await container.read(settingsProvider.notifier).setLocaleCode('es');
        await tester.pumpAndSettle();
        expect(find.text('Ajustes'), findsOneWidget);

        await container.read(settingsProvider.notifier).setLocaleCode('ar');
        await tester.pumpAndSettle();
        expect(find.text('الإعدادات'), findsOneWidget);
      },
    );
  });
}
