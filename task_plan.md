# Phase 4B Implementation Plan: Open-With, Auto-Rescan, Pull-to-Refresh, Accessibility, Tests & Release Prep

> **Goal:** Implement Phase 4B features in strict sequence:
> 1. Auto rescan on resume (Android 5-minute debounce persisted in SharedPreferences, iOS scanAppDocuments).
> 2. Pull-to-refresh on HomeScreen & FilesScreen with SnackBar scan report.
> 3. Global error handling in `main.dart` with `FlutterError.onError` and `runZonedGuarded` (debugPrint only).
> 4. Comprehensive accessibility audit: semantic labels, tooltips, contrast ratio check (>= 4.5:1), text scale 2.0 layout overflow immunity, and accessibility guideline widget tests.
> 5. Widget test asserting exactly 4 Tools with stable Keys; SDK `integration_test` verifying core app navigation, tools count, and search input.
> 6. Native "Open with Doc Reader" integration via `open_file_handler` with Android Intent Filters, iOS Document Types, lifecycle listeners, and isolated error recovery.
> 7. Release build verification: `flutter analyze`, `flutter test`, `flutter build apk --release`.

**Hard Rules:**
- The Tools tab must remain EXACTLY 4 tools: Image to PDF, Scan to PDF, Merge PDF, Split PDF. Do NOT add or remove tools.
- Touch targets $\ge 48\text{dp}$.
- Follow strict order: Steps 1 -> 2 -> 3 -> 4 -> 5 -> 6.

---

## Tasks

### Phase 1: Auto Rescan on App Resume
- [x] Task 1.1: Persist `last_scan_timestamp` in `SharedPreferences` in `ScannerService` / `app.dart`.
- [x] Task 1.2: Update `_checkAndStartScanOnResume()` in `lib/app.dart`: on Android, if `allFilesAccess` is granted and `DateTime.now().difference(lastScan) > Duration(minutes: 5)`, trigger background scan. On iOS, call `scanAppDocuments()`.

### Phase 2: Pull-to-Refresh
- [x] Task 2.1: Wrap scrollable content in `HomeScreen` (`lib/features/home/home_screen.dart`) with `RefreshIndicator`. On refresh: Android checks permission and runs scan (or displays dialog); iOS runs `scanAppDocuments()`. Display SnackBar: "Scan complete: N files".
- [x] Task 2.2: Wrap `FilesScreen` (`lib/features/files/files_screen.dart`) with `RefreshIndicator` reusing the same centralized scanning flow.

### Phase 3: Global Error Handling & Clean Print Calls
- [x] Task 3.1: Wrap `runApp` in `lib/main.dart` with `runZonedGuarded` and set `FlutterError.onError` logging via `debugPrint`.
- [x] Task 3.2: Audit all `print()` calls in `lib/` and replace with `debugPrint` or remove.

### Phase 4: Accessibility Pass
- [x] Task 4.1: Ensure every `IconButton` across `lib/` has an informative `tooltip` and `semanticLabel`.
- [x] Task 4.2: Update `FileTile` (`lib/features/files/widgets/file_tile.dart`) with comprehensive `Semantics` (e.g. "PDF, <name>, 2.5 MB, modified Oct 23, bookmarked", tap/long-press hints).
- [x] Task 4.3: Update category tiles on Home (`_CategoryTile`) with Semantics ("<Category>, N files") and selection mode announcement ("N selected").
- [x] Task 4.4: Check color contrast in `lib/core/theme/app_theme.dart` ($\ge 4.5:1$ body text contrast) and adjust colors if needed.
- [x] Task 4.5: Verify layouts at text scale 2.0 (Home grid, file tiles, Tools grid, bottom sheets) using `Flexible`/`Wrap`/`ellipsis`.
- [x] Task 4.6: Add accessibility guideline widget tests in `test/widget_test.dart` testing `androidTapTargetGuideline`, `labeledTapTargetGuideline`, and `textContrastGuideline`.

### Phase 5: Tests (Tools 4-Tile Assertion & Integration Test)
- [x] Task 5.1: Add stable Keys to the 4 tool tiles in `lib/features/tools/tools_screen.dart` (`tool_image_to_pdf`, `tool_scan_to_pdf`, `tool_merge_pdf`, `tool_split_pdf`).
- [x] Task 5.2: Write widget test in `test/widget_test.dart` asserting Tools screen shows exactly 4 tools with corresponding labels and keys.
- [x] Task 5.3: Add `integration_test: sdk: flutter` to `pubspec.yaml` and create `integration_test/app_test.dart` testing tab navigation, tools count, and search input.

### Phase 6: Native "Open with Doc Reader"
- [x] Task 6.1: Native method channel service `OpenWithService` with cold/warm start handling.
- [x] Task 6.2: Add Android intent filters in `android/app/src/main/AndroidManifest.xml` (ACTION_VIEW for pdf, docx, xlsx, pptx, doc, xls, ppt, txt, csv, images).
- [x] Task 6.3: Implement intent handling in `android/app/src/main/kotlin/com/craftlineinteractive/docview/MainActivity.kt`.
- [x] Task 6.4: Add CFBundleDocumentTypes in `ios/Runner/Info.plist` and update `ios/Runner/SceneDelegate.swift`.
- [x] Task 6.5: Implement `importFromPath` in `lib/data/services/import_service.dart`.
- [x] Task 6.6: Add cold/warm start listener in Flutter to copy to `imported/`, upsert, and call `openDocument()`.

### Phase 7: Verification & Release Build
- [x] Task 7.1: Run `flutter analyze` & ensure 0 issues.
- [x] Task 7.2: Run `flutter test` & verify all tests pass.
- [x] Task 7.3: Run `flutter build apk` & verify build compiles cleanly.
- [x] Task 7.4: Report files changed and provide manual QA checklist.
