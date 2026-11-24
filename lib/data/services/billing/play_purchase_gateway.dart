import 'dart:async';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'purchase_gateway.dart';

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
