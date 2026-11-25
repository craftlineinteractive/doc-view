# Production Constants & Configuration Reference: Doc View

This document is the authoritative single source of truth for every environment variable, build flag, and configuration constant required for production release.

---

## 1. Constants Inventory & Deployment Matrix

| Constant Name | Location in Codebase | How to Supply / Inject | Required Before Production? | Default Value | Notes / Description |
|---|---|---|---|---|---|
| `supportEmail` | `lib/core/constants/app_constants.dart` | Direct constant or Dart define | **REQUIRED** | `""` (Empty string) | Customer support email displayed in Settings → Support and feedback dialogs. |
| `termsOfUseUrl` | `lib/core/constants/app_constants.dart` | Direct constant or Dart define | **REQUIRED** | `""` (Empty string) | Public HTTPS URL where `docs/release/store/terms_of_use.md` is hosted. |
| `privacyPolicyUrl` | `lib/core/constants/app_constants.dart` | Direct constant or Dart define | **REQUIRED** | `""` (Empty string) | Public HTTPS URL where `docs/release/store/privacy_policy.md` is hosted. Must match Google Play Console URL. |
| `storeShareUrl` | `lib/core/constants/app_constants.dart` | Direct constant or Dart define | **REQUIRED** | `""` (Empty string) | Google Play Store listing URL (`https://play.google.com/store/apps/details?id=com.craftlineinteractive.docview`). |
| `storeRateUrl` | `lib/core/constants/app_constants.dart` | Direct constant or Dart define | **REQUIRED** | `""` (Empty string) | Market direct rating URI (`market://details?id=com.craftlineinteractive.docview`). |
| `admobAppId` | `android/app/build.gradle.kts` | `-PadmobAppId=...` or `~/.gradle/gradle.properties` | **REQUIRED** | `ca-app-pub-3940256099942544~3347511713` (Test App ID) | Production AdMob Application ID. Release builds are blocked by Gradle if left as test ID. |
| `ADMOB_BANNER_ID` | `lib/core/config/ad_config.dart` | `--dart-define=ADMOB_BANNER_ID=...` | **REQUIRED** (for ads) | `""` (Empty string) | Production banner ad unit ID from AdMob. If empty, banner slot is disabled and collapses to 0 height. |
| `ADMOB_NATIVE_ID` | `lib/core/config/ad_config.dart` | `--dart-define=ADMOB_NATIVE_ID=...` | **REQUIRED** (for ads) | `""` (Empty string) | Production native in-feed ad unit ID. If empty, native ad slots collapse to 0 height. |
| `ADMOB_INTERSTITIAL_ID` | `lib/core/config/ad_config.dart` | `--dart-define=ADMOB_INTERSTITIAL_ID=...` | **REQUIRED** (for ads) | `""` (Empty string) | Production interstitial ad unit ID. If empty, interstitials are suppressed. |
| `productId` (IAP) | `lib/data/services/billing/iap_config.dart` | Constant in `iap_config.dart` | **CONFIGURED** | `docview_premium` | Google Play subscription product ID. |
| `androidSubscriptionsUrl` | `lib/core/constants/app_constants.dart` | Constant in `app_constants.dart` | **CONFIGURED** | `https://play.google.com/store/account/subscriptions` | Google Play subscription management page. |

---

## 2. Automated Pre-Production Verification Test
The test located at `test/constants/constants_audit_test.dart` audits the state of all constants:
- Enumerates which constants are populated and which remain empty.
- Verifies that empty constants fail production verification unless populated or explicitly configured.
- Guarantees the app gracefully hides empty rows in debug and testing modes without crashing.
