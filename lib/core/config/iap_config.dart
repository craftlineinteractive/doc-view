import 'package:flutter/foundation.dart';

/// Configuration for Google Play In-App Billing subscriptions.
///
/// Note: To comply with dynamic store pricing and regional currency localization,
/// this configuration strictly contains product identifiers, entitlement durations,
/// and offline grace windows. It contains ZERO price or currency literals.
@immutable
class IapConfig {
  const IapConfig._();

  /// Single auto-renewing subscription product identifier on Google Play.
  static const String subscriptionProductId = 'docview_premium';

  /// Base plan identifier for yearly subscription on Google Play Billing v5+.
  static const String yearlyBasePlanId = 'yearly';

  /// Base plan identifier for monthly subscription on Google Play Billing v5+.
  static const String monthlyBasePlanId = 'monthly';

  /// Offer identifier for the free trial offer.
  static const String freeTrialOfferId = 'freetrial-7d';

  /// Set of all active subscription product identifiers registered on Google Play.
  static const Set<String> subscriptionProductIds = {
    subscriptionProductId,
  };

  /// ISO-8601 billing period for annual plan (1 year).
  static const String periodYearly = 'P1Y';

  /// ISO-8601 billing period for monthly plan (1 month).
  static const String periodMonthly = 'P1M';

  /// Duration of the offline grace period during which an active subscription
  /// remains valid without requiring network entitlement re-verification.
  static const Duration offlineGracePeriod = Duration(days: 7);

  /// SharedPreferences key for caching active premium state.
  static const String prefKeyPremiumActive = 'premium_active';

  /// SharedPreferences key for recording timestamp (ms) of last successful store verification.
  static const String prefKeyPremiumVerifiedAtMs = 'premium_verified_at_ms';

  /// SharedPreferences key for recording whether the subscription product has been seen from store.
  static const String prefKeyIapProductSeen = 'iap_product_seen';

  /// SharedPreferences key for caching the purchase token for verification.
  static const String prefKeyPurchaseToken = 'iap_purchase_token';

  /// SharedPreferences key for caching the active base plan ID.
  static const String prefKeyActiveBasePlan = 'iap_active_base_plan';
}
