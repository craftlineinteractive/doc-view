import 'dart:async';
import 'package:in_app_purchase/in_app_purchase.dart';

import 'subscription_plan.dart';

/// Abstract contract for In-App Billing store operations.
///
/// Decouples UI and state management from the concrete platform billing engine
/// (`in_app_purchase`), allowing production execution via [PlayPurchaseGateway]
/// and deterministic testing/simulation via [FakePurchaseGateway].
abstract class PurchaseGateway {
  /// Stream emitting real-time purchase updates from the store.
  Stream<List<PurchaseDetails>> get purchaseStream;

  /// Checks if the platform store is reachable and available for billing.
  Future<bool> isAvailable();

  /// Queries the store for localized product details (title, description, price).
  Future<List<ProductDetails>> queryProductDetails(Set<String> productIds);

  /// Queries the store for subscription base plans and introductory offers.
  Future<List<SubscriptionPlan>> querySubscriptionPlans();

  /// Initiates a purchase flow for a specific subscription plan.
  Future<bool> buyPlan({required SubscriptionPlan plan});

  /// Initiates a purchase flow for an auto-renewing subscription or non-consumable item.
  Future<bool> buySubscription({required ProductDetails productDetails});

  /// Requests the store to restore past active purchases and deliver them via [purchaseStream].
  Future<void> restorePurchases();

  /// Acknowledges and completes an active purchase with the store.
  Future<void> completePurchase(PurchaseDetails purchase);

  /// Releases resources and stream subscriptions.
  void dispose();
}
