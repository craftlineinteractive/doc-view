import 'dart:io';
import 'package:flutter/foundation.dart';

/// Ad unit types supported by Doc View.
enum AdType {
  banner,
  native,
  interstitial,
}

/// Central configuration for AdMob advertisement units, IDs, and safety checks.
class AdConfig {
  AdConfig._();

  /// Google's public test App ID (for manifest documentation & test reference).
  static const String testAppId = 'ca-app-pub-3940256099942544~3347511713';

  /// Google's public test ad unit IDs (Debug only).
  static const Map<AdType, String> testAdUnitIds = {
    AdType.banner: 'ca-app-pub-3940256099942544/6300978111',
    AdType.native: 'ca-app-pub-3940256099942544/2247696110',
    AdType.interstitial: 'ca-app-pub-3940256099942544/1033173712',
  };

  /// Production ad unit IDs per type. Empty strings by default until configured.
  /// When empty in release builds, ad placement is disabled and collapses to zero height.
  static const String releaseBannerAdUnitId = '';
  static const String releaseNativeAdUnitId = '';
  static const String releaseInterstitialAdUnitId = '';

  /// Optional test flag to simulate release mode behavior in widget/unit tests.
  static bool? forceReleaseModeForTesting;

  /// Whether native platform channel ad requests should be dispatched.
  /// Defaults to false during headless widget tests to prevent MissingPluginException,
  /// and true in live application execution on devices and emulators.
  static bool enablePlatformChannelRequests =
      !Platform.environment.containsKey('FLUTTER_TEST');

  /// Returns the ad unit ID for the specified [type].
  ///
  /// In release builds (or when [forceReleaseModeForTesting] is true), returns
  /// the production ad unit ID (empty string by default).
  /// In debug mode, returns Google's public test ad unit ID.
  static String getAdUnitId(AdType type) {
    final isRelease = forceReleaseModeForTesting ?? kReleaseMode;
    if (isRelease) {
      switch (type) {
        case AdType.banner:
          return releaseBannerAdUnitId;
        case AdType.native:
          return releaseNativeAdUnitId;
        case AdType.interstitial:
          return releaseInterstitialAdUnitId;
      }
    }
    return testAdUnitIds[type] ?? '';
  }

  /// Whether ads of the given [type] are enabled and configured with a valid unit ID.
  static bool isAdEnabled(AdType type) {
    return getAdUnitId(type).trim().isNotEmpty;
  }

  /// Backward-compatible flag for legacy placeholder UI.
  static bool showPlaceholders = kDebugMode;
}
