# 05. Build Plan: Phased Implementation Roadmap

This document outlines the ordered implementation roadmap for executing the full redesign of **Doc View** to match the approved mockups in `doc_view_mockups/`.

The build is partitioned into 5 subsequent execution phases corresponding directly to prompts `R-B` through `R-F` in `doc_view_mockups/AI_REDESIGN_PROMPTS.md`.

---

## Global Governance & Hard Rules

1. **Strict UI Layer Only**: Existing business logic, databases, repositories, scanner isolates, and riverpod providers must remain functional. Do NOT rename or delete logic contracts.
2. **Tools Contract**: The Tools tab has **EXACTLY 4 tools**: Image to PDF, Scan to PDF, Merge PDF, Split PDF. Never add others (no Compress, Annotate, Sign, OCR, Word to PDF, recycle bin, print).
3. **Isolate Safety**: Any function passed to `Isolate.run` or `compute` must be top-level or static, receiving only primitives, Strings, or plain DTOs without capturing `this` or UI contexts.
4. **Platform Specifics**: Android is the primary platform; iOS must work with the same UI. Do not copy iPhone system chrome (9:41 clock, Dynamic Island, home bar indicator).
5. **No Network Downloads / Bundled Assets**: Bundled offline fonts (Space Grotesk & Inter) only. No runtime font fetching via `google_fonts`.

---

## Phase 1: Foundation, Tokens, Theme & Shared Components (Prompt R-B)

### 1.1 Scope
Establish the design system foundation, asset fonts, theme extensions, component library primitives, unified shimmer animation controller, and ad placeholder widgets. No screen redesigns occur in this phase.

### 1.2 Exact Files Created / Modified
- **Fonts & Assets**:
  - `assets/fonts/Inter-Regular.ttf`, `Inter-Medium.ttf`, `Inter-SemiBold.ttf`, `Inter-Bold.ttf`, `OFL.txt`
  - `assets/fonts/SpaceGrotesk-SemiBold.ttf`, `SpaceGrotesk-Bold.ttf`, `OFL.txt`
  - `pubspec.yaml` (declare font families; check/add `material_symbols_icons` dependency)
- **Theme & Tokens**:
  - `lib/core/theme/doc_view_colors.dart` (Light and Dark color tokens)
  - `lib/core/theme/doc_view_typography.dart` (Space Grotesk + Inter text styles)
  - `lib/core/theme/doc_view_tokens.dart` (`ThemeExtension<DocViewTokens>` for file-type colors, hairlines, divider bands, etc.)
  - `lib/core/theme/app_theme.dart` (Refactored `lightTheme` and `darkTheme` incorporating tokens)
  - `lib/core/theme/app_icons.dart` (Central icon mapping for Material Symbols Outlined)
- **Shared Component Library**:
  - `lib/core/widgets/doc_scaffold.dart`
  - `lib/core/widgets/doc_bottom_nav_bar.dart`
  - `lib/core/widgets/doc_app_bar.dart`
  - `lib/core/widgets/doc_underline_tabs.dart`
  - `lib/core/widgets/doc_filter_chip_row.dart`
  - `lib/core/widgets/doc_breadcrumb_bar.dart`
  - `lib/core/widgets/category_tile.dart`
  - `lib/core/widgets/file_type_badge.dart`
  - `lib/core/widgets/file_row.dart`
  - `lib/core/widgets/folder_row.dart`
  - `lib/core/widgets/file_thumbnail.dart`
  - `lib/core/widgets/buttons/doc_primary_button.dart`
  - `lib/core/widgets/buttons/doc_secondary_button.dart`
  - `lib/core/widgets/buttons/doc_destructive_button.dart`
  - `lib/core/widgets/buttons/doc_icon_button.dart`
  - `lib/core/widgets/buttons/doc_fab.dart`
  - `lib/core/widgets/inputs/doc_search_field.dart`
  - `lib/core/widgets/inputs/doc_text_field.dart`
  - `lib/core/widgets/inputs/doc_segmented_control.dart`
  - `lib/core/widgets/modals/doc_bottom_sheet.dart`
  - `lib/core/widgets/modals/options_list_tile.dart`
  - `lib/core/widgets/modals/doc_dialog.dart`
  - `lib/core/widgets/modals/progress_sheet.dart`
  - `lib/core/widgets/modals/result_sheet.dart`
  - `lib/core/widgets/states/doc_empty_state.dart`
  - `lib/core/widgets/states/doc_error_state.dart`
  - `lib/core/widgets/states/doc_permission_required_state.dart`
  - `lib/core/widgets/skeletons/shimmer_box.dart`
  - `lib/core/widgets/skeletons/skeleton_file_row.dart`
  - `lib/core/widgets/ads/ad_banner_slot.dart`
  - `lib/core/widgets/ads/native_ad_row.dart`
  - `lib/core/widgets/ads/interstitial_placeholder.dart`
  - `lib/core/widgets/tools/tool_card.dart`
  - `lib/core/widgets/tools/reorderable_page_row.dart`
  - `lib/core/widgets/tools/dashed_add_card.dart`
- **Debug Gallery**:
  - `lib/features/debug/component_gallery_screen.dart` (kDebugMode only, interactive component showcase in Light/Dark and 1.0x/2.0x font scaling)
- **Tests**:
  - `test/widgets/component_library_test.dart`

### 1.3 Execution & Dependency Order
1. Download/place font files in `assets/fonts/` and register in `pubspec.yaml`.
2. Implement color and typography tokens; update `app_theme.dart`.
3. Implement `ShimmerBox` and skeleton components.
4. Implement button, input, tile, and modal families.
5. Implement ad placeholder widgets with $\ge 16\text{pt}$ clearance enforcement.
6. Assemble the `ComponentGalleryScreen` and write widget unit tests.

### 1.4 Verification
- **Automated**:
  - `flutter analyze` passes with 0 issues.
  - `flutter test` passes all tests.
- **Manual (Emulator)**:
  - Launch app, navigate to Component Gallery in Light and Dark modes.
  - Verify font rendering of Space Grotesk Bold and Inter across all scales.
  - Verify ShimmerBox animation smooth 1.4s sweep and check reduced motion toggle.

---

## Phase 2: Launch Flow, Home, Search & File Lists (Prompt R-C)

### 2.1 Scope
Redesign the user onboarding sequence, permissions gate, Home screen ("All files", "Recent", "Bookmarks"), Search screen (all 5 states), and synthesize the Category File List and Image Photo Grid.

### 2.2 Exact Files Created / Modified
- **Modified**:
  - `lib/features/splash/splash_screen.dart` (single line wordmark, radial glow, smooth router transition)
  - `lib/features/onboarding/onboarding_screen.dart` (3-page PageView, step indicators, tool preview)
  - `lib/features/home/home_screen.dart` (DocHomeAppBar, 4-column CategoryGrid, Recent/Bookmarks tabs, docked ad banner, FAB with 16pt clearance)
  - `lib/features/files/files_screen.dart` (Refactored to use `FileRow`, `NativeAdRow` in-feed, skeleton states)
  - `lib/features/search/search_screen.dart` (5 states, recent searches persistence, in-feed native ad at slot 6)
- **Created**:
  - `lib/features/permissions/permissions_screen.dart` (Android Frame A vs iOS Frame B, Frame C "Free with ads")
  - `lib/features/files/category_files_screen.dart` (Synthesized PDF/Word/Excel/PPT/TXT file list)
  - `lib/features/files/image_grid_screen.dart` (Synthesized 3-column photo grid)
  - `lib/features/files/widgets/sort_bottom_sheet.dart` (Synthesized Date/Name/Size sort sheet)
  - `lib/features/search/widgets/recent_searches_list.dart` (Stored FIFO recent query list)
  - `lib/features/search/widgets/clear_search_history_dialog.dart`
- **Tests**:
  - `test/features/home/home_screen_test.dart`
  - `test/features/search/search_screen_test.dart`
  - `test/features/onboarding/onboarding_test.dart`

### 2.3 Verification
- **Automated**:
  - `flutter analyze` (0 issues).
  - `flutter test` (all passing).
- **Manual (Emulator)**:
  - Fresh launch: Splash screen wordmark strictly on ONE line -> Onboarding 1-3 -> Permissions screen -> Home screen.
  - Switch between Recent and Bookmarks tabs; toggle bookmark star on a file.
  - Search: Type query, verify highlighted matches; clear query, verify recent searches list.
  - Tap PDF category tile: verify CategoryFilesScreen; tap Image tile: verify 3-column photo grid.

---

## Phase 3: File Management & Document Viewers (Prompt R-D)

### 3.1 Scope
Redesign single-file actions, multi-select batch deletion, folder browser (Directories), and all document viewers (PDF reader, Office viewer, Image viewer, TXT viewer).

### 3.2 Exact Files Created / Modified
- **Modified**:
  - `lib/features/files/widgets/file_options_sheet.dart` (28pt radius, 7 actions, destructive styling)
  - `lib/features/directories/directories_screen.dart` (Breadcrumbs, folder/file rows, 6 typed states)
  - `lib/features/viewer/pdf_viewer_screen.dart` (Light `#EEF0F5` / Dark `#11131B` chassis with un-inverted white page, floating page pill, bottom toolbar, NO ads)
  - `lib/features/viewer/office_viewer_screen.dart` (Offline office viewer with search counter, outline sheet; omit '+' and 'Filter')
  - `lib/features/viewer/image_viewer_screen.dart` (Pinch to zoom 1.0x-3.0x, black chassis)
  - `lib/features/viewer/txt_viewer_screen.dart` (Line numbers, typography sheet)
- **Created**:
  - `lib/features/files/widgets/rename_dialog.dart` (Locked `.pdf` extension suffix)
  - `lib/features/files/widgets/delete_dialog.dart` (Permanent deletion warning)
  - `lib/features/files/widgets/file_details_sheet.dart` (File metadata breakdown)
  - `lib/features/viewer/widgets/pdf_password_dialog.dart`
  - `lib/features/viewer/widgets/pdf_pages_thumbnail_sheet.dart` (Thumbnail grid jump sheet)
  - `lib/features/viewer/widgets/pdf_goto_page_dialog.dart`
- **Tests**:
  - `test/features/files/file_actions_test.dart`
  - `test/features/directories/directories_states_test.dart`
  - `test/features/viewer/pdf_viewer_test.dart`

### 3.3 Verification
- **Automated**:
  - `flutter analyze` (0 issues).
  - `flutter test` (all passing).
- **Manual (Emulator)**:
  - 3-dot menu on file: open Options sheet, test Rename dialog with locked suffix, test Details sheet.
  - Multi-select: select 3 files, verify counter in app bar and delete dialog.
  - Directories: navigate into `Download`, verify breadcrumb back-navigation.
  - Open PDF: verify un-inverted white page on dark chassis; open password-protected PDF; open DOCX, XLSX, image, and TXT.

---

## Phase 4: Tools (Strict 4-Tool Contract) & Results (Prompt R-E)

### 4.1 Scope
Redesign the Tools tab and the 4 tool workflows (Image to PDF, Scan to PDF, Merge PDF, Split PDF), progress dialogs, and success/error result sheets.

### 4.2 Exact Files Created / Modified
- **Modified**:
  - `lib/features/tools/tools_screen.dart` (4 tools ONLY: Image to PDF, Scan to PDF, Merge PDF, Split PDF; "Created by you" cards + See All)
  - `lib/features/tools/image_list_editor_screen.dart` (Reorderable images, A4/Fit segmented control, dashed add card)
  - `lib/features/tools/merge_screen.dart` & `library_pdf_picker_screen.dart` (Step 1 picker with native ad row; Step 2 arrange & merge)
  - `lib/features/tools/split_screen.dart` (Range selector, quick-select macros, ~EST file size calculation)
- **Created**:
  - `lib/features/tools/widgets/tool_progress_sheet.dart` (Determinate progress indicator)
  - `lib/features/tools/widgets/tool_result_sheet.dart` (Success checkmark, created file card, Open & Share CTAs)
  - `lib/features/tools/widgets/tool_interstitial_placeholder.dart` (Full-screen interstitial after export)
  - `lib/features/tools/created_documents_screen.dart` (See All destination)
- **Tests**:
  - `test/features/tools/tools_contract_test.dart` (STRICT: asserts exactly 4 tools)
  - `test/features/tools/split_macro_test.dart` (Validates range string parsing for Odd/Even/All)

### 4.3 Verification
- **Automated**:
  - `flutter analyze` (0 issues).
  - `flutter test` (all passing; 4-tools contract explicitly verified).
- **Manual (Emulator)**:
  - Run Image to PDF: pick 3 images, reorder, convert, verify progress sheet -> interstitial -> result sheet -> open generated PDF.
  - Run Split PDF: select PDF, tap "Odd Pages" macro, verify range field updates and ~EST size calculates.
  - Run Merge PDF: pick 2 PDFs, reorder, merge.

---

## Phase 5: Settings, Ad Placement Audit, Accessibility & Release Polish (Prompt R-F)

### 5.1 Scope
Redesign Settings tab, theme bottom sheet, scan settings, FAQ accordion; conduct comprehensive ad placement audit; perform accessibility audit; generate final release APK.

### 5.2 Exact Files Created / Modified
- **Modified**:
  - `lib/features/settings/settings_screen.dart` (Grouped card layout, uppercase section headers, stored scan timestamp, docked banner)
  - `lib/features/settings/faq_screen.dart` (Accordion items, complete answers from Phase 5A)
- **Created**:
  - `lib/features/settings/widgets/theme_selection_bottom_sheet.dart` (System / Light / Dark radio cards)
  - `lib/features/settings/scan_settings_screen.dart` (Diagnostics card for Android, auto-scan radio)
  - `docs/redesign/06_ad_placement_audit.md` (Screen-by-screen compliance verification)
  - `docs/redesign/07_qa_report.md` (Final visual comparison report)
- **Tests**:
  - `test/features/settings/settings_screen_test.dart`
  - `test/accessibility/accessibility_guidelines_test.dart`

### 5.3 Verification
- **Automated**:
  - `flutter analyze` (0 issues).
  - `flutter test` (all tests passing including accessibility guidelines).
  - `flutter build apk --release` succeeds cleanly.
- **Manual (Emulator & Real Device)**:
  - Switch theme live between Light and Dark from Settings.
  - Verify full end-to-end user journey.
  - Review `06_ad_placement_audit.md` and `07_qa_report.md`.

