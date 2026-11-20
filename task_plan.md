# Task Plan: Phase G3a - PDF Reader Upgrade & Pages Screen

## Overview
Phase G3a upgrades the Doc View PDF reader with a redesigned top bar (with conditional Convert-to-Word icon, Pages icon, and 3-dot menu), a shared 5-item `ReaderBottomRow` ("Vertical/Horizontal", "Rotate", "Search", "Invert", "Share"), a debounced async `ReaderSearchBar` with match highlighting and no-text-layer message, a clean Isolate-based `PdfPageEditService`, and a new `/pdf-pages` (`PagesScreen`) with lazy thumbnails, selection, drag-to-reorder, insert from another PDF, rotate, extract, delete, undo, and safe temp-then-rename saving.

## Phases & Tasks

### [x] Step 0: Real Baseline Report & Architecture Decisions
- [x] Run `git status`, baseline `flutter analyze` and `flutter test`.
- [x] Analyze pdfrx capabilities without Syncfusion (Spike 1f).
- [x] Document current `lib/features/viewer/` structure & shared components.
- [x] Document pdfrx APIs for horizontal layout, text search, and scanned PDFs.
- [x] Record blank page deferral in `docs/redesign/04_gaps_and_conflicts.md`.

### [x] Task 1: Shared Reader Components (`ReaderBottomRow` & `ReaderSearchBar`)
- [x] Create `lib/shared/widgets/reader/reader_bottom_row.dart`:
  - 5 items, 64pt height, outlined icons + labels, tooltips, accessible semantics, RTL aware, reduced motion aware, selected/toggled state styling for Invert.
  - Reusable for G3b.
- [x] Create `lib/shared/widgets/reader/reader_search_bar.dart`:
  - Replaces top bar during search: back/cancel button, search text field, match counter ("X of Y" / "500+"), prev/next chevron buttons, clear button.
  - Debounced input (300 ms), accessible semantics, high-contrast states.
- [x] Add both components to `ComponentGalleryScreen` (`lib/features/debug/component_gallery_screen.dart`).
- [x] Verify `flutter analyze`.

### [x] Task 2: PDF Reader Chrome Upgrade & Inverted Matrix
- [x] Extract all strings to ARB in `lib/l10n/app_en.arb` and regenerate `app_en_XA.arb` + `AppLocalizations`.
- [x] Update `lib/features/viewer/pdf_viewer_screen.dart`:
  - Top bar: back button, file name (ellipsis) + "N Pages • size", Convert-to-Word icon (`conversionsEnabled` gated), Pages icon (navigates to `/pdf-pages`), 3-dot menu (Go to page, Bookmark toggle, Details sheet, Open in another app).
  - Bottom row: `ReaderBottomRow` with:
    1. "Vertical/Horizontal" (toggles scroll direction; label shows mode to switch TO; maintains current page).
    2. "Rotate" (toggles system portrait/landscape orientations; restores on exit).
    3. "Search" (activates `ReaderSearchBar`).
    4. "Invert" (`ColorFiltered` matrix applied to PDF canvas only; session only).
    5. "Share" (invokes existing file share).
  - Auto-hiding top bar & bottom row on page tap (page pill auto-fades after 2.5s idle).
  - Keep password, corrupt, missing-file flows intact.
- [x] Remove `lib/features/viewer/pdf_viewer_screen.dart`, `widgets/pdf_more_sheet.dart`, `widgets/pdf_pages_sheet.dart` from `test/l10n/pending_rewrite.txt`.
- [x] Verify `flutter analyze`.

### [x] Task 3: Asynchronous Text Search Implementation
- [x] Wire `PdfTextSearcher` to `PdfViewerController` in `pdf_viewer_screen.dart`.
- [x] Configure `pagePaintCallbacks` with `matchTextColor` (yellow with alpha) and `activeMatchTextColor` (orange with alpha).
- [x] Debounce query by 300 ms; cap counter at 500 matches with `"500+"`.
- [x] Detect scanned PDFs with no text layer (`page.loadText()` empty across pages) and show localized `"This PDF has no searchable text"`.
- [x] Verify scrolling remains smooth during search on 100+ page PDF.
- [x] Verify `flutter analyze`.

### [x] Task 4: PdfPageEditService & Typed Errors
- [x] Add typed PDF page editing error reasons to `lib/core/errors/app_errors.dart` (e.g. `sourceFileNotFound`, `passwordProtectedOrCorrupt`, `allPagesDeleted`, `saveFailed`).
- [x] Implement `lib/data/services/pdf/pdf_page_edit_service.dart`:
  - Takes output path, list of `{sourcePath, sourcePageIndex, rotationDegrees}`.
  - Runs in an Isolate (top-level function, primitive DTOs only).
  - Reorder, rotate, delete, extract, and insert pages from other PDFs via `pdfrx` (`PdfDocument.createNew`, `doc.pages`, `page.rotatedTo`, `encodePdf`).
  - Progress reporting via `SendPort`.
  - Pure typed errors, zero UI/user-facing strings.
- [x] Unit tests in `test/services/pdf_page_edit_service_test.dart` using programmatically generated PDFs (`package:pdf` in tests only) verifying correctness of reorder, rotate, delete, extract, and insert.
- [x] Verify `flutter analyze`.

### [x] Task 5: Pages Screen (`/pdf-pages`)
- [x] Create `lib/features/viewer/pages_screen.dart`:
  - Route `/pdf-pages` in `lib/core/router/app_router.dart`.
  - Top bar: back, "N Pages", Undo button, "Select all / Clear", "Save" (enabled only when unsaved changes exist).
  - Body: virtualized thumbnail grid (3 cols portrait, 5 landscape) with page number, lazy rendering, at most 2 concurrent renders, 60-item LRU cache, skeleton placeholders. Initial page from reader scrolled into view and highlighted.
  - Drag to reorder (`ReorderableListView` / custom reorder grid).
  - Tapping toggles selection check badge.
  - Bottom row:
    - Nothing selected: "Insert" -> bottom sheet with "Pages from another PDF" (existing picker, inserts after selected/end; "Blank page" hidden per Step 0b).
    - One or more selected: "Rotate" (+90° CW per tap, live thumbnail update), "Extract" (creates new PDF with selected pages), "Delete" (blocked if all pages selected).
  - Single-level "Undo" in top bar.
  - "Save" dialog: "Save as new file" (default) & "Replace original" (safe temp file in same folder, verify readable, atomic rename).
  - Unsaved changes confirmation dialog ("Discard changes?").
  - Integration with `createdFilesProvider` and `PdfOutputService`.
- [x] Verify `flutter analyze`.

### [x] Task 6: Comprehensive Automated Tests
- [x] Update `test/features/pdf_viewer_test.dart` and `test/features/pages_screen_test.dart`.
- [x] Update `test/l10n/l10n_overflow_and_rtl_test.dart` for reader chrome, search bar, and pages screen at 1.0x & 2.0x text scales in `en_XA` and RTL.
- [x] Verify inverted guardrail passes with 0 violations across 102 files.
- [x] Verify `flutter test` passes with 391 tests.

### [x] Task 7: Live Emulator QA on `emulator-5554` & Performance Profiling
- [x] Capture light/dark screenshots under `docs/redesign/img/g3a/` (all < 300 KB):
  - 100+ page PDF reader, horizontal mode, phone rotation, invert mode, search with matches, search with no matches, scanned PDF no-text-layer message.
  - Pages screen: grid, reorder, rotate, delete, insert, save as new, replace original.
  - Correctness evidence: 6-page test PDF (P1..P6) reordered, rotated, saved, and opened.
- [x] Run scrolling benchmark on 120-page PDF; reported 62.27 ms/frame average.
- [x] Verify physical phone availability or emulator-only.

### [x] Task 8: Documentation & Atomic Area Commits
- [x] Update `docs/redesign/08_new_screens.md`.
- [x] Commit per area following Conventional Commits with QA lines.
- [x] Deliver final G3a report.

---

# Phase G3b: Office Viewers Modernization (Word, PPT, TXT)

### [x] Task 1: Orientation Extraction & Shared Infrastructure
- [x] Extracted `ReaderOrientationController` into `lib/shared/widgets/reader/reader_orientation.dart`.
- [x] Restores portrait/landscape orientations on dispose and when app is backgrounded.
- [x] Updated `PdfViewerScreen` to reuse `ReaderOrientationController`.

### [x] Task 2: Word, RTF, and PowerPoint Reader Upgrade
- [x] Reused `ReaderBottomRow` in `OfficeViewerScreen` with: Rotate, Search, Share (Vertical/Horizontal and Invert strictly hidden per Step 0b capability analysis).
- [x] Reused `ReaderSearchBar` wired to `DocumentViewController.search(query)` with match counters.
- [x] Retained legacy banners ("Legacy format: text only") for .doc, .ppt, and .rtf formats.
- [x] Documented platform view invert limitation in `docs/redesign/04_gaps_and_conflicts.md`.

### [x] Task 3: TXT Viewer Modernization & Isolate Search
- [x] Modernized `TxtViewerScreen` with `ReaderBottomRow` (Rotate, Search, Invert, Share).
- [x] Implemented background isolate search over loaded lines with 500-match cap and "500+" indicator.
- [x] Added distinct highlighting for current and non-current search matches with auto-scroll jump.
- [x] Implemented session-only canvas inversion filter.
- [x] Retained top-bar controls (A-, A+, monospace font) and 1 MB safety cap.

### [x] Task 4: String Extraction & Guardrail Verification
- [x] Extracted all viewer strings to ARB (`app_en.arb` and `app_en_XA.arb`).
- [x] Removed `office_viewer_screen.dart`, `txt_viewer_screen.dart`, `image_viewer_screen.dart`, and `viewer_screen.dart` from pending rewrite.
- [x] Verified inverted string guardrail with 0 violations across 113 surviving `lib/` files.

### [x] Task 5: Automated Testing & Emulator QA
- [x] Added widget test suites `test/features/office_viewer_test.dart` and `test/features/txt_viewer_test.dart`.
- [x] Added layout tests to `test/l10n/l10n_overflow_and_rtl_test.dart`.
- [x] Verified full test suite passing (426 tests).
- [x] Captured 13 emulator QA screenshots under `docs/redesign/img/g3b/` (< 300 KB each).

---

# Phase G3c: Native Spreadsheet Grid Viewer (XLSX, XLSM, CSV, TSV)

### [x] Task 1: Package Dependencies & Step 0 Spikes
- [x] Added `excel: ^4.0.6`, `csv: ^6.0.0`, and `two_dimensional_scrollables: ^0.3.9` with aligned transitive overrides.
- [x] Documented package capabilities and 100k row memory benchmarks in `docs/spikes/g0_report.md` Section 8.
- [x] Recorded formula, sheet visibility, and OLE2 encryption limits in `docs/redesign/04_gaps_and_conflicts.md`.

### [x] Task 2: Models & Isolate Parser Service
- [x] Implemented `SpreadsheetCell`, `SheetData`, `WorkbookData`, and `MergedCellRange` DTO models.
- [x] Implemented `SpreadsheetParserService` with background isolate workers (`_parseExcelWorker`, `_parseDelimitedWorker`).
- [x] Enforced hard cap of 20,000 rows and 100 columns per sheet with dismissible info banner.
- [x] Implemented typed exceptions (`SpreadsheetPasswordProtectedException`, `SpreadsheetTooLargeException`, `SpreadsheetTimeoutException`).
- [x] Verified with 11 unit tests in `test/features/spreadsheet_parsing_test.dart`.

### [x] Task 3: Shared Grid & Reader Components
- [x] Built `SpreadsheetGrid` on `TableView.builder` with pinned row/col headers, merged cell spans, selection, double-tap zoom, and canvas invert filter.
- [x] Built `FormulaBar` with coordinate chip, formula/display text, bottom sheet inspector, and TSV clipboard copy.
- [x] Built `SheetTabBar` scrollable tab list for multi-sheet workbooks.
- [x] Built floating `ZoomPill` displaying active zoom percentage with tap-to-reset.
- [x] Verified with 6 widget tests in `test/shared/widgets/spreadsheet_components_test.dart`.

### [x] Task 4: SpreadsheetViewerScreen & Dispatcher Routing
- [x] Implemented `SpreadsheetViewerScreen` in `lib/features/viewer/spreadsheet_viewer_screen.dart`.
- [x] Updated `ViewerScreen` routing: `.xlsx`, `.xlsm`, `.csv`, `.tsv` to `SpreadsheetViewerScreen`; legacy `.xls` to `OfficeViewerScreen`.
- [x] Integrated `ReaderBottomRow` (Rotate, Search, Invert, Share) and `ReaderSearchBar` with isolate match computation.
- [x] Implemented error fallbacks: password lock screen, 20s timeout limit, and oversized file limit.
- [x] Verified with 10 widget tests in `test/features/spreadsheet_viewer_test.dart`.

### [x] Task 5: Localization & RTL Guardrail
- [x] Added all spreadsheet strings to `app_en.arb` and `app_en_XA.arb`.
- [x] Removed `spreadsheet_viewer_screen.dart` and `viewer_screen.dart` from pending rewrite.
- [x] Verified inverted string guardrail with 0 violations across 116 surviving `lib/` files.
- [x] Verified `l10n_overflow_and_rtl_test.dart` passes across 4 layout configs (198 tests).

### [x] Task 6: Live Emulator QA & Performance Profiling
- [x] Generated 6 test workbooks (`test_20k.xlsx`, `test_styled.xlsx`, `test_100k.csv`, `sample.xls`, `test_encrypted.xlsx`, `test_oversized.xlsx`).
- [x] Captured 15 emulator screenshots under `docs/redesign/img/g3c/` (< 300 KB each).
- [x] Benchmarked frame times (18 ms 50th percentile) and heap footprints (Native 55.8 MB PSS, Dalvik 8.6 MB).
- [x] Documented screenshots and benchmarks in `docs/redesign/08_new_screens.md` and `docs/spikes/g0_report.md`.

