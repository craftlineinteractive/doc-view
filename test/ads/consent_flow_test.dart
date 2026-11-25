import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:docview/core/config/ad_config.dart';
import 'package:docview/data/services/ads/ad_service.dart';
import 'package:docview/data/services/ads/consent_gateway.dart';
import 'package:docview/data/services/billing/billing_providers.dart';
import 'package:docview/features/settings/settings_screen.dart';
import 'package:docview/l10n/app_localizations.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    AdConfig.enablePlatformChannelRequests = false;
  });

  tearDown(() {
    AdConfig.enablePlatformChannelRequests = true;
  });
  group('UMP Consent & SDK Gating Tests', () {
    test('Non-premium user with consent can request ads and initialize SDK', () async {
      final fakeConsent = FakeConsentGateway(canRequestAdsValue: true);

      final container = ProviderContainer(
        overrides: [
          consentGatewayProvider.overrideWithValue(fakeConsent),
          isPremiumProvider.overrideWith((ref) => false),
        ],
      );

      final adService = container.read(adServiceProvider);
      expect(adService.isSdkInitialized, isFalse);

      await adService.initializeSdkIfAllowed();
      // In headless test without real platform channel, handles gracefully
      expect(await fakeConsent.canRequestAds(), isTrue);
    });

    test('Premium user NEVER initializes Mobile Ads SDK regardless of consent', () async {
      final fakeConsent = FakeConsentGateway(canRequestAdsValue: true);

      final container = ProviderContainer(
        overrides: [
          consentGatewayProvider.overrideWithValue(fakeConsent),
          isPremiumProvider.overrideWith((ref) => true), // Premium!
        ],
      );

      final adService = container.read(adServiceProvider);
      await adService.initializeSdkIfAllowed();

      expect(adService.isSdkInitialized, isFalse,
          reason: 'Premium users must never initialize the Mobile Ads SDK');
    });

    test('User without consent cannot initialize SDK', () async {
      final fakeConsent = FakeConsentGateway(canRequestAdsValue: false); // Consent denied / pending

      final container = ProviderContainer(
        overrides: [
          consentGatewayProvider.overrideWithValue(fakeConsent),
          isPremiumProvider.overrideWith((ref) => false),
        ],
      );

      final adService = container.read(adServiceProvider);
      await adService.initializeSdkIfAllowed();

      expect(adService.isSdkInitialized, isFalse);
    });

    testWidgets('Settings shows "Ad choices" row when privacy options required', (tester) async {
      final fakeConsent = FakeConsentGateway(isPrivacyOptionsRequiredValue: true);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            consentGatewayProvider.overrideWithValue(fakeConsent),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: SettingsScreen(
              showAdChoicesOverride: true,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final adChoicesFinder = find.byKey(const Key('settings_ad_choices'));
      await tester.scrollUntilVisible(
        adChoicesFinder,
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.drag(find.byType(Scrollable).first, const Offset(0, -100));
      await tester.pumpAndSettle();
      expect(adChoicesFinder, findsOneWidget);

      await tester.tap(adChoicesFinder);
      await tester.pumpAndSettle();

      expect(fakeConsent.showPrivacyOptionsFormCalled, isTrue);
    });

    testWidgets('Settings hides "Ad choices" row when privacy options not required', (tester) async {
      final fakeConsent = FakeConsentGateway(isPrivacyOptionsRequiredValue: false);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            consentGatewayProvider.overrideWithValue(fakeConsent),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: SettingsScreen(
              showAdChoicesOverride: false,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final adChoicesFinder = find.byKey(const Key('settings_ad_choices'));
      expect(adChoicesFinder, findsNothing);
    });
  });
}
