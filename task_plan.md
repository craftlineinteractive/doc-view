# Task Plan: Doc Reader Phase 2B (Document Viewers)

## Goal
Implement quiet, content-first in-app viewers for PDF, Image, and TXT files, external opening via OpenFilex for Office/other formats, thumbnail caching in FileTile, and file existence verification.

## Architecture & Constraints
- Dark theme & colors from `app_theme.dart` (quiet, content-first, minimal chrome).
- Use `FileActionsController` for bookmarking and opening events.
- No heavy work on the UI thread (isolate decoding for TXT).
- Cache image thumbnails (`cacheWidth: 120`, `gaplessPlayback: true`).
- All touch targets >= 48dp.
- No logic inside `build()`, full async error & loading handling.

## Phases & Tasks
- [x] **Step 0: Packages & Platform Configuration**
  - [x] Add `pdfrx` and `open_filex` via `flutter pub add`.
  - [x] Update iOS deployment target to 15.0 in `ios/Podfile` and `ios/Runner.xcodeproj/project.pbxproj`.
  - [x] Inspect pdfrx documentation and API from pub cache.
- [x] **Step 1: features/viewer/viewer_screen.dart (Dispatcher)**
  - [x] Check `File(path).exists()`. If missing, remove DB row via repository, show SnackBar, pop.
  - [x] Dispatch to `PdfViewerScreen`, `ImageViewerScreen`, `TxtViewerScreen`.
  - [x] For `word`, `excel`, `ppt`, `other`: invoke `OpenFilex.open()`, then pop. If result != done, show SnackBar.
- [x] **Step 2: PdfViewerScreen**
  - [x] `PdfViewer.file` integration with documented API.
  - [x] Minimal AppBar with file name and `FileActionsController.toggleBookmark`.
  - [x] Page indicator overlay pill ("3 / 120") and validated "Go to page" dialog.
  - [x] Password prompt dialog with retry and cancellation handling.
  - [x] Corrupt/unreadable error state with "Open in another app" action.
  - [x] Clean controller disposal.
- [x] **Step 3: ImageViewerScreen**
  - [x] Dark background, `InteractiveViewer` (scale 1 to 5).
  - [x] Double-tap zoom toggle, single tap to toggle chrome (AppBar visibility).
  - [x] `Image.file` with error state.
- [x] **Step 4: TxtViewerScreen**
  - [x] Read file via `Isolate.run`, decode `utf8.decode(..., allowMalformed: true)`.
  - [x] Cap at 1 MB with banner indicator if capped.
  - [x] `SelectionArea` with `ListView.builder` over lines.
  - [x] Font size A- / A+ (12-28) and monospace toggle stored in `SharedPreferences`.
  - [x] Loading & error states.
- [x] **Step 5: Image Thumbnails in FileTile**
  - [x] `cacheWidth: 120`, `fit: BoxFit.cover`, `filterQuality: FilterQuality.low`, `gaplessPlayback: true`.
  - [x] Fallback to category icon on error or non-image types.
- [x] **Step 6: Router Configuration**
  - [x] Replace `/viewer` route in `app_router.dart` with `ViewerScreen` and null safety fallback.
- [x] **Step 7: Verification & Testing**
  - [x] Update unit and widget tests.
  - [x] Run `flutter analyze` and `flutter test`. Ensure 0 errors, 0 warnings.
  - [x] Verify build and test on Android emulator.
