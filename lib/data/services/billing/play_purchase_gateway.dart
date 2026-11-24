import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
// ignore: depend_on_referenced_packages
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

import '../../../core/config/iap_config.dart';
import 'purchase_gateway.dart';
import 'subscription_plan.dart';

/// Production implementation of [PurchaseGateway] connecting to Google Play Billing
/// (and StoreKit on iOS) through the standard `in_app_purchase` plugin.
class PlayPurchaseGateway implements PurchaseGateway {
  PlayPurchaseGateway({InAppPurchase? iap}) : _iap = iap ?? InAppPurchase.instance;

  final InAppPurchase _iap;

  @override
  Stream<List<PurchaseDetails>> get purchaseStream => _iap.purchaseStream;

  @override
  Future<bool> isAvailable() async {
    try {
      return await _iap.isAvailable();
    } catch (_) {
      return false;
    }
  }

  @override
  Future<List<ProductDetails>> queryProductDetails(Set<String> productIds) async {
    try {
      final response = await _iap.queryProductDetails(productIds);
      if (response.error != null) {
        return const [];
      }
      return response.productDetails;
    } catch (_) {
      return const [];
    }
  }

  @override
  Future<List<SubscriptionPlan>> querySubscriptionPlans() async {
    try {
      final products = await queryProductDetails(IapConfig.subscriptionProductIds);
      if (products.isEmpty) return const [];

      final plans = <SubscriptionPlan>[];

      for (final product in products) {
        if (product is GooglePlayProductDetails) {
          final offers = product.productDetails.subscriptionOfferDetails;
          if (offers != null && offers.isNotEmpty) {
            for (final offer in offers) {
              final phases = offer.pricingPhases;
              if (phases.isEmpty) continue;

              // 1. Identify introductory free trial by zero-price first phase
              bool hasTrial = false;
              int? trialDays;
              dynamic recurringPhase = phases.last;

              if (phases.length > 1 && phases.first.priceAmountMicros == 0) {
                hasTrial = true;
                trialDays = SubscriptionPlan.parseBillingPeriodDays(phases.first.billingPeriod);
              } else if (phases.first.priceAmountMicros == 0 && phases.first.billingCycleCount > 0) {
                hasTrial = true;
                trialDays = SubscriptionPlan.parseBillingPeriodDays(phases.first.billingPeriod);
              }

              // 2. Identify recurring phase (non-zero or recurring cycle)
              for (final phase in phases) {
                if (phase.priceAmountMicros > 0 || phase.billingCycleCount == 0) {
                  recurringPhase = phase;
                  break;
                }
              }

              final period = recurringPhase.billingPeriod;
              // Filter to recognized periods: P1Y and P1M
              if (period != IapConfig.periodYearly && period != IapConfig.periodMonthly) {
                continue;
              }

              plans.add(
                SubscriptionPlan(
                  productId: product.id,
                  basePlanId: offer.basePlanId,
                  billingPeriod: period,
                  formattedPrice: recurringPhase.formattedPrice,
                  rawPrice: recurringPhase.priceAmountMicros / 1000000.0,
                  currencyCode: recurringPhase.priceCurrencyCode,
                  currencySymbol: '',
                  hasFreeTrial: hasTrial,
                  trialDays: trialDays,
                  productDetails: product,
                  offerToken: offer.offerIdToken,
                ),
              );
            }
          }
        } else {
          // Non-Android fallback
          plans.add(
            SubscriptionPlan(
              productId: product.id,
              basePlanId: IapConfig.yearlyBasePlanId,
              billingPeriod: IapConfig.periodYearly,
              formattedPrice: product.price,
              rawPrice: product.rawPrice,
              currencyCode: product.currencyCode,
              currencySymbol: product.currencySymbol,
              hasFreeTrial: false,
              productDetails: product,
            ),
          );
        }
      }

      return plans;
    } catch (e) {
      debugPrint('PlayPurchaseGateway error querying plans: $e');
      return const [];
    }
  }

  @override
  Future<bool> buyPlan({required SubscriptionPlan plan}) async {
    try {
      PurchaseParam purchaseParam;
      if (defaultTargetPlatform == TargetPlatform.android && plan.offerToken != null) {
        purchaseParam = GooglePlayPurchaseParam(
          productDetails: plan.productDetails,
          offerToken: plan.offerToken,
        );
      } else {
        purchaseParam = PurchaseParam(productDetails: plan.productDetails);
      }
      return await _iap.buyNonConsumable(purchaseParam: purchaseParam);
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> buySubscription({required ProductDetails productDetails}) async {
    final purchaseParam = PurchaseParam(productDetails: productDetails);
    return await _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  @override
  Future<void> restorePurchases() async {
    await _iap.restorePurchases();
  }

  @override
  Future<void> completePurchase(PurchaseDetails purchase) async {
    if (purchase.pendingCompletePurchase) {
      await _iap.completePurchase(purchase);
    }
  }

  @override
  void dispose() {
    // No-op for singleton in_app_purchase instance
  }
}
