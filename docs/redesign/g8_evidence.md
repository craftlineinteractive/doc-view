# Phase G8 Evidence: Native Android App Widgets & Quick Access Notification

## 1. Executive Summary

Phase G8 delivers native Android Home Screen App Widgets and an ongoing Quick Access notification for fast, convenient entry points into Doc View:

- **App Widget 1: Recent Files (4 × 2 / 3 × 2)**:
  - Displays up to 5 recently opened files with colored file-type badges (PDF, DOCX, XLSX, PPTX, TXT, IMG), truncated title, and relative timestamp (e.g. `2m`, `1h`, `Yesterday`).
  - Tapping any file row dispatches `docview://open?id=$id` deep link opening the file directly in the viewer.
  - Tapping the widget header opens Doc View Home (`docview://home`).
  - Empty state when no recent files exist.
  - Enforces strict user privacy: file paths are completely stripped; only `{id, name, type, modified}` is shared with the widget provider.
- **App Widget 2: Quick Tools (4 × 1)**:
  - Horizontal row of 4 circular tool buttons: **Scan**, **Image to PDF**, **Search**, **Import**.
  - Deep-link dispatches: `docview://tools/scan`, `docview://tools/image-to-pdf`, `docview://search`, `docview://tools/import`.
- **Quick Access Ongoing Notification**:
  - Low-importance persistent notification in notification tray with Doc View brand icon and 3 action buttons: **Scan**, **Image to PDF**, **Search**.
  - Toggled ON/OFF in Settings → General → "Quick access notification" adaptive switch row (default OFF).
  - Respects Android 13+ (API 33+) runtime `POST_NOTIFICATIONS` permission with graceful fallback dialog and settings guidance.
  - Low importance (`Importance.low`), low priority (`Priority.low`), ongoing sticky flag (`ongoing: true`), and private visibility. Re-posts on next app start if enabled.
- **Settings & Add Widget Sheet**:
  - Settings row under Others: "Add Widget" opens `AddWidgetBottomSheet` modal.
  - PageView carousel displaying live preview cards of both 4 × 2 and 4 × 1 widgets with active page indicator dots.
  - Sticky primary CTA: "Add widget" invokes Android `AppWidgetManager.requestPinAppWidget()` when supported (Android 8.0+ / API 26+), or presents step-by-step manual home screen launcher guide when not supported.
  - Verified for accessibility, RTL layout, and zero text overflow at 2.0x font scaling.

---

## 2. Commit Inventory: Files Added by `ebd1d9b` and `aaa66fc`

### Files Added in Commit `ebd1d9b`:
- **Android Manifest & Native App Widgets**:
  - `android/app/src/main/res/layout/widget_recent_files.xml` (RemoteViews 4x2 layout)
  - `android/app/src/main/res/layout/widget_quick_tools.xml` (RemoteViews 4x1 layout)
  - `android/app/src/main/res/xml/recent_files_widget_info.xml` (AppWidgetProviderInfo metadata)
  - `android/app/src/main/res/xml/quick_tools_widget_info.xml` (AppWidgetProviderInfo metadata)
  - `android/app/src/main/kotlin/com/craftlineinteractive/docview/RecentFilesWidgetReceiver.kt` (Widget update broadcast receiver)
  - `android/app/src/main/kotlin/com/craftlineinteractive/docview/QuickToolsWidgetReceiver.kt` (Widget update broadcast receiver)
  - `android/app/src/main/res/drawable/ic_widget_scan.xml`, `ic_widget_image.xml`, `ic_widget_search.xml`, `ic_widget_import.xml`
  - `android/app/src/main/res/drawable/widget_background.xml`, `widget_circle_button.xml`, `widget_item_background.xml`, `widget_tag_background.xml`
  - `android/app/src/main/res/values/colors.xml`, `android/app/src/main/res/values-night/colors.xml`, `android/app/src/main/res/values/strings.xml`
- **Flutter Widget Data Store, Services & UI**:
  - `lib/data/services/widgets/widget_data_store.dart` (Data store managing SharedPreferences JSON)
  - `lib/data/services/widgets/deep_link_service.dart` (Deep link routing & security validation)
  - `lib/data/services/notifications/quick_access_notification_service.dart` (Low-importance ongoing notification service)
  - `lib/features/settings/widgets/add_widget_bottom_sheet.dart` (2-card PageView slider with pin widget CTA)
- **Unit & Widget Test Suites**:
  - `test/widgets/widget_data_store_test.dart` (158 lines, 4 test cases)
  - `test/widgets/deep_link_test.dart` (136 lines, 8 test cases)
  - `test/features/settings/add_widget_sheet_test.dart` (76 lines, 4 test cases)
  - `test/features/settings/quick_access_notification_test.dart` (50 lines, 2 test cases)

### Files Added / Updated in Commit `aaa66fc`:
- `android/app/src/main/kotlin/com/craftlineinteractive/docview/QuickToolsWidgetReceiver.kt` (Package fix to `es.antonborri.home_widget`)
- `android/app/src/main/kotlin/com/craftlineinteractive/docview/RecentFilesWidgetReceiver.kt` (Package fix to `es.antonborri.home_widget`)
- `lib/core/config/feature_flags.dart` (Enabled `widgetsEnabled = true`)
- `lib/features/debug/component_gallery_screen.dart` (Section 17: Widget & Notification QA)
- `docs/redesign/g8_evidence.md` (Initial evidence document)
- `docs/redesign/img/g8/g8_settings_notification_toggle.png` (227 KB)
- `docs/redesign/img/g8/g8_add_widget_sheet.png` (171 KB)
- `docs/redesign/img/g8/g8_quick_tools_sheet.png` (161 KB)
- `docs/redesign/img/g8/g8_notification_tray.png` (289 KB)

---

## 3. Privacy & Security Data Contract

The widget data store enforces strict data minimization:

| Field | Stored in Widget Storage | Description |
|---|---|---|
| `id` | **YES** | Primary key integer/string ID used for database lookup |
| `name` | **YES** | Display filename only (e.g. `Contract_Agreement.pdf`) |
| `type` | **YES** | File type tag string (`pdf`, `docx`, `xlsx`, `pptx`, `txt`, `img`) |
| `modified` | **YES** | Timestamp string for relative time formatting |
| **`path`** | **STRICTLY FORBIDDEN** | Absolute file path is stripped before persistence |

### Removal Triggers & Verified Tests

The widget data store removes files and resets data upon any of the following events:
1. **Recent History Cleared**:
   - Implementation: `FileOperationsController.clearRecentHistory()` invokes `widgetDataStore.clearRecentHistory()`, resetting JSON to `'[]'`.
   - Verified by test: `WidgetDataStore Privacy & Operations Tests clearRecentHistory empties the widget store and updates widget` in `test/widgets/widget_data_store_test.dart`.
2. **File Moved to Recycle Bin**:
   - Implementation: `FileOperationsController.moveToTrash(files)` iterates files and calls `widgetDataStore.removeFile(id)`.
   - Verified by test: `WidgetDataStore Privacy & Operations Tests removeFile removes only the target item and updates widget` in `test/widgets/widget_data_store_test.dart`.
3. **File Deleted from Device/Database**:
   - Implementation: `FileOperationsController.deleteFile(id)` and `deleteFiles(files)` calls `widgetDataStore.removeFile(id)`.
   - Verified by test: `WidgetDataStore Privacy & Operations Tests removeFile removes only the target item and updates widget` in `test/widgets/widget_data_store_test.dart`.
4. **App Data Cleared**:
   - Implementation: Android OS clears `SharedPreferences` upon app data clear, completely wiping widget storage.
5. **Path Privacy Verification**:
   - Verified by test: `CRITICAL PRIVACY TEST: updateRecentFiles NEVER stores file path in widget JSON` in `test/widgets/widget_data_store_test.dart`.

---

## 4. Deep-Link Route Handler & ID Validation

Deep links are handled by `DeepLinkService` (`lib/data/services/widgets/deep_link_service.dart`):

| URI Scheme | Action / Destination | Validation & Fallback |
|---|---|---|
| `docview://home` | `/home` | Direct GoRouter navigation |
| `docview://search` | `/search` | Direct GoRouter push |
| `docview://tools/scan` | `/tools/scan` | Direct GoRouter push |
| `docview://tools/image-to-pdf` | `/tools/image-to-pdf` | Direct GoRouter push |
| `docview://tools/import` | `/tools/import` | Direct GoRouter push |
| `docview://open?id=$id` | `/viewer` with `DocFile` | Validates ID is strictly integer; queries database via repository; if ID is invalid or file missing, safely redirects to `/home` |
| Malformed / Unknown | `/home` | Redirects to `/home` safely |

### Verified Automated Tests (`test/widgets/deep_link_test.dart`):
- `DeepLinkService routes docview://home to /home`
- `DeepLinkService routes docview://search to /search`
- `DeepLinkService routes docview://tools/scan to /tools/scan`
- `DeepLinkService routes docview://tools/image-to-pdf to /tools/image-to-pdf`
- `DeepLinkService routes docview://tools/import to /tools/import`
- `SECURITY: rejects malicious traversal or injection in file id and redirects to /home` (tested with `../../etc/passwd`, `1;DROP TABLE;`, `<script>`, empty)
- `opens viewer when file exists in repository`
- `safely falls back to /home when file does not exist in repository`

---

## 5. Add Widget Sheet Specification

- **UI Structure**: `AddWidgetBottomSheet` (`lib/features/settings/widgets/add_widget_bottom_sheet.dart`).
- **2-Card Slider**:
  - Card 1: 4 × 2 Recent Files Widget preview with 5 mock file rows and relative timestamps.
  - Card 2: 4 × 1 Quick Tools Widget preview with circular buttons (Scan, Images, Search, Import).
- **Controls & Navigation**:
  - Animated PageView carousel with active indicator dots.
  - Primary button: "Add widget" calls `AppWidgetManager.requestPinAppWidget()` via `MethodChannel('com.craftlineinteractive.docview/widgets')`.
  - Fallback dialog: For launchers lacking programmatic pin support, shows "Add from Home Screen: Long press empty area on home screen -> Tap Widgets -> Find Doc View -> Drag to home screen".
- **Verified Tests (`test/features/settings/add_widget_sheet_test.dart`)**:
  - `renders recent files card (4 × 2) and page indicators`
  - `swiping pageview reveals quick tools card (4 × 1)`
  - `renders cleanly at text scale 2.0 without overflow`
  - `renders cleanly under RTL directionality`

---

## 6. Quick Access Ongoing Notification Specification

- **Settings Integration**: Switch under Settings → General → "Quick access notification", default **OFF**.
- **Permission Flow**:
  - On toggle ON: checks Android 13+ `POST_NOTIFICATIONS` permission.
  - If not granted, requests permission via system prompt.
  - If denied, presents dialog with explanation and "Open Settings" button directing to app notification settings.
- **Notification Details**:
  - Channel: `docview_quick_access`, name `Quick Access`, importance `Importance.low` (silent, no sound, no popup banner).
  - Priority: `Priority.low`, visibility: private.
  - Sticky ongoing flag: `ongoing: true`, `autoCancel: false`.
  - Actions (3):
    1. **Scan** (`action_scan` -> `/tools/scan`)
    2. **Image to PDF** (`action_image_to_pdf` -> `/tools/image-to-pdf`)
    3. **Search** (`action_search` -> `/search`)
  - Tap on notification body -> `/home`.
- **Lifecycle & Persistence**:
  - Re-post on next app start: `QuickAccessNotificationService.init()` reads `pref_quick_access_notification_enabled`. If true, automatically re-posts notification.
  - Swipe-away / OS termination: Persistent `ongoing: true` prevents swipe-away on standard Android; if killed by OS or device reboots, the notification is restored when Doc View starts.
- **Verified Tests (`test/features/settings/quick_access_notification_test.dart`)**:
  - `displays Quick access notification switch under General`
  - `displays Add Widget row under Others and opens AddWidgetBottomSheet`

---

## 7. QA Verification Table & Evidence Pack (`emulator-5554`)

All QA verification runs were conducted on `emulator-5554` (AVD: `Medium_Phone_API_36.1`). All 4 screenshot artifacts are strictly `< 300 KB` and located in `docs/redesign/img/g8/`:

| Scenario | Environment / Device | Result | Evidence / Artifact |
|---|---|---|---|
| **Settings: Toggle & Add Widget Row** | `emulator-5554` | **DONE** | `docs/redesign/img/g8/g8_settings_notification_toggle.png` (227 KB) |
| **Add Widget Sheet: 4x2 Recent Files** | `emulator-5554` | **DONE** | `docs/redesign/img/g8/g8_add_widget_sheet.png` (171 KB) |
| **Add Widget Sheet: 4x1 Quick Tools** | `emulator-5554` | **DONE** | `docs/redesign/img/g8/g8_quick_tools_sheet.png` (161 KB) |
| **Notification Tray: 3 Quick Actions** | `emulator-5554` | **DONE** | `docs/redesign/img/g8/g8_notification_tray.png` (289 KB) |
| **Widget Data Privacy (Path Stripped)** | Automated Unit Test | **DONE** | `test/widgets/widget_data_store_test.dart` |
| **Widget Removal on Delete / Trash** | Automated Unit Test | **DONE** | `test/widgets/widget_data_store_test.dart` & `lib/features/providers/providers.dart` |
| **Widget Removal on Clear Recents** | Automated Unit Test | **DONE** | `test/widgets/widget_data_store_test.dart` |
| **Deep Link Routing & ID Security** | Automated Unit Test | **DONE** | `test/widgets/deep_link_test.dart` |
| **Third-Party Launcher Pin Compatibility** | Physical OEM Launchers | `NOT TESTED (physical)` | Added to `docs/release/qa_backlog.md` (Section 2) |
| **OEM Notification Tray Styling** | Physical OEM Hardware | `NOT TESTED (physical)` | Added to `docs/release/qa_backlog.md` (Section 2) |
| **Reboot Receiver Wake on Battery Saver** | Physical Hardware | `NOT TESTED (physical)` | Added to `docs/release/qa_backlog.md` (Section 2) |
