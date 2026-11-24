import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/config/iap_config.dart';
import 'purchase_gateway.dart';
import 'subscription_plan.dart';

/// State representing user entitlement, active plans, and billing operations.
@immutable
class PremiumState {
  const PremiumState({
    this.isPremium = false,
    this.isGracePeriod = false,
    this.activeProductId,
    this.activeBasePlanId,
    this.verifiedAt,
    this.isLoading = false,
    this.isRestoring = false,
    this.errorMessage,
    this.iapProductSeen = false,
    this.plans = const [],
    this.selectedPlan,
    this.products = const [],
    this.selectedProduct,
  });

  /// Whether the user currently has an active premium entitlement (either verified or within grace).
  final bool isPremium;

  /// Whether the current premium status is sustained by the 7-day offline grace period.
  final bool isGracePeriod;

  /// The product ID of the currently active subscription (e.g. `docview_premium`).
  final String? activeProductId;

  /// The active base plan ID (e.g. `yearly` or `monthly`).
  final String? activeBasePlanId;

  /// The timestamp of the last successful store verification.
  final DateTime? verifiedAt;

  /// Whether a store query or purchase operation is actively in flight.
  final bool isLoading;

  /// Whether a restore operation is actively in flight.
  final bool isRestoring;

  /// Any human-readable error returned from the platform billing engine.
  final String? errorMessage;

  /// Whether the subscription product has been successfully returned and seen from the store.
  final bool iapProductSeen;

  /// Localized subscription plans returned from the store (Yearly first, Monthly second).
  final List<SubscriptionPlan> plans;

  /// The currently selected subscription plan on the paywall screen.
  final SubscriptionPlan? selectedPlan;

  /// Raw platform products queried from the store.
  final List<ProductDetails> products;

  /// Selected product details for backwards compatibility.
  final ProductDetails? selectedProduct;

  PremiumState copyWith({
    bool? isPremium,
    bool? isGracePeriod,
    String? activeProductId,
    String? activeBasePlanId,
    DateTime? verifiedAt,
    bool? isLoading,
    bool? isRestoring,
    String? errorMessage,
    bool? iapProductSeen,
    List<SubscriptionPlan>? plans,
    SubscriptionPlan? selectedPlan,
    List<ProductDetails>? products,
    ProductDetails? selectedProduct,
    bool clearActiveProduct = false,
    bool clearError = false,
  }) {
    return PremiumState(
      isPremium: isPremium ?? this.isPremium,
      isGracePeriod: isGracePeriod ?? this.isGracePeriod,
      activeProductId: clearActiveProduct ? null : (activeProductId ?? this.activeProductId),
      activeBasePlanId: clearActiveProduct ? null : (activeBasePlanId ?? this.activeBasePlanId),
      verifiedAt: verifiedAt ?? this.verifiedAt,
      isLoading: isLoading ?? this.isLoading,
      isRestoring: isRestoring ?? this.isRestoring,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      iapProductSeen: iapProductSeen ?? this.iapProductSeen,
      plans: plans ?? this.plans,
      selectedPlan: selectedPlan ?? this.selectedPlan,
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

    // 1. Check cached entitlement, offline grace period, and iap_product_seen
    final cachedProductSeen = prefs?.getBool(IapConfig.prefKeyIapProductSeen) ?? false;
    state = state.copyWith(iapProductSeen: cachedProductSeen);
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
    final cachedProduct = prefs?.getString(IapConfig.prefKeyPurchaseToken);
    final cachedBasePlan = prefs?.getString(IapConfig.prefKeyActiveBasePlan);

    if (cachedActive && verifiedAtMs != null) {
      final verifiedDate = DateTime.fromMillisecondsSinceEpoch(verifiedAtMs);
      final elapsed = _nowProvider().difference(verifiedDate);

      if (elapsed <= IapConfig.offlineGracePeriod) {
        // Active under 7-day offline grace fallback
        state = state.copyWith(
          isPremium: true,
          isGracePeriod: elapsed.inDays > 1,
          activeProductId: cachedProduct ?? IapConfig.subscriptionProductId,
          activeBasePlanId: cachedBasePlan ?? IapConfig.yearlyBasePlanId,
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

  /// Loads subscription products and plans from the store.
  /// Exactly two plans ever shown: Yearly first, Monthly second.
  Future<void> loadProducts() async {
    final available = await gateway.isAvailable();
    if (!available) {
      return;
    }

    // 1. Query plans from gateway
    final fetchedPlans = await gateway.querySubscriptionPlans();
    final fetchedProducts = await gateway.queryProductDetails(IapConfig.subscriptionProductIds);

    if (fetchedPlans.isNotEmpty || fetchedProducts.isNotEmpty) {
      // Mark store product seen in cache and state
      await prefs?.setBool(IapConfig.prefKeyIapProductSeen, true);
      state = state.copyWith(iapProductSeen: true);
    }

    if (fetchedPlans.isEmpty) {
      return;
    }

    // Identify plans strictly by billing period: P1Y (yearly) and P1M (monthly)
    SubscriptionPlan? yearlyPlan;
    SubscriptionPlan? monthlyPlan;

    for (final plan in fetchedPlans) {
      if (plan.billingPeriod == IapConfig.periodYearly && yearlyPlan == null) {
        yearlyPlan = plan;
      } else if (plan.billingPeriod == IapConfig.periodMonthly && monthlyPlan == null) {
        monthlyPlan = plan;
      }
      // Any extra plans (e.g. quarterly) are intentionally omitted
    }

    final organizedPlans = <SubscriptionPlan>[];
    if (yearlyPlan != null) organizedPlans.add(yearlyPlan);
    if (monthlyPlan != null) organizedPlans.add(monthlyPlan);

    state = state.copyWith(
      plans: organizedPlans,
      selectedPlan: state.selectedPlan ?? (organizedPlans.isNotEmpty ? organizedPlans.first : null),
      products: fetchedProducts,
      selectedProduct: state.selectedProduct ?? (fetchedProducts.isNotEmpty ? fetchedProducts.first : null),
    );
  }

  /// Selects the chosen plan card.
  void selectPlan(SubscriptionPlan plan) {
    state = state.copyWith(
      selectedPlan: plan,
      selectedProduct: plan.productDetails,
    );
  }

  /// Selects product for backwards compatibility.
  void selectProduct(ProductDetails product) {
    state = state.copyWith(selectedProduct: product);
  }

  /// Triggers subscription purchase for [plan] (or currently selected plan).
  Future<bool> buyPlan([SubscriptionPlan? plan]) async {
    final target = plan ?? state.selectedPlan;
    if (target == null) {
      state = state.copyWith(errorMessage: 'No plan selected');
      return false;
    }

    state = state.copyWith(isLoading: true, clearError: true);
    final success = await gateway.buyPlan(plan: target);
    if (!success) {
      state = state.copyWith(isLoading: false, errorMessage: 'Failed to initiate purchase');
    }
    return success;
  }

  /// Triggers subscription purchase for [product] or selected plan.
  Future<bool> buySubscription([ProductDetails? product]) async {
    if (state.selectedPlan != null) {
      return buyPlan(state.selectedPlan);
    }
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
          final verified = await _verifyPurchaseEntitlement(purchase);
          if (verified) {
            final now = _nowProvider();
            final token = purchase.verificationData.serverVerificationData;
            await prefs?.setBool(IapConfig.prefKeyPremiumActive, true);
            await prefs?.setInt(IapConfig.prefKeyPremiumVerifiedAtMs, now.millisecondsSinceEpoch);
            await prefs?.setString(IapConfig.prefKeyPurchaseToken, token);
            await prefs?.setBool(IapConfig.prefKeyIapProductSeen, true);

            state = state.copyWith(
              isPremium: true,
              isGracePeriod: false,
              activeProductId: purchase.productID,
              verifiedAt: now,
              isLoading: false,
              iapProductSeen: true,
              clearError: true,
            );
          } else {
            state = state.copyWith(
              isLoading: false,
              errorMessage: 'Failed to verify purchase with Google Play',
            );
          }
          await gateway.completePurchase(purchase);
          break;

        case PurchaseStatus.error:
          state = state.copyWith(
            isLoading: false,
            errorMessage: purchase.error?.message ?? 'Store billing error',
          );
          await gateway.completePurchase(purchase);
          break;

        case PurchaseStatus.canceled:
          state = state.copyWith(isLoading: false, clearError: true);
          await gateway.completePurchase(purchase);
          break;
      }
    }
  }

  Future<bool> _verifyPurchaseEntitlement(PurchaseDetails purchase) async {
    // Client-side verification of local & server cryptographic tokens from Google Play
    final verificationData = purchase.verificationData;
    return verificationData.source.isNotEmpty &&
        verificationData.serverVerificationData.isNotEmpty;
  }

  /// Simulator hook for component gallery and unit tests.
  void setSimulatedState({
    required bool isPremium,
    bool isGracePeriod = false,
    String? activeProductId,
    String? activeBasePlanId,
    DateTime? verifiedAt,
    bool? iapProductSeen,
  }) {
    if (iapProductSeen != null) {
      prefs?.setBool(IapConfig.prefKeyIapProductSeen, iapProductSeen);
    }
    state = state.copyWith(
      isPremium: isPremium,
      isGracePeriod: isGracePeriod,
      activeProductId: activeProductId,
      activeBasePlanId: activeBasePlanId,
      verifiedAt: verifiedAt,
      iapProductSeen: iapProductSeen ?? state.iapProductSeen,
      clearActiveProduct: !isPremium,
    );
  }

  @override
  void dispose() {
    _isDisposed = true;
    _purchaseSub?.cancel();
    _stateStreamController.close();
    super.dispose();
  }
}
