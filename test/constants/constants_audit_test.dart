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

      // supportEmail stays empty unless provided by owner (tracked in constants_to_fill.md)
      expect(emptyConstants, contains('supportEmail'));
      // Owner constants are now populated with public URLs
      expect(populatedConstants, contains('privacyPolicyUrl'));
      expect(populatedConstants, contains('termsOfUseUrl'));
      expect(populatedConstants, contains('storeShareUrl'));
      expect(populatedConstants, contains('storeRateUrl'));
      expect(populatedConstants, contains('iapProductId'));
    });
  });
}
