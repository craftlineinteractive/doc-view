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
