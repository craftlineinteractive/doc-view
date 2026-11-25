# Google Play Production Release Checklist: Doc View

This end-to-end checklist guides the engineering and release process for launching Doc View version 1.0.0 on Google Play.

---

## Phase 1: Accounts, Merchant Profile & Legal Scaffolding
- [ ] **Google Play Developer Account**: Ensure developer account is active, identity verified, and in good standing.
- [ ] **Google Payments Merchant Profile**: Configure payments profile in Play Console to process in-app subscriptions and receive payouts.
- [ ] **Syncfusion Community License**: Register for a free Syncfusion Community License (for eligible entities < $1M gross annual revenue) following `docs/release/syncfusion_license.md`.
- [ ] **AdMob Account & App Registration**:
  - Create Doc View app entry in Google AdMob console.
  - Link AdMob app to Google Play Store package (`com.craftlineinteractive.docview`).
  - Create production ad units: Banner, Native In-feed, and Interstitial.
  - Set up `app-ads.txt` on developer domain.
- [ ] **Google Play In-App Subscription Product**:
  - In Play Console → Monetization → Subscriptions, create product `docview_premium`.
  - Add base plan `monthly` (billing period P1M) with offer `freetrial-7d` (7-day free trial).
  - Add base plan `yearly` (billing period P1Y) with offer `freetrial-7d` (7-day free trial).
  - Reference: `docs/release/iap_products.txt`.

---

## Phase 2: Configuration & Secrets Injection
- [ ] **Constants Configuration**: Fill all required production values in `lib/core/constants/app_constants.dart` following `docs/release/constants_to_fill.md`:
  - `supportEmail`
  - `termsOfUseUrl`
  - `privacyPolicyUrl`
  - `storeShareUrl`
  - `storeRateUrl`
- [ ] **Upload Keystore**:
  - Generate upload keystore following `docs/release/keystore.md`.
  - Backup keystore in at least two secure locations.
  - Create `android/key.properties` with keystore credentials (never committed to git).
- [ ] **Hosted Documents**: Host `docs/release/store/privacy_policy.md` and `docs/release/store/terms_of_use.md` on your public website domain.

---

## Phase 3: Release Build Artifact Generation
- [ ] **Run Full Test Suite**: `flutter test` must pass 100% with zero skipped or failing tests.
- [ ] **Run Analyzer**: `flutter analyze` must report zero issues or warnings.
- [ ] **Build Production AAB**:
  ```bash
  flutter build appbundle --release \
    --obfuscate \
    --split-debug-info=../docview_symbols \
    --dart-define=ADMOB_BANNER_ID="YOUR_BANNER_ID" \
    --dart-define=ADMOB_NATIVE_ID="YOUR_NATIVE_ID" \
    --dart-define=ADMOB_INTERSTITIAL_ID="YOUR_INTERSTITIAL_ID" \
    -PadmobAppId="YOUR_ADMOB_APP_ID"
  ```
- [ ] **Archive Symbols**: Securely store `../docview_symbols` mapping files and `build/app/outputs/mapping/release/mapping.txt` matching the release Git tag.

---

## Phase 4: Google Play Console Store Setup
- [ ] **Main Store Listing**:
  - Title (max 30 chars), Short Description (max 80 chars), and Full Description from `docs/release/store/listing.md`.
  - App icon (512 x 512 32-bit PNG).
  - Feature graphic (1024 x 500 JPG/PNG).
  - Minimum 4 phone screenshots (following 8-screen plan in `listing.md`).
- [ ] **App Content & Policy Declarations**:
  - **Privacy Policy URL**: Enter hosted URL.
  - **Data Safety Form**: Complete questionnaire using answers from `docs/release/store/data_safety.md`.
  - **Advertising ID Declaration**: Complete declaration from `docs/release/store/permission_declarations.md`.
  - **All Files Access Declaration (`MANAGE_EXTERNAL_STORAGE`)**:
    - Select Document management use case.
    - Submit justification text and YouTube demo video link (using script from `permission_declarations.md`).
  - **Content Rating**: Complete IARC questionnaire using `docs/release/store/content_rating.md`.
  - **Target Audience**: General audience (13+).
  - **News / COVID-19 / Financial Features Declarations**: Mark No where applicable.

---

## Phase 5: Testing Tracks & Gradual Rollout
- [ ] **Internal Testing Track**:
  - Upload release AAB to Internal Testing.
  - Verify installation on physical devices via Play Store internal link.
  - Test real Play Billing subscription purchase with test license accounts.
  - Test test-ad display and UMP consent form rendering.
- [ ] **Closed Testing Track (20 Testers / 14 Days)**:
  - *Note*: Personal developer accounts created after Nov 13, 2023 require closed testing with at least 20 opted-in testers for 14 continuous days before requesting production access. Verify current account requirements in Play Console.
- [ ] **Production Rollout**:
  - Request Production access once closed testing criteria are fulfilled.
  - Stage rollout: Start with **10% staged rollout** on Day 1.
  - Monitor Google Play Android Vitals for crash rate (< 1.09%) and ANR rate (< 0.47%).
  - Increment rollout to 25% → 50% → 100% over 7 days.
