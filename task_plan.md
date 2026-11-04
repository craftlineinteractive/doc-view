# Phase 3B: PDF Tools Implementation Plan

> **Goal:** Implement the Tools tab with 4 complete PDF creation and editing features: Image to PDF, Scan to PDF, Merge PDF, and Split PDF, adhering to dark/light theme consistency, UI performance isolates, touch accessibility, and comprehensive testing.

**Architecture:**
- **Services Layer (`lib/data/services/pdf/`)**:
  - `pdf_output_service.dart`: Creates and manages the `created/` output directory, sanitizes file names, generates collision-free file paths (`uniqueFile`), and registers created PDFs into SQLite (`DocFile`) with provider invalidation.
  - `image_to_pdf_service.dart`: Memory-safe image-to-PDF conversion. Compresses each image individually with `flutter_image_compress` (JPEG, quality 80, max 1600px), builds PDF using `package:pdf`, handles progress callbacks, and builds in isolate.
  - `pdf_merge_service.dart`: Merges multiple PDFs preserving original vectors using `pdfrx`'s `PdfDocument.createNew()`, `pages` assignment, and `encodePdf()`.
  - `pdf_split_service.dart`: Splits a PDF into multiple documents using `pdfrx` page slicing and encoding according to parsed `PageRange`s.
- **Pure Logic Utility (`lib/core/utils/page_range_parser.dart`)**:
  - Validates and parses page range expressions (`"1-3, 5, 8-10"`) against total document page count without merging or reordering.
- **UI Layer (`lib/features/tools/`)**:
  - `tools_screen.dart`: Two sections ("Convert & Create", "Edit & Manage") displaying exactly the 4 implemented tools in 4-column grid tiles (>=48dp touch targets).
  - `widgets/tool_result_bottom_sheet.dart`: Shared success sheet displaying generated PDF(s) with Open (`openDocument`), Share (`share_plus`), and Done actions.
  - `widgets/library_pdf_picker_screen.dart`: Reusable indexed PDF picker (multi-select for Merge, single-select for Split) with search filtering and checkboxes.
  - `image_list_editor_screen.dart`: Shared reorderable thumbnail editor for both Image to PDF and Scan to PDF, with page mode selector (A4 vs Fit), file naming, and progress dialog.
  - `merge_screen.dart`: Reorderable PDF list with remove actions, file naming, and progress indicator.
  - `split_screen.dart`: Document page count summary, live inline syntax validation for page ranges, and multi-file progress dialog.

**Tech Stack:**
- Flutter 3.x, Riverpod 3.x, GoRouter, SQLite (sqflite)
- `pdfrx` (native PDFium document inspection, page slicing, and encoding)
- `pdf` (creating PDFs from images)
- `cunning_document_scanner` (system/ML Kit document camera scanner)
- `flutter_image_compress` (memory-safe image resizing and compression)
- `share_plus` (system sharing intent)

---

## Phases & Tasks

### Phase 1: Core Logic & Services
- [x] Task 1.1: Implement `PageRangeParser` (`lib/core/utils/page_range_parser.dart`) and unit tests (`test/unit_test.dart`)
- [x] Task 1.2: Implement `PdfOutputService` (`lib/data/services/pdf/pdf_output_service.dart`) with file sanitization and registration
- [x] Task 1.3: Implement `ImageToPdfService` (`lib/data/services/pdf/image_to_pdf_service.dart`) with isolated compilation and memory-safe compression
- [x] Task 1.4: Implement `PdfMergeService` (`lib/data/services/pdf/pdf_merge_service.dart`) using `pdfrx`
- [x] Task 1.5: Implement `PdfSplitService` (`lib/data/services/pdf/pdf_split_service.dart`) using `pdfrx`

### Phase 2: Shared UI Components
- [x] Task 2.1: Implement `ToolResultBottomSheet` (`lib/features/tools/widgets/tool_result_bottom_sheet.dart`)
- [x] Task 2.2: Implement `LibraryPdfPickerScreen` (`lib/features/tools/widgets/library_pdf_picker_screen.dart`) for single and multi-select modes

### Phase 3: Tool Implementation & Screens
- [x] Task 3.1: Implement `ImageListEditorScreen` (`lib/features/tools/image_list_editor_screen.dart`) shared by Image to PDF & Scan to PDF
- [x] Task 3.2: Implement `MergeScreen` (`lib/features/tools/merge_screen.dart`)
- [x] Task 3.3: Implement `SplitScreen` (`lib/features/tools/split_screen.dart`)
- [x] Task 3.4: Rebuild `ToolsScreen` (`lib/features/tools/tools_screen.dart`) with the 4-column grid layout and 2 sections

### Phase 4: Verification & Manual Testing
- [x] Task 4.1: Run `flutter analyze` & fix any warnings/errors (0 issues found)
- [x] Task 4.2: Run `flutter test` & verify all unit tests pass (26/26 passed)
- [x] Task 4.3: Build & install APK on emulator for user manual QA
