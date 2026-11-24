import 'package:flutter/foundation.dart';

/// Configuration for Google Play In-App Billing subscriptions.
///
/// Note: To comply with dynamic store pricing and regional currency localization,
/// this configuration strictly contains product identifiers, entitlement durations,
/// and offline grace windows. It contains ZERO price or currency literals.
@immutable
class IapConfig {
  const IapConfig._();

  /// Annual auto-renewing subscription product identifier.
  static const String yearlySubscriptionId = 'docview_premium_yearly';

  /// Monthly auto-renewing subscription product identifier.
  static const String monthlySubscriptionId = 'docview_premium_monthly';

  /// Set of all active subscription product identifiers registered on Google Play.
  static const Set<String> subscriptionProductIds = {
    yearlySubscriptionId,
    monthlySubscriptionId,
  };

  /// Base plan identifier for yearly subscription on Google Play Billing v5+.
  static const String yearlyBasePlanId = 'docview-premium-yearly-base';

  /// Base plan identifier for monthly subscription on Google Play Billing v5+.
  static const String monthlyBasePlanId = 'docview-premium-monthly-base';

  /// Duration of the offline grace period during which an active subscription
  /// remains valid without requiring network entitlement re-verification.
  static const Duration offlineGracePeriod = Duration(days: 7);

  /// Number of days in the free trial period for the annual subscription.
  static const int yearlyTrialDays = 7;

  /// SharedPreferences key for caching active premium state.
  static const String prefKeyPremiumActive = 'premium_active';

  /// SharedPreferences key for recording timestamp (ms) of last successful store verification.
  static const String prefKeyPremiumVerifiedAtMs = 'premium_verified_at_ms';

  /// SharedPreferences key for caching the product identifier of the active subscription.
  static const String prefKeyIapProductSeen = 'iap_product_seen';

  /// SharedPreferences key for caching the purchase token for verification.
  static const String prefKeyPurchaseToken = 'iap_purchase_token';
}
