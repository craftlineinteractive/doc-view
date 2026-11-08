# Task Plan: Phase 2 (R-C) - Launch Flow, Home, Search, Category File Lists, PDF Thumbnails & Tests

## Global Constraints & Rules
- UI layer only. Keep all existing behavior, providers, services, DB, scanner, isolates and tests working.
- Tools tab has EXACTLY 4 tools (Image to PDF, Scan to PDF, Merge PDF, Split PDF).
- Android first and iOS with the same UI; no iPhone chrome.
- Isolate safety: top-level/static functions only receiving primitives or plain DTOs.
- No new packages. Use already installed `pdfrx` for PDF thumbnails.
- Const constructors; no logic in build(); touch targets >= 48x48; skeletons (no spinners); respect reduced motion; no overflow at text scale 2.0.
- Run `flutter analyze` after each numbered step and fix all issues before proceeding.

## Implementation Steps

- [x] **Step 1: Splash Screen Redesign (`doc_view_mockups/01_launch/01_splash`)**
  - Path: `lib/features/splash/splash_screen.dart`
  - Wordmark "Doc View" on ONE line in Space Grotesk 32pt Bold.
  - Subtle floating pages / documents decoration, radial glow (Light `#E9F2FF`, Dark `#1E2A45`).
  - 120pt horizontal shimmer sweep line.
  - Version text "Version 1.0.0" from package_info_plus if available, else AppConstants.
  - Startup gate: minimum 1000ms display + await DB open + settings loaded + onboarding status.
  - Verification: `flutter analyze` clean, test startup route resolution.

- [x] **Step 2: Onboarding Flow Redesign (`doc_view_mockups/01_launch/02_onboarding_1`, `03_onboarding_2`, `04_onboarding_3`)**
  - Path: `lib/features/onboarding/onboarding_screen.dart`, `lib/features/onboarding/widgets/*`
  - 3-step `PageView` with shared page container and bottom navigation controls.
  - Pages 1 & 2: top right "Skip" button.
  - Page 3: top left back button, "Step 3 of 3" counter, and "Get Started" CTA button.
  - Page indicator: 3 dots with active 24x6pt elongated pill (`#1A66E8`) and 6x6pt inactive dots.
  - Custom illustrations built with Flutter widgets/CustomPaint (zero images, zero new packages).
  - Page 3 displays exactly the four tools (Image to PDF, Scan to PDF, Merge PDF, Split PDF).
  - Persist `onboarding_complete` flag via shared_preferences / SettingsRepository.
  - Verification: `flutter analyze` clean.

- [x] **Step 3: Permissions & Privacy Flow (`doc_view_mockups/01_launch/05_permissions_privacy`)**
  - Path: `lib/features/permissions/permissions_screen.dart`
  - Frame A (Android): "All files access" (`MANAGE_EXTERNAL_STORAGE`) explainer card with icon, rationale, "Grant Access" and "Not Now" buttons.
  - Frame B (iOS): Document import and file sharing guide (never shown on Android).
  - Frame C ("Free with ads"): Explainer shown after onboarding and before app shell. UI only (no consent SDK yet).
  - Reuse existing permission providers / requests.
  - Verification: `flutter analyze` clean.

- [x] **Step 4: Home Screen Redesign & State Variants (`02_home/01_home_all_files`, `02_home_state_variants`)**
  - Path: `lib/features/home/home_screen.dart`
  - Header: gradient background, Space Grotesk "Doc View" headline, search action button.
  - 4x2 Category Grid: $32 \times 38\text{pt}$ format cards, $20\text{pt}$ radius container, label, and document counts.
  - Underline tabs: "Recent" and "Bookmarks" with selection/sort action icon.
  - File rows using `FileRow` with $48 \times 56\text{pt}$ preview thumbnails and format pill badges.
  - Native ad placeholder row (`NativeAdRow`) inserted after the 4th Recent item.
  - Docked AdMob banner slot (60pt) directly above bottom nav bar.
  - FAB: primary blue '+' button positioned with $\ge 16\text{pt}$ clearance from any ad widget.
  - Implement all 6 states: populated, bookmarks empty, recent empty, scanning (progress banner + shimmer count badges), permission gate, and full skeleton state.
  - Verification: `flutter analyze` clean, all 60 tests pass.

- [x] **Step 5: Search Screen Redesign (`03_search/01_search_states`)**
  - Path: `lib/features/search/search_screen.dart`, `lib/features/search/widgets/*`
  - Implement all 5 states:
    1. Empty query with Recent Searches (last 10 queries persisted in SharedPreferences) + "Clear" button.
    2. Typing / Active search: real-time filtered results highlighting matched text with bold primary blue style.
    3. No results state: search illustration + "No matching documents found".
    4. Loading skeleton state (`SkeletonFileRow`).
    5. Keyboard active state with responsive layout and clear search button.
  - Native ad placeholder (`NativeAdRow`) strictly at result position 6 only. No docked banner.
  - Verification: `flutter analyze` clean.

- [x] **Step 6: Category File Lists & Image Photo Grid**
  - Path: `lib/features/files/files_screen.dart`, `lib/features/files/widgets/sort_bottom_sheet.dart`
  - Document lists (PDF, Word, Excel, PPT, TXT):
    - SubAppBar with category title + file count ("PDF • 92 files"), search icon, sort icon, selection icon.
    - `FileRow` items with `NativeAdRow` after 4th and every 8th item.
    - Skeletons and empty states.
  - Image category: 3-column thumbnail grid with 4pt gaps.
    - `ResizeImage` with `cacheWidth: 300`, `gaplessPlayback: true`, error fallback.
    - Long-press selection mode showing top-right check badge on selected thumbnails.
  - Sort bottom sheet: Date, Name, Size (Ascending/Descending), wired to `sortOptionProvider`.
  - Verification: `flutter analyze` clean, all 60 tests pass.

- [x] **Step 7: pdfrx-based PDF Thumbnail Source (`ThumbnailSource`)**
  - Path: `lib/shared/widgets/tiles/pdf_thumbnail_source.dart`, `lib/shared/widgets/tiles/file_thumbnail.dart`
  - Concurrency limit: maximum 2 PDF renders at a time using a queue.
  - Render small size (~144px width) for visible rows only.
  - Disk cache in app cache directory (`/cache/pdf_thumbnails/`) keyed by pure Dart hash of `(path + modified + size)`.
  - Cache size cap 100 MB with oldest-first eviction on startup.
  - 3-second timeout, error or encrypted PDF gracefully returns null (falls back to red PDF type glyph).
  - Verify scrolling in profile mode (`flutter run --profile`).
  - Verification: `flutter analyze` clean.

- [x] **Step 8: Automated Widget & Integration Tests**
  - Path: `test/phase2_redesign_test.dart`
  - Tested Home states (populated with NativeAdRow, empty recent, empty bookmarks).
  - Tested Search states (recent searches, query matching, bold blue highlight, no results).
  - Tested Image category 3-column grid and selection mode.
  - Tested Onboarding 3-step navigation, Skip, Step 3 of 3, 4 tools, and persistence.
  - Tested PDF ThumbnailSource fallback to red PDF glyph.
  - Verified all 67 tests in the suite pass (100% pass rate).
  - Verification: `flutter test` and `dart analyze` clean (0 errors, 0 warnings).
  - Live emulator verification on `emulator-5554` with screenshots captured.
