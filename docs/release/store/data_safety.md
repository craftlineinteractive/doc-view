# Google Play Data Safety Form Guide: Doc View

This document provides recommended answers for the Google Play Console **Data safety** questionnaire based on Doc View's current codebase and integrated SDKs (Google Mobile Ads 9.2.0, Google UMP, Google Play Billing).

> [!NOTE]
> Verify all answers in Google Play Console prior to final production submission, as Google's Data Safety taxonomy and SDK declarations may update over time.

---

## 1. Data Collection & Security Overview

| Question | Recommended Answer | Rationale |
|---|---|---|
| Does your app collect or share any of the required user data types? | **Yes** | Google Mobile Ads and Google Play Billing collect diagnostic, device ID, and purchase data. |
| Is all of the user data collected by your app encrypted in transit? | **Yes** | All network traffic dispatched by Google Mobile Ads, UMP, and Google Play uses HTTPS / TLS encryption. |
| Do you provide a way for users to request that their data be deleted? | **Yes** | Local document data is deleted via app storage clear; Google provides ad ID reset in Android OS settings. |

---

## 2. Detailed Data Types Breakdown

### A. Location
- **Approximate Location (Coarse)**:
  - *Collected*: **Yes** (by Google Mobile Ads SDK for ad serving/fraud prevention based on IP address).
  - *Shared*: **Yes** (with advertising partners).
  - *Processed Ephemerally*: **Yes**.
  - *Required or Optional*: **Required** for free-tier users; N/A for Premium users.
  - *Purpose*: Advertising, Analytics, Fraud prevention.

### B. Personal Info
- **Name, Email, Address, Phone, User IDs**: **NOT COLLECTED**.

### C. Financial Info
- **User Payment Info (Credit Cards)**: **NOT COLLECTED** (Handled entirely by Google Play).
- **Purchase History**:
  - *Collected*: **Yes** (by Google Play Billing Library to verify subscriptions).
  - *Shared*: **No**.
  - *Processed Ephemerally*: **No**.
  - *Purpose*: Account management, App functionality.

### D. Files and Docs
- **Files, Documents, Text, Photos**: **NOT COLLECTED / NOT SHARED**.
  - *Crucial Declaration*: All PDF, Office, and text document processing occurs 100% on-device. No document files or contents are uploaded, collected, or shared.

### E. Photos and Videos
- **Photos / Videos**: **NOT COLLECTED / NOT SHARED**. Camera capture is processed locally into PDF.

### F. Device or Other IDs
- **Device or other IDs (e.g. Advertising ID / GAID)**:
  - *Collected*: **Yes** (by Google Mobile Ads SDK).
  - *Shared*: **Yes** (with advertising partners for ad measurement and personalization).
  - *Purpose*: Advertising or marketing, Analytics, Fraud prevention.
  - *User Choice*: Users can opt out of personalized ads via Android OS settings or in-app UMP consent form (**Settings → Ad choices**).

### G. App Activity & Performance
- **App Interactions & In-App Search**: **NOT COLLECTED** (Search queries execute strictly against local SQLite).
- **Crash Logs & Diagnostics**:
  - *Collected*: **Yes** (by Google Mobile Ads / Play Services).
  - *Shared*: **Yes**.
  - *Purpose*: Analytics, Diagnostics.

---

## 3. SDK-by-SDK Data Source Reference

1. **Google Mobile Ads (AdMob) & UMP SDK**:
   - Device identifiers (Advertising ID)
   - Diagnostic and crash logs
   - Coarse location (IP-derived)
2. **Google Play Billing**:
   - Purchase tokens and subscription entitlement records
3. **Doc View Core Application**:
   - **Zero external data collection**. All documents, annotations, signatures, bookmarks, and trash items reside strictly in local sandboxed storage.
