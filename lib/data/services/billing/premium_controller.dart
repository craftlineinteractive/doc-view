import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/config/iap_config.dart';
import 'purchase_gateway.dart';

/// State representing user entitlement, active plans, and billing operations.
@immutable
class PremiumState {
  const PremiumState({
    this.isPremium = false,
    this.isGracePeriod = false,
    this.activeProductId,
    this.verifiedAt,
    this.isLoading = false,
    this.isRestoring = false,
    this.errorMessage,
    this.products = const [],
    this.selectedProduct,
  });

  /// Whether the user currently has an active premium entitlement (either verified or within grace).
  final bool isPremium;

  /// Whether the current premium status is sustained by the 7-day offline grace period.
  final bool isGracePeriod;

  /// The product ID of the currently active subscription (e.g. `docview_premium_yearly`).
  final String? activeProductId;

  /// The timestamp of the last successful store verification.
  final DateTime? verifiedAt;

  /// Whether a store query or purchase operation is actively in flight.
  final bool isLoading;

  /// Whether a restore operation is actively in flight.
  final bool isRestoring;

  /// Any human-readable error returned from the platform billing engine.
  final String? errorMessage;

  /// Available subscription products queried from the store.
  final List<ProductDetails> products;

  /// The currently selected subscription product on the paywall screen.
  final ProductDetails? selectedProduct;

  PremiumState copyWith({
    bool? isPremium,
    bool? isGracePeriod,
    String? activeProductId,
    DateTime? verifiedAt,
    bool? isLoading,
    bool? isRestoring,
    String? errorMessage,
    List<ProductDetails>? products,
    ProductDetails? selectedProduct,
    bool clearActiveProduct = false,
    bool clearError = false,
  }) {
    return PremiumState(
      isPremium: isPremium ?? this.isPremium,
      isGracePeriod: isGracePeriod ?? this.isGracePeriod,
      activeProductId: clearActiveProduct ? null : (activeProductId ?? this.activeProductId),
      verifiedAt: verifiedAt ?? this.verifiedAt,
      isLoading: isLoading ?? this.isLoading,
      isRestoring: isRestoring ?? this.isRestoring,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      products: products ?? this.products,
      selectedProduct: selectedProduct ?? this.selectedProduct,
    );
  }
}

/// State notifier managing subscription verification, offline grace logic, and store interaction.
class PremiumController extends ValueNotifier<PremiumState> {
  PremiumController({
    required this.gateway,
    this.prefs,
    DateTime Function()? nowProvider,
  })  : _nowProvider = nowProvider ?? DateTime.now,
        super(const PremiumState()) {
    _init();
  }

  bool _isDisposed = false;

  final StreamController<PremiumState> _stateStreamController =
      StreamController<PremiumState>.broadcast();

  /// Stream emitting subscription state changes for reactive subscribers.
  Stream<PremiumState> get stateStream async* {
    yield state;
    yield* _stateStreamController.stream;
  }

  PremiumState get state => value;
  set state(PremiumState s) {
    if (_isDisposed) return;
    value = s;
    if (!_stateStreamController.isClosed) {
      _stateStreamController.add(s);
    }
  }

  final PurchaseGateway gateway;
  SharedPreferences? prefs;
  final DateTime Function() _nowProvider;
  StreamSubscription<List<PurchaseDetails>>? _purchaseSub;

  Future<void> _init() async {
    prefs ??= await SharedPreferences.getInstance();

    // 1. Check cached entitlement & offline grace period
    _checkOfflineGraceEntitlement();

    // 2. Listen to real-time purchase updates from store
    _purchaseSub = gateway.purchaseStream.listen(
      _handlePurchaseUpdates,
      onError: (dynamic error) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: error.toString(),
        );
      },
    );

    // 3. Query product catalog from store
    await loadProducts();
  }

  void _checkOfflineGraceEntitlement() {
    final cachedActive = prefs?.getBool(IapConfig.prefKeyPremiumActive) ?? false;
    final verifiedAtMs = prefs?.getInt(IapConfig.prefKeyPremiumVerifiedAtMs);
    final cachedProduct = prefs?.getString(IapConfig.prefKeyIapProductSeen);

    if (cachedActive && verifiedAtMs != null) {
      final verifiedDate = DateTime.fromMillisecondsSinceEpoch(verifiedAtMs);
      final elapsed = _nowProvider().difference(verifiedDate);

      if (elapsed <= IapConfig.offlineGracePeriod) {
        // Active under 7-day offline grace fallback
        state = state.copyWith(
          isPremium: true,
          isGracePeriod: elapsed.inDays > 1, // grace active if not verified today
          activeProductId: cachedProduct,
          verifiedAt: verifiedDate,
        );
        return;
      } else {
        // Grace period expired (> 7 days without verification)
        prefs?.setBool(IapConfig.prefKeyPremiumActive, false);
        state = state.copyWith(
          isPremium: false,
          isGracePeriod: false,
          clearActiveProduct: true,
        );
        return;
      }
    }

    state = state.copyWith(
      isPremium: false,
      isGracePeriod: false,
    );
  }

  /// Loads subscription products from the store and orders Yearly first, Monthly second.
  Future<void> loadProducts() async {
    final available = await gateway.isAvailable();
    if (!available) {
      return;
    }

    final fetched = await gateway.queryProductDetails(IapConfig.subscriptionProductIds);
    if (fetched.isEmpty) {
      return;
    }

    // Sort: Yearly first, Monthly second
    final sorted = List<ProductDetails>.from(fetched)
      ..sort((a, b) {
        if (a.id == IapConfig.yearlySubscriptionId) return -1;
        if (b.id == IapConfig.yearlySubscriptionId) return 1;
        return 0;
      });

    state = state.copyWith(
      products: sorted,
      selectedProduct: state.selectedProduct ?? sorted.first,
    );
  }

  /// Selects the chosen plan card.
  void selectProduct(ProductDetails product) {
    state = state.copyWith(selectedProduct: product);
  }

  /// Triggers subscription purchase for [product] (or currently selected plan).
  Future<bool> buySubscription([ProductDetails? product]) async {
    final target = product ?? state.selectedProduct;
    if (target == null) {
      state = state.copyWith(errorMessage: 'No plan selected');
      return false;
    }

    state = state.copyWith(isLoading: true, clearError: true);
    final success = await gateway.buySubscription(productDetails: target);
    if (!success) {
      state = state.copyWith(isLoading: false, errorMessage: 'Failed to initiate purchase');
    }
    return success;
  }

  /// Restores existing purchases from Google Play.
  Future<void> restorePurchases() async {
    state = state.copyWith(isRestoring: true, clearError: true);
    await gateway.restorePurchases();
    state = state.copyWith(isRestoring: false);
  }

  Future<void> _handlePurchaseUpdates(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      switch (purchase.status) {
        case PurchaseStatus.pending:
          state = state.copyWith(isLoading: true, clearError: true);
          break;

        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          await _verifyAndGrantEntitlement(purchase);
          break;

        case PurchaseStatus.error:
          state = state.copyWith(
            isLoading: false,
            errorMessage: purchase.error?.message ?? 'Purchase transaction failed',
          );
          break;

        case PurchaseStatus.canceled:
          state = state.copyWith(
            isLoading: false,
            clearError: true,
          );
          break;
      }
    }
  }

  Future<void> _verifyAndGrantEntitlement(PurchaseDetails purchase) async {
    final now = _nowProvider();

    // Acknowledge purchase with store
    await gateway.completePurchase(purchase);

    // Persist entitlement cache in SharedPreferences
    await prefs?.setBool(IapConfig.prefKeyPremiumActive, true);
    await prefs?.setInt(IapConfig.prefKeyPremiumVerifiedAtMs, now.millisecondsSinceEpoch);
    await prefs?.setString(IapConfig.prefKeyIapProductSeen, purchase.productID);
    if (purchase.verificationData.serverVerificationData.isNotEmpty) {
      await prefs?.setString(
        IapConfig.prefKeyPurchaseToken,
        purchase.verificationData.serverVerificationData,
      );
    }

    state = state.copyWith(
      isPremium: true,
      isGracePeriod: false,
      activeProductId: purchase.productID,
      verifiedAt: now,
      isLoading: false,
      clearError: true,
    );
  }

  /// Test and debug simulator helper to set entitlement conditions.
  void setSimulatedState({
    required bool isPremium,
    bool isGracePeriod = false,
    String? activeProductId,
    DateTime? verifiedAt,
  }) {
    state = state.copyWith(
      isPremium: isPremium,
      isGracePeriod: isGracePeriod,
      activeProductId: activeProductId,
      verifiedAt: verifiedAt,
      clearActiveProduct: activeProductId == null,
    );
  }

  @override
  void dispose() {
    _isDisposed = true;
    _purchaseSub?.cancel();
    _stateStreamController.close();
    gateway.dispose();
    super.dispose();
  }
}
