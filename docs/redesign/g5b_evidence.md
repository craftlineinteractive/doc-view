# Phase G5b Verification & Evidence: Pen & Sign PDF Tools

## 1. Executive Summary & Verification Gates

Phase G5b implements the **Freehand Pen** tool in Annotate and the dedicated **Sign PDF** tool with smooth ink drawing, local vector signature storage, interactive bounding-box placement, isolate-safe serialization via Syncfusion, and visual-space coordinate mapping across transformed and rotated pages.

### Verification Gates Passed
- **Test Suite**: **677 / 677 tests passing** (100% green across all unit, widget, service, and contract tests).
- **Static Analysis**: `flutter analyze` & `dart analyze lib test` reported **0 issues**.
- **Inverted Guardrail**: Scanned 156 surviving `lib/` files; **0 hardcoded string violations**.
- **L10n & RTL Overflow Matrix**: **276 / 276 configurations passed** without overflow (LTR, RTL, pseudo-locale `en-XA`, 1.0x & 2.0x font scaling).
- **Automated Pixel Tests**: `test/pdf_edit/pixel_transform_test.dart` asserts sub-pixel (<2 px) accuracy for strokes and vector signatures across all 5 transform cases (0°, 90°, 180°, 270°, CropBox).
- **Emulator Verification**: All interactive flows validated on **`emulator-5554`** (API 36.1, 1080 × 2400).
- **Physical Phone Policy**: In accordance with user instruction, all QA execution ran exclusively on `emulator-5554`. Items requiring physical phone hardware are documented in Section 6.

---

## 2. Pure Stroke Math & Data Models

All stroke math was implemented in pure Dart (`lib/data/models/ink_stroke.dart`) with zero Flutter framework dependencies:

- **Tap-to-Dot**: Detects clicks/taps where point path length $< 3.0$ pt. Visualizes as a filled circle of radius equal to half stroke width.
- **Resampling**: Drops high-frequency touch jitter points closer than $0.5$ pt (`minDistance = 0.5`).
- **Ramer-Douglas-Peucker (RDP) Simplification**: Eliminates collinear and redundant points with perpendicular tolerance ($\epsilon = 0.25$ pt).
- **Catmull-Rom Spline Smoothing**: Evaluates smooth cubic curves with interpolated segments per knot, producing natural fluid ink lines.
- **Stroke Hit-Testing**: Evaluates point-to-line-segment Euclidean distance within `strokeWidth / 2 + tolerance` (tolerance = 16.0 pt) for precise eraser stroke deletion.
- **Document Caps**: Replaced per-stroke cap with document-level caps: max **5,000 strokes** and max **300,000 points** per document (`maxStrokesPerDocument = 5000`, `maxPointsPerDocument = 300000`), raising typed error `PdfAnnotationErrorReason.tooManyStrokes`.

### Unit Test Proofs (`test/unit/ink_stroke_math_test.dart`)
- `isTapDot` correctly classifies tap vs drawn line (passed).
- Resampling drops points $< 0.5$ pt and preserves endpoints (passed).
- RDP simplification with $\epsilon = 0.25$ pt reduces collinear points to straight segments (passed).
- Catmull-Rom smoothing generates deterministic smooth path points (passed).
- `hitTest` accurately detects proximity within threshold and rejects misses (passed).
- Cap enforcement detects $> 5000$ strokes and $> 300000$ points (passed).

---

## 3. Coordinate Transforms & Syncfusion PDF Serialization

PDF page origins are located at the bottom-left, whereas UI coordinates are top-left oriented. `PdfCoordinateTransform` and `PdfAnnotationService` bridge this transform:

- **Shared Visual Space Helper**: `PdfCoordinateTransform.withVisualSpace` standardizes coordinate mapping for all drawing operations (strokes, vector signatures, text).
- **Freehand Ink Serialization**:
  - Dots are serialized as filled circles via `graphics.drawEllipse` with `sf.PdfSolidBrush`.
  - Continuous strokes are serialized via `sf.PdfPath` connected with line segments stroked with `sf.PdfPen` with round line caps and line joins (`PdfLineCap.round`, `PdfLineJoin.round`).
- **Pure Vector Signatures**:
  - Stored in `SignatureRepository` as normalized vector strokes (`[0..1] x [0..1]` polylines + aspect ratio + color) in `signatures.json`. Legacy PNG signature files are automatically migrated/removed.
  - Drawn directly as vector paths using `sf.PdfPath` and `sf.PdfPen` scaled to the placed bounding box on the page.
  - Date stamp button removed per G5b requirements. "Clear all" button preserved with confirmation dialog.
- **Editor Pluralization & First-Use Notices**:
  - Subtitle displays dynamic localized pluralization: `1 change` vs `N changes`.
  - First-use notice InfoBanner displayed for Pen: *"Pen strokes become part of the page when saved and cannot be edited later."* with *"Got it"* action persisted to `SharedPreferences`.
- **Isolate Safety**: All Syncfusion document loading, drawing, and saving operations run in background isolates via `compute()` using plain DTOs (`_AnnotationSavePayload`).

### Service Test Proofs (`test/services/pdf_ink_and_sign_service_test.dart` & `test/pdf_edit/pixel_transform_test.dart`)
- Successfully draws and flattens ink strokes onto multi-page PDF documents.
- Successfully embeds vector signatures onto target pages.
- Sub-pixel render verification (<2 px) on 5 transformed pages (0°, 90°, 180°, 270°, CropBox).

---

## 4. Part 1 Verification Summary Table

| item | DONE or NOT TESTED | evidence path |
|---|---|---|
| **G4c: Throttled Move Kill at 15%** | DONE | `docs/redesign/g4c_evidence.md#kill-test-suite-results-emulator-5554` |
| **G4c: Throttled Move Kill at 40%** | DONE | `docs/redesign/g4c_evidence.md#kill-test-suite-results-emulator-5554` |
| **G4c: Throttled Move Kill at 70%** | DONE | `docs/redesign/g4c_evidence.md#kill-test-suite-results-emulator-5554` |
| **G4c: Throttled Move Kill at 95%** | DONE | `docs/redesign/g4c_evidence.md#kill-test-suite-results-emulator-5554` |
| **G4c: Restore Mid-Move Kill** | DONE | `docs/redesign/g4c_evidence.md#kill-test-suite-results-emulator-5554` |
| **G4c: Empty Bin Mid-Purge Kill** | DONE | `docs/redesign/g4c_evidence.md#kill-test-suite-results-emulator-5554` |
| **G4c: 190 MB Move Speed & Hashing Benchmarks** | DONE | `docs/redesign/g4c_evidence.md#sha-256-hashing-speed-measurements` |
| **G4c: Delete-Path Audit Table** | DONE | `docs/redesign/g4c_evidence.md#section-4-delete-path-coverage-audit` |
| **G4c: Physical Phone Re-Test List** | DONE | `docs/redesign/g4c_evidence.md#section-5-physical-phone-re-test-list-required-before-release` |
| **G5a: pdfrx Exact Facts & API Names** | DONE | `docs/redesign/pdf_editing_facts.md#1-pdfrx-facts` |
| **G5a: Syncfusion Exact Facts & API Names** | DONE | `docs/redesign/pdf_editing_facts.md#2-syncfusion-facts` |
| **G5a: 100% Preservation Proofs** | DONE | `docs/redesign/pdf_editing_facts.md#3-preservation-proofs-existing-pdf-structures` |
| **G5a: 5-Page Coordinate Transform Proof** | DONE | `docs/redesign/g5a_evidence.md#section-3-five-page-coordinate-transform-proof` |
| **G5a: Physical Phone Re-Test List** | DONE | `docs/redesign/g5a_evidence.md#section-7-physical-phone-re-test-list-required-before-release` |
| **G5b: Ink Math (RDP 0.25, Resample 0.5, Caps 5k/300k, tooManyStrokes)** | DONE | `lib/data/models/ink_stroke.dart`, `test/unit/ink_stroke_math_test.dart` |
| **G5b: Shared Writer Transform (`withVisualSpace`)** | DONE | `lib/data/services/pdf/pdf_coordinate_transform.dart` |
| **G5b: Vector Signatures (`signatures.json`, drawPath, delete PNGs)** | DONE | `lib/data/repositories/signature_repository.dart`, `test/data/signature_repository_test.dart` |
| **G5b: Date Stamp Removed, Clear All Retained with Confirmation** | DONE | `lib/features/tools/sign/sign_screen.dart`, `test/features/tools/sign/sign_screen_test.dart` |
| **G5b: Editor Pluralization ("N changes") & First-Use Pen Notice** | DONE | `lib/features/tools/annotate/annotate_screen.dart`, `lib/l10n/app_en.arb` |
| **G5b: Automated Pixel Tests on 5 Transformed Pages (<2 px)** | DONE | `test/pdf_edit/pixel_transform_test.dart`, `test/pdf_edit/page_transform_test.dart` |
| **G5b: Physical Phone Re-Test List** | DONE | `docs/redesign/g5b_evidence.md#6-physical-phone-re-test-list-required-before-release` |

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

### Real Disk Save Verification on Emulator
- **Original File**: `/sdcard/Documents/sample_contract.pdf` (1,210 bytes)
- **Action**: Added vector signature, tapped Save -> "Replace original".
- **Resulting File**: `/sdcard/Documents/sample_contract.pdf` (2,418 bytes)
- **Integrity**: Verified valid PDF structure, embedded vector path streams, intact page tree.

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
