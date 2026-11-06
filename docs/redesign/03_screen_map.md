# 03. Screen Map: Mockup to Code Architecture

This document maps all 24 mockup screen folders from `doc_view_mockups/manifest.json` to the current and target Dart codebase.

---

## 1. Launch & Onboarding

### 1. `01_launch/01_splash`
- **Mockup Title**: Splash screen
- **Target Route**: `/splash`
- **Existing File**: `lib/features/splash/splash_screen.dart`
- **New Files to Create**: None
- **Visual Changes Needed**:
  - Replace current plain background with subtle radial blue glow behind brand mark.
  - Light mode: Pure `#FFFFFF` with `#E9F2FF` center radial glow.
  - Dark mode: Deep navy `#1A1D29` with `#1E2A45` radial glow.
  - Brand Mark: Center glossy rounded-rect icon (40pt radius).
  - Wordmark: "Doc View" in Space Grotesk 32pt Bold (FIX DEFECT: do NOT wrap onto two lines; render on a single line).
  - Tagline: "All your documents, one clean view" (Inter 15pt Medium `#8A8F9C`).
- **Ads**: None.

---

### 2. `01_launch/02_onboarding_1` & `03_onboarding_2` & `04_onboarding_3`
- **Mockup Title**: Onboarding 3-Step Flow
  1. *Step 1*: "All your documents, one place" (auto-scan and discover all PDFs, Word, Excel, PPT, images).
  2. *Step 2*: "Read anything, beautifully" (lightning-fast offline viewer with search and dark mode).
  3. *Step 3*: "Powerful PDF tools, offline" (convert images, merge files, split pages safely on device).
- **Target Route**: `/onboarding` (PageView with 3 steps)
- **Existing File**: `lib/features/onboarding/onboarding_screen.dart`
- **New Files to Create**:
  - `lib/features/onboarding/widgets/onboarding_page_content.dart`
  - `lib/features/onboarding/widgets/onboarding_indicator.dart`
- **Visual Changes Needed**:
  - Unified header: "Skip" button on top right for pages 1–2; Page 3 has back button and primary "Get Started" CTA button.
  - Active page indicator: 24x6pt elongated pill (`#1A66E8`), inactive indicators are 6x6pt circular dots (`#E6E9F0` Light / `#2A3042` Dark).
  - Primary CTA button: `DocPrimaryButton` 56pt height at bottom.
  - Light & Dark mode support.
- **Ads**: None.

---

### 3. `01_launch/05_permissions_privacy`
- **Mockup Title**: Permissions and privacy flow
- **Target Route**: `/permissions`
- **Existing File**: `lib/features/onboarding/permission_screen.dart` (or modal prompt before Home)
- **New Files to Create**: `lib/features/permissions/permissions_screen.dart`
- **Visual Changes Needed**:
  - Frame A (Android): "All files access" (MANAGE_EXTERNAL_STORAGE) permission explainer. Large folder badge with lock/shield, clear text ("Doc View needs permission to scan and manage your documents"), primary "Grant All Files Access" button, secondary "Not now / Select files" button.
  - Frame B (iOS): "Bring your documents to Doc View" (iOS-only; strictly suppressed on Android).
  - Frame C: "Free with ads" explainer shown before Google UMP / ATT consent dialogs.
- **Ads**: None.

---

## 2. Home & Search

### 4. `02_home/01_home_all_files` & `02_home_state_variants`
- **Mockup Title**: Home, "All files" tab & state variants
- **Target Route**: `/home` (Tab 0) or `/`
- **Existing Files**:
  - `lib/features/home/home_screen.dart`
  - `lib/features/files/files_screen.dart`
  - `lib/features/files/widgets/file_tile.dart`
- **New Files to Create**:
  - `lib/features/home/widgets/home_header.dart`
  - `lib/features/home/widgets/category_grid.dart`
  - `lib/features/home/widgets/recent_files_section.dart`
- **Visual Changes Needed**:
  - Top header: Header gradient `#E9F2FF` to `#FFFFFF` (Light), "Doc View" headline (Space Grotesk 24pt Bold), search icon button, and selection mode trigger. (FIX DEFECT: do NOT use "DocView" or `more_vert` icon).
  - 4-Column Category Grid: PDF, Word, Excel, PPT, TXT, Image, Folders/Browse. 20pt card radius, format colors and badges.
  - Floating Action Button (FAB): Positioned with $\ge 16\text{pt}$ clearance above docked banner. (FIX DEFECT: resolve overlap between FAB and ad install button).
  - States:
    - Normal populated list.
    - Shimmer skeleton loading state (`ShimmerBox` rows).
    - Empty Recent state with clean illustration.
    - Indexing / Scanning progress banner state.
    - Permission required state.
- **Ads**:
  - Docked 60pt adaptive banner directly above 64pt bottom navigation bar.
  - In-feed native ad row (68pt) at slot 6 in Recent files list.

---

### 5. `03_home_recent_and_bookmarks/01_recent_tab` & `02_bookmarks_tab`
- **Mockup Title**: Recent & Bookmarks Tabs
- **Target Route**: Tab switch inside `/home` or dedicated view
- **Existing File**: `lib/features/files/files_screen.dart` (segmented control)
- **New Files to Create**:
  - `lib/core/widgets/doc_underline_tabs.dart`
  - `lib/features/files/widgets/bookmarks_empty_state.dart`
- **Visual Changes Needed**:
  - `DocUnderlineTabs`: Recent / Bookmarks tabs with active 3pt indicator bar and count pills ("Recent (12)", "Bookmarks (3)").
  - Bookmark star toggle on `FileRow`: Smooth optimistic update with yellow filled star `#F5A524`.
  - Empty Bookmarks state: Star illustration + "No bookmarks yet. Tap the star icon on any document to pin it here."
- **Ads**: Docked 60pt banner above nav bar; native ad row in list.

---

### 6. `03_search/01_search_states`
- **Mockup Title**: Search screen (5 states)
- **Target Route**: `/search`
- **Existing File**: `lib/features/search/search_screen.dart`
- **New Files to Create**:
  - `lib/features/search/widgets/recent_searches_view.dart`
  - `lib/features/search/widgets/search_result_row.dart`
- **Visual Changes Needed**:
  - 48pt pill search field with automatic focus, back arrow prefix, clear button suffix.
  - Filter chip row beneath search field (`All`, `PDF`, `Word`, `Excel`, `PPT`, `TXT`, `Image`).
  - State 1: Typing with highlighted substring matches in file names (`#1A66E8` bold text).
  - State 2: Empty query showing "Recent searches" list with clock icons and clear history action.
  - State 3: No results found ("No documents matching 'xyz'").
  - State 4: Skeleton shimmer list during background debounce search.
  - State 5: Soft keyboard open with bottom safe-area insets.
- **Ads**: In-feed native ad at position 6 in search results. NO docked banner on search screen.

---

## 3. File Management & Directories

### 7. `04_file_management/01_file_actions`
- **Mockup Title**: Single-file actions (options sheet, rename, delete, details)
- **Target Route**: Modal sheets / dialogs triggered from file 3-dot button
- **Existing Files**:
  - `lib/features/files/widgets/file_tile.dart` (action handlers)
- **New Files to Create**:
  - `lib/features/files/widgets/file_options_bottom_sheet.dart`
  - `lib/features/files/widgets/rename_file_dialog.dart`
  - `lib/features/files/widgets/delete_file_dialog.dart`
  - `lib/features/files/widgets/file_details_sheet.dart`
- **Visual Changes Needed**:
  - Options Bottom Sheet: 28pt top corner radius, drag handle, 520pt max height. Actions: Open, Bookmark, Share, Rename, Details, Delete (destructive red). (FIX DEFECT: ignore stale links to "Annotations" and "Export Ops").
  - Rename Dialog: 24pt corner radius. Input field with locked `.pdf` extension suffix so user cannot accidentally corrupt the file extension.
  - Delete Dialog: Destructive red CTA "Delete File", file name in bold, warning that deletion is permanent.
  - Details Sheet: File path, size, page count (if PDF), created date, modified date, MIME type.
- **Ads**: None on dialogs or modal sheets.

---

### 8. `04_file_management/02_multi_select_delete`
- **Mockup Title**: Multi-select and batch delete
- **Target Route**: Active selection state across file lists
- **Existing Files**:
  - `lib/features/files/files_screen.dart`
- **New Files to Create**:
  - `lib/core/widgets/doc_selection_app_bar.dart`
  - `lib/features/files/widgets/batch_delete_dialog.dart`
- **Visual Changes Needed**:
  - Replaces top app bar with `DocSelectionAppBar` ("N selected", Select All toggle, Close).
  - Checkboxes replace file thumbnails on the left of each row.
  - (FIX DEFECT: do NOT implement `drag_indicator` handles shown in mockup—files lists have no manual reordering).
  - Bottom docked ad banner is SUPPRESSED in selection mode to give full screen to selection actions.
  - Bottom action bar: Share selected, Delete selected (with counter badge).
- **Ads**: Suppressed during selection mode.

---

### 9. `04_file_management/03_directories`
- **Mockup Title**: Directories (folder browser)
- **Target Route**: `/directories`
- **Existing File**: `lib/features/directories/directories_screen.dart`
- **New Files to Create**:
  - `lib/core/widgets/doc_breadcrumb_bar.dart`
  - `lib/features/directories/widgets/folder_list_row.dart`
- **Visual Changes Needed**:
  - Horizontal scrollable breadcrumb path (`Root > Download > Subfolder`).
  - Folder rows: accent blue folder icon `#2F7BEA`, folder name, modified date, right chevron.
  - Handle all 5 typed states cleanly:
    - Normal directory list (folders on top, followed by documents).
    - Permission required state with "Grant All Files Access" button.
    - Android 11+ protected folder state (`Android/data`, `Android/obb`).
    - Empty folder state ("No documents in this folder").
    - Folder not found / deleted state.
    - Shimmer skeleton loading state.
- **Ads**: Docked 60pt banner above bottom navigation bar.

---

## 4. Document Viewers

### 10. `05_viewers/01_pdf_reader` & `02_pdf_reader_states`
- **Mockup Title**: PDF Reader chassis, dialogs and exception states
- **Target Route**: `/viewer/pdf`
- **Existing File**: `lib/features/viewer/pdf_viewer_screen.dart`
- **New Files to Create**:
  - `lib/features/viewer/widgets/pdf_reader_app_bar.dart`
  - `lib/features/viewer/widgets/pdf_more_bottom_sheet.dart`
  - `lib/features/viewer/widgets/pdf_password_dialog.dart`
  - `lib/features/viewer/widgets/pdf_goto_page_dialog.dart`
- **Visual Changes Needed**:
  - Dedicated reader chassis: Light mode canvas `#EEF0F5`, Dark mode canvas `#11131B`.
  - IMPORTANT: In Dark mode, the document page itself stays pure white (un-inverted) for readability; only the surrounding chassis and toolbars darken.
  - Floating pill overlay: Page number pill "Page 4 / 12" at bottom center that fades after 2.5s.
  - More Bottom Sheet: Quick actions (Share, Print, Go to page, Details).
  - Password Dialog: Masked text field with toggle eye icon.
  - Error States: Corrupt PDF screen, missing file screen with back navigation.
- **Ads**: STRICTLY NONE (clean reading surface).

---

### 11. `05_viewers/03_office_viewer`
- **Mockup Title**: Office Viewer (DOCX, XLSX, PPTX)
- **Target Route**: `/viewer/office`
- **Existing File**: `lib/features/viewer/office_viewer_screen.dart`
- **New Files to Create**:
  - `lib/features/viewer/widgets/office_reader_app_bar.dart`
  - `lib/features/viewer/widgets/office_outline_sheet.dart`
- **Visual Changes Needed**:
  - Clean top app bar with document title and format glyph (Word blue `#1E5FD8`, Excel green `#1E9E4F`, PPT orange `#F26B1D`).
  - Search in document bar with match counter ("3 of 14").
  - (FIX DEFECT: Viewer is read-only. Omit the "+" add-tab button and "Filter" button shown in mockup XLSX).
  - (FIX DEFECT: Disregard marketing board text claiming "Rust OpenXML parser"; use existing Flutter engine).
- **Ads**: STRICTLY NONE.

---

### 12. `05_viewers/04_image_txt_viewer`
- **Mockup Title**: Image viewer and TXT viewer
- **Target Route**: `/viewer/image`, `/viewer/txt`
- **Existing Files**:
  - `lib/features/viewer/image_viewer_screen.dart`
  - `lib/features/viewer/txt_viewer_screen.dart`
- **New Files to Create**:
  - `lib/features/viewer/widgets/txt_typography_bottom_sheet.dart`
- **Visual Changes Needed**:
  - Image Viewer: Interactive pinch-to-zoom with double-tap reset (1.0x to 3.0x), full black or dark navy backdrop, image metadata pill.
  - TXT Viewer: Line-numbered monospaced reader, light/dark chassis, typography sheet (font size slider, line height, font family choice).
- **Ads**: STRICTLY NONE.

---

## 5. Tools (Strict 4-Tool Contract)

### 13. `06_tools/01_tools_tab`
- **Mockup Title**: Tools tab
- **Target Route**: `/tools` (Tab 1)
- **Existing File**: `lib/features/tools/tools_screen.dart`
- **New Files to Create**:
  - `lib/features/tools/widgets/tool_grid_card.dart`
  - `lib/features/tools/widgets/created_by_you_section.dart`
- **Visual Changes Needed**:
  - STRICT HARD RULE: Exactly 4 tool cards:
    1. **Image to PDF** (Purple/Indigo gradient glyph `#6366F1`)
    2. **Scan to PDF** (Teal/Emerald gradient glyph `#0EA5E9`)
    3. **Merge PDF** (Blue/Cyan gradient glyph `#1A66E8`)
    4. **Split PDF** (Orange/Coral gradient glyph `#F97316`)
  - NEVER add Compress, Annotate, Sign, OCR, or other tools.
  - (FIX DEFECT: Omit decorative board labels "Engine 4.18" and "2 Utilities").
  - "Created by you" section: Horizontal or vertical list of PDFs generated by Doc View tools with thumbnail, date, size, and 3-dot menu.
  - "See All" button navigates to a filtered list of created files.
- **Ads**: Docked 60pt banner above bottom nav bar.

---

### 14. `06_tools/02_image_to_pdf_scan`
- **Mockup Title**: Image to PDF editor and scan review
- **Target Route**: `/tools/image-to-pdf`
- **Existing File**: `lib/features/tools/image_list_editor_screen.dart`
- **New Files to Create**:
  - `lib/features/tools/widgets/reorderable_image_tile.dart`
  - `lib/features/tools/widgets/page_layout_selector.dart`
- **Visual Changes Needed**:
  - Reorderable list of picked images with thumbnail preview, page number badge, rotation action, and delete button.
  - Layout Segmented Control: `A4` vs `Fit to Image`.
  - Margin toggle / padding selector.
  - `DashedAddCard` at the bottom of the list to pick additional images.
  - Floating or pinned bottom CTA: `Convert to PDF (N images)` (56pt `DocPrimaryButton`).
- **Ads**: None in editor.

---

### 15. `06_tools/03_merge_pdf`
- **Mockup Title**: Merge PDF (select, arrange, error)
- **Target Route**: `/tools/merge`
- **Existing Files**:
  - `lib/features/tools/library_pdf_picker_screen.dart`
  - `lib/features/tools/merge_screen.dart`
- **New Files to Create**: None (refactor existing into matching layout)
- **Visual Changes Needed**:
  - Step 1 (Picker): Multi-select PDF documents with checkmarks and selected counter. (FIX DEFECT: suppress iOS-only "iCloud Drive" tab on Android).
  - Step 2 (Arrange): Reorderable list of selected PDFs with drag handles, page count badges, and delete action.
  - Bottom CTA: `Merge N PDFs` (56pt `DocPrimaryButton`).
- **Ads**: In-feed native ad row in Step 1 picker; NO banner.

---

### 16. `06_tools/04_split_pdf`
- **Mockup Title**: Split PDF (pick, configure, error)
- **Target Route**: `/tools/split`
- **Existing Files**:
  - `lib/features/tools/library_pdf_picker_screen.dart`
  - `lib/features/tools/split_screen.dart`
- **New Files to Create**:
  - `lib/features/tools/widgets/quick_select_macro_row.dart`
- **Visual Changes Needed**:
  - Step 1: Single-selection PDF picker with page count preview.
  - Step 2: Split configuration:
    - Segmented mode toggle: "Page Range" (e.g. `1-3, 5`) vs "Every N Pages" (e.g. `2`).
    - Quick-select macro chips: `All Pages`, `Odd Pages`, `Even Pages`, `First 5 Pages`.
    - Approximate estimated output size indicator: `~EST: 2.1 MB`.
  - Bottom CTA: `Split PDF` (56pt `DocPrimaryButton`).
- **Ads**: None in configuration.

---

### 17. `06_tools/05_progress_results`
- **Mockup Title**: Operation progress and results
- **Target Route**: Modal sheets and sheets over tools
- **Existing Files**: Handled inline in tool screens
- **New Files to Create**:
  - `lib/features/tools/widgets/tool_progress_sheet.dart`
  - `lib/features/tools/widgets/tool_result_sheet.dart`
- **Visual Changes Needed**:
  - Progress Sheet: Centered determinate progress bar (0% to 100%), percentage text, operation step ("Processing page 3..."). (FIX DEFECT: backdrop must show the real 4-tool tab; NEVER show 5 tools or Compress).
  - Result Sheet: Large green checkmark badge `#1FA971`, generated document card (thumbnail, file name, size, page count), primary CTA "Open PDF", secondary CTA "Share".
  - Interstitial Ad: Triggered strictly after successful export result, before navigating to viewer.
- **Ads**: Interstitial ad after successful export.

---

## 6. Settings & Support

### 18. `07_settings/01_settings_tab`
- **Mockup Title**: Settings tab
- **Target Route**: `/settings` (Tab 2)
- **Existing File**: `lib/features/settings/settings_screen.dart`
- **New Files to Create**:
  - `lib/features/settings/widgets/settings_tile.dart`
  - `lib/features/settings/widgets/settings_section_header.dart`
- **Visual Changes Needed**:
  - Grouped card layout: 20pt card radius, `#F3F5FA` (Light) / `#232838` (Dark).
  - Uppercase section headers: `GENERAL`, `SCANNING & STORAGE`, `ABOUT & SUPPORT`.
  - Setting items: App theme (System / Light / Dark), Auto-scan mode, Include images toggle, FAQ, Privacy Policy, Share app, Rate app.
  - (FIX DEFECT: do NOT use JetBrains Mono; use Inter with tabular figures for version strings).
- **Ads**: Docked 60pt banner above bottom nav bar.

---

### 19. `07_settings/02_settings_sub_screens`
- **Mockup Title**: Settings sub-screens: theme sheet, scan settings, snackbar
- **Target Route**: Modal sheet + `/settings/scan`
- **Existing Files**:
  - Handled in `lib/features/settings/settings_screen.dart`
- **New Files to Create**:
  - `lib/features/settings/widgets/theme_selection_bottom_sheet.dart`
  - `lib/features/settings/scan_settings_screen.dart`
- **Visual Changes Needed**:
  - Theme Selection Sheet: 3 options with radio indicators: System default, Light theme, Dark theme.
  - Scan Settings Screen: Diagnostics card (Android-only: total indexed, last scan time, storage access status; hidden on iOS).
- **Ads**: Docked 60pt banner on Scan Settings screen.

---

### 20. `07_settings/03_faq`
- **Mockup Title**: FAQ screen
- **Target Route**: `/settings/faq`
- **Existing File**: `lib/features/settings/faq_screen.dart`
- **New Files to Create**:
  - `lib/features/settings/widgets/faq_accordion_item.dart`
- **Visual Changes Needed**:
  - Accordion expandable tiles with smooth height animation and rotating chevron.
  - 20pt card radius for FAQ containers.
  - Complete Q&A contents populated from Phase 5A.
- **Ads**: Docked 60pt banner.

---

## 7. AdMob Placement Reference

### 21. `08_ads/01_admob_placements`
- **Mockup Title**: AdMob placements and policy board
- **Target Route**: Reference specification for widgets
- **Existing File**: `lib/core/ads/` (placeholder implementations)
- **New Files to Create**:
  - `lib/core/widgets/ads/ad_banner_slot.dart`
  - `lib/core/widgets/ads/native_ad_row.dart`
  - `lib/core/widgets/ads/native_ad_card.dart`
  - `lib/core/widgets/ads/interstitial_placeholder.dart`
- **Visual Specifications**:
  - Docked 60pt adaptive banner: Collapses to `0pt` (`SizedBox.shrink()`) on `NO_FILL`.
  - In-feed 68pt native ad row: Replaces a standard file row in lists (Home Recent slot 6, Search slot 6, Merge picker).
  - Interstitial: Full-screen modal triggered ONLY on tool export completion.
- **Ads**: Foundation placeholder widgets with `AD` badge.

