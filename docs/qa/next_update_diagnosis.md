# Doc View: 1.0.0 Release Diagnosis & Root Cause Audit

**Document Date:** 2026-11-26  
**Auditor:** Systematic Debugging Specialist & Senior Flutter Mobile Architect  
**Target Package:** `com.craftlineinteractive.docview`  
**Shipped Version:** 1.0.0 (Build 1) -> Target Version: 1.0.1 (Build 2)  

---

## Part A1: Test Realism Audit

### Audit Table: Test Realism vs Play Tester Experience

| Feature | Tests Covering It | Execution Mode (Real Service/Files vs Fakes) | Why Play Testers Failed While Tests Passed |
|---|---|---|---|
| **Scan to PDF** | `test/features/tools_test.dart` | **Fakes Only**: Tests only assert tile visibility in `ToolsScreen` using `Key('tool_scan_to_pdf')` and mock DocFiles. | Never invoked `_onScanToPdf` or `CunningDocumentScanner` in test. In real release, missing camera/scanner result handling, URI schemes (`file://`, `content://`), or scanner exceptions thrown from platform channel caused catch-all `importFailedError`. |
| **Image to PDF** | `test/features/tools_test.dart`, `test/features/tools/tool_contract_test.dart` | **Fakes / Mocks**: UI pumps with mock DocFiles. Service tests used synthetic byte buffers without permission barriers. | Real picker returns varied file schemes or paths on external storage (`/storage/emulated/0/...`). Without All Files access, reading images directly fails with `EACCES (Permission denied)`. |
| **Create PDF** | `test/features/tools/create_pdf_screen_test.dart`, `test/features/tools/create_pdf_service_test.dart` | **Fakes Only in Screen Test**: `_MockCreatePdfService` returned dummy `DocFile(path: '/mock/path/...')`. Service test used `_TestPdfOutputService` overriding `getOutputDir` to temp directory. | The real UI wiring was never tested against the real `CreatePdfService`, real `PdfOutputService`, and SQLite repository together. If `created/` directory creation had permission/timing flaws or `Isolate.run` encountered release worker constraints, generic `generationFailed` was thrown. |
| **PDF to Word** | `test/features/tools/convert/pdf_to_word_screen_test.dart` | **Fakes Only**: Tests pumped screen with `initialFile` supplied directly in constructor. | Tests bypassed `_pickFile()`! In production, tapping "Select PDF" pushes `/tools/pick`, which calls `Navigator.pop(selectedList)` returning `List<DocFile>`. But `_pickFile()` used `context.push<DocFile?>('/tools/pick')`. The type mismatch resulted in `null` or unhandled cast exception, leaving the user on the exact same "Select PDF" page. Pressing Back on the empty screen exited to Tools, and pressing Back on Tools exited the app because `MainShell` lacked `PopScope`. |
| **Merge PDF** | `test/unit/pdf_merge_split_logic_test.dart`, `test/features/tools_test.dart` | **Synthetic in Unit Test; Fakes in UI**: Pure Dart byte merging tested; UI used `_mockDocFile`. | In release, inputs on external storage without `MANAGE_EXTERNAL_STORAGE` cannot be opened directly if passed by absolute path instead of copied through app cache. |
| **Split PDF** | `test/unit/pdf_merge_split_logic_test.dart`, `test/features/tools_test.dart` | **Synthetic in Unit Test; Fakes in UI**: Pure logic tested; UI used `_mockDocFile`. | Same as Merge: direct access to raw paths without caching fails when All Files Access is denied. |
| **Manage Pages** | `test/features/pages_screen_test.dart` | **Mocks / In-Memory**: Tests pump `PagesScreen` with in-memory DocFiles. | Real file modifications require permission if replacing original on external storage. |
| **Annotate** | `test/features/tools/annotate/annotate_screen_test.dart` | **Mocks / In-Memory**: Screen tested with mock files and simulated sessions. | The feature was blocked for real testers because `isPremium` was false and `locksActive` redirected to `/premium` where navigation/purchase state delayed or failed. |
| **Add Text** | `test/features/tools/add_text/add_text_screen_test.dart` | **Mocks / In-Memory**: Screen tested with mock files. | Dragging triggered state rebuilds per pan update without `RepaintBoundary` isolation. Pixel transforms on rotated pages were only partially validated. |
| **Sign** | `test/features/tools/sign/sign_screen_test.dart` | **Mocks / In-Memory**: Tested with mock DocFiles and fake signature repo. | Gated behind premium lock; could not be tested by internal testers due to gate behavior. |
| **Print** | `test/features/tools/print_pdf_service_test.dart` | **Mocks Only**: Intercepts `Printing` method calls via test channel. | Real Android print spooler interaction was never executed in release. |
| **Import** | `test/features/tools_test.dart` | **Fakes Only**: Tests only assert tile presence. | `ImportService` without All Files Access cannot access external directories directly. |
| **Recycle Bin** | `test/data/trash_service_test.dart`, `test/features/tools/recycle_bin_screen_test.dart` | **Temp Directory**: Unit tests used temp folder and mock repo. | Files on non-accessible external storage cannot be moved or deleted without app-private staging. |
| **Open-with** | `test/widgets/deep_link_test.dart` | **URL Deep Links Only**: Tests tested `docview://home`, `docview://search`. | Zero tests for `android.intent.action.VIEW` with `content://` or `file://` schemes. On cold start, `SplashScreen` executed `context.go('/home')` after 1.2s, overwriting any viewer route opened by `_handleOpenedFile`. |
| **Premium Page** | `test/features/premium/premium_screen_test.dart` | **Fakes Only**: Tests used `FakePurchaseGateway` with pre-populated dummy products. | Real Google Play Billing takes 1.5–3 seconds to query products on a cold connection. Because billing wasn't pre-warmed, users saw "Subscriptions will be available soon" or blank lines while loading. |
| **Ads** | `test/ads/ad_placements_and_caps_test.dart`, `test/ads/consent_flow_test.dart` | **Fakes Only**: Tests simulated consent and used debug test unit IDs. | In release builds, empty `ADMOB_*_ID` compile definitions intentionally disable all ad placements. Testers running standard release builds had empty IDs, resulting in zero ads. |
| **Widgets** | `test/widgets/widget_data_store_test.dart` | **SharedPreferences JSON Test Only**: Verified JSON schema. | Android AppWidget XML layouts, `RemoteViewsService`, and `WidgetConfigActivity` were never tested in Flutter test harnesses. |
| **Viewers' Menus** | `test/features/viewer_test.dart` | **Isolated Dialogs**: Tested `PdfPasswordDialog.show`, `PdfGoToPageDialog.show`. | The top-right 3-dot `PopupMenuButton` in `PdfViewerScreen`, `OfficeViewerScreen`, `SpreadsheetViewerScreen`, and `TxtViewerScreen` was **never tapped** in any test! `ImageViewerScreen` used a bottom sheet (`PdfMoreSheet`), whereas other viewers had broken or unresponsive popup menus. |

### Why Tests Stayed Green While Shipped Build Failed
1. **Pervasive Mocking at Screen Boundaries**: Almost all widget tests injected mock repositories or services that bypassed actual platform channels, file system I/O, and isolate invocation.
2. **Missing Navigation Integration Tests**: Tests verified screens in isolation (`home: const Screen()`) rather than walking through GoRouter stack transitions. Thus, type mismatches (such as `List<DocFile>` popped into `DocFile?`) and missing `PopScope` on `MainShell` went undetected.
3. **Environment Assumptions**: Automated tests run on host OS with full file read/write permissions, whereas Android 11+ enforces scoped storage restrictions and revocable permissions.
4. **Obfuscation & Release Optimization**: Unit tests run in debug JIT mode without R8 code shrinking, string stripping, or release isolate constraints.

---

## Part A2: Release-Like Build & QA Matrix

### Build Command
```powershell
flutter build appbundle --release --obfuscate --split-debug-info=../docview_symbols `
  -PallowTestAdIds=true -PallowDebugSigning=true
```
Or for connected emulator (`x86_64`):
```powershell
flutter build apk --release --obfuscate --split-debug-info=../docview_symbols `
  --target-platform android-x64 -PallowTestAdIds=true -PallowDebugSigning=true
```

### QA Execution Matrix

| Test Scenario | Permission: All Files Granted | Permission: All Files Denied | Device / OS Version | Premium State | Result / Observation |
|---|---|---|---|---|---|
| **P0: PDF to Word picker & back** | Pass | Fail (prior to fix) | emulator-5554 (API 36) | Free (locks inactive) | Shows Select PDF -> pick fails due to type cast -> back exits app due to missing PopScope |
| **P0: Tool File Operations** | Pass | Fail (prior to fix) | emulator-5554 (API 36) | Free | External files thrown `EACCES` when opened directly |
| **P0: Premium Pricing Load** | N/A | N/A | emulator-5554 (API 36) | Free -> Querying | Shows "Subscriptions available soon" flash before connection |
| **P0: Open from Files / External** | Pass | Fail (prior to fix) | emulator-5554 (API 36) | Any | Cold start wiped by Splash `context.go('/home')` |
| **P0: Viewer 3-dot Menu** | Pass | Pass | emulator-5554 (API 36) | Any | 3-dot PopupMenuButton non-functional or inconsistent with Image Viewer |
| **P0: PPTX Extra Whitespace** | Pass | Pass | emulator-5554 (API 36) | Any | Bottom of 3-slide and 20-slide PPTX scrolls far past content into blank space |
| **P0: Dark Mode Palette** | Pass | Pass | emulator-5554 (API 36) | Any | Borders, icons, and text leak blue/blueTint instead of clean neutral surfaces |

*Note on Android versions:* Local Android SDK has `android-36` and `android-36.1` installed (`Medium_Phone_API_36.1` and `Pixel_6`). Older system images (`android-30`, `android-34`) are not installed locally and are marked NOT TESTED (Physical/Old AVD) in `docs/release/qa_backlog.md`.

### Release-Safe Logging Implementation
Added `AppLog.e(area, reasonName, error, stack)` in `lib/core/utils/app_log.dart`:
- Emits release logcat messages under tag `DocView.<area>`.
- Strictly redacts all file paths, user document titles, and personal data.
- Logs only the typed reason name and the exception type (e.g. `[Tools] save_failed (error: FileSystemException)`).

---

## Part A3: Root Cause Analysis

### Issue 1: Navigation and Premium Gate & Tool Failures
- **Steps to reproduce:**
  1. Open app, go to Tools tab.
  2. Tap "PDF to Word".
  3. Screen shows "Select PDF" button. Tap "Select PDF".
  4. Select a PDF file and tap "Select".
  5. Screen returns to the exact same "Select PDF" screen.
  6. Press Android hardware Back button -> returns to Tools.
  7. Press Android hardware Back button on Tools -> app unexpectedly closes.
- **Expected:** Tapping "Select PDF" picks the file and navigates to conversion options. Pressing Back on Tools returns to Home tab (tab 0).
- **Actual:** User is stuck on "Select PDF". Back closes app.
- **Root Cause (File:Line):**
  1. `lib/features/tools/convert/pdf_to_word_screen.dart:138`:
     `final result = await context.push<DocFile?>('/tools/pick', ...);`
     `ToolFilePickerScreen` (`lib/features/tools/widgets/tool_file_picker_screen.dart:141`) calls `Navigator.of(context).pop(selectedList)` where `selectedList` is a `List<DocFile>`. A `List<DocFile>` cannot be cast to `DocFile?`. The awaited push completes with `null` or raises a cast exception, keeping `_selectedFile` null.
  2. `lib/features/shell/main_shell.dart:23`:
     `MainShell` has no `PopScope`. On Android, pressing the Back button on tab index 1 (Tools) or 2 (Settings) pops the host activity because `StatefulShellRoute` does not intercept Back by default.
  3. For Scan to PDF and Create PDF:
     `lib/features/tools/tools_screen.dart:85`: catch-all `catch (_)` maps any scanner or file error to generic `importFailedError`.
     `lib/data/services/pdf/pdf_output_service.dart`: without handling external storage permissions, reading input files directly from external storage fails when All Files Access is denied.

### Issue 2: Premium Prices Delay
- **Steps to reproduce:**
  1. Cold start app without active network or on fresh install.
  2. Navigate to Premium screen.
- **Expected:** Prices and plans appear immediately from cache or with a shimmer skeleton, with clear loading indicators.
- **Actual:** Screen flashes "Subscriptions will be available soon" disabled state, then 2 seconds later jolts into plan cards once billing queries finish.
- **Root Cause (File:Line):**
  - `lib/features/premium/premium_screen.dart:499`:
    `if (!isProductSeen) Container(key: Key('premium_disabled_state'), ... Text(l10n.premiumSubscriptionsAvailableSoon))`
  - `lib/data/services/billing/premium_controller.dart:200`:
    `PremiumController` is not pre-warmed on app launch. The store is queried only when the screen is watched. Furthermore, plans and price strings were not cached in `SharedPreferences`.

### Issue 6: Open Files From Outside
- **Steps to reproduce:**
  1. Open a PDF from WhatsApp, Files, or Gmail using "Open with Doc View".
- **Expected:** Doc View opens directly into `PdfViewerScreen` with the document.
- **Actual:** App opens to Splash/Home; the external file is ignored or flashes and disappears.
- **Root Cause (File:Line):**
  1. `lib/app.dart:90`:
     On cold start, `openWithService.getInitialFile()` retrieves the path and pushes `/viewer`. However, `SplashScreen` (`lib/features/splash/splash_screen.dart`) concurrently runs its 1200ms timer and calls `context.go('/home')`, replacing the route stack and destroying the viewer.
  2. `android/app/src/main/AndroidManifest.xml:56`:
     Intent filter only listens for `ACTION_VIEW` on specific MIME types; missing `ACTION_SEND`, `ACTION_SEND_MULTIPLE`, `application/octet-stream` with extension matching, and `application/rtf`.
  3. `android/app/src/main/kotlin/com/craftlineinteractive/docview/MainActivity.kt:165`:
     `queryFileName` returns `"opened_file"` without extension if content resolver does not provide `DISPLAY_NAME`, leading to categorization failure in `ImportService`.

### Issue 7: PPTX Extra Whitespace
- **Steps to reproduce:**
  1. Open any presentation (e.g. 3-slide or 20-slide PPTX) in Office viewer.
  2. Scroll down past the final slide.
- **Expected:** The presentation stops cleanly below the last slide with standard padding.
- **Actual:** User can scroll hundreds of pixels into empty white/gray space.
- **Root Cause (File:Line):**
  - `packages/offline_document_viewer/assets/viewers/pptx.js:64`:
    `slide.style.transform = 'scale(' + scale + ')';`
    `slide.style.marginBottom = (16 - height * (1 - scale)) + 'px';`
    In WebKit / Chromium WebView, applying negative bottom margin on elements with CSS scale transforms does not collapse the scrollable bounding box of `#stage` or the document body. The container's scroll height retains the unscaled layout height of all slides combined. Setting explicit container height or wrapping each slide in an overflow-hidden wrapper is required.

### Issue 8: Viewers Three-Dot Menus
- **Steps to reproduce:**
  1. Open a document in PDF, Office, Spreadsheet, or TXT viewer.
  2. Tap the top-right 3-dot icon.
- **Expected:** A clean, accessible options sheet opens (Share, Bookmark, Details, Open in another app, etc.).
- **Actual:** In PDF, Office, Spreadsheet, and TXT viewers, 3-dot does nothing or pops an inconsistent `PopupMenuButton` that fails touch targets and contrast, while `ImageViewerScreen` cleanly opens `PdfMoreSheet`.
- **Root Cause (File:Line):**
  - `lib/features/viewer/pdf_viewer_screen.dart:711`:
  - `lib/features/viewer/office_viewer_screen.dart:441`:
  - `lib/features/viewer/spreadsheet_viewer_screen.dart:567`:
  - `lib/features/viewer/txt_viewer_screen.dart:898`:
    All four screens use `PopupMenuButton<String>` with disparate item lists and no shared bottom sheet, whereas `lib/features/viewer/image_viewer_screen.dart:289` calls `PdfMoreSheet.show(...)`.

### Issue 9: Ads Not Showing and App Open Ad
- **Steps to reproduce:**
  1. Run release build.
  2. Navigate Home, Tools, or export documents.
- **Expected:** Ads appear on allowed surfaces according to frequency caps.
- **Actual:** Zero ads appear.
- **Root Cause (File:Line):**
  - `lib/core/config/ad_config.dart:27-32`:
    Release ad unit IDs default to empty strings when `--dart-define` is not passed. By design, empty ID means "placement off". Build scripts did not enforce or automate reading from a configuration file.
  - App Open ad was not implemented in `AdService` or `AdConfig`.

### Issue 13: Dark Mode Colors
- **Steps to reproduce:**
  1. Switch app theme to Dark mode in Settings.
  2. View Home, Settings, Tools, or lists.
- **Expected:** Clean dark navy surfaces with neutral borders, neutral text, and neutral icons. Blue reserved strictly for primary interactive actions and selections.
- **Actual:** Everything looks blue-tinted. Borders are blue-gray, list icons are blue, headers have blue tint.
- **Root Cause (File:Line):**
  - `lib/core/theme/doc_view_colors.dart:33`: `hairlineDark = Color(0xFF2A3042)` is blue-gray instead of neutral `#FFFFFF1F`.
  - `lib/core/theme/app_theme.dart:203`: `ColorScheme.fromSeed(seedColor: primaryBlue)` leaks blue into `surfaceTint`, `outline`, and `secondary`.
  - `lib/shared/widgets/tiles/settings_row.dart:83-84`:
    `iconColor ?? tokens.primaryBlue` and `iconBgColor ?? tokens.blueTint` forces all settings icons to blue tint.

---

## Hypotheses Matrix (A3 Checklist)

| Hypothesis | Description | Verdict | Evidence |
|---|---|---|---|
| **H1** | Writes outside app-private storage needing All Files access | **CONFIRMED** | Tools attempted direct operations on public storage paths; failed with `EACCES` when permission revoked. |
| **H2** | R8 or obfuscation hazards (enum `.toString()`, `runtimeType`) | **CONFIRMED** | `runtimeType == other.runtimeType` in models and `.toString()` checks in catch clauses break under obfuscation. |
| **H3** | Scanner returning `file://`, `content://`, or cache paths | **CONFIRMED** | Cunning scanner returns raw URIs that standard `File(path)` fails to open without normalization. |
| **H4** | Isolate or compute issues in release | **CONFIRMED** | `Isolate.run(() => worker(params))` closures inside instance methods captured `this` (`CreatePdfService`, `PdfToWordService`), which contained SQLite handles and Riverpod `Ref`, throwing `ArgumentError: Illegal argument in isolate message` in AOT release builds. Fixed by moving isolate dispatch to standalone top-level functions `dispatchCompileTemplatePdf` and `_dispatchPdfToWordConversion`. |
| **H5** | Missing output directories | **CONFIRMED** | If `created/` or `opened_with/` directories did not exist, writing failed without `create(recursive: true)`. |
| **H6** | Split-APK or ABI issues | **RULED OUT** | Both universal and ABI-specific APKs package 64-bit binaries properly. |
| **H7** | GoRouter redirect replacing stack & PopScope blocking | **CONFIRMED** | Child route navigators lacked local `PopScope`, exiting on back from Tools/Settings; `PdfToWord` type cast caused silent loop. |
| **H8** | Intent filters or missing `onNewIntent` | **CONFIRMED** | Missing `ACTION_SEND`, `application/octet-stream`, and cold-start splash wipe. |
| **H9** | Release builds with empty ad unit IDs | **CONFIRMED** | Empty dart-define strings disable placements by design; build scripts lacked validation. |
| **H10** | Missing runtime Camera permission before scanning | **CONFIRMED** | Scan to PDF called `cunning_document_scanner` directly without requesting Android runtime `CAMERA` permission first, causing immediate failure when permission had not been previously granted. Fixed by requesting `Permission.camera.request()` in `DocumentScannerFacade`. |
