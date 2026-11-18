import 'package:docview/app.dart';
import 'package:docview/data/repositories/settings_repository.dart';
import 'package:docview/features/providers/providers.dart';
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

      // Reset to null
      await repo.saveLocaleCode(null);
      expect(await repo.getLocaleCode(), isNull);
      settings = await repo.loadSettings();
      expect(settings.localeCode, isNull);
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

      // Reset to system default
      await container.read(settingsProvider.notifier).setLocaleCode(null);
      expect(container.read(localeProvider), isNull);
    });

    test('resolveAppLocale prioritizes exact language+country matches like en_XA', () {
      const supported = [Locale('en'), Locale('en', 'XA')];

      expect(
        DocReaderApp.resolveAppLocale(const Locale('en', 'XA'), supported),
        equals(const Locale('en', 'XA')),
      );
      expect(
        DocReaderApp.resolveAppLocale(const Locale('en', 'US'), supported),
        equals(const Locale('en')),
      );
      expect(
        DocReaderApp.resolveAppLocale(const Locale('ja'), supported),
        equals(const Locale('en')),
      );
    });
  });
}
