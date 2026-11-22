# Phase G5b Verification & Evidence: Pen & Sign PDF Tools

## 1. Executive Summary & Verification Gates

Phase G5b implements the **Freehand Pen** tool in Annotate and the dedicated **Sign PDF** tool with smooth ink drawing, local signature storage, interactive bounding-box placement, date stamping, and isolate-safe serialization via Syncfusion.

### Verification Gates Passed
- **Test Suite**: **673 / 673 tests passing** (100% green across all unit, widget, service, and contract tests).
- **Static Analysis**: `dart analyze lib test` reported **0 issues**.
- **Inverted Guardrail**: Scanned 156 surviving `lib/` files; **0 hardcoded string violations**.
- **L10n & RTL Overflow Matrix**: **276 / 276 configurations passed** without overflow (LTR, RTL, pseudo-locale `en-XA`, 1.0x & 2.0x font scaling).
- **Emulator Verification**: All interactive flows validated on **`emulator-5554`** (API 36.1, 1080 × 2400).
- **Physical Phone Policy**: In accordance with user instruction, all QA execution ran exclusively on `emulator-5554`. Items requiring physical phone hardware are documented in Section 6.

---

## 2. Pure Stroke Math & Data Models

All stroke math was implemented in pure Dart (`lib/data/models/ink_stroke.dart`) with zero Flutter framework dependencies:

- **Tap-to-Dot**: Detects clicks/taps where point path length $< 2.0$ pt and point count $< 5$. Visualizes as a filled circle of radius equal to half stroke width.
- **Ramer-Douglas-Peucker (RDP) Simplification**: Eliminates collinear and redundant points with perpendicular tolerance ($\epsilon = 1.0$ pt).
- **Uniform Resampling**: Resamples points at uniform arc-length intervals ($3.0$ pt) to remove gesture sampling artifacts and jitter.
- **Catmull-Rom Spline Smoothing**: Evaluates smooth cubic curves with 3 interpolated segments per knot, producing natural fluid ink lines.
- **Stroke Hit-Testing**: Evaluates point-to-line-segment Euclidean distance within `strokeWidth / 2 + tolerance` (tolerance = 16.0 pt) for precise eraser stroke deletion.
- **Point Caps**: Enforces strict safety limits of max **5,000 points per stroke** and max **300,000 points per document** to protect against unbounded memory growth.

### Unit Test Proofs (`test/unit/ink_stroke_math_test.dart`)
- `isTapDot` correctly classifies tap vs drawn line (passed).
- RDP simplification preserves endpoints while reducing collinear segments (passed).
- Uniform resampling produces equidistant points along path (passed).
- Catmull-Rom smoothing generates continuous smooth path points (passed).
- `hitTest` accurately detects proximity within threshold and rejects misses (passed).
- Stroke point cap prevents appending beyond 5,000 points (passed).

---

## 3. Coordinate Transforms & Syncfusion PDF Serialization

PDF page origins are located at the bottom-left, whereas UI coordinates are top-left oriented. `PdfCoordinateTransform` and `PdfAnnotationService` bridge this transform:

- **Point Transform**:
  $$\text{syncY} = \text{pageHeight} - \text{visualY}$$
  $$\text{visualY} = \text{pageHeight} - \text{syncY}$$
- **Freehand Ink Serialization**:
  - Dots are serialized as filled circles via `graphics.drawEllipse` with `sf.PdfSolidBrush`.
  - Continuous strokes are serialized via `sf.PdfPath` connected with cubic Bézier segments (`path.addBezier`) stroked with `sf.PdfPen` with round line caps and line joins (`PdfLineCap.round`, `PdfLineJoin.round`).
- **Signature & Date Placement**:
  - Saved transparent PNG signatures are loaded and rendered using `graphics.drawImage(pdfImage, syncRect)`.
  - Date stamps are rendered using standard Helvetica `sf.PdfStandardFont(PdfFontFamily.helvetica, 14, style: PdfFontStyle.bold)` and `sf.PdfSolidBrush(sf.PdfColor(0, 0, 0))`.
- **Isolate Safety**: All Syncfusion document loading, drawing, and saving operations run in background isolates via `compute()` using plain DTOs (`_AnnotationSavePayload`).

### Service Test Proofs (`test/services/pdf_ink_and_sign_service_test.dart`)
- Successfully draws and flattens ink strokes onto multi-page PDF documents.
- Successfully embeds PNG signatures and date text onto target pages.
- Correctly converts coordinates between visual space and PDF CropBox/MediaBox.

---

## 4. Reusable Editor Shell & Tool Implementations

### Reusable `PdfEditorShell` & `EditorSession`
- Generic snapshot undo/redo session stack capped at 100 snapshots.
- Standardized top App Bar with Undo, Redo, Save button, and back navigation.
- Built-in discard confirmation dialog preventing accidental loss of user work.
- Built-in "Save as new file" vs "Replace original" bottom sheet.
- Digital signature warning banner displayed when AcroForm signatures exist.

### Annotate Freehand Pen Tool
- Added 5th toolbar tool: **Pen** (`annotate_tool_pen`).
- Tap Pen to activate drawing mode; tap active Pen to open `PenSheet`.
- `PenSheet`: 6 swatches (Black, Blue, Red, Green, Purple, Orange), 1-12 pt discrete width slider, Eraser mode toggle.
- Single-finger drawing with two-finger pan/zoom handled cleanly via `SinglePointerDrawRecognizer`.

### Sign PDF Tool
- Dedicated screen (`/tools/sign`) registered in Edit & Manage right after Annotate (11 visible tools).
- `SignatureRepository`: Enforces max 5 saved signatures; stores transparent PNGs in application support directory.
- Android backup exclusion: Excludes `signatures/` from Google Cloud Backup and device migration (`backup_rules.xml`, `data_extraction_rules.xml`).
- `SignaturePad`: Smooth drawing with Catmull-Rom interpolation, Clear, Discard, and Save actions.
- `PlacedSignatureBox`: Drag-to-move bounded to page, 4 corner resize handles (min 60 × 20 pt, max 90% width), delete & apply floating action pill.
- Date stamp tool placing ISO formatted dates (`yyyy-MM-dd`).

---

## 5. Live Emulator Verification & Screenshots (`emulator-5554`)

All flows were executed on `emulator-5554` running Android 16 (API 36.1) at 1080 × 2400 resolution (420 dpi). All captured images meet the strict $< 300\text{ KB}$ constraint.

| View Description | File Path | Dimensions | File Size | Status |
|---|---|---|---|---|
| **Tools Tab with 11 Tools (Annotate & Sign in Edit & Manage)** | `docs/redesign/img/g5b/07_tools_tab_11_tools.png` | 1080 × 2400 | 264 KB | Verified |
| **Annotate Screen: Pen Active & Ink Stroke** | `docs/redesign/img/g5b/01_annotate_pen_active.png` | 1080 × 2400 | 117 KB | Verified |
| **Annotate Screen: Pen Settings Sheet & Palette** | `docs/redesign/img/g5b/02_annotate_pen_sheet.png` | 1080 × 2400 | 104 KB | Verified |
| **Sign Screen: Empty Saved Signatures Sheet** | `docs/redesign/img/g5b/03_sign_sheet_empty.png` | 1080 × 2400 | 65 KB | Verified |
| **Signature Pad: Smooth Cursive Drawing** | `docs/redesign/img/g5b/04_signature_pad_drawing.png` | 1080 × 2400 | 85 KB | Verified |
| **Sign Screen: Placed Signature with Resize Handles** | `docs/redesign/img/g5b/05_sign_placed_signature_handles.png` | 1080 × 2400 | 72 KB | Verified |
| **Sign Screen: Placed Date Stamp on Contract** | `docs/redesign/img/g5b/06_sign_date_stamp_placed.png` | 1080 × 2400 | 75 KB | Verified |

### Real Disk Save Verification on Emulator
- **Original File**: `/sdcard/Documents/sample_contract.pdf` (1,210 bytes)
- **Action**: Added signature PNG + ISO date stamp "2026-11-22", tapped Save -> "Replace original".
- **Resulting File**: `/sdcard/Documents/sample_contract.pdf` (2,533 bytes)
- **Integrity**: Verified valid PDF structure, embedded PNG image and font streams, intact page tree.

---

## 6. Physical Phone Re-Test List (Required Before Release)

The following items cannot be fully verified on an emulator and require verification on a physical hardware device prior to production store release:

1. **Stylus & Finger Touch Latency**:
   - Verify real-time stylus / capacitive pen drawing response without visual lag or pointer stutter.
2. **Hardware Palm Rejection**:
   - Verify that resting a palm on the glass while drawing with an active stylus or single finger does not trigger inadvertent canvas panning or spurious ink dots.
3. **Hardware Storage I/O Throughput**:
   - Measure real NAND flash write speeds when serializing complex multi-page annotations on documents larger than 50 MB.
4. **Physical High-DPI Screen Rendering**:
   - Confirm anti-aliasing quality of thin (1.0 pt) and thick (12.0 pt) strokes on AMOLED / OLED panels at native refresh rates (90 Hz / 120 Hz).
5. **Camera Scanner Hardware Integration**:
   - Verify camera hardware autofocus and document border edge detection when transitioning from scan to annotate/sign.
