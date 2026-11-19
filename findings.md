# Findings: Phase G3a - PDF Reader & Pages Screen

## pdfrx Capabilities Analysis (Step 0b)
1. **Rotate page**: Supported natively via `page.rotatedTo(PdfPageRotation rotation)`, `page.rotatedCW90()`, `page.rotatedBy(...)` from `PdfPageWithRotationExtension`. When `outputDoc.encodePdf()` is called, PDFium persists rotation via `FPDFPage_SetRotation`.
2. **Delete pages**: Supported natively by omitting pages from `outputDoc.pages = [pages]`.
3. **Reorder pages**: Supported natively by reordering `PdfPage` items in `outputDoc.pages = [pages]`.
4. **Extract pages**: Supported natively by creating `outputDoc = await PdfDocument.createNew()` and assigning the desired slice of pages to `outputDoc.pages`, followed by `encodePdf()`.
5. **Insert pages from another PDF**: Supported natively by opening the source PDF via `PdfDocument.openFile()` and assigning `outputDoc.pages = [...targetPages, ...sourcePages]`.
6. **Insert blank page**: `pdfrx` / `pdfrx_engine` has **no native API to create an empty `PdfPage`** (e.g. `PdfDocument.createBlankPage()` does not exist).
   - Per owner instruction: "If any is not possible with pdfrx, do NOT add Syncfusion: hide that single operation, record it in docs/redesign/04_gaps_and_conflicts.md as 'deferred to G5 (needs Syncfusion)', and continue."
   - Recorded in `docs/redesign/04_gaps_and_conflicts.md` under section 6.5.

## Text Search Architecture (Step 0d)
- Uses `PdfTextSearcher(_controller)`.
- Highlights rendered via `PdfViewerParams.pagePaintCallbacks: [_textSearcher.defaultPaintCallback]`.
- Colors: `matchTextColor: Colors.yellow.withValues(alpha: 0.5)` and `activeMatchTextColor: Colors.orange.withValues(alpha: 0.6)`.
- Scanned PDF detection: if 0 matches and `page.loadText()` has empty text on all pages, show "This PDF has no searchable text".
- Debounce: 300 ms. Capped at 500 matches with "500+".

## Horizontal Page Layout Architecture (Step 0d)
- Uses `PdfViewerParams.layoutPages` with `PdfPageLayout Function(List<PdfPage> pages, PdfViewerParams params)`.
- Computes horizontal offsets `Rect.fromLTWH(x, (height - page.height)/2, page.width, page.height)`.
- RTL support: pages laid out in reading order according to text direction.
- Switching between vertical and horizontal calls `_controller.invalidate()`.
