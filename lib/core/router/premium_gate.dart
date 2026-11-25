import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/services/billing/billing_providers.dart';

/// Features gated by Doc View Premium.
enum PremiumFeature {
  annotate,
  addText,
  sign,
  managePages,
  pdfToWord,
}

/// Centralized gatekeeper checking if a feature requires Doc View Premium.
class PremiumGate {
  const PremiumGate._();

  /// Returns true if [feature] is unlocked for the user.
  ///
  /// LOCK SAFEGUARD:
  /// Locks are active ONLY when `locksActiveProvider` is true (i.e. `premiumEnabled`
  /// is true AND `iap_product_seen` has been cached from a store response).
  /// If locks are not active, all features are fully open and accessible.
  static bool isUnlocked(WidgetRef ref, PremiumFeature feature) {
    if (feature != PremiumFeature.annotate && feature != PremiumFeature.sign) {
      return true;
    }
    final locksActive = ref.read(locksActiveProvider);
    if (!locksActive) return true;
    return ref.read(isPremiumProvider);
  }

  /// Returns true if [feature] is locked for the user.
  static bool isLocked(WidgetRef ref, PremiumFeature feature) => !isUnlocked(ref, feature);

  /// Checks if [feature] is unlocked for the user.
  /// If locked, navigates to `/premium` and returns false.
  /// If unlocked, returns true.
  static bool check(BuildContext context, WidgetRef ref, PremiumFeature feature) {
    if (isUnlocked(ref, feature)) return true;
    context.push('/premium');
    return false;
  }
}
