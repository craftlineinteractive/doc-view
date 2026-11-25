# G9 QA Evidence: Google Mobile Ads 9+, UMP Consent, and Privacy Compliance

## 1. Environment & Device Context
- **Target Platform**: Android 16 (API 36.1) on `emulator-5554`
- **Application ID**: `com.craftlineinteractive.docview`
- **Flutter Version**: 3.44.9 (Dart 3.12.2)
- **Google Mobile Ads SDK**: `google_mobile_ads: ^9.1.0` (resolved to `9.2.0`, Apache 2.0 license)
- **Native compileSdk**: Android 36 natively supported by Google Mobile Ads 9+

---

## 2. Cold Start Benchmark (emulator-5554)
Measured via `adb shell am start -W -n com.craftlineinteractive.docview/.MainActivity` (3 consecutive runs):
- **Run 1**: WaitTime: 27,671 ms
- **Run 2**: WaitTime: 31,635 ms
- **Run 3**: WaitTime: 28,689 ms
- **Average Startup Time**: 29.33 s (standard debug mode with JIT compilation & observatory on Android 16 API 36.1)

---

## 3. Screenshots Matrix (< 300 KB each)
All screenshots captured on `emulator-5554` and verified in `docs/redesign/img/g9/`:
| Screenshot File | Size | Description & Verification |
|---|---|---|
| `g9_home_adaptive_banner.png` | 169,259 bytes (~165 KB) | Home screen showing docked Google Mobile Ads adaptive banner at bottom ("Test Ad AdMob has a YouTube series!"), FAB with 16pt clearance padding above banner, and clean layout. |
| `g9_home_native_infeed.png` | 276,284 bytes (~270 KB) | Component Gallery / In-feed showing native ad container ("Test Ad: Flood-It! INSTALL") with full metadata and AdMob native ad validator compliance. |
| `g9_consent_form_eea.png` | 219,930 bytes (~214 KB) | Live Google User Messaging Platform (UMP) consent dialog ("Welcome to Publisher Test Ads... asks for your consent to use your personal data to:") with Consent, Do not consent, and Manage options. |
| `g9_settings_ad_choices.png` | 274,061 bytes (~268 KB) | Settings tab showing "Ad choices - Manage privacy and advertising choices" row under Others with custom icon and docked adaptive banner. |
| `g9_post_export_interstitial.png` | 257,837 bytes (~252 KB) | Fullscreen Interstitial simulation dialog / ad view with dismiss/close controls, 3-min cooldown, and 3/day daily cap enforcement. |

---

## 4. Merged AndroidManifest & Permission Audit
Analysis of permissions introduced by `google_mobile_ads: 9.2.0`:
- `android.permission.INTERNET`: Required to fetch ad creative and UMP consent definitions.
- `android.permission.ACCESS_NETWORK_STATE`: Required to detect online/offline connectivity before requesting ads.
- `com.google.android.gms.permission.AD_ID`: Google Play Advertising ID permission for non-personalized/personalized ad requests.
- **Forbidden Permissions Check**: ZERO storage permissions (`MANAGE_EXTERNAL_STORAGE` or location permissions) added by ads module.
- **Data Privacy Guarantee**: Documents and file paths are never passed to any advertising API. Ads collapse to 0 height when offline or in release mode with empty ad unit IDs.

---

## 5. Automated Guardrail Verification
1. `test/ads/no_real_ad_ids_test.dart`:
   - Scanned entire repository for production publisher IDs (`pub-[0-9]{16}`). Result: **0 violations**.
   - Verified release mode behavior with empty unit IDs: Produces 0 ad requests, collapses slots to 0 height. Result: **PASSED**.
   - Verified debug mode behavior: Uses Google public test IDs. Result: **PASSED**.
2. `test/l10n/no_hardcoded_strings_test.dart`:
   - Scanned all 179 surviving `lib/` files. Result: **0 violations**.
3. `test/premium/no_price_literals_test.dart`:
   - Scanned all Dart and ARB files for price literals. Result: **0 violations**.
