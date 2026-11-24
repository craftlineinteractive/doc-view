# Release Constants To Fill Before Store Submission

All user-facing legal, support, and store constants live in `lib/core/constants/app_constants.dart` and ship as empty strings (`''`) during development so unconfigured rows stay cleanly hidden. Before building a production release (Android Play Store / iOS App Store), populate every constant below.

| Constant (`AppConstants.*`) | Current Default | Where Used in UI | Source Document / Store Listing |
| --- | --- | --- | --- |
| `supportEmail` | `''` | FAQ highlight banner `"Contact us"` button & FAQ bottom `"Still need help? Send feedback"` CTA (`mailto:` with app version/build in body). Hidden when empty. | Official support inbox for Craftline Interactive (e.g., `support@craftlineinteractive.com`). |
| `termsOfUseUrl` | `''` | Settings → Others → `"Terms of use"` row (opens external browser). Hidden when empty. | Hosted Terms of Use / Terms of Service web page (HTTPS) published on the official app website and referenced in Play Console / App Store Connect. |
| `privacyPolicyUrl` | `''` | Settings → Others → `"Privacy policy"` row (opens external browser). Hidden when empty. | Hosted Privacy Policy web page (HTTPS) matching the URL declared in Google Play Data Safety / App Store Privacy Details (must disclose Google AdMob data usage). |
| `storeShareUrl` | `''` | Settings → Top group → `"Share"` row (opens system Share Sheet via `share_plus`). Hidden when empty. | Public store listing URL (e.g., `https://play.google.com/store/apps/details?id=com.craftlineinteractive.docview` on Android or universal landing URL redirecting to Play Store / App Store). |
| `storeRateUrl` | `''` | Settings → General → `"Rate us"` drawer → `"Rate on Google Play"` button (opens external browser). Hidden inside drawer when empty. | Google Play listing URL (`https://play.google.com/store/apps/details?id=com.craftlineinteractive.docview`) / App Store review URL. |

## Pre-Configured Platform URLs (No Change Needed Unless Store Policy Changes)

| Constant (`AppConstants.*`) | Value | Where Used |
| --- | --- | --- |
| `androidSubscriptionsUrl` | `https://play.google.com/store/account/subscriptions` | Settings → Others → `"Manage subscriptions"` on Android (gated behind `premiumEnabled` in `lib/core/config/feature_flags.dart`, Phase G7). |
| `iosSubscriptionsUrl` | `https://apps.apple.com/account/subscriptions` | Settings → Others → `"Manage subscriptions"` on iOS (gated behind `premiumEnabled` in `lib/core/config/feature_flags.dart`, Phase G7). |

## Feature Flags (`lib/core/config/feature_flags.dart`)

| Flag | Default | Target Phase | Effect When `true` |
| --- | --- | --- | --- |
| `premiumEnabled` | `true` | Phase G7 | Shows `"Manage subscriptions"` row under Settings → Others and enables `/premium` paywall and billing flows. |
| `widgetsEnabled` | `false` | Phase G8 | Shows `"Add Widget"` row under Settings → Others. |

## In-App Purchase Subscriptions (Google Play Console)

Subscription identifiers and base plans must be configured in Google Play Console (Monetize → Subscriptions) as specified in `docs/release/iap_products.txt`:
- **Annual Subscription**: Product ID `docview_premium_yearly`, Base Plan ID `docview-premium-yearly-base`, 7-day free trial.
- **Monthly Subscription**: Product ID `docview_premium_monthly`, Base Plan ID `docview-premium-monthly-base`.
- Dynamic localized pricing and currency are managed entirely within Google Play Console and retrieved at runtime via Google Play Billing v5+ (Zero price literals in application code).
