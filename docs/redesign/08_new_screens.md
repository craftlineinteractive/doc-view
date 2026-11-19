# 08. New & Restructured Screens (Phase G2)

This document catalogs every screen and bottom sheet added or restructured in **Phase G2**, mapping each to the existing screen pattern it follows, the shared components reused, the three newly introduced shared components, and the native Android/iOS File Manager integration contract.

---

## Allowed New Shared Components

| Component | Path | Purpose & Accessibility |
| --- | --- | --- |
| `StarRatingBar` | `lib/shared/widgets/settings/star_rating_bar.dart` | 5 tappable star buttons (`>= 48x48` each), localized `"N stars"` semantics, reading-direction RTL ordering, reduced-motion aware (`MediaQuery.disableAnimationsOf(context)` skips scale animation). |
| `LanguageTile` | `lib/shared/widgets/settings/language_tile.dart` | Radio selection row (`>= 56pt` height) matching Scan Settings radio geometry, with native name title, optional English subtitle, optional `(not translated)` debug badge, and full button/selected semantics. |
| `SettingsFooter` | `lib/shared/widgets/settings/settings_footer.dart` | Centered `"Version X.Y.Z (N)"` footer with `"Version X.Y.Z build N"` semantics, debug-only long-press hook for `ComponentGalleryScreen`, and a small `"Open-source licenses"` `TextButton` directly underneath (approved deviation). |

---

## Screen & Sheet Inventory

### 1. Settings Tab (`lib/features/settings/settings_screen.dart`)
- **Existing screen copied**: Previous `SettingsScreen` (`07_settings/01_settings_tab`).
- **Shared components reused**: `DocScaffold`, `SettingsGroupCard`, `SettingsRow`, `SettingsSectionHeader`, `Shimmer`, `SkeletonBox`, `ThemeSelectionSheet`, `AdBannerSlot` (via `DocScaffold`).
- **New shared components used**: `SettingsFooter`.
- **Structure (exact order)**:
  1. **Top group**: `File manager`, `FAQ`, `Share` (hidden when `AppConstants.storeShareUrl` is empty).
  2. **General**: `Scan settings`, `App theme`, `Language` (shown in release only when `> 1` shipped language; always shown in debug), `Rate us`.
  3. **Others** *(hidden entirely when all 4 rows are hidden)*: `Add Widget` (`widgetsEnabled`), `Terms of use` (`termsOfUseUrl`), `Privacy policy` (`privacyPolicyUrl`), `Manage subscriptions` (`premiumEnabled`).
  4. **Footer**: Centered `SettingsFooter` (`Version 1.0.0 (1)` + `Open-source licenses` link).
- **Removed from Settings**: `Import files` (moves to Tools in G4; Home FAB continues importing), `Rescan now` (lives in Scan settings), `Clear recent history` (moved to Scan settings History section), `Send feedback` (lives inside FAQ and Rate drawer).

### 2. Language Screen (`lib/features/settings/language_screen.dart`, route `/settings/language`)
- **Existing screens copied**: `ScanSettingsScreen` (grouped radio card layout) + `SearchScreen` (`DocSearchField` pill search bar).
- **Shared components reused**: `DocScaffold`, `DocSubAppBar`, `DocSearchField`, `SettingsGroupCard`, `DocEmptyState`.
- **New shared components used**: `LanguageTile`.
- **Behavior**:
  - Lists `"System default"` first (resets `localeCode` to `null`), followed by entries from `LanguageCatalog`.
  - Release builds display **only shipped languages** backed by ARB files in `AppLocalizations.supportedLocales`.
  - Debug builds also display `Pseudo-locale (en_XA)` and planned unshipped languages (`hi`, `gu`, `es`, `pt-BR`, `fr`, `de`, `ar`, `id`, `ru`) badged `(not translated)`.
  - Selecting a shipped language (or `en_XA` in debug) updates `localeProvider` live without app restart and persists to `SettingsRepository`.

### 3. Rate Us Drawer (`lib/features/settings/widgets/rate_us_sheet.dart`)
- **Existing screen copied**: `ThemeSelectionSheet` / modal bottom sheets built on `DocBottomSheet`.
- **Shared components reused**: `DocBottomSheet`, `DocTonalButton`.
- **New shared components used**: `StarRatingBar`.
- **Compliance & non-gating rules**:
  - Shows `"Rate Doc View"`, `"Your feedback helps us improve"`, and 5 interactive stars.
  - After selecting **any** star value (1–5), displays a short localized message (high / medium / low wording only) and **always** shows the exact same two equal-size, equal-weight `DocTonalButton` actions in order:
    1. `"Rate on Google Play"` (opens `storeRateUrl`; hidden only when `storeRateUrl` is empty; supports debug override).
    2. `"Help & feedback"` (closes sheet and navigates to `/faq` with `extra: {'fromRating': true}`).
  - Plus a `"Not now"` text button. Never gates routes by star count, never auto-opens the store, and never prompts automatically.

### 4. FAQ with Rating Highlight (`lib/features/settings/faq_screen.dart`, route `/faq`)
- **Existing screen copied**: Existing `FaqScreen` (`07_settings/03_faq`).
- **Shared components reused**: `DocScaffold`, `DocIconButton`, `InfoBanner` (highlight style with `tokens.primaryBlue`).
- **New shared components used**: None.
- **Behavior**:
  - Accepts optional `fromRating` boolean (passed via GoRouter `state.extra`).
  - Normal FAQ (`fromRating == false`) renders without any banner.
  - When `fromRating == true`, displays `InfoBanner` above the topics list with `"Sorry to hear that. Browse the answers below or contact us; we read every message."` and a `"Contact us"` button (launches `mailto:` to `supportEmail` with app version/build in subject & body; hidden when `supportEmail` is empty).

### 5. Scan Settings History Section (`lib/features/settings/scan_settings_screen.dart`)
- **Existing screen copied**: Existing `ScanSettingsScreen` (`07_settings/02_settings_sub_screens`).
- **Shared components reused**: `SettingsSectionHeader`, `SettingsGroupCard`, `SettingsRow`, `showDocConfirmDialog`.
- **New shared components used**: None.
- **Behavior**:
  - Adds a `"History"` section with `"Clear recent history"` reusing the existing destructive confirmation dialog, `FileActionsController.clearRecentHistory()`, and localized snackbar.
  - Keeps `"Rescan now"` on Android and displays the localized `"Last scan: ..."` timestamp subtitle directly underneath.

### 6. Version Footer (`lib/shared/widgets/settings/settings_footer.dart`)
- **Existing screen copied**: Replaces the previous Settings `About` card rows (`Version` and `Open-source licenses`).
- **Shared components reused**: Material `TextButton`, `showLicensePage`, `DocViewTypography`, `DocViewTokens`.
- **New shared components used**: `SettingsFooter`.
- **Approved deviation**: Includes a small `"Open-source licenses"` text link centered underneath `"Version 1.0.0 (1)"` so third-party license attribution remains accessible.

---

## System File Manager MethodChannel Contract

- **Channel Name**: `com.craftlineinteractive.docview/file_manager`
- **Method**: `openSystemFileManager` -> returns `Future<bool>`
- **Android Implementation** (`android/app/src/main/kotlin/com/craftlineinteractive/docview/MainActivity.kt`):
  1. Attempts `Intent(Intent.ACTION_VIEW)` with URI `content://com.android.externalstorage.documents/document/primary%3ADownload` and MIME type `vnd.android.document/directory` (`FLAG_ACTIVITY_NEW_TASK`) — verified in G0 Spike 4 (`docs/spikes/g0_report.md`).
  2. Falls back to URI-only `Intent(Intent.ACTION_VIEW, downloadDocsUri)`.
  3. Falls back to `Intent("android.intent.action.VIEW_DOWNLOADS")`.
  4. If no activity can handle any intent or an exception occurs, catches safely and returns `false` (never crashes).
- **iOS Implementation** (`lib/data/services/file_manager_service.dart`):
  - Attempts `url_launcher` with `shareddocuments://` (`LaunchMode.externalApplication`); returns `false` if unavailable.
- **Dart Fallback** (`SettingsScreen._openFileManager`):
  - If `FileManagerService.openSystemFileManager()` returns `false`, navigates cleanly to the in-app `/directories` screen (`DirectoriesScreen`).

---

## Phase G3a Reader & Pages Screen Upgrades

### 7. PDF Viewer Screen (`lib/features/viewer/pdf_viewer_screen.dart`, route `/viewer/pdf`)
- **Structure**:
  - **Top Bar**:
    - Back button with localized tooltip.
    - Title column: truncated file name (`TextOverflow.ellipsis`) with subtitle `"N Pages • <size>"`.
    - Convert-to-Word icon action: gated strictly behind `feature_flags.dart: conversionsEnabled` (defaults to `false`, enabled in Phase G6; zero dead UI).
    - Pages management icon action: navigates to `/pdf-pages` with file and current page index.
    - 3-dot overflow menu: "Go to page" (opens `PdfPagesSheet`), "Add/Remove bookmark", "Details" (opens `FileDetailsSheet`), and "Open in another app" (delegates via `OpenFilex`).
  - **Viewer Body**:
    - pdfrx `PdfViewer.file` integration with vertical and horizontal reading layout options.
    - Live text search highlighting on canvas via `PdfTextSearcher` match callback.
    - Inverted color filter matrix (`_isInverted` toggled via ColorFiltered matrix for night/high-contrast reading).
    - Floating page pill indicators at bottom and right edge during scroll.
    - Tap canvas to toggle top bar and bottom toolbar chrome.
  - **Bottom Toolbar**:
    - Uses shared `ReaderBottomRow` with 5 items:
      1. Horizontal / Vertical scroll layout toggle.
      2. Orientation lock / rotation toggle (`SystemChrome.setPreferredOrientations`).
      3. Search toggle (reveals `ReaderSearchBar`).
      4. Color invert toggle (visual active state when enabled).
      5. Share document action (invokes `SharePlus`).

### 8. Pages Management Screen (`lib/features/viewer/pages_screen.dart`, route `/pdf-pages`)
- **Route**: `/pdf-pages`, accepts `extra: {'file': DocFile, 'currentPage': int}`.
- **Layout & Responsiveness**:
  - Top AppBar: Back button (with unsaved changes discard confirmation dialog), localized `"Pages"` title, single-level Undo action icon, and tonal FilledButton `"Save"`.
  - Subheader row: Left-aligned localized page count (e.g. `"6 pages"`), Right-aligned `"Select all"` / `"Clear selection"` action.
  - Thumbnail Grid:
    - 3 columns in portrait orientation; 5 columns in landscape orientation.
    - Child aspect ratio 0.72.
    - Reordering via `LongPressDraggable<int>` and `DragTarget<int>` with immediate visual rearrangement.
    - Page number badge (`1`, `2`, ...) at top-left of each tile.
    - Selection indicator ring with primary blue border when tapped.
  - Performance & Caching:
    - Lazy thumbnail rendering with 60-item in-memory LRU thumbnail cache (`_thumbnailCache`).
    - Serialized background render queue (`_renderQueue`) with max concurrency 2 to avoid memory bloat and UI jank.
    - Thumbnail dimensions capped at 240x320 with low memory footprint.
- **Editing Actions (Bottom Row)**:
  - Contextual action bar appears whenever 1 or more pages are selected:
    - **Rotate**: Rotates selected pages clockwise by +90° with instant visual feedback and persistent `PdfPageEditSpec` state.
    - **Extract**: Extracts selected pages into a new document via `PdfPageEditService.extractPages`.
    - **Delete**: Removes selected pages from the document with single-level undo. Hard rule: deleting all pages is blocked with an informative localized error snackbar.
  - When no pages are selected, displays an **Insert** action (supports picking from another PDF document via `FilePicker`).
- **Persistence & Save Flow**:
  - Single-level undo snapshots page ordering, rotations, and deletions.
  - Save action opens a modal dialog:
    - Option 1: "Save as new file" with custom file name input.
    - Option 2: "Replace original file" with atomic isolate-based replace (`PdfPageEditService.saveDocument(replaceOriginal: true)`).
  - Handles Windows and Android file lock safety gracefully.

### 9. PDF More & Pages Bottom Sheets (`lib/features/viewer/widgets/`)
- Fully localized with zero hardcoded strings.
- Clamped text scaling (max 1.3x) to guarantee zero overflows even under extreme pseudo-locales (`en_XA`, RTL) at 2.0x accessibility font scaling.

---

## Phase G3b Office & TXT Viewers Modernization

### 10. Office Viewer Screen (`lib/features/viewer/office_viewer_screen.dart`, route `/viewer/office`)
- **Supported Formats**: Word (`docx`, `docm`, `rtf`, `doc`) and PowerPoint (`pptx`, `pptm`, `ppt`).
- **Structure**:
  - **Top Bar**:
    - Back button with localized tooltip.
    - Title column: truncated file name (`TextOverflow.ellipsis`) with subtitle `"N units • <EXT>"`.
    - Bookmark toggle action.
    - 3-dot overflow menu: "Outline" (conditionally displayed if document outline is available), "Details" (`FileDetailsSheet`), and "Open in another app" (`OpenFilex`).
  - **Viewer Body**:
    - `offline_document_viewer` `DocumentView` integration.
    - Legacy format banner ("Legacy format: text only") preserved for `.doc` and `.rtf`.
    - Tap on document content toggles top bar and bottom toolbar chrome auto-hide.
  - **Bottom Row**:
    - Shared `ReaderBottomRow` with exactly 3 items:
      1. **Rotate**: Toggles portrait and landscape orientations via shared `ReaderOrientationController`.
      2. **Search**: Toggles `ReaderSearchBar`.
      3. **Share**: Invokes `fileActionsControllerProvider.shareFiles`.
    - *(Vertical/Horizontal and Invert are hidden per capability rules due to WebView lack of paging and platform-view color filter bypass)*.
  - **Search**:
    - Shared `ReaderSearchBar` wired to `DocumentViewController.search(query)` and `controller.searchHits`.
    - Chevrons hidden (`showNavigationChevrons: false`) because the web engine does not support step-through cursor navigation.
    - Counter displays localized hit counts ("1 match", "N matches", "0 of 0").
  - **Outline Sheet**:
    - Extracted `OfficeOutlineSheet` (`lib/features/viewer/widgets/office_outline_sheet.dart`) with `Material` root and clamped text scaling (`maxScaleFactor: 1.3`).

### 11. TXT Viewer Screen (`lib/features/viewer/txt_viewer_screen.dart`, route `/viewer/txt`)
- **Supported Formats**: `txt`, `md`, `log`, `csv` fallback.
- **Structure**:
  - **Top Bar**:
    - Back button with localized tooltip.
    - Title column: truncated file name with subtitle `"N units • <EXT>"`.
    - Font size adjusters (A-, A+) and monospace font toggle.
    - Bookmark toggle action.
    - 3-dot overflow menu: "Details" and "Open in another app".
    - 1 MB file size cap notice preserved.
  - **Viewer Body**:
    - Virtualized `ListView.builder` over text lines for zero jank on large files.
    - TextSpan highlighting over visible lines with distinct styling for the active match.
    - `SelectionArea` compatibility preserved.
    - Tap on text surface toggles chrome auto-hide.
  - **Bottom Row**:
    - Shared `ReaderBottomRow` with 4 items:
      1. **Rotate**: Orientation toggle via `ReaderOrientationController`.
      2. **Search**: Toggles `ReaderSearchBar`.
      3. **Invert**: Swaps text canvas background and text colors to the theme opposite (light becomes dark, dark becomes light; session-only).
      4. **Share**: Invokes file sharing.
  - **Search**:
    - Runs in background `Isolate` using top-level function `computeTxtMatches` (primitives only, no captured state).
    - Capped at 500 matches with "500+" counter indicator.
    - Step-through up/down navigation chevrons auto-scroll `Scrollable.ensureVisible` to the matching line.

### 12. Shared Reader Infrastructure (`lib/shared/widgets/reader/`)
- `ReaderOrientationController`: Small controller class managing `SystemChrome.setPreferredOrientations`. Restores all orientations automatically upon dispose and when the app is backgrounded.
- `ReaderBottomRow`: Shared 64pt bottom row with 48x48 icon buttons, outlined icons, and localized labels.
- `ReaderSearchBar`: Top-bar replacement search UI with animated appearance, debounced input, match count, up/down arrows, and clear action.

### 13. Image Viewer & Dispatcher Localization
- `ImageViewerScreen`: All strings extracted to ARB, removed from `pending_rewrite.txt`.
- `ViewerScreen`: Format dispatcher localized, centralized file extension groupings maintained.
