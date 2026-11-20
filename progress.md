# Progress Log: Phase G3a - G3c

- **Baseline**:
  - `git status`: Clean working tree (at `ff306dd`).
  - `flutter analyze`: 0 issues found (10.2s).
  - `flutter test`: 346/346 passing.

- **Phase G3a Completed**:
  - `ReaderBottomRow` & `ReaderSearchBar` created and wired to ComponentGallery.
  - PDF reader chrome modernized with top bar, 5-item bottom row, and color inversion matrix.
  - Asynchronous search implemented with `PdfTextSearcher`, match callbacks, and scanned PDF detection.
  - `PdfPageEditService` implemented with pure typed errors and tested with 7 unit tests.
  - `PagesScreen` created with responsive 3/5-col grid, lazy LRU thumbnail cache, reordering, rotation, deletion, undo, and atomic save.
  - Guardrail verified clean: 102 files scanned, 0 violations.
  - Full test suite passing: 391/391 tests passed (0 failures).
  - All 15 emulator screenshots captured under `docs/redesign/img/g3a/` (all < 300 KB).
  - 120-page document rapid scroll benchmarked at 62.27 ms/frame on emulator.
  - Documentation updated in `docs/redesign/08_new_screens.md`.

- **Phase G3b Completed**:
  - Extracted shared `ReaderOrientationController` with lifecycle-aware system orientation management.
  - Modernized `OfficeViewerScreen` (DOCX, DOCM, RTF, PPTX, PPTM, PPT) with `ReaderBottomRow` (Rotate, Search, Share) and `ReaderSearchBar`.
  - Modernized `TxtViewerScreen` with `ReaderBottomRow` (Rotate, Search, Invert, Share), isolate search, and 500+ match cap.
  - Removed all office, text, image, and dispatcher viewers from pending rewrite list.
  - Guardrail verified clean: 113 files scanned, 0 violations.
  - Full test suite passing: 426/426 tests passed (0 failures).
  - All 13 emulator screenshots captured under `docs/redesign/img/g3b/` (all < 300 KB).

- **Phase G3c Completed**:
  - Added dependencies `excel: ^4.0.6`, `csv: ^6.0.0`, and `two_dimensional_scrollables: ^0.3.9`.
  - Implemented `SpreadsheetParserService` with background isolate workers and 20,000 row / 100 column caps.
  - Implemented `SpreadsheetGrid` with pinned headers, merged cell ranges, double-tap zoom, and invert canvas filter.
  - Implemented `FormulaBar`, `SheetTabBar`, and `ZoomPill`.
  - Implemented `SpreadsheetViewerScreen` with routing for `.xlsx`, `.xlsm`, `.csv`, `.tsv`, and legacy `.xls` fallback.
  - Guardrail verified clean: 116 files scanned, 0 violations.
  - Full test suite passing: 463/463 tests passed (0 failures).
  - All 15 emulator screenshots captured under `docs/redesign/img/g3c/` (all < 300 KB).
  - Profiling: 18 ms scroll frame time (50th percentile), Dalvik heap 8.6 MB, Native heap 55.8 MB PSS.
