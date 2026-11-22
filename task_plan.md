# Task Plan: G5a - PDF Editing Engine & Annotate Tool (Text Markup Only)

## Status: IN_PROGRESS
- Start Date: 2026-11-22
- Current Step: Step 0 (Gate, Facts, Coordinate Proof & Second Viewer)

---

## Phases & Tasks

### [COMPLETED] Phase 0: Step 0 Gate, Facts & Discovery
- [x] Check git status is clean
- [x] Verify docs/redesign/g4c_evidence.md exists with no gaps
- [x] Run flutter analyze & flutter test to record baseline test count (587 baseline)
- [x] Inspect installed `pdfrx` package source for exact API names (selection, overlays, coords, rotation, boxes, annotations)
- [x] Check Syncfusion PDF APIs for `PdfTextMarkupAnnotation`, multi-rect / `boundsCollection`, `PdfSignatureField`, rotation / crop
- [x] Check connected devices (`adb devices -l` -> `emulator-5554`)

### [COMPLETED] Phase 1: Add Package & Coordinate Transform Proof
- [x] Add `syncfusion_flutter_pdf: 28.2.12` to `pubspec.yaml`
- [x] Write `docs/release/syncfusion_license.md` with eligibility rules and release checklist item
- [x] Implement pure coordinate transform in `lib/data/services/pdf/pdf_coordinate_transform.dart`
- [x] Implement `test/pdf_edit/page_transform_test.dart` generating 5-page PDF (Rotate 0, 90, 180, 270, and custom CropBox), applying highlights, rendering via pdfrx, and pixel sampling overlap > 90% (achieved > 99%, < 0.4 px accuracy)
- [x] Document verified formulas in `docs/redesign/pdf_coordinates.md`
- [x] Verify second viewer opening via ACTION_VIEW intent on emulator (`emulator-5554`) and screenshot saved to `docs/redesign/img/g5a/second_viewer.png` (63.8 KB)

### [PENDING] Phase 2: PdfAnnotationService & Markup DTOs
- [ ] Create `lib/data/models/pdf_markup.dart` (DTOs: TextMarkup, TextMarkupType, lineRects, color, pageIndex)
- [ ] Create `lib/data/services/pdf/pdf_annotation_service.dart` with top-level isolate function
- [ ] Add typed errors to `app_errors.dart` (or pdf-specific errors: encrypted, invalid, writeFailed)
- [ ] Add post-save verification (pdfrx page count, Syncfusion annotation count verification)
- [ ] Add signature field detection (`PdfSignatureField`) returning `hasDigitalSignature: true`
- [ ] Unit tests for PdfAnnotationService (form fields, bookmarks, links, attachments, existing annotations preserved)

### [PENDING] Phase 3: Session Notifier & State Management
- [ ] Implement `AnnotateSessionNotifier` (immutable state: list of TextMarkup, undo/redo stacks cap 100, dirty flag)
- [ ] Session tests for undo/redo, removal of session markup, cap at 100, limits warning (> 150MB, > 500 pages)

### [PENDING] Phase 4: Shared Components
- [ ] Implement `AnnotateToolbar` (ReaderBottomRow style: Copy, Highlight, Underline, Strikethrough, Color swatch)
- [ ] Implement `SelectionMenu` (floating above text selection)
- [ ] Implement `PageMarkupOverlay` (drawing translucent highlights & 1.5pt underline/strikethrough over pdfrx pages)
- [ ] Add entries to `ComponentGalleryScreen`
- [ ] Widget tests for components

### [PENDING] Phase 5: AnnotateScreen, Route & Registry
- [ ] Set `annotateEnabled = true` in registry; Amber gradient; first in "Edit & Manage"
- [ ] Update contract test deliberately for 10 visible tools
- [ ] Implement `AnnotateScreen` (`/tools/annotate`), file picker flow, top bar, save dialog ("Save as new file", "Replace original" disabled if signed)
- [ ] Add ARB strings to `app_en.arb` and `app_en_XA.arb`

### [PENDING] Phase 6: Full Test Suite & Overflow Harness
- [ ] Screen widget tests (toolbar states, color memory, Save enabled only with changes, discard dialog, replace-original disabled for signed PDFs)
- [ ] Extend `l10n_overflow_and_rtl_test.dart` for annotate screen, dialogs, sheets
- [ ] Verify `no_hardcoded_strings_test.dart` passes

### [PENDING] Phase 7: QA Verification & Evidence Deliverable
- [ ] Execute QA scenarios a-k on emulator & device in light/dark
- [ ] Capture screenshots under `docs/redesign/img/g5a/` (< 300 KB each)
- [ ] Second viewer screenshot
- [ ] Write `docs/redesign/g5a_evidence.md`
- [ ] Commit per area with conventional commits and show git log
