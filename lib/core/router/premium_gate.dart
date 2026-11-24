import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/services/billing/billing_providers.dart';
import '../config/feature_flags.dart';
import '../extensions/l10n_extension.dart';

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

  /// Returns true if the user has access to [feature].
  /// When `premiumEnabled` is false, everything is accessible.
  static bool isUnlocked(WidgetRef ref, PremiumFeature feature) {
    if (!premiumEnabled) return true;
    return ref.read(isPremiumProvider);
  }

  /// Checks if [feature] is unlocked for the user.
  /// If locked, navigates to `/premium` and returns false.
  /// If unlocked, returns true.
  static bool check(BuildContext context, WidgetRef ref, PremiumFeature feature) {
    if (isUnlocked(ref, feature)) return true;
    context.push('/premium');
    return false;
  }

  /// Shows the Premium confirmation dialog for PagesScreen operations.
  /// Returns true if the user is already premium, false otherwise (prompting upgrade).
  static Future<bool> checkPagesEdit(BuildContext context, WidgetRef ref) async {
    if (isUnlocked(ref, PremiumFeature.managePages)) return true;

    final l10n = context.l10n;
    final upgrade = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.premiumPagesGateTitle),
          content: Text(l10n.premiumPagesGateBody),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(l10n.actionCancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(l10n.premiumPagesGateUpgrade),
            ),
          ],
        );
      },
    );

    if (upgrade == true && context.mounted) {
      context.push('/premium');
    }
    return false;
  }
}
