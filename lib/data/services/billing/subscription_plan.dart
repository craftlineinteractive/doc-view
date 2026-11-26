import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../../core/config/iap_config.dart';

/// Localized subscription plan details parsed from Google Play store response.
@immutable
class SubscriptionPlan {
  const SubscriptionPlan({
    required this.productId,
    required this.basePlanId,
    required this.billingPeriod,
    required this.formattedPrice,
    required this.rawPrice,
    required this.currencyCode,
    required this.currencySymbol,
    this.hasFreeTrial = false,
    this.trialDays,
    required this.productDetails,
    this.offerToken,
  });

  /// The store product identifier (e.g. `docview_premium`).
  final String productId;

  /// The base plan identifier (e.g. `yearly`, `monthly`).
  final String basePlanId;

  /// ISO-8601 billing period (e.g. `P1Y` for yearly, `P1M` for monthly).
  final String billingPeriod;

  /// Localized formatted recurring price returned by the store (e.g. dynamic currency).
  final String formattedPrice;

  /// Raw numeric recurring price for mathematical discount/savings calculations.
  final double rawPrice;

  /// Currency code (e.g. `USD`, `EUR`, `INR`).
  final String currencyCode;

  /// Currency symbol if provided by the store.
  final String currencySymbol;

  /// Whether this plan offers a zero-price introductory trial phase.
  final bool hasFreeTrial;

  /// Duration of the introductory free trial in days, parsed dynamically from ISO-8601.
  /// Never hard-coded.
  final int? trialDays;

  /// The underlying platform [ProductDetails] passed to the purchase gateway.
  final ProductDetails productDetails;

  /// Google Play Billing v5 offer token for subscription purchase parameter.
  final String? offerToken;

  /// Whether this is the annual subscription base plan (`P1Y`).
  bool get isYearly => billingPeriod == IapConfig.periodYearly;

  /// Whether this is the monthly subscription base plan (`P1M`).
  bool get isMonthly => billingPeriod == IapConfig.periodMonthly;

  /// Parses an ISO-8601 duration string (e.g. `P7D`, `P14D`, `P1W`, `P1M`) into days.
  static int? parseBillingPeriodDays(String? period) {
    if (period == null || period.isEmpty) return null;
    final trimmed = period.trim().toUpperCase();
    final match = RegExp(r'^P(?:(\d+)Y)?(?:(\d+)M)?(?:(\d+)W)?(?:(\d+)D)?').firstMatch(trimmed);
    if (match == null) return null;

    final years = int.tryParse(match.group(1) ?? '') ?? 0;
    final months = int.tryParse(match.group(2) ?? '') ?? 0;
    final weeks = int.tryParse(match.group(3) ?? '') ?? 0;
    final days = int.tryParse(match.group(4) ?? '') ?? 0;

    final totalDays = (years * 365) + (months * 30) + (weeks * 7) + days;
    return totalDays > 0 ? totalDays : null;
  }

  /// Serializes plan to a persistent JSON map for offline / cold-load caching.
  Map<String, dynamic> toJson() => {
        'productId': productId,
        'basePlanId': basePlanId,
        'billingPeriod': billingPeriod,
        'formattedPrice': formattedPrice,
        'rawPrice': rawPrice,
        'currencyCode': currencyCode,
        'currencySymbol': currencySymbol,
        'hasFreeTrial': hasFreeTrial,
        'trialDays': trialDays,
        'offerToken': offerToken,
      };

  /// Restores plan from cached JSON with a reconstructed [ProductDetails].
  static SubscriptionPlan fromJson(Map<String, dynamic> json) {
    final prodId = json['productId'] as String? ?? IapConfig.subscriptionProductId;
    final fmtPrice = json['formattedPrice'] as String? ?? '';
    final rPrice = (json['rawPrice'] as num?)?.toDouble() ?? 0.0;
    final currCode = json['currencyCode'] as String? ?? '';
    final currSym = json['currencySymbol'] as String? ?? '';

    return SubscriptionPlan(
      productId: prodId,
      basePlanId: json['basePlanId'] as String? ?? '',
      billingPeriod: json['billingPeriod'] as String? ?? '',
      formattedPrice: fmtPrice,
      rawPrice: rPrice,
      currencyCode: currCode,
      currencySymbol: currSym,
      hasFreeTrial: json['hasFreeTrial'] as bool? ?? false,
      trialDays: json['trialDays'] as int?,
      offerToken: json['offerToken'] as String?,
      productDetails: ProductDetails(
        id: prodId,
        title: 'Doc View Premium',
        description: '',
        price: fmtPrice,
        rawPrice: rPrice,
        currencyCode: currCode,
        currencySymbol: currSym,
      ),
    );
  }
}
