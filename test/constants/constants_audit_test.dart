import 'package:docview/core/config/ad_config.dart';
import 'package:docview/core/config/iap_config.dart';
import 'package:docview/core/constants/app_constants.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Production Constants Audit Test', () {
    test('audits and lists all production constants status', () {
      final constantsMap = <String, String>{
        'supportEmail': AppConstants.supportEmail,
        'termsOfUseUrl': AppConstants.termsOfUseUrl,
        'privacyPolicyUrl': AppConstants.privacyPolicyUrl,
        'storeShareUrl': AppConstants.storeShareUrl,
        'storeRateUrl': AppConstants.storeRateUrl,
        'releaseBannerAdUnitId': AdConfig.releaseBannerAdUnitId,
        'releaseNativeAdUnitId': AdConfig.releaseNativeAdUnitId,
        'releaseInterstitialAdUnitId': AdConfig.releaseInterstitialAdUnitId,
        'iapProductId': IapConfig.subscriptionProductId,
      };

      final emptyConstants = <String>[];
      final populatedConstants = <String>[];

      constantsMap.forEach((key, value) {
        if (value.trim().isEmpty) {
          emptyConstants.add(key);
        } else {
          populatedConstants.add(key);
        }
      });

      // In repository state, URLs and release ad IDs are intentionally empty placeholders
      // to prevent hardcoding personal credentials in git.
      // IAP product ID must be populated with 'docview_premium'
      expect(IapConfig.subscriptionProductId, equals('docview_premium'));
      expect(AppConstants.appName, equals('Doc View'));
      expect(emptyConstants, contains('supportEmail'));
      expect(emptyConstants, contains('privacyPolicyUrl'));
      expect(emptyConstants, contains('termsOfUseUrl'));
      expect(populatedConstants, contains('iapProductId'));
    });
  });
}
