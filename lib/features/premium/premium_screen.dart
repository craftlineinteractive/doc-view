import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/config/iap_config.dart';
import '../../core/constants/app_constants.dart';
import '../../core/extensions/l10n_extension.dart';
import '../../core/theme/app_icons.dart';
import '../../core/theme/doc_view_colors.dart';
import '../../core/theme/doc_view_tokens.dart';
import '../../core/theme/doc_view_typography.dart';
import '../../data/services/billing/billing_providers.dart';
import '../../data/services/billing/premium_controller.dart';
import '../../data/services/billing/subscription_plan.dart';
import '../../shared/widgets/buttons/doc_icon_button.dart';

/// Screen presenting Doc View Premium subscription plans, benefits, and purchase flows.
class PremiumScreen extends ConsumerStatefulWidget {
  const PremiumScreen({super.key});

  @override
  ConsumerState<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends ConsumerState<PremiumScreen>
    with SingleTickerProviderStateMixin {
  static bool _introPlayedThisSession = false;

  late final AnimationController _animController;
  late final Animation<double> _crownScale;
  late final Animation<double> _crownGlow;
  late final Animation<double> _titleFade;
  late final Animation<Offset> _benefitsSlide;
  late final Animation<double> _benefitsFade;
  late final Animation<Offset> _plansSlide;
  late final Animation<double> _plansFade;

  String _selectedPeriod = IapConfig.periodYearly;
  Timer? _retryTimer;
  bool _timedOut = false;

  void _startRetryTimer() {
    _retryTimer?.cancel();
    _retryTimer = Timer(const Duration(seconds: 8), () {
      if (mounted) {
        final ctrl = ref.read(premiumControllerProvider);
        if (ctrl.state.plans.isEmpty) {
          setState(() {
            _timedOut = true;
          });
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _startRetryTimer();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    _crownScale = Tween<double>(begin: 0.2, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.0, 0.35, curve: Curves.easeOutBack),
      ),
    );

    _crownGlow = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.15, 0.50, curve: Curves.easeInOut),
      ),
    );

    _titleFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.25, 0.55, curve: Curves.easeIn),
      ),
    );

    _benefitsSlide = Tween<Offset>(
      begin: const Offset(0.0, 0.15),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.40, 0.75, curve: Curves.easeOutCubic),
      ),
    );

    _benefitsFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.40, 0.75, curve: Curves.easeIn),
      ),
    );

    _plansSlide = Tween<Offset>(
      begin: const Offset(0.0, 0.20),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.65, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _plansFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.65, 1.0, curve: Curves.easeIn),
      ),
    );

    if (kDebugMode) {
      try {
        final actionFile = File('/data/user/0/com.craftlineinteractive.docview/files/debug_action.txt');
        if (actionFile.existsSync()) {
          final content = actionFile.readAsStringSync().trim();
          if (content == 'show_premium_subscribed') {
            actionFile.deleteSync();
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ref.read(premiumControllerProvider).setSimulatedState(
                isPremium: true,
                isGracePeriod: false,
                activeProductId: IapConfig.subscriptionProductId,
                activeBasePlanId: IapConfig.yearlyBasePlanId,
                verifiedAt: DateTime.now(),
                iapProductSeen: true,
              );
            });
          }
        }
      } catch (_) {}
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (_introPlayedThisSession || (MediaQuery.maybeDisableAnimationsOf(context) ?? false)) {
        _animController.value = 1.0;
      } else {
        _introPlayedThisSession = true;
        _animController.forward();
      }
    });
  }

  @override
  void dispose() {
    _retryTimer?.cancel();
    _animController.dispose();
    super.dispose();
  }

  Future<void> _handleSubscribe(
    PremiumController controller,
    SubscriptionPlan? selectedPlan,
  ) async {
    if (selectedPlan == null) return;
    try {
      final success = await controller.buyPlan(selectedPlan);
      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.premiumActiveStatus),
            backgroundColor: DocViewColors.success,
          ),
        );
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.premiumErrorGeneral),
          backgroundColor: DocViewColors.error,
        ),
      );
    }
  }

  Future<void> _handleRestore(PremiumController controller) async {
    try {
      await controller.restorePurchases();
      if (!mounted) return;

      final state = controller.state;
      if (state.isPremium) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.premiumRestoreSuccess),
            backgroundColor: DocViewColors.success,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.premiumRestoreNone),
          ),
        );
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.premiumErrorGeneral),
          backgroundColor: DocViewColors.error,
        ),
      );
    }
  }

  Future<void> _openUrl(String url) async {
    if (url.isEmpty) return;
    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = context.l10n;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final controller = ref.watch(premiumControllerProvider);
    final asyncState = ref.watch(premiumStateStreamProvider);
    final premiumState = asyncState.asData?.value ?? controller.state;
    final isAlreadyPremium = premiumState.isPremium && !premiumState.isGracePeriod;
    final isGracePeriod = premiumState.isGracePeriod;
    final isProductSeen = premiumState.iapProductSeen;

    SubscriptionPlan? yearlyPlan;
    SubscriptionPlan? monthlyPlan;

    for (final plan in premiumState.plans) {
      if (plan.isYearly && yearlyPlan == null) {
        yearlyPlan = plan;
      } else if (plan.isMonthly && monthlyPlan == null) {
        monthlyPlan = plan;
      }
    }

    final selectedPlan = _selectedPeriod == IapConfig.periodYearly ? yearlyPlan : monthlyPlan;
    final yearlyPrice = yearlyPlan?.formattedPrice ?? '...';
    final monthlyPrice = monthlyPlan?.formattedPrice ?? '...';

    // Calculate dynamic savings percentage: ((12 * monthly - yearly) / (12 * monthly) * 100)
    int? savingsPercent;
    if (yearlyPlan != null && monthlyPlan != null) {
      if (yearlyPlan.rawPrice > 0 && monthlyPlan.rawPrice > 0) {
        final annualMonthlyCost = 12 * monthlyPlan.rawPrice;
        final diff = annualMonthlyCost - yearlyPlan.rawPrice;
        final pct = ((diff / annualMonthlyCost) * 100).round();
        if (pct >= 1) {
          savingsPercent = pct;
        }
      }
    }

    final String? savingsBadgeText = (yearlyPlan != null && monthlyPlan != null)
        ? (savingsPercent != null ? l10n.premiumSavePercent(savingsPercent) : l10n.premiumSaveUnknown)
        : null;

    final String yearlySubtitle = (yearlyPlan?.hasFreeTrial ?? false) && (yearlyPlan?.trialDays != null && yearlyPlan!.trialDays! > 0)
        ? l10n.premiumPlanYearlyTrial(yearlyPlan.trialDays!, yearlyPrice)
        : l10n.premiumPlanYearlySub(yearlyPrice);

    final String monthlySubtitle = (monthlyPlan?.hasFreeTrial ?? false) && (monthlyPlan?.trialDays != null && monthlyPlan!.trialDays! > 0)
        ? l10n.premiumPlanMonthlyTrial(monthlyPlan.trialDays!, monthlyPrice)
        : l10n.premiumPlanMonthlySub(monthlyPrice);

    final bool hasTrial = selectedPlan != null && selectedPlan.hasFreeTrial && (selectedPlan.trialDays ?? 0) > 0;
    final String ctaLabel = hasTrial
        ? l10n.premiumActionStartTrial(selectedPlan.trialDays!)
        : l10n.premiumActionSubscribe;

    final showTerms = AppConstants.termsOfUseUrl.isNotEmpty;
    final showPrivacy = AppConstants.privacyPolicyUrl.isNotEmpty;

    final canPop = Navigator.of(context).canPop();

    return PopScope(
      canPop: canPop,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          context.go('/home');
        }
      },
      child: GestureDetector(
        onTap: () {
          if (_animController.isAnimating) {
            _animController.forward(from: 1.0);
          }
        },
        behavior: HitTestBehavior.translucent,
        child: Scaffold(
          backgroundColor: isDark ? DocViewColors.backgroundDark : Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,
            leading: DocIconButton(
              icon: AppIcons.close,
              tooltip: l10n.actionClose,
              onPressed: () {
                if (Navigator.of(context).canPop()) {
                  context.pop();
                } else {
                  context.go('/home');
                }
              },
            ),
          actions: [
            TextButton(
              onPressed: premiumState.isLoading || premiumState.isRestoring
                  ? null
                  : () => _handleRestore(controller),
              child: premiumState.isRestoring
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(
                      l10n.premiumActionRestore,
                      style: DocViewTypography.bodySm.copyWith(
                        color: tokens.primaryBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // 1. Animated Gold Crown with Radial Glow
                    AnimatedBuilder(
                      animation: _animController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _crownScale.value,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    colors: [
                                      tokens.premiumGold.withValues(
                                        alpha: 0.28 * _crownGlow.value,
                                      ),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                width: 68,
                                height: 68,
                                decoration: BoxDecoration(
                                  color: tokens.premiumGold,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: tokens.premiumGold.withValues(
                                        alpha: 0.40 * _crownGlow.value,
                                      ),
                                      blurRadius: 16,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                alignment: Alignment.center,
                                child: const Icon(
                                  AppIcons.crown,
                                  color: Colors.white,
                                  size: 36,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),

                    // 2. Headline & Subtitle
                    FadeTransition(
                      opacity: _titleFade,
                      child: Column(
                        children: [
                          Text(
                            l10n.premiumTitle,
                            textAlign: TextAlign.center,
                            style: DocViewTypography.headlineLg.copyWith(
                              fontFamily: 'SpaceGrotesk',
                              fontWeight: FontWeight.w800,
                              fontSize: 26,
                              color: tokens.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l10n.premiumSubtitle,
                            textAlign: TextAlign.center,
                            style: DocViewTypography.bodyMd.copyWith(
                              color: tokens.textSecondary,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Active Subscription Banner if already subscribed
                    if (isAlreadyPremium || isGracePeriod) ...[
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: tokens.premiumGoldSurface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: tokens.premiumGold.withValues(alpha: 0.5),
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.verified_rounded,
                              color: tokens.premiumGoldDark,
                              size: 28,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    isGracePeriod
                                        ? l10n.premiumGraceStatus
                                        : l10n.premiumActiveStatus,
                                    style: DocViewTypography.titleMd.copyWith(
                                      color: tokens.textPrimary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    premiumState.activeBasePlanId == IapConfig.yearlyBasePlanId
                                        ? l10n.premiumPlanYearly
                                        : l10n.premiumPlanMonthly,
                                    style: DocViewTypography.bodySm.copyWith(
                                      color: tokens.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            FilledButton.tonal(
                              onPressed: () => _openUrl(AppConstants.androidSubscriptionsUrl),
                              child: Text(l10n.premiumManageInPlay),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],

                    // 3. Benefits List
                    SlideTransition(
                      position: _benefitsSlide,
                      child: FadeTransition(
                        opacity: _benefitsFade,
                        child: Column(
                          children: [
                            _BenefitRow(
                              icon: Icons.auto_awesome_rounded,
                              iconColor: tokens.primaryBlue,
                              title: l10n.premiumFeatureAllTools,
                              subtitle: l10n.premiumFeatureAllToolsSub,
                            ),
                            const SizedBox(height: 14),
                            _BenefitRow(
                              icon: Icons.block_rounded,
                              iconColor: const Color(0xFF1FA971),
                              title: l10n.premiumFeatureAdFree,
                              subtitle: l10n.premiumFeatureAdFreeSub,
                            ),
                            const SizedBox(height: 14),
                            _BenefitRow(
                              icon: Icons.transform_rounded,
                              iconColor: const Color(0xFFF5A524),
                              title: l10n.premiumFeatureUnlimitedConversions,
                              subtitle: l10n.premiumFeatureUnlimitedConversionsSub,
                            ),
                            const SizedBox(height: 14),
                            _BenefitRow(
                              icon: Icons.shield_outlined,
                              iconColor: const Color(0xFF8B5CF6),
                              title: l10n.premiumFeaturePrivacyFirst,
                              subtitle: l10n.premiumFeaturePrivacyFirstSub,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // 4. Plan Selection Cards, Shimmer Skeleton, or Retry CTA
                    Builder(
                      builder: (context) {
                        if (!isProductSeen) {
                          if (premiumState.isLoading) {
                            return const _PlanCardsSkeleton();
                          }
                          return Container(
                            key: const Key('premium_disabled_state'),
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 24),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? DocViewColors.surfaceDark
                                  : tokens.surfaceAlt,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: tokens.hairline),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.schedule_rounded,
                                  color: tokens.textSecondary,
                                  size: 32,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  l10n.premiumSubscriptionsAvailableSoon,
                                  textAlign: TextAlign.center,
                                  style: DocViewTypography.bodyMd.copyWith(
                                    color: tokens.textSecondary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else if (premiumState.plans.isNotEmpty) {
                          return SlideTransition(
                            position: _plansSlide,
                            child: FadeTransition(
                              opacity: _plansFade,
                              child: Column(
                                children: [
                                  // Exactly Yearly first (preselected)
                                  _PlanCard(
                                    key: const Key('plan_card_yearly'),
                                    title: l10n.premiumPlanYearly,
                                    badgeText: savingsBadgeText,
                                    subtitle: yearlySubtitle,
                                    isSelected: _selectedPeriod == IapConfig.periodYearly,
                                    onTap: () => setState(() {
                                      _selectedPeriod = IapConfig.periodYearly;
                                      if (yearlyPlan != null) {
                                        controller.selectPlan(yearlyPlan);
                                      }
                                    }),
                                  ),
                                  const SizedBox(height: 12),

                                  // Exactly Monthly second
                                  _PlanCard(
                                    key: const Key('plan_card_monthly'),
                                    title: l10n.premiumPlanMonthly,
                                    subtitle: monthlySubtitle,
                                    isSelected: _selectedPeriod == IapConfig.periodMonthly,
                                    onTap: () => setState(() {
                                      _selectedPeriod = IapConfig.periodMonthly;
                                      if (monthlyPlan != null) {
                                        controller.selectPlan(monthlyPlan);
                                      }
                                    }),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else if (_timedOut ||
                            (premiumState.errorMessage != null &&
                                !premiumState.isLoading)) {
                          return Container(
                            key: const Key('premium_retry_state'),
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 24),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? DocViewColors.surfaceDark
                                  : tokens.surfaceAlt,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: tokens.hairline),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.cloud_off_rounded,
                                  color: tokens.textSecondary,
                                  size: 32,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  l10n.premiumLoadPlansFailed,
                                  textAlign: TextAlign.center,
                                  style: DocViewTypography.bodyMd.copyWith(
                                    color: tokens.textSecondary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                FilledButton.tonalIcon(
                                  key: const Key('premium_retry_button'),
                                  onPressed: () {
                                    setState(() {
                                      _timedOut = false;
                                    });
                                    _startRetryTimer();
                                    controller.loadProducts();
                                  },
                                  icon: const Icon(Icons.refresh_rounded,
                                      size: 18),
                                  label: Text(l10n.actionRetry),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return const _PlanCardsSkeleton();
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // 5. Sticky Bottom Action & Disclaimers
            Container(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
              decoration: BoxDecoration(
                color: isDark ? DocViewColors.surfaceDark : Colors.white,
                border: Border(
                  top: BorderSide(
                    color: tokens.hairline,
                    width: 0.5,
                  ),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0A000000),
                    blurRadius: 10,
                    offset: Offset(0, -3),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Primary CTA Button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: Builder(
                      builder: (context) {
                        if (!isProductSeen) {
                          if (premiumState.isLoading) {
                            return FilledButton(
                              key: const Key('premium_cta_button'),
                              onPressed: null,
                              style: FilledButton.styleFrom(
                                backgroundColor:
                                    tokens.primaryBlue.withValues(alpha: 0.6),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          }
                          return FilledButton(
                            key: const Key('premium_cta_button'),
                            onPressed: null,
                            style: FilledButton.styleFrom(
                              backgroundColor: tokens.primaryBlue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: Text(
                              l10n.premiumSubscriptionsAvailableSoon,
                              style: DocViewTypography.headlineSm.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                          );
                        } else if (premiumState.plans.isNotEmpty) {
                          return FilledButton(
                            key: const Key('premium_cta_button'),
                            onPressed: (premiumState.isLoading ||
                                    premiumState.isRestoring)
                                ? null
                                : () => _handleSubscribe(
                                    controller, selectedPlan),
                            style: FilledButton.styleFrom(
                              backgroundColor: tokens.primaryBlue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: premiumState.isLoading
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    ctaLabel,
                                    style: DocViewTypography.headlineSm.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                    ),
                                  ),
                          );
                        } else if (_timedOut ||
                            (premiumState.errorMessage != null &&
                                !premiumState.isLoading)) {
                          return FilledButton(
                            key: const Key('premium_cta_button'),
                            onPressed: () {
                              setState(() {
                                _timedOut = false;
                              });
                              _startRetryTimer();
                              controller.loadProducts();
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: tokens.primaryBlue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: Text(
                              l10n.actionRetry,
                              style: DocViewTypography.headlineSm.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                          );
                        } else {
                          // Clean skeleton/shimmer loading state (never "-" or disabled message)
                          return FilledButton(
                            key: const Key('premium_cta_button'),
                            onPressed: null,
                            style: FilledButton.styleFrom(
                              backgroundColor:
                                  tokens.primaryBlue.withValues(alpha: 0.6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Renewal disclaimer with pricing-unavailable fallback
                  Text(
                    (yearlyPlan == null && monthlyPlan == null)
                        ? l10n.premiumRenewalDisclosurePricingUnavailable
                        : l10n.premiumBillingDisclaimer,
                    textAlign: TextAlign.center,
                    style: DocViewTypography.captionXs.copyWith(
                      color: tokens.textSecondary,
                      fontSize: 11,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Legal Links: Terms & Privacy (HIDDEN when constants are empty)
                  if (showTerms || showPrivacy) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (showTerms)
                          GestureDetector(
                            onTap: () => _openUrl(AppConstants.termsOfUseUrl),
                            child: Text(
                              l10n.premiumTerms,
                              style: DocViewTypography.captionXs.copyWith(
                                color: tokens.primaryBlue,
                                decoration: TextDecoration.underline,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        if (showTerms && showPrivacy)
                          Text(
                            ' • ',
                            style: DocViewTypography.captionXs.copyWith(
                              color: tokens.textSecondary,
                            ),
                          ),
                        if (showPrivacy)
                          GestureDetector(
                            onTap: () => _openUrl(AppConstants.privacyPolicyUrl),
                            child: Text(
                              l10n.premiumPrivacy,
                              style: DocViewTypography.captionXs.copyWith(
                                color: tokens.primaryBlue,
                                decoration: TextDecoration.underline,
                                fontSize: 11,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }
}

class _BenefitRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;

  const _BenefitRow({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: DocViewTypography.bodyMd.copyWith(
                  fontWeight: FontWeight.w700,
                  color: tokens.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: DocViewTypography.bodySm.copyWith(
                  color: tokens.textSecondary,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PlanCard extends StatelessWidget {
  final String title;
  final String? badgeText;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _PlanCard({
    super.key,
    required this.title,
    this.badgeText,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Semantics(
      button: true,
      selected: isSelected,
      label: '$title, $subtitle',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            constraints: const BoxConstraints(minHeight: 68),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: isSelected
                  ? tokens.primaryBlue.withValues(alpha: isDark ? 0.15 : 0.06)
                  : (isDark ? DocViewColors.surfaceDark : tokens.surfaceAlt),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? tokens.primaryBlue : tokens.hairline,
                width: isSelected ? 2.0 : 1.0,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  isSelected
                      ? Icons.radio_button_checked_rounded
                      : Icons.radio_button_unchecked_rounded,
                  color: isSelected ? tokens.primaryBlue : tokens.textSecondary,
                  size: 22,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              title,
                              style: DocViewTypography.titleMd.copyWith(
                                fontWeight: FontWeight.w700,
                                color: tokens.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (badgeText != null) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: tokens.premiumGold,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                badgeText!,
                                style: DocViewTypography.captionXs.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        subtitle,
                        style: DocViewTypography.bodySm.copyWith(
                          color: tokens.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PlanCardsSkeleton extends StatelessWidget {
  const _PlanCardsSkeleton();

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? DocViewColors.surfaceDark : tokens.surfaceAlt;
    final barBg = isDark ? const Color(0xFF2E3545) : const Color(0xFFE2E6EE);

    return Column(
      key: const Key('premium_plans_skeleton'),
      children: [
        // Skeleton Card 1 (Yearly)
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: tokens.hairline),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 140,
                    height: 18,
                    decoration: BoxDecoration(
                      color: barBg,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  Container(
                    width: 70,
                    height: 22,
                    decoration: BoxDecoration(
                      color: barBg,
                      borderRadius: BorderRadius.circular(11),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                width: 200,
                height: 14,
                decoration: BoxDecoration(
                  color: barBg.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Skeleton Card 2 (Monthly)
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: tokens.hairline),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 120,
                height: 18,
                decoration: BoxDecoration(
                  color: barBg,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: 160,
                height: 14,
                decoration: BoxDecoration(
                  color: barBg.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
