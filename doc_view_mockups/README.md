# Doc View: UI Mockups (arranged)

Approved UI mockups for **Doc View**, an offline document reader and PDF toolkit (PDF, Word, Excel, PowerPoint, TXT, images; exactly **four** PDF tools). Generated with Google Stitch, then arranged and documented here for the Flutter redesign.

- **Target:** Android first (first public release), iOS second. Same UI on both.
- **Design baseline:** 393 x 852 (treat units as dp on Android). Light, Dark (deep navy) and Skeleton states for data screens.
- **Contents:** 24 screen folders, each with `code.html` (HTML/Tailwind mockup) and `screen.png` (preview, 2 folders have no PNG), plus `00_design_system/DESIGN.md` and `manifest.json` (machine-readable index).

## 1. How to read a mockup (important)

1. **Source of truth order:** the 393 x 852 phone frames in `screen.png` / `code.html` > `00_design_system/DESIGN.md` > this README.
2. Every `code.html` is a **presentation board**: it contains workbench chrome (top nav, "spec" cards, telemetry badges, "Engine v4.18" labels, long marketing text). **Only the phone frames are app UI.** Ignore everything else.
3. The phone frames mimic an **iPhone** (9:41 clock, Dynamic Island, home indicator). **Do NOT reproduce those.** On Android use the real system status bar and navigation bar (edge-to-edge, correct insets).
4. `screen.png` previews: some are downscaled tall strips (e.g. 303x1600) and hard to read; the HTML is then the better source. Fonts in the PNGs fall back to a serif; ignore that. Use the fonts named below.
5. Mockups use the Tailwind CDN and **Material Symbols Outlined**. Several screens (splash, onboarding 1-2, permissions, settings tab/sub-screens, FAQ) use no icon font (inline shapes/SVG).
6. Advertiser names in ad slots (CloudDrive Pro, Google Workspace, Clean Master...) are **placeholders**.

## 2. Folder structure

```
doc_view_mockups/
├── README.md
├── manifest.json
├── 00_design_system/DESIGN.md
├── 01_launch/
│   ├── 01_splash/   (code.html, screen.png)
│   ├── 02_onboarding_1/   (code.html, screen.png)
│   ├── 03_onboarding_2/   (code.html, screen.png)
│   ├── 04_onboarding_3/   (code.html  (no PNG))
│   ├── 05_permissions_privacy/   (code.html, screen.png)
├── 02_home/
│   ├── 01_home_all_files/   (code.html, screen.png)
│   ├── 02_home_state_variants/   (code.html, screen.png)
├── 03_search/
│   ├── 01_search_states/   (code.html, screen.png)
├── 04_file_management/
│   ├── 01_file_actions/   (code.html, screen.png)
│   ├── 02_multi_select_delete/   (code.html, screen.png)
│   ├── 03_directories/   (code.html, screen.png)
├── 05_viewers/
│   ├── 01_pdf_reader/   (code.html, screen.png)
│   ├── 02_pdf_reader_states/   (code.html, screen.png)
│   ├── 03_office_viewer/   (code.html  (no PNG))
│   ├── 04_image_txt_viewer/   (code.html, screen.png)
├── 06_tools/
│   ├── 01_tools_tab/   (code.html, screen.png)
│   ├── 02_image_to_pdf_scan/   (code.html, screen.png)
│   ├── 03_merge_pdf/   (code.html, screen.png)
│   ├── 04_split_pdf/   (code.html, screen.png)
│   ├── 05_progress_results/   (code.html, screen.png)
├── 07_settings/
│   ├── 01_settings_tab/   (code.html, screen.png)
│   ├── 02_settings_sub_screens/   (code.html, screen.png)
│   ├── 03_faq/   (code.html, screen.png)
├── 08_ads/
│   ├── 01_admob_placements/   (code.html, screen.png)
```

## 3. Design tokens (summary; full text in `00_design_system/DESIGN.md`)

### Colors
| Role | Light | Dark (deep navy) |
|---|---|---|
| Background | #FFFFFF (top header gradient #E9F2FF to #FFFFFF) | #1A1D29 |
| Tile / card | #F3F5FA | #232838 |
| Divider band (8pt) | #F1F3F8 | #141722 |
| Hairline (1px) | #E6E9F0 | #2A3042 |
| Text primary | #11141C | #FFFFFF |
| Text secondary | #8A8F9C | #858B9C |
| Section header | #8A94AE | #7F8AA8 |
| Primary blue | #1A66E8 (interactive #2F7BEA) | #1A66E8 button, #4D8FF7 active |
| Blue tint | #E8F0FE | #1E2A45 |
| Sheet scrim | rgba(17,20,28,0.40-0.50) | rgba(10,12,18,0.65) |
| Skeleton shimmer | #E9EDF5 to #F5F7FB | #262B3A to #30364A (1.4s sweep) |
| Reader canvas behind page | #EEF0F5 | #11131B (page stays white, not inverted) |

File types: PDF `#E02B2B`, Word `#1E5FD8`, Excel `#1E9E4F`, PowerPoint `#F26B1D`, TXT `#5B6B9A`, Image `#FFB300`, Folders `#2F7BEA`. States: success `#1FA971`, warning `#F5A524`, error `#E5484D`.

### Typography
- **Space Grotesk** (700/600): display headings and screen/section titles (32/24/18 px).
- **Inter**: everything else. Title 16 Bold, label 15/13/11 SemiBold, body 15 Medium / 13 and 12 Regular.
- Bundle both fonts as assets (the app is offline; do not fetch from Google Fonts at runtime). No third font (ignore JetBrains Mono in the settings boards).

### Shape, spacing, elevation
4pt grid, page margin 20, card/tile radius 20, buttons radius 16 (primary CTA height 56), thumbnails radius 10 with 0.5pt inner hairline, sheets 28 top radius, dialogs 24, pills fully rounded, minimum touch target 48 x 48. Docked chrome: bottom nav 64 + adaptive banner 60 (AD pill). Elevation is mostly tonal + hairline; shadows `0 4 20 rgba(17,20,28,0.06)` light, `0 4 24 rgba(0,0,0,0.45)` dark.

## 4. Global rules

1. **Exactly four tools** exist: Image to PDF, Scan to PDF, Merge PDF, Split PDF. No Compress, Annotate, Sign, Word to PDF, OCR, recycle bin or print.
2. **No premium, remove-ads or language rows** anywhere (Settings).
3. **Ad-free surfaces:** PDF/Office/Image/TXT viewers, tool editors (Image to PDF, Split), selection mode, splash, onboarding, permissions. **Ads allowed:** Home, file lists, Directories, Tools tab, Settings, FAQ (docked 60pt banner above the 64pt nav), in-feed native rows (Home Recent, Search position 6, Merge step 1), interstitial only after a successful tool result.
4. Keep **>= 16pt** clearance between any ad and any button/FAB. Ads that fail to load collapse to zero height.
5. Use "Doc View" (not "DocView"); bottom nav labels "All files", "Tools", "Settings".
6. **Skeleton instead of spinners** for every data screen; inline progress bars are allowed for operations.
7. Respect reduced-motion and system font scale (layouts must not overflow at 200%).

## 5. Android and iOS notes

| Topic | Android (primary) | iOS |
|---|---|---|
| System bars | Real status bar + gesture/3-button nav; edge-to-edge; icon brightness follows theme | Real status bar + home indicator; safe-area insets |
| Back | System/predictive back; PopScope for selection mode, folder-up in Directories | Swipe-back; same logic |
| Permission screen | Frame A ("All files access", opens system settings) | Frame B (Import files / Files app folder); never shows Frame A |
| Merge picker tabs | All PDFs / Recent / Downloads | All PDFs / Recent / Downloads / iCloud Drive |
| Scan settings | Storage diagnostics card shown | Hide diagnostics card |
| Ripple / feedback | Material ink ripple on tappable rows and buttons | Same widgets, platform scroll physics |

## 6. Screen index

| # | Folder | Screen | Modes | Ads | PNG |
|---|---|---|---|---|---|
| 1 | `01_launch/01_splash` | Splash screen | Light, Dark | None | yes |
| 2 | `01_launch/02_onboarding_1` | Onboarding 1 of 3: All your documents, one place | Light, Dark | None | yes |
| 3 | `01_launch/03_onboarding_2` | Onboarding 2 of 3: Read anything, beautifully | Light, Dark | None | yes |
| 4 | `01_launch/04_onboarding_3` | Onboarding 3 of 3: Powerful PDF tools, offline | Light, Dark | None | **no** |
| 5 | `01_launch/05_permissions_privacy` | Permissions and privacy flow | Light, Dark | None | yes |
| 6 | `02_home/01_home_all_files` | Home, "All files" tab | Light, Dark, Skeleton | Native row inside Recent list + docked 60pt adaptive banner above nav | yes |
| 7 | `02_home/02_home_state_variants` | Home state variants | Light, Dark (each of 5 states) | Docked banner in all states | yes |
| 8 | `03_search/01_search_states` | Search screen, 5 states | Light, Dark | One in-feed native ad at position 6; NO docked banner | yes |
| 9 | `04_file_management/01_file_actions` | Single-file actions: options sheet, rename, delete, details | Light, Dark | None on sheets; the list behind shows one native ad row | yes |
| 10 | `04_file_management/02_multi_select_delete` | Multi-select and batch delete | Light, Dark | Banner suppressed in selection mode | yes |
| 11 | `04_file_management/03_directories` | Directories (folder browser) | Light, Dark | Docked 60pt banner above nav | yes |
| 12 | `05_viewers/01_pdf_reader` | PDF reader | Light, Dark (white page kept un-inverted), Skeleton, More menu | NONE (ad-free reading surface) | yes |
| 13 | `05_viewers/02_pdf_reader_states` | PDF reader exception states and dialogs | Light, Dark | NONE | yes |
| 14 | `05_viewers/03_office_viewer` | Office viewer: DOCX, XLSX, PPTX | Light, Dark | NONE | **no** |
| 15 | `05_viewers/04_image_txt_viewer` | Image viewer and TXT viewer | Light, Dark, Zoomed, Skeleton | NONE | yes |
| 16 | `06_tools/01_tools_tab` | Tools tab (exactly 4 tools) | Light, Dark, Skeleton, Empty | Docked 60pt banner above nav | yes |
| 17 | `06_tools/02_image_to_pdf_scan` | Image to PDF editor and scan review | Light, Dark, Scan review, Empty, Skeleton | NONE | yes |
| 18 | `06_tools/03_merge_pdf` | Merge PDF: select, arrange, error | Light, Dark | In-feed native ad in step 1 only; no banner | yes |
| 19 | `06_tools/04_split_pdf` | Split PDF: pick, configure, error | Light, Dark | NONE | yes |
| 20 | `06_tools/05_progress_results` | Operation progress and results | Light, Dark | Interstitial only after a successful result, never on launch | yes |
| 21 | `07_settings/01_settings_tab` | Settings tab | Light, Dark, Skeleton | Docked 60pt banner above nav | yes |
| 22 | `07_settings/02_settings_sub_screens` | Settings sub-screens: theme sheet, scan settings, snackbar | Light, Dark | Docked banner on Scan settings | yes |
| 23 | `07_settings/03_faq` | FAQ | Light, Dark, Skeleton | Docked 60pt banner | yes |
| 24 | `08_ads/01_admob_placements` | AdMob placements and policy board | Light, Dark | This IS the ad reference | yes |

## 7. Screen details

### 1. Splash screen

- **Folder:** `01_launch/01_splash`
- **Suggested route / code location:** `/splash` / `lib/features/splash/splash_screen.dart`
- **Modes:** Light, Dark
- **Frames in this mockup:** Light (#FFFFFF with pale-blue glow); Dark (#1A1D29 deep navy with blue glow)
- **Ads on this screen:** None
- **What the UI contains:**
  - Centered brand mark: rounded-square blue app icon with white folded-corner page (red + blue text lines), soft blue glow behind it, two translucent floating pages drifting behind.
  - Wordmark "Doc View" (bold, single line) and tagline "All your documents, one place."
  - Bottom: thin 120pt shimmer progress line and "Version 1.0.0".
  - No buttons, no ads, no bottom nav.
- **Mockup defects / do NOT copy:**
  - The screenshot shows the wordmark wrapping onto two lines ("Doc" / "View") and overlapping the tagline. Implement it on ONE line with proper spacing.

### 2. Onboarding 1 of 3: All your documents, one place

- **Folder:** `01_launch/02_onboarding_1`
- **Suggested route / code location:** `/onboarding (page 1)` / `lib/features/onboarding/onboarding_screen.dart`
- **Modes:** Light, Dark
- **Frames in this mockup:** Light; Dark
- **Ads on this screen:** None
- **What the UI contains:**
  - Top-right "Skip" (with close glyph).
  - Illustration: floating document cards (Q3_Audit.xlsx, Pitch_Deck.pptx, Scan_042.jpg, Contract.docx, Financial_Plan.pdf "Page 1 of 12") around a "92 Files / All Files" folder badge, built from CSS/inline SVG shapes (no icon font).
  - Headline "All your documents, one place"; subtitle about automatic finding and organizing; 3 page indicators (first is an elongated pill); full-width primary button "Next".
  - No ads, no bottom nav.

### 3. Onboarding 2 of 3: Read anything, beautifully

- **Folder:** `01_launch/03_onboarding_2`
- **Suggested route / code location:** `/onboarding (page 2)` / `lib/features/onboarding/onboarding_screen.dart`
- **Modes:** Light, Dark
- **Frames in this mockup:** Light; Dark
- **Ads on this screen:** None
- **What the UI contains:**
  - "Skip" top-right.
  - Illustration: phone-style PDF reader card (Annual_Report.pdf, "Executive Summary", page pill "3 / 120") with floating Budget_Q4.xlsx mini table (Dept/Plan/Actual) and Contract_v2.docx ("Clause 8 · Signed Verified") cards.
  - Headline "Read anything, beautifully"; subtitle; indicator on dot 2; "Back" text button + primary "Next".

### 4. Onboarding 3 of 3: Powerful PDF tools, offline

- **Folder:** `01_launch/04_onboarding_3`
- **Suggested route / code location:** `/onboarding (page 3)` / `lib/features/onboarding/onboarding_screen.dart`
- **Modes:** Light, Dark
- **Frames in this mockup:** Light; Dark
- **Ads on this screen:** None
- **What the UI contains:**
  - Header differs from pages 1-2: back arrow + "Step 3 of 3" (no Skip).
  - 2x2 grid of exactly four tool tiles: Image to PDF ("Convert JPG & PNG"), Scan to PDF ("Camera edge detect"), Merge PDF ("Combine into one"), Split PDF ("Extract any range"), with small illustrative glyphs.
  - Badge "100% Offline • Private & Secure"; headline "Powerful PDF tools, offline"; subtitle; "Back" + primary "Get started" (with arrow).
- **Mockup defects / do NOT copy:**
  - No screen.png was included in the original zip; use code.html only.
  - The HTML <title> says "Splash Screen" (copy-paste error); the content is Onboarding 3.
  - Header pattern differs from pages 1-2 (Step 3 of 3 + back arrow vs Skip). Keep as designed or unify; report the choice.

### 5. Permissions and privacy flow

- **Folder:** `01_launch/05_permissions_privacy`
- **Suggested route / code location:** `/permission (Android), /import-guide (iOS), /ads-consent` / `lib/features/permissions/*`
- **Modes:** Light, Dark
- **Frames in this mockup:** A: Android "All files access" (MANAGE_EXTERNAL_STORAGE); B: iOS "Bring your documents to Doc View"; C: "Free with ads" explainer shown before the Google consent (UMP) and iOS ATT prompts
- **Ads on this screen:** None
- **What the UI contains:**
  - Frame A: storage illustration (P/W/X file chips flowing into "Doc View" list, "Indexed Offline"); headline "Let Doc View find your documents"; 3 reassurance rows (Works offline / No uploads / You can change this any time); primary "Grant access"; text button "Import files instead".
  - Frame B (iOS only): "On My iPhone > Doc View folder" illustration; two option cards "Import files" and "Open Doc View folder in Files app"; primary "Import files".
  - Frame C: headline "Free with ads"; rows "What ads you may see", "Documents stay completely private", "You can change your choice in Settings"; primary "Continue"; link "Privacy policy".
  - No ads and no bottom nav on any of these.
- **Gaps vs current app code:**
  - Frame B is iOS-only; Android build must never show it, and iOS must never show Frame A.

### 6. Home, "All files" tab

- **Folder:** `02_home/01_home_all_files`
- **Suggested route / code location:** `/home (tab 1)` / `lib/features/home/home_screen.dart`
- **Modes:** Light, Dark, Skeleton
- **Frames in this mockup:** Light; Dark; Skeleton shimmer
- **Ads on this screen:** Native row inside Recent list + docked 60pt adaptive banner above nav
- **What the UI contains:**
  - App bar: "Doc View" with small logo glyph + search icon; light mode has the pale-blue header gradient.
  - 4x2 category grid: All 5,363 / PDF 92 / Word 20 / Excel 7 / PPT 4 / TXT 7 / Image 5,233 / Folders "Browse" (filled folded-corner glyphs, tiles with 20pt radius).
  - Underline tabs "Recent" / "Bookmarks" + select (checklist) icon at right.
  - Rows (68pt): PDF row with first-page preview, IMG with thumbnail, DOCX and XLSX with badges; outlined bookmark + 3-dot actions; one native ad row (Ad chip, Install button).
  - Blue FAB (56pt, plus); docked 60pt banner ad with AD pill; bottom nav: All files / Tools / Settings.
- **Mockup defects / do NOT copy:**
  - The FAB overlaps the native ad row and its Install button; this breaks the design system own 16pt-clearance rule. Place the FAB so it never overlaps an ad or a tappable row action (>= 16pt gap).
  - Tile label here is "Folders / Browse"; the destination screen is titled "Directories". Keep as designed and be consistent.

### 7. Home state variants

- **Folder:** `02_home/02_home_state_variants`
- **Suggested route / code location:** `/home (states)` / `lib/features/home/home_screen.dart`
- **Modes:** Light, Dark (each of 5 states)
- **Frames in this mockup:** 1 Bookmarks tab populated (3 pinned PDFs, filled bookmarks); 2 Bookmarks empty; 3 Recent empty; 4 Indexing & scan in progress; 5 Permission gate (no access yet)
- **Ads on this screen:** Docked banner in all states
- **What the UI contains:**
  - Same chrome as Home; this board shows how the content area changes per state.
  - Bookmarks populated: 3 PDF rows (Financial_Report_Q4_2025.pdf etc.) with filled blue bookmark icons, FAB, docked banner.
  - Empty states: illustration + title + subtitle (+ button for Recent empty).
  - Scanning: slim progress + "Scanning... N files found" while counts/rows shimmer.
  - Permission gate: counts show 0, top card prompting "Allow", secondary "Import files".
- **Mockup defects / do NOT copy:**
  - Header here reads "DocView" and shows a more_vert icon; Home (01) uses "Doc View" with search only. Use "Doc View" everywhere.

### 8. Search screen, 5 states

- **Folder:** `03_search/01_search_states`
- **Suggested route / code location:** `/search` / `lib/features/search/search_screen.dart`
- **Modes:** Light, Dark
- **Frames in this mockup:** 1 Typing "prac" with highlighted matches; 2 Empty query: Recent searches; 3 No results for "xyz"; 4 Skeleton; 5 Keyboard open (query "fin")
- **Ads on this screen:** One in-feed native ad at position 6; NO docked banner
- **What the UI contains:**
  - Back arrow + autofocused pill search field (48pt, radius 24) with clear (X).
  - Scrollable filter chips: All, PDF, Word, Excel, PPT, TXT, Image.
  - Result rows with matched substring in bold blue, meta line "date · size · /folder", 3-dot; native ad strictly at result position 6.
  - Recent searches list with Clear; no-results illustration "No results for "xyz""; skeleton rows.
- **Gaps vs current app code:**
  - Recent-searches storage is new behavior (not built yet).

### 9. Single-file actions: options sheet, rename, delete, details

- **Folder:** `04_file_management/01_file_actions`
- **Suggested route / code location:** `sheets/dialogs over file lists` / `lib/features/files/widgets/file_options_sheet.dart (+ rename/delete/details dialogs)`
- **Modes:** Light, Dark
- **Frames in this mockup:** A Options bottom sheet (520pt, 28pt top radius); B Rename dialog with validation; C Delete confirmation dialog; D File details sheet
- **Ads on this screen:** None on sheets; the list behind shows one native ad row
- **What the UI contains:**
  - A: header with file name + "2.5 MB • 10/23/2026"; 56pt rows: Open, Share, Rename, Add bookmark, Open in another app, Details, Delete (red).
  - B: title "Rename file", 52pt field with locked ".pdf" suffix, red 1.5px error border and message "Name can't contain / \ : * ? " < > |", Cancel / Rename.
  - C: warning icon, "Delete DMS Practicals.pdf?", "This can't be undone.", file chip with size, Cancel / Delete (#E5484D).
  - D: 120x150 first-page preview with "PG 1/14" chip, key-value table (Name, Type, Size "2.5 MB (2,621,440 bytes)", Modified, Location with copy pill, Bookmarked), "Open file" button.
- **Mockup defects / do NOT copy:**
  - The board nav mentions "Frame C: Annotations" and "Frame D: Export Ops"; these are stale links, no annotation or export UI exists. Ignore.

### 10. Multi-select and batch delete

- **Folder:** `04_file_management/02_multi_select_delete`
- **Suggested route / code location:** `selection mode on file lists` / `lib/features/files/* (SelectionController)`
- **Modes:** Light, Dark
- **Frames in this mockup:** 1 Selection mode active; 2 Delete confirmation "Delete 3 files?"; 3 List after delete with snackbar "3 files deleted"
- **Ads on this screen:** Banner suppressed in selection mode
- **What the UI contains:**
  - App bar turns blue-tinted: close, "3 selected / 7.3 MB total", Select all, share, delete.
  - Rows show leading check circles; selected rows tinted; bottom contextual dock (Share, Bookmark, Delete) replaces the nav; banner suppressed.
  - Confirm dialog and snackbar as described.
- **Mockup defects / do NOT copy:**
  - Rows show drag_indicator handles in selection mode; there is no reordering on these lists. Do not implement the handles.

### 11. Directories (folder browser)

- **Folder:** `04_file_management/03_directories`
- **Suggested route / code location:** `/directories` / `lib/features/directories/directories_screen.dart`
- **Modes:** Light, Dark
- **Frames in this mockup:** A Normal browser; B Permission required; C Protected folder (Android/data); D Empty folder; E Folder not found; F Skeleton list
- **Ads on this screen:** Docked 60pt banner above nav
- **What the UI contains:**
  - Back bar "Directories" + search + more; breadcrumb "Root > Download > Reports" with tappable blue segments.
  - FOLDERS (4) with sort chip "Name ↑": folder rows (name, "Modified Oct 23 · 8 items", chevron). FILES (2) with sort chip "Size ↓": PDF preview row (120 pages · 4.2 MB · Oct 22) and TXT badge row.
  - State messages exactly: "Doc View needs All files access to browse your folders." / "This folder is protected by Android." / "No supported files or folders here." / "This folder no longer exists."
  - Docked banner + bottom nav (All files tab stays active).
- **Gaps vs current app code:**
  - Item counts ("8 items"), page counts ("120 pages") and sort chips are NOT in the current Directories code; counting items per folder may be slow, so compute lazily or omit counts and report it.

### 12. PDF reader

- **Folder:** `05_viewers/01_pdf_reader`
- **Suggested route / code location:** `/viewer (pdf)` / `lib/features/viewer/pdf_viewer_screen.dart`
- **Modes:** Light, Dark (white page kept un-inverted), Skeleton, More menu
- **Frames in this mockup:** 01 Light reader; 02 Dark chassis (page stays white); 03 Skeleton; 04 More bottom sheet
- **Ads on this screen:** NONE (ad-free reading surface)
- **What the UI contains:**
  - Top bar: back, file name + "120 Pages • 4.2 MB", bookmark, 3-dot. Page content (lab-manual page with code block with line numbers and a Param/Type/Description table).
  - Page pill "3 / 120" (with "Page 3 of 120" label) and a floating bottom toolbar: Pages (grid), Go to, Share, More.
  - Dark mode subtitle shows "Night UI Active".
- **Gaps vs current app code:**
  - "Pages" (thumbnail grid) has no dedicated frame; build a simple thumbnail sheet or hide the button and report. No page-scrubber slider is present in this HTML.

### 13. PDF reader exception states and dialogs

- **Folder:** `05_viewers/02_pdf_reader_states`
- **Suggested route / code location:** `/viewer (pdf) dialogs and error screens` / `lib/features/viewer/pdf_viewer_screen.dart`
- **Modes:** Light, Dark
- **Frames in this mockup:** 1 Password-protected dialog; 2 "Go to page" dialog; 3 Corrupt file screen; 4 File missing screen
- **Ads on this screen:** NONE
- **What the UI contains:**
  - 1: blurred page behind a scrim, lock icon, "This PDF is password-protected", field with eye toggle, error "Incorrect password. Try again.", Cancel / Unlock.
  - 2: "Go to page 1 - 120", field showing "42 of 120", hint "Enter a page between 1 and 120", Cancel / Go.
  - 3: "Can't open this PDF" with "Open in another app" and "Back". 4: "This file no longer exists" with "Back to files".

### 14. Office viewer: DOCX, XLSX, PPTX

- **Folder:** `05_viewers/03_office_viewer`
- **Suggested route / code location:** `/viewer (office)` / `lib/features/viewer/office_viewer_screen.dart`
- **Modes:** Light, Dark
- **Frames in this mockup:** 01 DOCX; 02 XLSX; 03 PPTX; 04 Search active; 05 Outline sheet; 06 Error (password) and shimmer
- **Ads on this screen:** NONE
- **What the UI contains:**
  - Shared bar: back, file name, search, outline/table icon, bookmark, 3-dot. Info banners: "Legacy format: text only · Learn more" and "Large spreadsheet: showing first 3000 rows".
  - DOCX: pages on grey canvas with headings, a table, an exhibit caption, page chip "1 / 8". XLSX: frozen header row # / A-F, sheet tabs (Sales, Summary, Data). PPTX: stacked 16:9 slides with slide chip.
  - Search: counter + prev/next, matches highlighted. Outline: indented list of headings/sheets/slides. Error: "Password-protected files can't be opened here" + "Open in another app".
- **Mockup defects / do NOT copy:**
  - No screen.png was included in the original zip; use code.html only.
  - The board text claims a "Rust OpenXML parser"; that is marketing fiction. The app uses the offline_document_viewer package.
  - The XLSX frame shows a "Filter" chip and a sheet-tab "+" (add) button. The viewer is read-only: omit "+", and omit "Filter" unless you implement it.

### 15. Image viewer and TXT viewer

- **Folder:** `05_viewers/04_image_txt_viewer`
- **Suggested route / code location:** `/viewer (image, txt)` / `lib/features/viewer/image_viewer_screen.dart, txt_viewer_screen.dart`
- **Modes:** Light, Dark, Zoomed, Skeleton
- **Frames in this mockup:** Image 01 standard (1.0x); Image 02 zoomed (2.5x); Image 03 shimmer decode; TXT light, dark and typography controls
- **Ads on this screen:** NONE
- **What the UI contains:**
  - Image: pure black canvas, translucent top bar (back, file name, "JPEG ...", 3-dot), bottom info chip "4000 x 3000 · 2.4 MB | 100% Scale"; zoomed HUD with fit/reset and "2.5x" pill.
  - TXT: bar with file name, A- / A+ and monospace toggle, banner "Showing first 1 MB", 1.5 line-height body, font-size control.
- **Mockup defects / do NOT copy:**
  - This PNG is large (2046x2853) and readable; the board text about "Bicubic Hardware Sampling" and "NV21 buffers" is decoration.

### 16. Tools tab (exactly 4 tools)

- **Folder:** `06_tools/01_tools_tab`
- **Suggested route / code location:** `/tools (tab 2)` / `lib/features/tools/tools_screen.dart`
- **Modes:** Light, Dark, Skeleton, Empty
- **Frames in this mockup:** 01 Light; 02 Dark; 03 Shimmer; 04 Empty "Created by you"
- **Ads on this screen:** Docked 60pt banner above nav
- **What the UI contains:**
  - Header "WORKSPACE / Tools" + search. Section "Convert & Create": Image to PDF ("Turn photos into one PDF"), Scan to PDF ("Scan paper with camera"). Section "Edit & Manage": Merge PDF ("Combine PDFs into one"), Split PDF ("Extract pages or ranges").
  - "Created by you" + See All: horizontal cards with PDF previews (Invoice_Scan_Nov.pdf, Receipts_Batch_04.pdf, "Today • 1.2 MB"); empty state "PDFs you create appear here".
  - Docked banner + nav (Tools active).
- **Mockup defects / do NOT copy:**
  - The labels "Engine 4.18" and "2 Utilities" are board decoration; do not ship them.
  - Nav label here is "All Files"; Home uses "All files". Use "All files".
- **Gaps vs current app code:**
  - "See All" opens a list of created PDFs; no frame exists for it. Reuse the PDF file-list design.

### 17. Image to PDF editor and scan review

- **Folder:** `06_tools/02_image_to_pdf_scan`
- **Suggested route / code location:** `/tools/image-to-pdf` / `lib/features/tools/image_list_editor_screen.dart`
- **Modes:** Light, Dark, Scan review, Empty, Skeleton
- **Frames in this mockup:** 01 Light editor; 02 Dark editor; 03 Scan review (perspective quad); 04 Empty "Add images to start"; 05 Shimmer
- **Ads on this screen:** NONE
- **What the UI contains:**
  - Back, "Image to PDF", Clear. Segmented "A4 | Fit to image". File-name field with locked ".pdf". Reorderable rows (drag handle, thumbnail, "Page 1", name, size, remove) with a "Drop to reorder slot" placeholder.
  - Dashed "+ Add more images"; sticky footer "12 images · est. 3.4 MB", chip "A4 High Res", primary "Create PDF".
  - Scan review shows detected corner markers over each page; empty state offers Choose photos / Scan documents.
- **Mockup defects / do NOT copy:**
  - Decorative claims such as "Homography 8-DOF" and "Native Skia/PDF 2.0" are board text, not UI.
- **Gaps vs current app code:**
  - "A4 High Res" chip implies a quality option; the current service has only A4/Fit; show it as a static info chip or add a quality option and report.

### 18. Merge PDF: select, arrange, error

- **Folder:** `06_tools/03_merge_pdf`
- **Suggested route / code location:** `/tools/merge` / `lib/features/tools/library_pdf_picker_screen.dart, merge_screen.dart`
- **Modes:** Light, Dark
- **Frames in this mockup:** 01 Select PDFs; 02 Arrange & merge (drag state); 03 Error variant (encrypted); 04 Skeleton
- **Ads on this screen:** In-feed native ad in step 1 only; no banner
- **What the UI contains:**
  - Step 1: search, source tabs "All PDFs (18) / Recent / Downloads / iCloud Drive", rows with preview, pages, size, date; check circles; in-feed native ad; footer "3 selected / 62 pages total" + "Next".
  - Step 2: "Arrange & merge", Clear, hint "Drag handles to reorder", output name + ".pdf", reorderable rows (with page counts), dragging state, "Pre-flight Checklist: Compilation Ready, 3 files · 62 pages, 8.4 MB", primary "Merge 3 PDFs (62 Pages)".
  - Error: row flagged as encrypted/damaged with Remove action; Merge disabled.
- **Mockup defects / do NOT copy:**
  - The "iCloud Drive" tab is iOS-only; hide it on Android. Page counts per PDF require opening each document; compute lazily and show a placeholder until known.

### 19. Split PDF: pick, configure, error

- **Folder:** `06_tools/04_split_pdf`
- **Suggested route / code location:** `/tools/split` / `lib/features/tools/library_pdf_picker_screen.dart, split_screen.dart`
- **Modes:** Light, Dark
- **Frames in this mockup:** 01 Picker (single select); 02 Split config; 03 Error (dark); 04 Skeleton
- **Ads on this screen:** NONE
- **What the UI contains:**
  - Picker: "Select PDF to split", sort by date, rows with pages/size, footer "1 PDF selected · 120 pages" + Next.
  - Config: Reset; PDF card (name, "120 pages · 4.2 MB"); "PAGE RANGES" field with "Syntax: 1-3, 5, 8-10" and clear; hint "Each range becomes a separate PDF file"; "GENERATED ARTIFACTS (3)" chips (Pages 1-3 · 3 pgs, Page 5 · 1 pg, Pages 8-10 · 3 pgs); "QUICK SELECT MACROS": All pages, Odd pages, Even pages, Every 5 pages; summary "Output: 3 files · 7 pages extracted · EST: 280 KB"; primary "Split into 3 PDFs".
  - Error state: red field + message (e.g. reversed range), button disabled.
- **Gaps vs current app code:**
  - NEW behavior vs current code: quick-select macros and the "EST" size estimate. Macros are easy (they fill the range field); the estimate can be approximate (pages/total x size) and labelled "~".

### 20. Operation progress and results

- **Folder:** `06_tools/05_progress_results`
- **Suggested route / code location:** `dialogs/sheets after a tool runs` / `lib/features/tools/widgets/* (progress dialog, result sheet)`
- **Modes:** Light, Dark
- **Frames in this mockup:** 1 Progress dialog (Creating PDF 65%; Merging variant 45%); 2 Success sheet (single PDF); 3 Split success sheet (3 PDFs); 4 Error fallback sheet; 5 Interstitial ad frame
- **Ads on this screen:** Interstitial only after a successful result, never on launch
- **What the UI contains:**
  - Progress: non-dismissible, 24pt radius, determinate bar, "Processing image 5 of 12", "Approx. 4 seconds remaining · 3.4 MB", Cancel.
  - Success: check, "PDF created", file card with preview + "3.4 MB · 12 pages", Open / Share / Done. Split: "3 PDFs created", "Saved to /Documents/DocView/Split", per-file Open, Share all, Done.
  - Error: "Couldn't create PDF" + reason + Retry / Close. Interstitial: full-screen ad with close.
- **Mockup defects / do NOT copy:**
  - The dimmed Tools backdrop in these frames shows 5 tiles (Create PDF, Split PDF, Merge Docs, Compress, tune). That VIOLATES the 4-tool rule. Use the real Tools tab (Image to PDF, Scan to PDF, Merge PDF, Split PDF) as the backdrop. NO Compress tool.
  - The sample error code "Error 0x82A4" and "142 MB < 350 MB" are invented. Show the real error message; show free-space numbers only if you actually measure them.
  - The "WASM PDF-Core 3.1ms" text is decoration.
- **Gaps vs current app code:**
  - "Approx. seconds remaining" needs a time estimate; show it only if measurable, otherwise omit.

### 21. Settings tab

- **Folder:** `07_settings/01_settings_tab`
- **Suggested route / code location:** `/settings (tab 3)` / `lib/features/settings/settings_screen.dart`
- **Modes:** Light, Dark, Skeleton
- **Frames in this mockup:** 01 Light; 02 Dark; 03 Skeleton
- **Ads on this screen:** Docked 60pt banner above nav
- **What the UI contains:**
  - Rows: File manager, Import files, Rescan now ("Last scan: today, 4:31 PM"); General: Scan settings ("Scan on open"), App theme ("System default"), Clear recent history; Help: FAQ, Send feedback, Share app, Rate us; About: Privacy policy, Open-source licenses, Version "1.0.0 (1)".
  - NO premium, remove-ads or language rows (mandated). Docked banner + nav (Settings active).
- **Mockup defects / do NOT copy:**
  - Uses JetBrains Mono for tiny technical labels. Do not bundle a third font; use Inter with tabular figures.

### 22. Settings sub-screens: theme sheet, scan settings, snackbar

- **Folder:** `07_settings/02_settings_sub_screens`
- **Suggested route / code location:** `sheet + /settings/scan` / `lib/features/settings/*`
- **Modes:** Light, Dark
- **Frames in this mockup:** 01 App theme bottom sheet; 02 Scan settings screen; 03 Snackbar "Image list updated"
- **Ads on this screen:** Docked banner on Scan settings
- **What the UI contains:**
  - Theme sheet over dimmed Settings: three selectable cards (System default, Light "Clean white", Dark "Deep navy"), button "Apply theme".
  - Scan settings: "Scan frequency" radios (Scan on app open / Manual only), "Document filters" switch "Include images", "Storage diagnostics" card ("All files access granted", MANAGE_EXTERNAL_STORAGE, "Open settings"), "Rescan now", docked banner.
  - Snackbar "Image list updated" with action "Rescan now".
- **Mockup defects / do NOT copy:**
  - The diagnostics card is Android-only; on iOS hide it.

### 23. FAQ

- **Folder:** `07_settings/03_faq`
- **Suggested route / code location:** `/settings/faq` / `lib/features/settings/faq_screen.dart`
- **Modes:** Light, Dark, Skeleton
- **Frames in this mockup:** 01 Light; 02 Dark; 03 Skeleton
- **Ads on this screen:** Docked 60pt banner
- **What the UI contains:**
  - Back bar "FAQ" with "6 Topics"; accordion cards with rotating chevron; one card expanded (the iOS sandbox answer); six questions as in the app; bottom tonal button "Still need help? Send feedback".
  - Docked banner + nav (Settings active).
- **Mockup defects / do NOT copy:**
  - Only one answer is written in the mockup; use the answers from Phase 5A for the others.

### 24. AdMob placements and policy board

- **Folder:** `08_ads/01_admob_placements`
- **Suggested route / code location:** `n/a (design reference for ad widgets)` / `lib/core/ads/* (later AdMob phase)`
- **Modes:** Light, Dark
- **Frames in this mockup:** 01 Adaptive banner 60pt (loaded + skeleton); 02 Native ad row 68pt; 03 Native ad card; 04 Interstitial 393x852 with close; 05 Placement map and compliance matrix; 06 Ad failed / NO_FILL collapse
- **Ads on this screen:** This IS the ad reference
- **What the UI contains:**
  - Banner docked above the 64pt nav, with 16pt minimum gap from the FAB; native row matches file-row height; native card between sections; interstitial after tool completion with delayed close; failed ads collapse to zero height.
- **Mockup defects / do NOT copy:**
  - Advertiser names (CloudDrive Pro, Google Workspace, Clean Master...) are placeholders. Real creatives come from AdMob; layouts must tolerate any headline/icon.
  - Mentions "OCR"; there is no OCR in the app.
- **Gaps vs current app code:**
  - This phase builds ad PLACEHOLDER widgets only. Real AdMob SDK integration, consent (UMP/ATT) and ad IDs are a separate phase.

## 8. Common components found in the mockups

Build each once, reuse everywhere (names are suggestions):

- DocViewTheme + color/typography tokens (light/dark) and file-type color map
- AppScaffold (safe areas, optional docked banner + bottom nav)
- BottomNavBar (3 tabs, filled blue active / outlined inactive)
- DocViewAppBar variants: home (logo + title + search), back (title/subtitle + actions), selection (close, "N selected", select all, share, delete), search (pill field)
- UnderlineTabs (Recent / Bookmarks, 3pt indicator)
- FilterChipRow (All, PDF, Word, Excel, PPT, TXT, Image, with type dots)
- BreadcrumbBar (tappable segments, horizontal scroll)
- CategoryTile (4-column grid) and FileTypeGlyph / FileTypeBadge (folded corner, 3 sizes)
- FileRow (68pt): preview or badge, name, meta, bookmark, 3-dot; states default, bookmarked, selected, long-press
- FolderRow, FileThumbnail (48x56, radius 10, hairline; PDF first page, image thumbnail)
- PrimaryButton, SecondaryButton, TonalButton, DestructiveButton, TextButton, DocIconButton (48pt), Fab (56), BottomActionBar
- DocTextField (search, label+error, locked-suffix rename field, password with eye, number, ranges), SegmentedControl (A4 | Fit to image), Checkbox/Radio/Switch
- DocBottomSheet (28pt top radius, drag handle), OptionsList row (56pt), DocDialog (24pt radius), ProgressDialog (determinate), ResultSheet, SnackbarX with action
- InfoBanner (info/warning), ScanProgressBar, PageNumberPill, FloatingReaderToolbar
- EmptyState, ErrorState (illustration + title + subtitle + action), PermissionRequiredState
- Skeleton primitives (ShimmerBox, SkeletonFileRow, SkeletonTile, SkeletonList, SkeletonPage) driven by one animation controller
- AdBannerSlot (60pt, AD pill, collapses when empty), NativeAdRow (68pt), NativeAdCard, InterstitialPlaceholder (close after countdown ring)
- SettingsRow (leading outline icon, title, subtitle/value, chevron or switch), SectionHeader, ExpandableFaqCard
- ToolCard (glossy gradient icon, title, caption), CreatedPdfCard, ReorderablePageRow (drag handle, thumb, remove), DashedAddCard
- OnboardingPage layout + PageIndicator (elongated active pill), SplashLayout

## 9. Not designed yet (create from the design system)

- Component library board (reference for all components above)
- Category file list screen (PDF list; Image category as 3-column photo grid) plus its skeleton and empty state
- Sort bottom sheet (Date / Name / Size, ascending/descending)
- PDF "Pages" thumbnail sheet (or hide the button)
- "Clear recent history" confirm dialog
- "Created by you > See All" list (reuse the PDF file-list design)
- Incoming "Open with" loading state

## 10. Known mockup defects (summary)

- `01_launch/01_splash`: The screenshot shows the wordmark wrapping onto two lines ("Doc" / "View") and overlapping the tagline. Implement it on ONE line with proper spacing.
- `01_launch/04_onboarding_3`: No screen.png was included in the original zip; use code.html only.
- `01_launch/04_onboarding_3`: The HTML <title> says "Splash Screen" (copy-paste error); the content is Onboarding 3.
- `01_launch/04_onboarding_3`: Header pattern differs from pages 1-2 (Step 3 of 3 + back arrow vs Skip). Keep as designed or unify; report the choice.
- `02_home/01_home_all_files`: The FAB overlaps the native ad row and its Install button; this breaks the design system own 16pt-clearance rule. Place the FAB so it never overlaps an ad or a tappable row action (>= 16pt gap).
- `02_home/01_home_all_files`: Tile label here is "Folders / Browse"; the destination screen is titled "Directories". Keep as designed and be consistent.
- `02_home/02_home_state_variants`: Header here reads "DocView" and shows a more_vert icon; Home (01) uses "Doc View" with search only. Use "Doc View" everywhere.
- `04_file_management/01_file_actions`: The board nav mentions "Frame C: Annotations" and "Frame D: Export Ops"; these are stale links, no annotation or export UI exists. Ignore.
- `04_file_management/02_multi_select_delete`: Rows show drag_indicator handles in selection mode; there is no reordering on these lists. Do not implement the handles.
- `05_viewers/03_office_viewer`: No screen.png was included in the original zip; use code.html only.
- `05_viewers/03_office_viewer`: The board text claims a "Rust OpenXML parser"; that is marketing fiction. The app uses the offline_document_viewer package.
- `05_viewers/03_office_viewer`: The XLSX frame shows a "Filter" chip and a sheet-tab "+" (add) button. The viewer is read-only: omit "+", and omit "Filter" unless you implement it.
- `05_viewers/04_image_txt_viewer`: This PNG is large (2046x2853) and readable; the board text about "Bicubic Hardware Sampling" and "NV21 buffers" is decoration.
- `06_tools/01_tools_tab`: The labels "Engine 4.18" and "2 Utilities" are board decoration; do not ship them.
- `06_tools/01_tools_tab`: Nav label here is "All Files"; Home uses "All files". Use "All files".
- `06_tools/02_image_to_pdf_scan`: Decorative claims such as "Homography 8-DOF" and "Native Skia/PDF 2.0" are board text, not UI.
- `06_tools/03_merge_pdf`: The "iCloud Drive" tab is iOS-only; hide it on Android. Page counts per PDF require opening each document; compute lazily and show a placeholder until known.
- `06_tools/05_progress_results`: The dimmed Tools backdrop in these frames shows 5 tiles (Create PDF, Split PDF, Merge Docs, Compress, tune). That VIOLATES the 4-tool rule. Use the real Tools tab (Image to PDF, Scan to PDF, Merge PDF, Split PDF) as the backdrop. NO Compress tool.
- `06_tools/05_progress_results`: The sample error code "Error 0x82A4" and "142 MB < 350 MB" are invented. Show the real error message; show free-space numbers only if you actually measure them.
- `06_tools/05_progress_results`: The "WASM PDF-Core 3.1ms" text is decoration.
- `07_settings/01_settings_tab`: Uses JetBrains Mono for tiny technical labels. Do not bundle a third font; use Inter with tabular figures.
- `07_settings/02_settings_sub_screens`: The diagnostics card is Android-only; on iOS hide it.
- `07_settings/03_faq`: Only one answer is written in the mockup; use the answers from Phase 5A for the others.
- `08_ads/01_admob_placements`: Advertiser names (CloudDrive Pro, Google Workspace, Clean Master...) are placeholders. Real creatives come from AdMob; layouts must tolerate any headline/icon.
- `08_ads/01_admob_placements`: Mentions "OCR"; there is no OCR in the app.

## 11. Workflow

1. Copy this folder to the Flutter project root (`<project>/doc_view_mockups/`). Do **not** add it to `pubspec.yaml` assets.
2. Give the AI the redesign prompts in `AI_REDESIGN_PROMPTS.md` (R-A analysis first, then R-B to R-F in order).
3. After each phase compare the running app (Android emulator, Light and Dark) with the matching `screen.png`.
