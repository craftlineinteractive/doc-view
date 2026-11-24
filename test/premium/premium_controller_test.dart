import 'package:docview/core/config/iap_config.dart';
import 'package:docview/data/services/billing/fake_purchase_gateway.dart';
import 'package:docview/data/services/billing/premium_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PremiumController Unit Tests', () {
    late FakePurchaseGateway fakeGateway;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      fakeGateway = FakePurchaseGateway();
    });

    tearDown(() {
      fakeGateway.dispose();
    });

    test('Fresh free user initializes with isPremium = false and loads products/plans', () async {
      final prefs = await SharedPreferences.getInstance();
      final controller = PremiumController(gateway: fakeGateway, prefs: prefs);

      // Give event loop time to run _init
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(controller.state.isPremium, isFalse);
      expect(controller.state.isGracePeriod, isFalse);
      expect(controller.state.iapProductSeen, isTrue);
      expect(controller.state.plans.length, 2);
      // Yearly should be sorted first, monthly second
      expect(controller.state.plans[0].billingPeriod, IapConfig.periodYearly);
      expect(controller.state.plans[0].basePlanId, IapConfig.yearlyBasePlanId);
      expect(controller.state.plans[1].billingPeriod, IapConfig.periodMonthly);
      expect(controller.state.plans[1].basePlanId, IapConfig.monthlyBasePlanId);
      expect(controller.state.selectedPlan?.basePlanId, IapConfig.yearlyBasePlanId);
    });

    test('Offline grace period: active within 7 days is sustained with isPremium = true', () async {
      final fixedNow = DateTime(2026, 11, 24, 12, 0, 0);
      final verifiedAt = fixedNow.subtract(const Duration(days: 3)); // 3 days ago (< 7 days)

      SharedPreferences.setMockInitialValues({
        IapConfig.prefKeyPremiumActive: true,
        IapConfig.prefKeyPremiumVerifiedAtMs: verifiedAt.millisecondsSinceEpoch,
        IapConfig.prefKeyPurchaseToken: IapConfig.subscriptionProductId,
        IapConfig.prefKeyActiveBasePlan: IapConfig.yearlyBasePlanId,
      });

      final prefs = await SharedPreferences.getInstance();
      final controller = PremiumController(
        gateway: fakeGateway,
        prefs: prefs,
        nowProvider: () => fixedNow,
      );

      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(controller.state.isPremium, isTrue);
      expect(controller.state.isGracePeriod, isTrue);
      expect(controller.state.activeProductId, IapConfig.subscriptionProductId);
      expect(controller.state.verifiedAt, verifiedAt);
    });

    test('Offline grace period: expires when last verified > 7 days ago', () async {
      final fixedNow = DateTime(2026, 11, 24, 12, 0, 0);
      final verifiedAt = fixedNow.subtract(const Duration(days: 8)); // 8 days ago (> 7 days)

      SharedPreferences.setMockInitialValues({
        IapConfig.prefKeyPremiumActive: true,
        IapConfig.prefKeyPremiumVerifiedAtMs: verifiedAt.millisecondsSinceEpoch,
        IapConfig.prefKeyPurchaseToken: IapConfig.subscriptionProductId,
        IapConfig.prefKeyActiveBasePlan: IapConfig.yearlyBasePlanId,
      });

      final prefs = await SharedPreferences.getInstance();
      final controller = PremiumController(
        gateway: fakeGateway,
        prefs: prefs,
        nowProvider: () => fixedNow,
      );

      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(controller.state.isPremium, isFalse);
      expect(controller.state.isGracePeriod, isFalse);
      expect(controller.state.activeProductId, isNull);
      expect(prefs.getBool(IapConfig.prefKeyPremiumActive), isFalse);
    });

    test('Successful subscription purchase updates state and writes to SharedPreferences', () async {
      final prefs = await SharedPreferences.getInstance();
      final fixedNow = DateTime(2026, 11, 24, 14, 0, 0);

      final controller = PremiumController(
        gateway: fakeGateway,
        prefs: prefs,
        nowProvider: () => fixedNow,
      );

      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(controller.state.isPremium, isFalse);

      final success = await controller.buyPlan(controller.state.plans[0]);
      expect(success, isTrue);

      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(controller.state.isPremium, isTrue);
      expect(controller.state.isGracePeriod, isFalse);
      expect(controller.state.activeProductId, IapConfig.subscriptionProductId);
      expect(controller.state.isLoading, isFalse);
      expect(controller.state.errorMessage, isNull);

      // Verify persisted cache in SharedPreferences
      expect(prefs.getBool(IapConfig.prefKeyPremiumActive), isTrue);
      expect(prefs.getInt(IapConfig.prefKeyPremiumVerifiedAtMs), fixedNow.millisecondsSinceEpoch);
      expect(prefs.getString(IapConfig.prefKeyPurchaseToken), contains(IapConfig.subscriptionProductId));
      expect(prefs.getBool(IapConfig.prefKeyIapProductSeen), isTrue);
    });

    test('Purchase failure updates state with error message and keeps isPremium = false', () async {
      fakeGateway.simulatePurchaseFailure = true;
      final prefs = await SharedPreferences.getInstance();
      final controller = PremiumController(gateway: fakeGateway, prefs: prefs);

      await Future<void>.delayed(const Duration(milliseconds: 50));
      await controller.buyPlan(controller.state.plans[0]);
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(controller.state.isPremium, isFalse);
      expect(controller.state.isLoading, isFalse);
      expect(controller.state.errorMessage, contains('Simulated payment failure'));
    });

    test('Restore purchases recovers active subscription', () async {
      final prefs = await SharedPreferences.getInstance();
      final controller = PremiumController(gateway: fakeGateway, prefs: prefs);

      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(controller.state.isPremium, isFalse);

      await controller.restorePurchases();
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(controller.state.isPremium, isTrue);
      expect(controller.state.activeProductId, IapConfig.subscriptionProductId);
    });
  });
}
