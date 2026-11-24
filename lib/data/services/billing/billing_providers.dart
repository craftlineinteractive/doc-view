import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/feature_flags.dart';
import 'play_purchase_gateway.dart';
import 'premium_controller.dart';
import 'purchase_gateway.dart';

/// Provider exposing the active billing gateway.
///
/// Defaults to [PlayPurchaseGateway] in production.
/// Can be overridden in tests or component gallery via [FakePurchaseGateway].
final purchaseGatewayProvider = Provider<PurchaseGateway>((ref) {
  final gateway = PlayPurchaseGateway();
  ref.onDispose(gateway.dispose);
  return gateway;
});

/// Global provider for subscription entitlement and billing controller.
final premiumControllerProvider = Provider<PremiumController>((ref) {
  final gateway = ref.watch(purchaseGatewayProvider);
  final controller = PremiumController(gateway: gateway);
  ref.onDispose(controller.dispose);
  return controller;
});

/// Reactive stream of premium state updates.
final premiumStateStreamProvider = StreamProvider<PremiumState>((ref) {
  final controller = ref.watch(premiumControllerProvider);
  return controller.stateStream;
});

/// Reactive boolean provider indicating whether the user is an active Premium subscriber.
final isPremiumProvider = Provider<bool>((ref) {
  final controller = ref.watch(premiumControllerProvider);
  final asyncState = ref.watch(premiumStateStreamProvider);
  return asyncState.asData?.value.isPremium ?? controller.state.isPremium;
});

/// Reactive boolean provider indicating whether premium locks and safeguards are active.
///
/// LOCK SAFEGUARD:
/// Locks are active ONLY when:
/// 1. `FeatureFlags.premiumEnabled` is true, AND
/// 2. The store has returned the subscription product at least once (cached `iap_product_seen` is true).
///
/// If `iap_product_seen` has NOT been seen from the store, all features are completely FREE
/// and open (no crown badges, PagesScreen fully editable, paywall shows "Subscriptions will be available soon.").
final locksActiveProvider = Provider<bool>((ref) {
  if (!premiumEnabled) return false;
  final controller = ref.watch(premiumControllerProvider);
  final asyncState = ref.watch(premiumStateStreamProvider);
  final state = asyncState.asData?.value ?? controller.state;
  return state.iapProductSeen;
});

/// Reactive boolean provider determining whether advertisements should be displayed.
///
/// Evaluates to `false` (ads suppressed) if the user is a Premium subscriber.
final adsAllowedProvider = Provider<bool>((ref) {
  final isPremium = ref.watch(isPremiumProvider);
  return !isPremium;
});
