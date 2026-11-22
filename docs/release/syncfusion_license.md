# Syncfusion Essential PDF - Licensing & Registration Guide

## 1. Overview
Doc View utilizes `syncfusion_flutter_pdf` (v28.2.12) as its on-device PDF manipulation and annotation engine (text markup, page manipulations, and PDF document serialization).

Syncfusion provides a free Community License for eligible individuals and small organizations.

> [!IMPORTANT]
> **NO SYNCFUSION LICENSE KEY IS REGISTERED IN THE SOURCE CODE.**
> Per repository policy and security practices, no trial or commercial license key is committed to source control. The repository owner or release manager must obtain and register their own Syncfusion Community License Key personally prior to building a production release.

---

## 2. Syncfusion Community License Eligibility
To qualify for the free Syncfusion Community License, your organization/entity must satisfy all of the following criteria:
1. **Annual Gross Revenue**: Less than **$1,000,000 USD** per year.
2. **Developers**: No more than **5 developers** across the entire organization.
3. **Total Headcount**: No more than **10 total employees** across the entire organization.
4. **Capital / Funding**: Total outside investment / funding of less than **$3,000,000 USD**.

If the company exceeds any of these thresholds, a commercial Syncfusion Essential Studio license is required.

---

## 3. License Key Registration (For Release Builds)
Without a registered license key:
- Syncfusion outputs a runtime console warning during app startup:
  `Syncfusion license key is invalid or missing`
- When saving modified PDF documents via Syncfusion APIs, a small evaluation watermark is embedded into page margins:
  `"Created with a trial version of Syncfusion Essential PDF"`

### How to Register Prior to Release:
1. Log in to your Syncfusion account at https://www.syncfusion.com/.
2. Navigate to **My Dashboard -> Downloads & Keys** to generate a key for Essential Studio for Flutter / `syncfusion_flutter_pdf` (version 28.x).
3. In `lib/main.dart` (or via compile-time environment variable `--dart-define=SYNCFUSION_LICENSE_KEY=...`):
   ```dart
   import 'package:syncfusion_flutter_pdf/pdf.dart';

   void main() {
     // Retrieve from dart-define or local config:
     const syncfusionKey = String.fromEnvironment('SYNCFUSION_LICENSE_KEY');
     if (syncfusionKey.isNotEmpty) {
       SyncfusionLicense.registerLicense(syncfusionKey);
     }
     ...
   }
   ```
4. Build the release APK / AAB.

---

## 4. Pre-Release Checklist Item
Before publishing any release build to Google Play or external distribution:
- [ ] Confirm Community License eligibility or active commercial license.
- [ ] Ensure valid Syncfusion license key is injected at build time (`--dart-define=SYNCFUSION_LICENSE_KEY=...`) or registered.
- [ ] Verify that saving an annotated PDF does NOT produce trial evaluation watermarks in the exported PDF output.
