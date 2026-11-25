# Privacy Policy & Play Data Safety Changes (Phase G9)

> [!NOTE]
> This document details the updates required for the Doc View Privacy Policy and the Google Play Data Safety form following the integration of Google Mobile Ads (AdMob), the User Messaging Platform (UMP), In-App Purchases (Google Play Billing), and Home Widgets. This document serves as technical guidance and does not claim legal completeness.

---

## 1. Core Privacy Invariants
1. **Zero Document Data Leaves Device**:
   - All document files, PDFs, Word, Excel, PowerPoint, text, images, annotations, signatures, and thumbnails remain strictly stored on the user's local device storage.
   - No document metadata, filenames, paths, or contents are ever accessed by or transmitted to Google AdMob, Google Play Billing, or any external third-party server.
2. **On-Device Local Processing**:
   - PDF rendering, file parsing, editing, merging, splitting, image conversions, and document exports are performed entirely offline using local native and Flutter libraries.

---

## 2. Google Mobile Ads (AdMob) & UMP SDK Disclosures

### A. Data Collected by Google Mobile Ads SDK
The Google Mobile Ads SDK (version 5.3.1+) may automatically collect and process certain telemetry and network data for advertising and fraud prevention:
- **Device and other identifiers**:
  - Android Advertising ID (AAID / GAID) when consent is granted.
  - App-set IDs and SDK diagnostic instance identifiers.
- **Diagnostics and performance metrics**:
  - Ad request response latency, load time metrics, and SDK crash diagnostics.
- **Interaction data**:
  - Ad impressions, taps, click-through rates, and video completion events.

### B. Purposes in Play Data Safety Form
- **Advertising or Marketing**: Displaying personalized or non-personalized advertisements to free-tier users.
- **Analytics & Fraud Prevention**: Measuring ad deliverability and protecting against invalid clicks/impressions.
- **Data Encrypted in Transit**: All SDK transmissions use HTTPS / TLS.
- **User Control & Deletion**: Users may reset or delete their Android Advertising ID in Android OS Settings (`Settings -> Google -> Ads -> Reset advertising ID`). In the EEA/UK, users can manage consent at any time via Settings -> Others -> "Ad choices".

---

## 3. In-App Purchases & Subscriptions (Google Play Billing)
- **Financial Info**: Purchases are processed directly through Google Play Billing. Doc View does not collect, receive, or store credit card numbers, billing addresses, or banking details.
- **App Functionality**: Google Play returns purchase verification tokens and subscription status (`isPremium`) to unlock ad-free features and premium tools locally.

---

## 4. Native App Widgets & Quick Access Notifications
- **Local Cache**: Home Widgets and the Quick Access Notification read local file history (`recent_files_widget_info`) and quick tool action shortcuts from local app preferences (`SharedPreferences`).
- **No Network Transmission**: No widget data or notification interaction data is shared or uploaded.

---

## 5. AdMob & UMP Configuration Checklist
1. **AdMob Console**:
   - Enable Privacy & Messaging → GDPR message.
   - Target EEA, UK, and Switzerland users.
   - Configure Consent Form options: "Consent", "Do not consent", and "Manage options".
2. **Child-Directed / COPPA Flags**:
   - Doc View does not direct advertising to children under 13 (`TagForChildDirectedTreatment.unspecified` / not set).
3. **Max Ad Content Rating**:
   - Configured in SDK initialization request configuration to ensure brand-safe advertisements suitable for general audiences.
