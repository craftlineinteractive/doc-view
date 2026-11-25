# Mobile Security Review & Threat Assessment: Doc View (Android)

## 1. Executive Summary

This security review audits the security posture of Doc View for Android in accordance with OWASP Mobile Top 10, Google Play Policy requirements, and Android security best practices.

---

## 2. Security Assessment Matrix

| Area | Finding | Action Taken | Status |
|---|---|---|---|
| **Data Backup & Extraction** | Default Android backup could leak user digital signatures or back up deleted files to Google Drive. | Configured `res/xml/backup_rules.xml` and `data_extraction_rules.xml`. Explicitly excluded `signatures.json`, `signatures/`, `recycle_bin/`, and `docview.db` from cloud backup and unencrypted device transfer. | **VERIFIED & SECURED** |
| **Cleartext Network Traffic** | Unencrypted HTTP communication exposes users to Man-in-the-Middle (MitM) attacks. | Strict default: `usesCleartextTraffic` is false. All outgoing ad requests (AdMob, UMP) and Play Billing operations use encrypted HTTPS / TLS 1.3. | **VERIFIED & SECURED** |
| **Exported Components** | Overly permissive activity or receiver intent filters could allow malicious apps to access internal app state. | Only `MainActivity` (LAUNCHER, VIEW with specific MIME types) and AppWidget receivers (`APPWIDGET_UPDATE`) are exported. All internal services are non-exported (`exported="false"`). | **VERIFIED & SECURED** |
| **PendingIntent Mutability** | Mutable PendingIntents on Android 12+ (API 31+) permit intent redirection or hijacking. | All widget and notification PendingIntents explicitly set `PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT`. | **VERIFIED & SECURED** |
| **Deep Link Input Validation** | Malicious URIs (e.g. `docview://open?id=../../etc/passwd`) could attempt SQL injection or path traversal. | `DeepLinkService` strictly validates integer ID formats via regex and repository lookups, falling back safely to `/home`. Tested by `test/widgets/deep_link_test.dart`. | **VERIFIED & SECURED** |
| **FileProvider Scope** | Sharing files via broad storage roots exposes sensitive app directories. | FileProvider configured with isolated cache directories for exported and shared files only. | **VERIFIED & SECURED** |
| **Release Logging & Path Leakage** | Console logs in release builds could leak private file paths or names to system logcat. | All debug logging is guarded by `kDebugMode`. Release AOT compilation eliminates debug prints. Verified by logcat review. | **VERIFIED & SECURED** |
| **Secrets & Keys in Repository** | Hardcoded credentials or real AdMob IDs in git risk supply chain leaks and policy strikes. | Scanned repository with automated guardrails (`test/ads/no_real_ad_ids_test.dart`, `test/premium/no_price_literals_test.dart`). Zero secrets in git. Release IDs injected via `--dart-define` and Gradle properties. | **VERIFIED & SECURED** |
| **Android 14 (API 34) Compatibility** | Unspecified broadcast receiver export flags trigger runtime exceptions on Android 14+. | All dynamic receivers registered via Flutter plugins and app code specify `RECEIVER_NOT_EXPORTED` flag. | **VERIFIED & SECURED** |
| **High-Risk Permission Minimization** | Unused media (`READ_MEDIA_*`) and `FOREGROUND_SERVICE` permissions present rejection risk. | Explicitly removed using `tools:node="remove"`. Hardware features declared as non-required (`android:required="false"`). | **VERIFIED & SECURED** |

---

## 3. Threat Modeling & Mitigation Summary

### A. Document Contents Confidentiality
All document indexing, rendering (PDF, Word, Excel, PPTX, TXT), search, and annotations occur locally in memory or app-private storage (`/data/user/0/com.craftlineinteractive.docview/files/`). Document buffers are never transmitted over network sockets or shared with advertising SDKs.

### B. Widget Privacy Data Minimization
The Android App Widget RemoteViews cache (`SharedPreferences`) contains strictly:
- `id`: database primary key
- `name`: display filename
- `type`: file extension category (`pdf`, `docx`, etc.)
- `modified`: timestamp
File paths (`/storage/emulated/0/...`) are explicitly stripped by `WidgetDataStore.updateRecentFiles()`. Verified by automated unit test `test/widgets/widget_data_store_test.dart`.

### C. Signature Security
Signatures created in the Sign tool are vector coordinate arrays saved in internal app-private storage (`signatures.json`). They are excluded from cloud backup rules, ensuring signatures cannot be extracted from cloud account snapshots.
