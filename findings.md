# G5a Findings & Discoveries

## Architecture & Coordinate Systems
- pdfrx uses PDFium under the hood. Coordinates in `PdfPageText` are normalized 72 DPI points.
- Origin and orientation conventions across pdfrx and Syncfusion:
  - pdfrx page coordinates: Top-Left (0, 0) at top-left of the page; x increases right, y increases downward.
  - PDF native specification: Bottom-Left (0, 0) at bottom-left of CropBox/MediaBox; x increases right, y increases upward.
  - Syncfusion `PdfTextMarkupAnnotation(Rect bounds)`: expects PDF native points or top-left? (Must be empirically proven in Step 0d).
  - Rotation (/Rotate 0, 90, 180, 270) affects effective width/height and coordinate swaps.
- Syncfusion package version: `28.2.12`.
- License: Syncfusion Community License.
