# Doc View Android Permissions Audit & Play Console Declaration Matrix

## 1. Executive Summary

Doc View enforces strict permission minimization. Transitive media permissions (`READ_MEDIA_IMAGES`, `READ_MEDIA_VIDEO`, `READ_MEDIA_AUDIO`) and `FOREGROUND_SERVICE` have been explicitly stripped using `tools:node="remove"`.

---

## 2. Complete Permissions Inventory (AFTER Stripping)

| Permission | Origin / Sdk | Purpose / Why Needed | Where Used in App | Play Console Requirement |
|---|---|---|---|---|
| `android.permission.INTERNET` | App Manifest | Fetch ad creative, UMP GDPR consent messages, and handle store web links. | AdMob SDK, UMP SDK, `url_launcher` (external privacy/terms links) | Standard (No special declaration; disclosed in Data Safety) |
| `android.permission.ACCESS_NETWORK_STATE` | App Manifest & Play Services Ads | Verify device connectivity before dispatching network ad requests or opening web links. | `AdService`, Mobile Ads SDK | Standard (No declaration) |
| `android.permission.CAMERA` | App Manifest | Capture paper document photos for on-device Scan to PDF tool. | `ScanToPdfScreen`, `DocumentScannerService` | Standard (Optional hardware feature: `<uses-feature android:name="android.hardware.camera" android:required="false"/>`) |
| `android.permission.POST_NOTIFICATIONS` | App Manifest | Deliver optional persistent Quick Access notification (Android 13+ / API 33+). | `QuickAccessNotificationService` (default OFF in Settings) | Runtime permission dialog; disclosed in App Content rating |
| `android.permission.MANAGE_EXTERNAL_STORAGE` | App Manifest | Core file manager functionality: discover, index, organize, rename, delete, and restore office documents and PDFs across shared device storage. | `FileRepository`, `DirectoryScannerService`, `TrashService` | **High-Risk Permission Declaration**: Play Console "All files access" Declaration Form & video submission required |
| `android.permission.READ_EXTERNAL_STORAGE` (maxSdk 32) | App Manifest | Legacy Android storage access for document indexing on Android 12 and below. | Storage scanner on legacy devices | Deprecated on API 33+; covered by MANAGE_EXTERNAL_STORAGE declaration |
| `android.permission.WRITE_EXTERNAL_STORAGE` (maxSdk 29) | App Manifest | Legacy Android file write access on Android 9 and below. | File operations on legacy devices | Deprecated on API 30+; covered by MANAGE_EXTERNAL_STORAGE declaration |
| `com.google.android.gms.permission.AD_ID` | Play Services Ads | Fetch non-personalized or personalized advertising identifiers on Android 12+. | Google Mobile Ads SDK | **Advertising ID Declaration** in Play Console App Content |
| `android.permission.ACCESS_ADSERVICES_AD_ID` | Play Services Ads | Android 13+ Privacy Sandbox ad identifier access. | Google Mobile Ads SDK | Covered by Privacy Sandbox declarations |
| `android.permission.ACCESS_ADSERVICES_ATTRIBUTION` | Play Services Ads | Privacy Sandbox attribution measurement for ad clicks. | Google Mobile Ads SDK | Covered by Privacy Sandbox declarations |
| `android.permission.ACCESS_ADSERVICES_TOPICS` | Play Services Ads | Privacy Sandbox interest-based topics calculation. | Google Mobile Ads SDK | Covered by Privacy Sandbox declarations |
| `com.android.vending.BILLING` | Play Billing Library | Process Google Play In-App purchases and subscription management. | `InAppPurchase` plugin, `PremiumGateway` | Standard (Disclosed in Financial Data Safety) |
| `android.permission.VIBRATE` | `flutter_local_notifications` | Haptic feedback for notifications if configured by user. | Notification engine | Standard (No declaration) |
| `android.permission.WAKE_LOCK` | Play Services Measurement API | Ensure background tasks complete during brief ad lifecycle callbacks. | Transitive dependency | Standard (No declaration) |
| `android.permission.RECEIVE_BOOT_COMPLETED` | Play Services Ads | Background ad schedule reconciliation. | Transitive dependency | Standard (No declaration) |

---

## 3. Explicitly Removed Permissions (`tools:node="remove"`)

The following permissions were introduced by third-party plugins but are **NOT** required by Doc View and have been removed:

1. **`android.permission.READ_MEDIA_IMAGES`**:
   - *Removed from*: `open_filex`
   - *Rationale*: Doc View accesses documents via `MANAGE_EXTERNAL_STORAGE`; media store image queries are redundant.
2. **`android.permission.READ_MEDIA_VIDEO`**:
   - *Removed from*: `open_filex`
   - *Rationale*: Doc View is a document reader, not a video player.
3. **`android.permission.READ_MEDIA_AUDIO`**:
   - *Removed from*: `open_filex`
   - *Rationale*: Doc View does not play audio files.
4. **`android.permission.FOREGROUND_SERVICE`**:
   - *Removed from*: `androidx.work:work-runtime`
   - *Rationale*: Doc View does not execute background foreground tasks. The ongoing notification is an alert, not a long-running OS foreground service. Prevents Google Play Policy rejection.

---

## 4. Hardware Feature Fallbacks

```xml
<uses-feature android:name="android.hardware.camera" android:required="false"/>
<uses-feature android:name="android.hardware.camera.autofocus" android:required="false"/>
```
This guarantees devices without a physical camera (e.g. Chromebooks, tablets) can download and use Doc View for all document reading and management functions.
