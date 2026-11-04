# Task Plan: Phase 3A (In-app Office Viewers)

## Goal
Replace external app fallback for Word, Excel, and PowerPoint documents with high-fidelity, on-device in-app viewers using `offline_document_viewer`.

## Architecture & Constraints
- Dark theme & colors from `app_theme.dart` (quiet, content-first, minimal chrome).
- Isolate `offline_document_viewer` exclusively inside `lib/features/viewer/office_viewer_screen.dart`.
- Put office extensions in ONE constant in `lib/core/constants/file_types.dart`.
- Exhaustive handling of typed `DocumentFailure` with "Open in another app" fallback button.
- All touch targets >= 48dp.
- No logic inside `build()`, full async error & loading handling.

## Phases & Tasks
- [ ] **Step 0: Package & Platform Verification**
  - [x] Added `offline_document_viewer: ^0.1.0`.
  - [x] Read API and failure hierarchy from pub cache.
- [x] **Step 1: Extension Constants in `core/constants/file_types.dart`**
  - [x] Add `officeViewerExtensions` set and `isOfficeViewerSupported(path)`.
- [x] **Step 2: Implement `features/viewer/office_viewer_screen.dart`**
  - [x] `DocumentView(source: DocumentSource.file(file.path), controller: controller)`.
  - [x] Search AppBar with query submit, clear, and match count badge.
  - [x] Outline bottom sheet when `info.outline` is non-empty with `controller.goTo()`.
  - [x] Bookmark toggle via `FileActionsController`.
  - [x] Placeholder builder with "Opening document...".
  - [x] Exhaustive error builder (`EncryptedDocumentFailure`, `TooLargeFailure`, `UnsupportedFormatFailure`, etc.) with "Open in another app".
  - [x] Truncated banner for spreadsheets (>3000 rows) & legacy text-only banner for `.doc`/`.ppt`.
  - [x] Clean controller disposal.
- [x] **Step 3: Update `viewer_screen.dart` Dispatcher**
  - [x] Route supported office extensions to `OfficeViewerScreen`.
  - [x] Fall back to `open_filex` for unsupported office extensions (odt, ods, odp).
- [x] **Step 4: Settings Screen Licenses**
  - [x] Add "Open-source licenses" tile opening `showLicensePage`.
  - [x] Load and display Liberation font license from bundled package assets.
- [ ] **Step 5: Verification & Tests**
  - [x] Update unit tests in `test/unit_test.dart`.
  - [x] Run `flutter analyze` and `flutter test`. Ensure 0 errors, 0 warnings.
  - [ ] Verify build on emulator.
