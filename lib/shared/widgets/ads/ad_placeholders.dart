import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../core/constants/ad_config.dart';
import '../../../core/extensions/l10n_extension.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/doc_view_colors.dart';
import '../../../core/theme/doc_view_tokens.dart';
import '../../../core/theme/doc_view_typography.dart';
import '../../../data/services/ads/ad_service.dart';

export '../../../core/constants/ad_config.dart';

/// Data model representing ad content for placeholder rendering and testing.
@immutable
class AdPlaceholderModel {
  final String title;
  final String description;
  final String ctaLabel;
  final IconData icon;
  final double rating;

  const AdPlaceholderModel({
    this.title = 'CloudDrive Pro',
    this.description = 'Secure backup & sync for all your documents',
    this.ctaLabel = 'Install',
    this.icon = Icons.cloud_outlined,
    this.rating = 4.8,
  });
}

/// Docked 60pt adaptive banner slot.
/// Automatically collapses to 0 height with smooth animation when empty, failed, or premium.
class AdBannerSlot extends StatefulWidget {
  final bool isLoaded;
  final AdPlaceholderModel ad;
  final VoidCallback? onTap;
  final bool? adsAllowed;

  const AdBannerSlot({
    super.key,
    this.isLoaded = true,
    this.ad = const AdPlaceholderModel(),
    this.onTap,
    this.adsAllowed,
  });

  @override
  State<AdBannerSlot> createState() => _AdBannerSlotState();
}

class _AdBannerSlotState extends State<AdBannerSlot> {
  BannerAd? _bannerAd;
  bool _realAdLoaded = false;
  bool _adFailed = false;
  Orientation? _lastOrientation;
  double? _lastWidth;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final orientation = MediaQuery.of(context).orientation;
    final width = MediaQuery.of(context).size.width;
    if (_lastOrientation != orientation || _lastWidth != width) {
      _lastOrientation = orientation;
      _lastWidth = width;
      _loadRealBanner();
    }
  }

  Future<void> _loadRealBanner() async {
    if (widget.adsAllowed == false || !AdConfig.isAdEnabled(AdType.banner) || !AdConfig.enablePlatformChannelRequests) {
      return;
    }

    _bannerAd?.dispose();
    _bannerAd = null;

    final width = MediaQuery.of(context).size.width.truncate();
    final adSize = await AdSize.getLargeAnchoredAdaptiveBannerAdSize(width) ?? AdSize.banner;
    final adUnitId = AdConfig.getAdUnitId(AdType.banner);

    if (!mounted) return;

    try {
      _bannerAd = BannerAd(
        adUnitId: adUnitId,
        size: adSize,
        request: const AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            if (mounted) {
              setState(() {
                _realAdLoaded = true;
                _adFailed = false;
              });
            }
          },
          onAdFailedToLoad: (ad, error) {
            ad.dispose();
            if (mounted) {
              setState(() {
                _realAdLoaded = false;
                _adFailed = true;
                _bannerAd = null;
              });
            }
          },
        ),
      )..load();
    } catch (_) {
      // In headless test environments without platform channels
    }
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _bannerAd = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.adsAllowed == false) {
      return const SizedBox.shrink();
    }

    final isRelease = AdConfig.forceReleaseModeForTesting ?? kReleaseMode;
    // In release mode with empty ad ID, collapse cleanly to 0
    if (isRelease && !AdConfig.isAdEnabled(AdType.banner)) {
      return const SizedBox.shrink();
    }

    if (!AdConfig.showPlaceholders && !_realAdLoaded) {
      return const SizedBox.shrink();
    }

    // If real banner ad has loaded successfully
    if (_realAdLoaded && _bannerAd != null) {
      final tokens = context.tokens;
      final bannerHeight = _bannerAd!.size.height.toDouble().clamp(50.0, 64.0);
      return Container(
        height: bannerHeight,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: tokens.surfaceAlt,
          border: Border(
            top: BorderSide(color: tokens.hairline, width: 1),
          ),
        ),
        child: AdWidget(ad: _bannerAd!),
      );
    }

    // If real ad failed to load, collapse with 0 height
    if (_adFailed) {
      return const SizedBox.shrink();
    }

    // If placeholders enabled (debug mode / tests)
    if (AdConfig.showPlaceholders) {
      final tokens = context.tokens;
      final showPlaceholder = widget.isLoaded && !_adFailed;

      return AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        height: showPlaceholder ? 60 : 0,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: tokens.surfaceAlt,
          border: showPlaceholder
              ? Border(
                  top: BorderSide(color: tokens.hairline, width: 1),
                )
              : null,
        ),
        child: showPlaceholder
            ? OverflowBox(
                minHeight: 0,
                maxHeight: 60,
                alignment: Alignment.topCenter,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: widget.onTap,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          // "AD" badge
                          Semantics(
                            label: context.l10n.semanticAdvertisement,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: tokens.hairline,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'AD',
                                style: DocViewTypography.captionXs.copyWith(
                                  color: tokens.textSecondary,
                                  fontSize: 9,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Advertiser icon
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: tokens.surface,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: tokens.hairline, width: 1),
                            ),
                            child: Icon(widget.ad.icon, size: 20, color: tokens.primaryBlue),
                          ),
                          const SizedBox(width: 12),
                          // Advertiser title & copy
                          Expanded(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    widget.ad.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: DocViewTypography.labelMd.copyWith(
                                      color: tokens.textPrimary,
                                    ),
                                  ),
                                  Text(
                                    widget.ad.description,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: DocViewTypography.bodySm.copyWith(
                                      color: tokens.textSecondary,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Mini CTA
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: tokens.primaryBlue,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              widget.ad.ctaLabel,
                              style: DocViewTypography.labelXs.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : const SizedBox.shrink(),
      );
    }

    return const SizedBox.shrink();
  }
}

/// In-feed 68pt native ad row matching [FileRow] geometry.
class NativeAdRow extends StatefulWidget {
  final bool isLoaded;
  final AdPlaceholderModel ad;
  final VoidCallback? onTap;
  final bool? adsAllowed;

  const NativeAdRow({
    super.key,
    this.isLoaded = true,
    this.ad = const AdPlaceholderModel(),
    this.onTap,
    this.adsAllowed,
  });

  @override
  State<NativeAdRow> createState() => _NativeAdRowState();
}

class _NativeAdRowState extends State<NativeAdRow> {
  NativeAd? _nativeAd;
  bool _realAdLoaded = false;
  bool _adFailed = false;

  @override
  void initState() {
    super.initState();
    _loadRealNativeAd();
  }

  void _loadRealNativeAd() {
    if (widget.adsAllowed == false || !AdConfig.isAdEnabled(AdType.native) || !AdConfig.enablePlatformChannelRequests) {
      return;
    }

    final adUnitId = AdConfig.getAdUnitId(AdType.native);

    try {
      _nativeAd = NativeAd(
        adUnitId: adUnitId,
        request: const AdRequest(),
        listener: NativeAdListener(
          onAdLoaded: (ad) {
            if (mounted) {
              setState(() {
                _realAdLoaded = true;
                _adFailed = false;
              });
            }
          },
          onAdFailedToLoad: (ad, error) {
            ad.dispose();
            if (mounted) {
              setState(() {
                _realAdLoaded = false;
                _adFailed = true;
                _nativeAd = null;
              });
            }
          },
        ),
        nativeTemplateStyle: NativeTemplateStyle(
          templateType: TemplateType.small,
          mainBackgroundColor: Colors.transparent,
          cornerRadius: 16.0,
        ),
      )..load();
    } catch (_) {
      // In headless test environments
    }
  }

  @override
  void dispose() {
    _nativeAd?.dispose();
    _nativeAd = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.adsAllowed == false) return const SizedBox.shrink();

    final isRelease = AdConfig.forceReleaseModeForTesting ?? kReleaseMode;
    if (isRelease && !AdConfig.isAdEnabled(AdType.native)) {
      return const SizedBox.shrink();
    }

    if (!AdConfig.showPlaceholders && !_realAdLoaded) {
      return const SizedBox.shrink();
    }

    if (_realAdLoaded && _nativeAd != null) {
      final tokens = context.tokens;
      return Container(
        height: 68,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: tokens.surfaceAlt,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: tokens.hairline, width: 1),
        ),
        clipBehavior: Clip.antiAlias,
        child: AdWidget(ad: _nativeAd!),
      );
    }

    if (_adFailed || !widget.isLoaded) return const SizedBox.shrink();

    if (AdConfig.showPlaceholders) {
      final tokens = context.tokens;

      return Container(
        constraints: const BoxConstraints(minHeight: 68),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: tokens.surfaceAlt,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: tokens.hairline, width: 1),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(16),
            child: Row(
              children: [
                // Ad Icon 48x48
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: tokens.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: tokens.hairline, width: 1),
                  ),
                  child: Icon(widget.ad.icon, size: 26, color: tokens.primaryBlue),
                ),
                const SizedBox(width: 12),
                // Body
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Semantics(
                            label: context.l10n.semanticAdvertisement,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 1,
                              ),
                              margin: const EdgeInsets.only(right: 6),
                              decoration: BoxDecoration(
                                color: tokens.hairline,
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child: Text(
                                'AD',
                                style: DocViewTypography.captionXs.copyWith(
                                  color: tokens.textSecondary,
                                  fontSize: 9,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              widget.ad.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: DocViewTypography.titleMd.copyWith(
                                fontSize: 14,
                                color: tokens.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.ad.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: DocViewTypography.bodySm.copyWith(
                          color: tokens.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Install button
                Container(
                  height: 36,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: tokens.primaryBlue,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Text(
                    widget.ad.ctaLabel,
                    style: DocViewTypography.labelXs.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}

/// Native ad card for grid or promotional placements.
class NativeAdCard extends StatelessWidget {
  final AdPlaceholderModel ad;
  final VoidCallback? onTap;

  const NativeAdCard({
    super.key,
    this.ad = const AdPlaceholderModel(),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (!AdConfig.showPlaceholders) {
      return const SizedBox.shrink();
    }

    final tokens = context.tokens;

    return Container(
      decoration: BoxDecoration(
        color: tokens.surfaceAlt,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: tokens.hairline, width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(
                        color: tokens.hairline,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'AD',
                        style: DocViewTypography.captionXs.copyWith(
                          color: tokens.textSecondary,
                          fontSize: 9,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Icon(AppIcons.star, size: 14, color: DocViewColors.warning),
                    const SizedBox(width: 4),
                    Text(
                      '${ad.rating}',
                      style: DocViewTypography.labelXs.copyWith(
                        color: tokens.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Center(
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: tokens.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: tokens.hairline, width: 1),
                    ),
                    child: Icon(ad.icon, size: 36, color: tokens.primaryBlue),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  ad.title,
                  style: DocViewTypography.titleMd.copyWith(color: tokens.textPrimary),
                ),
                const SizedBox(height: 4),
                Text(
                  ad.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: DocViewTypography.bodySm.copyWith(color: tokens.textSecondary),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton(
                    onPressed: onTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: tokens.primaryBlue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(ad.ctaLabel, style: DocViewTypography.labelMd),
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

/// Fullscreen Interstitial ad placeholder with a 5-second countdown timer ring
/// before allowing dismissal.
class InterstitialPlaceholder extends StatefulWidget {
  final VoidCallback onDismiss;
  final AdPlaceholderModel ad;

  const InterstitialPlaceholder({
    super.key,
    required this.onDismiss,
    this.ad = const AdPlaceholderModel(),
  });

  /// Presents the fullscreen Interstitial ad if allowed and eligible.
  /// Enforces: at most once per 3 minutes, at most 3 per day, never for premium users.
  static Future<void> show(BuildContext context, {dynamic ref}) async {
    if (ref != null) {
      try {
        final adService = ref.read(adServiceProvider);
        final eligible = await adService.canShowInterstitial();
        if (eligible) {
          final completer = Completer<void>();
          await adService.showInterstitialIfEligible(
            onDismiss: () {
              if (!completer.isCompleted) completer.complete();
            },
          );
          return completer.future;
        }
      } catch (_) {}
    }

    if (!AdConfig.showPlaceholders || !context.mounted) return Future.value();
    return Navigator.of(context).push<void>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (dialogContext) => InterstitialPlaceholder(
          onDismiss: () => Navigator.of(dialogContext).pop(),
        ),
      ),
    );
  }

  @override
  State<InterstitialPlaceholder> createState() => _InterstitialPlaceholderState();
}

class _InterstitialPlaceholderState extends State<InterstitialPlaceholder> {
  int _secondsRemaining = 5;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_secondsRemaining > 0) {
            _secondsRemaining--;
          } else {
            _timer?.cancel();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!AdConfig.showPlaceholders) {
      WidgetsBinding.instance.addPostFrameCallback((_) => widget.onDismiss());
      return const SizedBox.shrink();
    }

    final tokens = context.tokens;
    final canClose = _secondsRemaining <= 0;

    return Scaffold(
      backgroundColor: tokens.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Top bar with countdown / close button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: tokens.hairline,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      context.l10n.adAdvertisementBadge,
                      style: DocViewTypography.captionXs.copyWith(
                        color: tokens.textSecondary,
                      ),
                    ),
                  ),
                  if (canClose)
                    IconButton(
                      tooltip: context.l10n.tooltipCloseAd,
                      icon: const Icon(AppIcons.close),
                      onPressed: widget.onDismiss,
                      color: tokens.textPrimary,
                    )
                  else
                    SizedBox(
                      width: 32,
                      height: 32,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircularProgressIndicator(
                            value: (5 - _secondsRemaining) / 5,
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(tokens.primaryBlue),
                            backgroundColor: tokens.hairline,
                          ),
                          Text(
                            '$_secondsRemaining',
                            style: DocViewTypography.captionXs.copyWith(
                              color: tokens.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const Spacer(),
              // Creative container
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: tokens.surfaceAlt,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: tokens.hairline, width: 1.5),
                ),
                child: Icon(widget.ad.icon, size: 52, color: tokens.primaryBlue),
              ),
              const SizedBox(height: 24),
              Text(
                widget.ad.title,
                textAlign: TextAlign.center,
                style: DocViewTypography.headlineLg.copyWith(color: tokens.textPrimary),
              ),
              const SizedBox(height: 12),
              Text(
                widget.ad.description,
                textAlign: TextAlign.center,
                style: DocViewTypography.bodyLg.copyWith(color: tokens.textSecondary),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: widget.onDismiss,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: tokens.primaryBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    widget.ad.ctaLabel,
                    style: DocViewTypography.labelLg,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
