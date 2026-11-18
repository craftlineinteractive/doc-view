import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/extensions/l10n_extension.dart';
import '../../../core/theme/doc_view_tokens.dart';
import '../../../core/theme/doc_view_typography.dart';
import '../../../shared/widgets/buttons/doc_buttons.dart';
import '../../../shared/widgets/settings/star_rating_bar.dart';
import '../../../shared/widgets/sheets/doc_bottom_sheet.dart';

/// Compliant, non-gating Rate us bottom sheet built on [DocBottomSheet].
///
/// After selecting ANY star value (1–5), displays a short localized message
/// and ALWAYS presents the same two equal-weight actions in the same order:
/// 1. "Rate on Google Play" (hidden only when storeRateUrl is empty)
/// 2. "Help & feedback" (opens FAQ with `fromRating: true`)
/// Plus a "Not now" dismissal button. Never auto-opens the store or gates routes.
class RateUsSheet extends StatefulWidget {
  const RateUsSheet({
    super.key,
    this.storeRateUrlOverride,
    this.onOpenStore,
    this.onHelpFeedback,
  });

  /// Debug/test override for [AppConstants.storeRateUrl]. Ignored in release.
  final String? storeRateUrlOverride;

  /// Optional test hook invoked when "Rate on Google Play" is tapped.
  final Future<void> Function(Uri uri)? onOpenStore;

  /// Optional callback invoked when "Help & feedback" is tapped.
  final VoidCallback? onHelpFeedback;

  static Future<void> show(
    BuildContext context, {
    String? storeRateUrlOverride,
    Future<void> Function(Uri uri)? onOpenStore,
    VoidCallback? onHelpFeedback,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => RateUsSheet(
        storeRateUrlOverride: storeRateUrlOverride,
        onOpenStore: onOpenStore,
        onHelpFeedback: onHelpFeedback ??
            () {
              Navigator.of(sheetContext).pop();
              if (context.mounted) {
                context.push('/faq', extra: const {'fromRating': true});
              }
            },
      ),
    );
  }

  @override
  State<RateUsSheet> createState() => _RateUsSheetState();
}

class _RateUsSheetState extends State<RateUsSheet> {
  int _selectedRating = 0;

  String get _effectiveStoreUrl {
    if (!kReleaseMode && widget.storeRateUrlOverride != null) {
      return widget.storeRateUrlOverride!;
    }
    return AppConstants.storeRateUrl;
  }

  String _messageForRating(BuildContext context, int rating) {
    if (rating >= 4) return context.l10n.rateResponseHigh;
    if (rating == 3) return context.l10n.rateResponseMedium;
    return context.l10n.rateResponseLow;
  }

  Future<void> _handleRateOnStore() async {
    final rawUrl = _effectiveStoreUrl;
    if (rawUrl.isEmpty) return;
    final uri = Uri.tryParse(rawUrl);
    if (uri == null) return;

    if (widget.onOpenStore != null) {
      await widget.onOpenStore!(uri);
      return;
    }

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {}
  }

  void _handleHelpFeedback() {
    if (widget.onHelpFeedback != null) {
      widget.onHelpFeedback!();
      return;
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final hasStoreUrl = _effectiveStoreUrl.isNotEmpty;

    return DocBottomSheet(
      title: context.l10n.rateSheetTitle,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              context.l10n.rateSheetSubtitle,
              style: DocViewTypography.bodyMd.copyWith(
                color: tokens.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: StarRatingBar(
                  rating: _selectedRating,
                  onRatingSelected: (value) {
                    setState(() {
                      _selectedRating = value;
                    });
                  },
                ),
              ),
            ),
            if (_selectedRating > 0) ...[
              const SizedBox(height: 16),
              Text(
                _messageForRating(context, _selectedRating),
                key: const Key('rate_feedback_message'),
                textAlign: TextAlign.center,
                style: DocViewTypography.titleMd.copyWith(
                  color: tokens.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              if (hasStoreUrl) ...[
                DocTonalButton(
                  key: const Key('btn_rate_store'),
                  label: context.l10n.rateActionStore,
                  icon: Icon(
                    Icons.open_in_new_rounded,
                    size: 18,
                    color: tokens.textPrimary,
                  ),
                  height: 52,
                  onPressed: _handleRateOnStore,
                ),
                const SizedBox(height: 10),
              ],
              DocTonalButton(
                key: const Key('btn_rate_help_feedback'),
                label: context.l10n.rateActionHelpFeedback,
                icon: Icon(
                  Icons.help_outline_rounded,
                  size: 18,
                  color: tokens.textPrimary,
                ),
                height: 52,
                onPressed: _handleHelpFeedback,
              ),
            ],
            const SizedBox(height: 8),
            Center(
              child: TextButton(
                key: const Key('btn_rate_not_now'),
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  context.l10n.actionNotNow,
                  style: DocViewTypography.labelLg.copyWith(
                    color: tokens.textSecondary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
