/// Application-wide constants.
class AppConstants {
  const AppConstants._();

  static const String appName = 'Doc View';

  /// Support email for feedback. Hidden in UI if empty.
  static const String supportEmail = '';

  /// URL pointing to the hosted Terms of Use document. Hidden in settings if empty.
  static const String termsOfUseUrl =
      'https://www.craftlineinteractive.in/app/doc-view/terms-of-use/';

  /// URL pointing to the hosted Privacy Policy document. Hidden in settings if empty.
  static const String privacyPolicyUrl =
      'https://www.craftlineinteractive.in/app/doc-view/privacy-policy/';

  /// App Store or Google Play share URL. Hidden in settings if empty.
  static const String storeShareUrl =
      'https://play.google.com/store/apps/details?id=com.craftlineinteractive.docview';

  /// App Store or Google Play rating URL. Hidden in Rate drawer if empty.
  static const String storeRateUrl =
      'https://play.google.com/store/apps/details?id=com.craftlineinteractive.docview';

  /// Platform subscription management pages (used only when `premiumEnabled` is true).
  static const String androidSubscriptionsUrl =
      'https://play.google.com/store/account/subscriptions';
  static const String iosSubscriptionsUrl =
      'https://apps.apple.com/account/subscriptions';

  /// Recycle bin retention period in days (30 days).
  static const int trashRetentionDays = 30;

  /// Maximum file size allowed in Recycle bin (200 MB).
  static const int trashMaxFileBytes = 200 * 1024 * 1024;
}
