# Findings: Phase G3a - G3c

## Phase G3a: PDF Reader & Pages Screen

### pdfrx Capabilities Analysis (Step 0b)
1. **Rotate page**: Supported natively via `page.rotatedTo(PdfPageRotation rotation)`, `page.rotatedCW90()`, `page.rotatedBy(...)` from `PdfPageWithRotationExtension`. When `outputDoc.encodePdf()` is called, PDFium persists rotation via `FPDFPage_SetRotation`.
2. **Delete pages**: Supported natively by omitting pages from `outputDoc.pages = [pages]`.
3. **Reorder pages**: Supported natively by reordering `PdfPage` items in `outputDoc.pages = [pages]`.
4. **Extract pages**: Supported natively by creating `outputDoc = await PdfDocument.createNew()` and assigning the desired slice of pages to `outputDoc.pages`, followed by `encodePdf()`.
5. **Insert pages from another PDF**: Supported natively by opening the source PDF via `PdfDocument.openFile()` and assigning `outputDoc.pages = [...targetPages, ...sourcePages]`.
6. **Insert blank page**: `pdfrx` / `pdfrx_engine` has **no native API to create an empty `PdfPage`** (e.g. `PdfDocument.createBlankPage()` does not exist).
   - Recorded in `docs/redesign/04_gaps_and_conflicts.md` under section 6.5.

### Text Search Architecture (Step 0d)
- Uses `PdfTextSearcher(_controller)`.
- Highlights rendered via `PdfViewerParams.pagePaintCallbacks: [_textSearcher.defaultPaintCallback]`.
- Colors: `matchTextColor: Colors.yellow.withValues(alpha: 0.5)` and `activeMatchTextColor: Colors.orange.withValues(alpha: 0.6)`.
- Scanned PDF detection: if 0 matches and `page.loadText()` has empty text on all pages, show "This PDF has no searchable text".
- Debounce: 300 ms. Capped at 500 matches with "500+".

### Horizontal Page Layout Architecture (Step 0d)
- Uses `PdfViewerParams.layoutPages` with `PdfPageLayout Function(List<PdfPage> pages, PdfViewerParams params)`.
- Computes horizontal offsets `Rect.fromLTWH(x, (height - page.height)/2, page.width, page.height)`.
- RTL support: pages laid out in reading order according to text direction.
- Switching between vertical and horizontal calls `_controller.invalidate()`.

---

## Phase G3b: Office Viewers & Capability Boundaries

### WebView & Platform View Limitations
1. **ColorFiltered Invert Failure**: Wrapping `DocumentView` with a `ColorFiltered` invert matrix does NOT invert the Android `InAppWebView` platform view (platform views bypass Flutter canvas-layer raster filters). Result confirmed on emulator: document background remained white `RGB(241, 242, 245)`. Per owner capability rule, Invert was strictly hidden on `ReaderBottomRow` for Word, RTF, and PowerPoint.
2. **Horizontal Layout**: `offline_document_viewer` has no public API for horizontal scroll layout or single-page paging. Strictly hidden on `ReaderBottomRow`.
3. **Search Cursor Stepping**: `DocumentViewController.search(query)` highlights matches in web preview and reports `searchHits`, but does not provide `nextMatch()` or `previousMatch()`. `ReaderSearchBar` displays match count while omitting unsupported navigation chevrons.

### TXT Viewer Isolate Search
- Text lines scanned inside an isolated worker thread using case-insensitive substring matching.
- Virtualized `ListView.builder` renders highlighted spans only for visible lines to ensure 60 fps rendering on large text files.
- Session-only canvas invert swaps background/foreground theme colors without modifying platform views.

---

## Phase G3c: Spreadsheet Grid & Package Capabilities

### Excel Package (`excel: 4.0.6`) Analysis
1. **Merged Cell Spans**: Exposed via `sheet.spannedItems` (`List<String>`, e.g. `['A1:B2']`).
2. **Styles & Colors**: Background fill color exposed as hex via `cell.cellStyle?.backgroundColor.colorHex`; font styles exposed via `isBold`, `fontFamily`, `fontSize`.
3. **Formulas**: Formula text exposed via `FormulaCellValue.formula`. Does not evaluate or cache calculated formula results.
4. **Sheet Visibility**: `excel` does not expose sheet visibility; all decoded sheets are surfaced in `SheetTabBar`.
5. **Password Protection**: Decoding encrypted OOXML compound containers throws `UnsupportedError`. Caught and surfaced as a dedicated lock screen with "Open in another app".
6. **Large Workbook Footprint**: 100k rows × 12 cols evaluated in isolate consumed **677.66 MB** peak RSS. Validated the 20,000-row / 100-column safety cap to guarantee $< 30\text{ MB}$ heap footprint on mobile devices.

### `two_dimensional_scrollables` (0.3.9) TableView
1. **Virtualization**: Recycles off-screen cells; only $\sim$32 cell widgets exist in memory during rapid scrolling.
2. **Merged Cells**: Natively supported via `TableViewCell(rowMergeStart, rowMergeSpan, columnMergeStart, columnMergeSpan)`.
3. **Pinned Headers**: Pinned row 0 (column letters A, B, C...) and pinned column 0 (row numbers 1, 2, 3...) stay frozen during bidirectional scrolling.
