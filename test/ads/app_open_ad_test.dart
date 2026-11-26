import 'package:docview/core/config/ad_config.dart';
import 'package:docview/core/utils/external_activity_guard.dart';
import 'package:docview/data/services/ads/ad_service.dart';
import 'package:docview/data/services/billing/billing_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AdConfig App Open Unit Tests', () {
    tearDown(() {
      AdConfig.forceReleaseModeForTesting = null;
    });

    test('AdType.appOpen returns test unit ID in debug mode', () {
      AdConfig.forceReleaseModeForTesting = false;
      final adUnitId = AdConfig.getAdUnitId(AdType.appOpen);
      expect(adUnitId, 'ca-app-pub-3940256099942544/9257395921');
      expect(AdConfig.isAdEnabled(AdType.appOpen), isTrue);
    });

    test('AdType.appOpen returns empty string in release mode when no define provided', () {
      AdConfig.forceReleaseModeForTesting = true;
      final adUnitId = AdConfig.getAdUnitId(AdType.appOpen);
      expect(adUnitId, isEmpty);
      expect(AdConfig.isAdEnabled(AdType.appOpen), isFalse);
    });
  });

  group('ExternalActivityGuard Unit Tests', () {
    tearDown(() {
      ExternalActivityGuard.setInExternalActivity(false);
    });

    test('guard sets isInExternalActivity to true during execution', () async {
      expect(ExternalActivityGuard.isInExternalActivity, isFalse);

      bool executed = false;
      final result = await ExternalActivityGuard.guard(() async {
        expect(ExternalActivityGuard.isInExternalActivity, isTrue);
        executed = true;
        return 42;
      });

      expect(executed, isTrue);
      expect(result, 42);
      // Holds true immediately after return to cover onResume
      expect(ExternalActivityGuard.isInExternalActivity, isTrue);
    });

    test('setInExternalActivity manually sets flag', () {
      ExternalActivityGuard.setInExternalActivity(true);
      expect(ExternalActivityGuard.isInExternalActivity, isTrue);
      ExternalActivityGuard.setInExternalActivity(false);
      expect(ExternalActivityGuard.isInExternalActivity, isFalse);
    });
  });

  group('AdService App Open Eligibility Tests', () {
    tearDown(() {
      ExternalActivityGuard.setInExternalActivity(false);
    });

    test('showAppOpenAdIfEligible returns early when in external activity', () async {
      final containerRef = ProviderContainer(
        overrides: [
          isPremiumProvider.overrideWith((ref) => false),
        ],
      );

      final adService = containerRef.read(adServiceProvider);
      ExternalActivityGuard.setInExternalActivity(true);

      // Should safely return without attempting to show
      await adService.showAppOpenAdIfEligible();
      expect(adService.isAppOpenAdAvailable, isFalse);

      containerRef.dispose();
    });

    test('disposeAllAds resets App Open Ad state', () {
      final containerRef = ProviderContainer(
        overrides: [
          isPremiumProvider.overrideWith((ref) => false),
        ],
      );

      final adService = containerRef.read(adServiceProvider);
      adService.disposeAllAds();
      expect(adService.isAppOpenAdAvailable, isFalse);

      containerRef.dispose();
    });
  });
}
