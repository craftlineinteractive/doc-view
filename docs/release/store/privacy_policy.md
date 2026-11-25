# Privacy Policy for Doc View

**Effective Date**: [DATE]  
**Last Updated**: [DATE]  
**Developer**: Craftline Interactive  
**Contact**: [CONTACT EMAIL]  
**Website**: [WEBSITE]

---

## 1. Overview & Core Privacy Commitment
Doc View ("we", "our", or "the app") is committed to protecting your privacy. Doc View is a local-first document reader and manager. 

**Your documents and files never leave your device.** We do not run document processing servers, cloud synchronization backends, or document inspection analytics. All viewing, reading, scanning, annotating, signing, and file conversions occur 100% locally on your device.

---

## 2. Information We Do NOT Collect
- **Document Contents**: We never inspect, read, copy, upload, or transmit the contents, filenames, or text of any document you open or create in Doc View.
- **User Accounts**: Doc View requires no account registration, login credentials, usernames, or passwords.
- **Location Data**: We do not collect or request precise or coarse GPS location data.
- **Biometrics**: Any saved signatures are vector paths stored locally in app-private storage (`signatures.json`) and never transmitted.

---

## 3. Local-Only On-Device Data
To provide app functionality, Doc View maintains private local caches on your device:
- **Recent Files & Bookmarks**: Stored in a local SQLite database (`docview.db`) to enable quick access.
- **Recycle Bin**: Deleted files are moved to an internal app-private recycle bin folder for 30-day safe recovery before permanent deletion.
- **Home Screen Widgets**: Up to 5 recent file names, types, IDs, and modified timestamps are cached in local `SharedPreferences` to render home screen glanceables. Absolute file paths are strictly stripped.
- **Notification Preferences**: Your toggle state for the optional Quick Access notification is stored in local preferences.

---

## 4. Third-Party Services & Data Collection
Doc View integrates industry-standard SDKs provided by Google to support advertising and in-app subscriptions:

### A. Google Mobile Ads (AdMob) & User Messaging Platform (UMP)
Doc View displays non-intrusive advertisements to free-tier users.
- **Data Collected**: Device identifiers (e.g. Google Advertising ID / GAID on Android), IP address (used for coarse geographic ad routing), crash logs, and diagnostic telemetry.
- **User Consent & GDPR**: For users residing in the European Economic Area (EEA), the UK, and Switzerland, Doc View uses Google's certified User Messaging Platform (UMP) consent SDK to present consent options before loading personalized or non-personalized ads.
- **Ad Choices**: You can update your privacy and advertising choices anytime in Doc View under **Settings → Others → Ad choices**.
- **Ad-Free Option**: Subscribing to Doc View Premium completely disables and disposes all advertising components and ceases ad SDK initialization.

### B. Google Play In-App Billing
Doc View uses the Google Play Billing Library to process subscriptions.
- **Data Collected**: Purchase tokens, order IDs, subscription status, and entitlements are verified through Google Play.
- **Financial Information**: We do **not** collect or store credit card numbers, bank account numbers, or billing addresses. All financial transactions are processed securely and directly by Google Play.

---

## 5. Android Permissions Explained
Doc View requests only permissions necessary for its advertised features:
- **All Files Access (`MANAGE_EXTERNAL_STORAGE`)**: Required for the core document manager functionality: finding, organizing, indexing, renaming, deleting, and restoring office files and PDFs across your device storage.
- **Camera (`CAMERA`)**: Used exclusively when you open the Scan to PDF feature to photograph paper documents. Images are converted directly into PDF on your device.
- **Notifications (`POST_NOTIFICATIONS`)**: Required only if you voluntarily enable the optional Quick Access ongoing notification in Settings.

---

## 6. Children's Privacy (COPPA Compliance)
Doc View is a general-audience productivity tool. It is not directed to children under the age of 13. We do not knowingly collect personal information from children under 13.

---

## 7. Data Retention & Deletion
Because your files and application databases reside locally on your device:
- Clearing application data via Android Settings (`Settings → Apps → Doc View → Clear Storage`) immediately and permanently deletes all local recents, bookmarks, trash items, signatures, and widget caches.
- Uninstalling Doc View removes all app-private storage and signatures.

---

## 8. Changes to This Privacy Policy
We may update this Privacy Policy periodically. Any updates will be published with a revised "Last Updated" date. We encourage you to review this policy periodically.

---

## 9. Contact Us
If you have questions or concerns regarding this Privacy Policy or data privacy in Doc View, please contact us at:
**Email**: [CONTACT EMAIL]  
**Website**: [WEBSITE]
