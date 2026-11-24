import 'dart:async';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'purchase_gateway.dart';

/// Test and debug simulation implementation of [PurchaseGateway].
///
/// Simulates store responses, price loading, purchasing, errors, and restores
/// without requiring a live Google Play Store connection or test account.
class FakePurchaseGateway implements PurchaseGateway {
  FakePurchaseGateway({
    this.isAvailableMock = true,
    List<ProductDetails>? mockProducts,
  })  : _products = mockProducts ?? _defaultMockProducts();

  bool isAvailableMock;
  List<ProductDetails> _products;
  final StreamController<List<PurchaseDetails>> _purchaseController =
      StreamController<List<PurchaseDetails>>.broadcast();

  // Test hooks
  bool simulatePurchaseFailure = false;
  bool simulateUserCancel = false;
  Duration delay = Duration.zero;

  void setAvailable(bool available) {
    isAvailableMock = available;
  }

  void setMockProducts(List<ProductDetails> products) {
    _products = products;
  }

  @override
  Stream<List<PurchaseDetails>> get purchaseStream => _purchaseController.stream;

  @override
  Future<bool> isAvailable() async {
    if (delay > Duration.zero) await Future.delayed(delay);
    return isAvailableMock;
  }

  @override
  Future<List<ProductDetails>> queryProductDetails(Set<String> productIds) async {
    if (delay > Duration.zero) await Future.delayed(delay);
    if (!isAvailableMock) return const [];
    return _products.where((p) => productIds.contains(p.id)).toList();
  }

  @override
  Future<bool> buySubscription({required ProductDetails productDetails}) async {
    if (delay > Duration.zero) await Future.delayed(delay);
    if (!isAvailableMock) return false;

    if (simulateUserCancel) {
      final canceledPurchase = _createPurchaseDetails(
        productId: productDetails.id,
        status: PurchaseStatus.canceled,
      );
      _purchaseController.add([canceledPurchase]);
      return true;
    }

    if (simulatePurchaseFailure) {
      final errorPurchase = _createPurchaseDetails(
        productId: productDetails.id,
        status: PurchaseStatus.error,
        error: IAPError(
          source: 'fake_store',
          code: 'payment_declined',
          message: 'Simulated payment failure',
        ),
      );
      _purchaseController.add([errorPurchase]);
      return true;
    }

    // Pending -> Purchased
    final pendingPurchase = _createPurchaseDetails(
      productId: productDetails.id,
      status: PurchaseStatus.pending,
    );
    _purchaseController.add([pendingPurchase]);

    final purchased = _createPurchaseDetails(
      productId: productDetails.id,
      status: PurchaseStatus.purchased,
      verificationData: PurchaseVerificationData(
        localVerificationData: 'fake_local_token_${productDetails.id}',
        serverVerificationData: 'fake_server_token_${productDetails.id}',
        source: 'fake_store',
      ),
    );
    _purchaseController.add([purchased]);
    return true;
  }

  @override
  Future<void> restorePurchases() async {
    if (delay > Duration.zero) await Future.delayed(delay);
    if (!isAvailableMock) return;

    if (_products.isNotEmpty) {
      final restored = _createPurchaseDetails(
        productId: _products.first.id,
        status: PurchaseStatus.restored,
      );
      _purchaseController.add([restored]);
    } else {
      _purchaseController.add([]);
    }
  }

  @override
  Future<void> completePurchase(PurchaseDetails purchase) async {
    // Simulated completion
  }

  @override
  void dispose() {
    _purchaseController.close();
  }

  PurchaseDetails _createPurchaseDetails({
    required String productId,
    required PurchaseStatus status,
    IAPError? error,
    PurchaseVerificationData? verificationData,
  }) {
    final details = PurchaseDetails(
      productID: productId,
      purchaseID: 'fake_order_${DateTime.now().millisecondsSinceEpoch}',
      verificationData: verificationData ??
          PurchaseVerificationData(
            localVerificationData: 'fake_token_$productId',
            serverVerificationData: 'fake_token_$productId',
            source: 'fake_store',
          ),
      transactionDate: DateTime.now().millisecondsSinceEpoch.toString(),
      status: status,
    );
    if (error != null) {
      details.error = error;
    }
    return details;
  }

  static List<ProductDetails> _defaultMockProducts() {
    return [
      _FakeProductDetails(
        id: 'docview_premium_yearly',
        title: 'Doc View Premium Yearly',
        description: 'Unlimited access with 7-day free trial',
        price: 'Dynamic Store Price / Year',
        rawPrice: 0.0,
        currencyCode: '',
        currencySymbol: '',
      ),
      _FakeProductDetails(
        id: 'docview_premium_monthly',
        title: 'Doc View Premium Monthly',
        description: 'Flexible monthly subscription',
        price: 'Dynamic Store Price / Month',
        rawPrice: 0.0,
        currencyCode: '',
        currencySymbol: '',
      ),
    ];
  }
}

class _FakeProductDetails extends ProductDetails {
  _FakeProductDetails({
    required super.id,
    required super.title,
    required super.description,
    required super.price,
    required super.rawPrice,
    required super.currencyCode,
    required super.currencySymbol,
  });
}
