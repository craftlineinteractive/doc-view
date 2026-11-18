/// Application-wide constants.
class AppConstants {
  const AppConstants._();

  static const String appName = 'Doc View';

  /// Support email for feedback. Hidden in UI if empty.
  static const String supportEmail = '';

  /// URL pointing to the hosted Terms of Use document. Hidden in settings if empty.
  static const String termsOfUseUrl = '';

  /// URL pointing to the hosted Privacy Policy document. Hidden in settings if empty.
  static const String privacyPolicyUrl = '';

  /// App Store or Google Play share URL. Hidden in settings if empty.
  static const String storeShareUrl = '';

  /// App Store or Google Play rating URL. Hidden in Rate drawer if empty.
  static const String storeRateUrl = '';

  /// Platform subscription management pages (used only when `premiumEnabled` is true).
  static const String androidSubscriptionsUrl =
      'https://play.google.com/store/account/subscriptions';
  static const String iosSubscriptionsUrl =
      'https://apps.apple.com/account/subscriptions';
}
