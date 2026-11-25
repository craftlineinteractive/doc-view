import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/config/ad_config.dart';
import '../billing/billing_providers.dart';
import 'consent_gateway.dart';

/// Ad manager coordinating Mobile Ads SDK lifecycle, UMP consent gating,
/// interstitial frequency capping, native ad caching, and immediate disposal on premium.
class AdService {
  final Ref _ref;
  bool _isSdkInitialized = false;

  InterstitialAd? _preloadedInterstitial;
  bool _isPreloadingInterstitial = false;
  final List<NativeAd> _cachedNativeAds = [];

  static const String _keyLastInterstitialTime = 'ad_interstitial_last_time_ms';
  static const String _keyDailyInterstitialDate = 'ad_interstitial_daily_date';
  static const String _keyDailyInterstitialCount = 'ad_interstitial_daily_count';

  /// Minimum interval between interstitial ad impressions (3 minutes).
  static const Duration minInterstitialInterval = Duration(minutes: 3);

  /// Maximum interstitial ads permitted per calendar day.
  static const int maxInterstitialsPerDay = 3;

  /// Maximum native ads kept in memory cache.
  static const int maxCachedNativeAds = 3;

  AdService(this._ref) {
    // Listen to billing state: if user becomes premium, immediately dispose all ads
    _ref.listen<bool>(adsAllowedProvider, (previous, adsAllowed) {
      if (!adsAllowed) {
        disposeAllAds();
      }
    });
  }

  /// Whether the Google Mobile Ads SDK has been initialized.
  bool get isSdkInitialized => _isSdkInitialized;

  /// Initializes the Mobile Ads SDK ONLY if ads are allowed (non-premium)
  /// and Google UMP consent permits ad requests (`canRequestAds == true`).
  Future<void> initializeSdkIfAllowed() async {
    final isPremium = _ref.read(isPremiumProvider);
    if (isPremium) {
      // Owner invariant: Premium users NEVER initialize the Mobile Ads SDK
      return;
    }

    final consentGateway = _ref.read(consentGatewayProvider);
    final canRequestAds = await consentGateway.canRequestAds();
    if (!canRequestAds) {
      return;
    }

    if (_isSdkInitialized) return;
    if (!AdConfig.enablePlatformChannelRequests) return;

    try {
      await MobileAds.instance.initialize();
      _isSdkInitialized = true;

      // Content-rating-safe configuration: maxAdContentRating is set to G.
      // tagForChildDirectedTreatment and age-restricted settings are intentionally NOT set.
      await MobileAds.instance.updateRequestConfiguration(
        RequestConfiguration(
          maxAdContentRating: MaxAdContentRating.g,
        ),
      );
    } catch (_) {
      // Gracefully handle missing play services or offline environments
    }
  }

  /// Verifies whether an interstitial ad satisfies frequency caps:
  /// 1. User is free-tier (!isPremium)
  /// 2. Interstitial ad unit ID is enabled
  /// 3. At least 3 minutes elapsed since last interstitial impression
  /// 4. At most 3 interstitials displayed on the current calendar day
  Future<bool> canShowInterstitial() async {
    final adsAllowed = _ref.read(adsAllowedProvider);
    if (!adsAllowed) return false;

    if (!AdConfig.isAdEnabled(AdType.interstitial)) return false;

    try {
      final prefs = await SharedPreferences.getInstance();
      final now = DateTime.now();

      // Cap 1: 3-minute interval
      final lastTimeMs = prefs.getInt(_keyLastInterstitialTime) ?? 0;
      if (lastTimeMs > 0) {
        final lastTime = DateTime.fromMillisecondsSinceEpoch(lastTimeMs);
        if (now.difference(lastTime) < minInterstitialInterval) {
          return false;
        }
      }

      // Cap 2: 3 per calendar day
      final todayStr = '${now.year}-${now.month}-${now.day}';
      final storedDate = prefs.getString(_keyDailyInterstitialDate) ?? '';
      int currentCount = prefs.getInt(_keyDailyInterstitialCount) ?? 0;

      if (storedDate != todayStr) {
        // Reset counter for new day
        currentCount = 0;
      }

      return currentCount < maxInterstitialsPerDay;
    } catch (_) {
      return false;
    }
  }

  /// Preloads an interstitial ad after a successful tool operation result is produced.
  /// Does NOT preload at app launch or after errors.
  Future<void> preloadInterstitialAfterSuccess() async {
    final allowed = await canShowInterstitial();
    if (!allowed || _isPreloadingInterstitial || _preloadedInterstitial != null) {
      return;
    }

    if (!_isSdkInitialized) {
      await initializeSdkIfAllowed();
      if (!_isSdkInitialized) return;
    }
    if (!AdConfig.enablePlatformChannelRequests) return;

    _isPreloadingInterstitial = true;
    final adUnitId = AdConfig.getAdUnitId(AdType.interstitial);

    try {
      await InterstitialAd.load(
        adUnitId: adUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            _preloadedInterstitial = ad;
            _isPreloadingInterstitial = false;
          },
          onAdFailedToLoad: (error) {
            _preloadedInterstitial = null;
            _isPreloadingInterstitial = false;
          },
        ),
      );
    } catch (_) {
      _isPreloadingInterstitial = false;
    }
  }

  /// Displays the preloaded interstitial ad if available and eligible.
  /// Invokes [onDismiss] immediately if ads are disabled or capped.
  Future<void> showInterstitialIfEligible({
    required VoidCallback onDismiss,
  }) async {
    final eligible = await canShowInterstitial();
    final ad = _preloadedInterstitial;

    if (!eligible || ad == null) {
      onDismiss();
      return;
    }

    // Clear preloaded reference so it cannot be shown twice
    _preloadedInterstitial = null;

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _recordInterstitialImpression();
        onDismiss();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        onDismiss();
      },
    );

    try {
      await ad.show();
    } catch (_) {
      ad.dispose();
      onDismiss();
    }
  }

  Future<void> _recordInterstitialImpression() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final now = DateTime.now();
      final todayStr = '${now.year}-${now.month}-${now.day}';

      final storedDate = prefs.getString(_keyDailyInterstitialDate) ?? '';
      int currentCount = prefs.getInt(_keyDailyInterstitialCount) ?? 0;

      if (storedDate != todayStr) {
        currentCount = 1;
      } else {
        currentCount++;
      }

      await prefs.setInt(_keyLastInterstitialTime, now.millisecondsSinceEpoch);
      await prefs.setString(_keyDailyInterstitialDate, todayStr);
      await prefs.setInt(_keyDailyInterstitialCount, currentCount);
    } catch (_) {}
  }

  /// Adds a native ad to memory cache, enforcing the [maxCachedNativeAds] limit.
  void registerNativeAd(NativeAd ad) {
    if (_cachedNativeAds.contains(ad)) return;

    if (_cachedNativeAds.length >= maxCachedNativeAds) {
      final oldest = _cachedNativeAds.removeAt(0);
      oldest.dispose();
    }
    _cachedNativeAds.add(ad);
  }

  /// Disposes and unregisters a specific native ad.
  void unregisterNativeAd(NativeAd ad) {
    _cachedNativeAds.remove(ad);
    ad.dispose();
  }

  /// Disposes all active ads immediately (e.g. when user upgrades to Premium).
  void disposeAllAds() {
    _preloadedInterstitial?.dispose();
    _preloadedInterstitial = null;
    _isPreloadingInterstitial = false;

    for (final nativeAd in _cachedNativeAds) {
      nativeAd.dispose();
    }
    _cachedNativeAds.clear();
  }
}

/// Riverpod provider for [AdService].
final adServiceProvider = Provider<AdService>((ref) {
  final service = AdService(ref);
  ref.onDispose(() => service.disposeAllAds());
  return service;
});
