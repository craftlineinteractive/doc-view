# 04. Gaps and Conflicts: Synthesis & Resolution

This document enumerates all un-designed screens, new behavior features, and known mockup defects identified across `doc_view_mockups/README.md` (sections 9 & 10), `manifest.json`, and the current Flutter implementation.

Each entry is explicitly tagged with a proposed resolution:
- `[implement]`: Synthesize from the design system and build according to specifications.
- `[omit]`: Exclude marketing artifacts, platform-incompatible elements, or duplicate/invalid mock elements.
- `[ask me]`: Flagged for explicit user decision if architectural ambiguity exists.

---

## 1. Un-Designed Screens (Section 9)

| # | Item | Mockup Gap Description | Design System Synthesis Strategy | Proposed Action |
| :- | :--- | :--- | :--- | :--- |
| 1.1 | **Category File List (PDF, Word, Excel, PPT, TXT)** | No dedicated full mockup frame for the category-filtered list (e.g. clicking "PDF" tile on Home). | Synthesize using `DocScaffold`, `DocSubAppBar` with category title + format glyph, `DocFilterChipRow`, search trigger, and standard 68pt `FileRow` list. Support empty and skeleton shimmer states. | `[implement]` |
| 1.2 | **Image Category View (Photo Grid)** | Clicking "Image" category tile needs an image-centric layout instead of a document row list. | Implement a 3-column photo grid with 4pt gaps, square aspect ratio, cached thumbnails, selection checkmark badges, and multi-select support. | `[implement]` |
| 1.3 | **Sort Bottom Sheet** | File lists need sorting options (Date, Name, Size; Ascending / Descending). | Implement `DocBottomSheet` (28pt radius) containing 6 radio list tiles using `OptionsListTile` geometry with checkmark indicators. | `[implement]` |
| 1.4 | **PDF "Pages" Thumbnail Grid Sheet** | PDF reader top bar includes a "Pages" button, but no dedicated page-grid frame exists. | Implement a grid modal sheet (3 columns of page thumbnails with page number badges, highlighting the active page and tapping jumps to page). | `[implement]` |
| 1.5 | **"Clear Recent History" Dialog** | Search screen shows a "Clear" button next to "Recent searches", but no confirmation dialog mockup exists. | Synthesize standard `DocDialog` (24pt radius) titled "Clear search history?" with "Cancel" and destructive "Clear" buttons. | `[implement]` |
| 1.6 | **"Created by you > See All" Screen** | Tools tab has a "See All" action above the "Created by you" card strip, but no dedicated screen exists. | Reuse the standard Category File List screen filtered strictly to the app's output directory (`/DocView/Created/`), titled "Created Documents". | `[implement]` |
| 1.7 | **Incoming "Open with" Loading State** | When Android/iOS launches the app via Intent / Document Interaction, a transition state is needed. | Synthesize a lightweight modal overlay with `CircularProgressIndicator` and "Opening document..." using the radial splash glow background. | `[implement]` |

---

## 2. New Behavior Features (Section 7 & Manifest)

| # | Feature | Mockup Implication | Proposed Technical Solution | Proposed Action |
| :- | :--- | :--- | :--- | :--- |
| 2.1 | **Recent Searches Persistence** | Search screen displays recent queries with clock icons. Current codebase has no search history store. | Persist a FIFO list of the last 10 search terms in `shared_preferences` under key `recent_searches`. Add tap-to-search and per-item remove actions. | `[implement]` |
| 2.2 | **Split PDF Quick-Select Macros** | Split PDF configuration screen shows macro chips: `All Pages`, `Odd Pages`, `Even Pages`, `First 5 Pages`. | Implement macro chip row that programmatically evaluates the document page count and populates the range text field (e.g. `1, 3, 5, 7` for Odd). | `[implement]` |
| 2.3 | **Split PDF "~EST" File Size Estimate** | Split PDF config shows an estimated output size pill (`~EST: 2.1 MB`). | Calculate an approximate estimate based on linear page ratio: `(selectedPages / totalPages) * originalFileSize`, formatted with `~EST: X.X MB`. | `[implement]` |
| 2.4 | **Lazy Folder Item & Page Counts** | Mockups show "8 items" on folder rows and "120 pages" on PDF picker rows. Synchronous computation slows directory traversal. | Compute folder item counts lazily via lightweight directory listing isolates; display skeleton/dash until resolved. | `[implement]` |

---

## 3. Known Mockup Defects & Reconciliations (Section 10)

| # | Mockup Location | Defect in Mockup | Reconciliation / Required Rule | Proposed Action |
| :- | :--- | :--- | :--- | :--- |
| 3.1 | `01_launch/01_splash` | Wordmark wraps onto two lines ("Doc" / "View") and overlaps tagline in screenshot. | Render "Doc View" on a **SINGLE** horizontal line in Space Grotesk 32pt Bold with proper vertical spacing (12pt) above tagline. | `[implement]` |
| 3.2 | `01_launch/04_onboarding_3` | Missing `screen.png`; HTML title says "Splash Screen". Header shows "Step 3 of 3" + back arrow instead of "Skip". | Use `code.html`. Keep consistent: Page 3 shows back arrow on left, no "Skip" on right, and bottom CTA changes to "Get Started". | `[implement]` |
| 3.3 | `01_launch/05_permissions` | Frame B shows iOS "Bring your documents to Doc View". | Strictly hide Frame B on Android. Android displays Frame A ("All files access") only. On iOS, display Frame B only. | `[implement]` |
| 3.4 | `02_home/01_home_all_files` | FAB overlaps the native ad row and its "Install" button, violating the 16pt clearance rule. | Enforce minimum 16pt vertical gap between FAB bottom edge and the top boundary of any ad container. | `[implement]` |
| 3.5 | `02_home/01_home_all_files` | Tile is labeled "Folders / Browse", but screen is titled "Directories". | Keep tile labeled "Folders / Browse" on Home and screen app bar titled "Directories", consistent with mockups. | `[implement]` |
| 3.6 | `02_home/02_home_state_variants` | Header reads "DocView" (no space) with `more_vert` menu icon. | Unify to brand standard: "Doc View" (with space) and search icon only; no `more_vert` menu. | `[implement]` |
| 3.7 | `04_file_management/01_file_actions` | Board nav lists "Frame C: Annotations" and "Frame D: Export Ops". | Stale links from earlier mockup drafts. Omit completely. The app does not support annotation. | `[omit]` |
| 3.8 | `04_file_management/02_multi_select` | Mockup file rows show `drag_indicator` handles in selection mode. | File lists are not manually reorderable. Omit drag handles; render standard selection checkboxes only. | `[omit]` |
| 3.9 | `05_viewers/03_office_viewer` | Marketing board claims "Rust OpenXML parser"; XLSX mockup shows "+" add tab and "Filter" chip. | Omit marketing text. The viewer is strictly read-only: omit "+" tab button and omit "Filter" chip. | `[omit]` |
| 3.10 | `05_viewers/04_image_txt_viewer` | Board text references "Bicubic Hardware Sampling" and "NV21 buffers". | Decorative marketing text. Omit from production UI. | `[omit]` |
| 3.11 | `06_tools/01_tools_tab` | Mockup shows decorative labels "Engine 4.18" and "2 Utilities". Nav label says "All Files" (capitalized). | Omit decorative engine labels. Unify bottom nav label to "All files" (lowercase 'f'). | `[omit]` |
| 3.12 | `06_tools/03_merge_pdf` | Mockup shows an "iCloud Drive" tab. | Platform-specific tab: hide "iCloud Drive" tab completely on Android. | `[omit]` |
| 3.13 | `06_tools/05_progress_results` | Dimmed backdrop behind progress/results sheets displays 5 tools including "Compress". | **STRICT HARD RULE VIOLATION**: The app has EXACTLY 4 tools (Image to PDF, Scan to PDF, Merge PDF, Split PDF). Never display "Compress". Backdrop must show the authentic 4-tool grid. | `[omit]` |
| 3.14 | `06_tools/05_progress_results` | Mockup shows invented error code "Error 0x82A4", "142 MB < 350 MB", and "WASM PDF-Core 3.1ms". | Display real exception messages. Free space warnings displayed only if measured via device storage API. | `[omit]` |
| 3.15 | `07_settings/01_settings_tab` | Technical version labels styled with JetBrains Mono. | Do not bundle JetBrains Mono. Use Inter with tabular figures (`FontFeature.tabularFigures()`). | `[omit]` |
| 3.16 | `07_settings/02_settings_sub_screens`| Diagnostics card on Scan Settings screen. | Display diagnostics card on Android only; hide on iOS where storage access diagnostics are inapplicable. | `[implement]` |
| 3.17 | `07_settings/03_faq` | Only 1 FAQ answer is written out in mockup board. | Populate all questions and answers using the verified FAQ dataset from Phase 5A. | `[implement]` |
| 3.18 | `08_ads/01_admob_placements` | Mockup specifies placeholder advertiser names and mentions "OCR". | Mockup text is illustrative. The app has no OCR tool. Ad widgets are built as platform-ready placeholders. | `[omit]` |

---

## 5. Owner-Approved Design Deviations (Prompt R-E1)

| # | Feature / Area | Specification in Mockup | Owner-Approved Deviation | Status |
| :- | :--- | :--- | :--- | :--- |
| 5.1 | **Home Category Tiles Background** | Rounded rectangular container cards with background tint and border. | **Borderless with no card background**: category tiles display directly on header/scaffold background without enclosing rounded box cards. | `[approved & kept]` |
| 5.2 | **Home Category Icons Geometry** | Standard rounded square icons with full-bleed flat fill. | **44x44 rounded squares (11pt radius) with folded corner**: folded top-right corner front side, white glyphs (PDF, W, X, PPT, TXT, Image icon). | `[approved & kept]` |
| 5.3 | **Launcher App Icon** | Single blue document square with white folded corner. | **4-Quadrant Launcher Icon**: 4 rounded quadrants (Red PDF, Blue Word, Green Excel, Orange PPT) inside adaptive icon squircle. | `[approved & kept]` |

---

## 6. Technical Limitations & Gaps (Prompt R-E2)

| # | Feature / Area | Specification in Mockup | Behavior & Resolution | Status |
| :- | :--- | :--- | :--- | :--- |
| 6.1 | **PPTX Offline Viewer Fallback** | All presentation files expected to render offline in-app. | Valid PPTX files with standard slides, slide layouts, and slide masters (`presentation_1.pptx`, `Dickinson_Template_basic.pptx`) render with high fidelity in both debug and release. Incomplete archives lacking masters or presentations with 0 slides (`sample.pptx`, `Dickinson_Template_black.pptx`) trigger `RendererFailure: no_slides`. Respected existing fallback: "Can't open this document. The document could not be rendered offline. [Open in another app]" via `OpenFilex`. | `[verified & documented]` |
| 6.2 | **Split PDF Macros: Odd/Even Pages Omission** | Mockups illustrate "Odd pages" and "Even pages" split macros. | In Split PDF, each extracted range becomes an independent output PDF file. Generating 50 separate 1-page PDFs for odd/even pages violates user intent. Omitted per Owner Decision; implemented only "All pages" and "Every 5 pages" macros (disabled above 100 files). | `[omit]` |
| 6.3 | **Merge PDF "+ Add PDF" Action** | Merge Arrange screen in mockup 03_merge_pdf has no direct button to add more PDFs once on arrange step. | Added "+ Add PDF" outlined button at the end of the reorderable list that returns to the picker to append more files without losing order. | `[implement & kept]` |
| 6.4 | **Offline Privacy Claim vs. AdMob Phase** | Launch onboarding badge states "100% Offline" and FAQ question 2 claims zero networking libraries. | In future AdMob phase, SDK requires network access for ads. FAQ question 2 updated per Owner Decision to state: "Your documents never leave your device. Doc View opens, converts and stores files locally. The app shows ads served by Google AdMob, which can use limited device data as described in our Privacy Policy." Must revisit "100% Offline" badge when AdMob is wired. | `[reconciled]` |

---

## 4. Summary of Actions

- **Total Items Categorized**: 29
- **Implement**: 16 items (Synthesized screens, persisted history, macros, size estimates, defect corrections)
- **Omit**: 13 items (Marketing artifacts, 5th tool, stale links, unneeded fonts, fake error codes)
- **Ask Me**: 0 items (All conflicts resolved deterministically via the governance rules in `README.md`).

