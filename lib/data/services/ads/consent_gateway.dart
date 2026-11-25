import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Abstract contract for User Messaging Platform (UMP) consent handling.
abstract class ConsentGateway {
  /// Requests consent information update from Google UMP.
  Future<void> requestConsentInfoUpdate({DebugGeography? debugGeography});

  /// Presents the UMP consent form if required.
  /// Returns `true` if consent form completed or not required, `false` on error.
  Future<bool> showConsentFormIfRequired();

  /// Whether ads can be requested under current consent status.
  Future<bool> canRequestAds();

  /// Whether the privacy options entry point ("Ad choices") is required by UMP.
  Future<bool> isPrivacyOptionsRequired();

  /// Displays the UMP privacy options consent form for the user to change consent.
  Future<void> showPrivacyOptionsForm();

  /// Resets UMP consent state for testing or debugging.
  Future<void> reset();
}

/// Production implementation of [ConsentGateway] backed by Google UMP SDK.
class UmpConsentGateway implements ConsentGateway {
  final ConsentInformation _consentInfo = ConsentInformation.instance;

  @override
  Future<void> requestConsentInfoUpdate({DebugGeography? debugGeography}) async {
    final completer = Completer<void>();

    final params = ConsentRequestParameters(
      consentDebugSettings: debugGeography != null
          ? ConsentDebugSettings(
              debugGeography: debugGeography,
            )
          : null,
    );

    _consentInfo.requestConsentInfoUpdate(
      params,
      () {
        if (!completer.isCompleted) completer.complete();
      },
      (FormError error) {
        // Graceful error handling (no network, offline, server issue)
        if (!completer.isCompleted) completer.complete();
      },
    );

    return completer.future.timeout(
      const Duration(seconds: 6),
      onTimeout: () => null,
    );
  }

  @override
  Future<bool> showConsentFormIfRequired() async {
    final completer = Completer<bool>();
    try {
      ConsentForm.loadAndShowConsentFormIfRequired((FormError? error) {
        if (!completer.isCompleted) completer.complete(error == null);
      });
      return await completer.future.timeout(
        const Duration(seconds: 15),
        onTimeout: () => false,
      );
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> canRequestAds() async {
    try {
      return await _consentInfo.canRequestAds();
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> isPrivacyOptionsRequired() async {
    if (kDebugMode) {
      try {
        final flag = File('/data/user/0/com.craftlineinteractive.docview/files/debug_ad_choices.txt');
        if (flag.existsSync()) return true;
      } catch (_) {}
    }
    try {
      final status = await _consentInfo.getPrivacyOptionsRequirementStatus();
      return status == PrivacyOptionsRequirementStatus.required;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> showPrivacyOptionsForm() async {
    final completer = Completer<void>();
    try {
      ConsentForm.showPrivacyOptionsForm((FormError? error) {
        if (!completer.isCompleted) completer.complete();
      });
      await completer.future.timeout(
        const Duration(seconds: 15),
        onTimeout: () => null,
      );
    } catch (_) {}
  }

  @override
  Future<void> reset() async {
    try {
      await _consentInfo.reset();
    } catch (_) {}
  }
}

/// In-memory fake implementation of [ConsentGateway] for unit/widget tests and debug switcher.
class FakeConsentGateway implements ConsentGateway {
  bool canRequestAdsValue;
  bool isPrivacyOptionsRequiredValue;
  bool showConsentFormCalled = false;
  bool showPrivacyOptionsFormCalled = false;
  DebugGeography? lastDebugGeography;

  FakeConsentGateway({
    this.canRequestAdsValue = true,
    this.isPrivacyOptionsRequiredValue = false,
  });

  @override
  Future<void> requestConsentInfoUpdate({DebugGeography? debugGeography}) async {
    lastDebugGeography = debugGeography;
  }

  @override
  Future<bool> showConsentFormIfRequired() async {
    showConsentFormCalled = true;
    return true;
  }

  @override
  Future<bool> canRequestAds() async {
    return canRequestAdsValue;
  }

  @override
  Future<bool> isPrivacyOptionsRequired() async {
    return isPrivacyOptionsRequiredValue;
  }

  @override
  Future<void> showPrivacyOptionsForm() async {
    showPrivacyOptionsFormCalled = true;
  }

  @override
  Future<void> reset() async {
    canRequestAdsValue = false;
    isPrivacyOptionsRequiredValue = false;
  }
}

/// Riverpod provider for [ConsentGateway].
final consentGatewayProvider = Provider<ConsentGateway>((ref) {
  return UmpConsentGateway();
});

/// Reactive provider for UMP privacy options requirement status.
final isPrivacyOptionsRequiredProvider = FutureProvider<bool>((ref) async {
  final gateway = ref.watch(consentGatewayProvider);
  return gateway.isPrivacyOptionsRequired();
});
