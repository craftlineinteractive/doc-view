# G4c & G5a Truth-Up + G5b Pen & Sign Implementation Plan

## Goal
Execute a complete evidence-and-fix truth-up for G4c (Recycle bin) and G5a (PDF annotation engine), verify all data safety gates, and implement G5b: Pen (in Annotate) and Sign (new tool) with full emulator QA, automated pixel tests, and conventional commits.

## Architecture & Tech Stack
- **Flutter / Dart** with Riverpod 2.x (`Notifier<T>`), `pdfrx` for PDF rendering, `syncfusion_flutter_pdf: 28.2.12` for annotation/graphics serialization in background isolates.
- **Data Safety**: Atomic writes, compile-time guards, checksum verifications, and non-destructive failure handling.
- **Shared Editor Shell**: Extracted `PdfEditorShell` and `EditorSession` powering both `AnnotateScreen` and `SignScreen`.
- **Target Device**: Android emulator (`emulator-5554`) ONLY. Physical device explicitly forbidden.

---

## Phases

### [ ] Phase 0: Gate & Baseline Verification
- Verify `git status` clean, `flutter analyze` clean, `flutter test` (baseline count: 621), `adb devices -l` (emulator-5554).

### [ ] Phase 1A: G4c Truth-Up (Recycle Bin)
- [ ] Task 1A.1: Debug slow copy throttle switch (compile-time `kDebugMode` guarded, ~20 MB/s) in component gallery and `TrashService`. Add unit test asserting throttle can never activate in release.
- [ ] Task 1A.2: Kill tests during move at 15%, 40%, 70%, 95% of 190MB throttled file. Verify original intact / bin copy registered, no duplicate/truncated files, leftover `.part` cleaned up. Show listings and `sha256sum`.
- [ ] Task 1A.3: Kill tests during restore and empty bin. Verify integrity.
- [ ] Task 1A.4: Hashing truth profiling on 150MB & 190MB files. Report exact package/function, profile-mode MB/s, frame timeline analysis, UI isolate jank diagnosis. Recommend cheaper sampled verification if under 100 MB/s.
- [ ] Task 1A.5: Live 210MB over-limit test (dialog, Cancel, Delete permanently). Screenshots.
- [ ] Task 1A.6: Revoked permission test (`appops set MANAGE_EXTERNAL_STORAGE deny`). Verify typed failure and original intact.
- [ ] Task 1A.7: Comprehensive delete-path audit table (`file:line | what it deletes | through Recycle bin?`). Fix any permanent delete missing bin. Verify live on emulator from 6 entry points.
- [ ] Task 1A.8: G4c specification checklist audit & implementation of any missing item.
- [ ] Task 1A.9: Update `docs/redesign/g4c_evidence.md` with device column and physical phone re-test list. Commit per area.

### [ ] Phase 1B: G5a Truth-Up (PDF Annotate Text Markup)
- [ ] Task 1B.1: Write `docs/redesign/pdf_editing_facts.md` with exact API names from installed pdfrx and Syncfusion packages. Document 27.2.5 spike vs 28.2.12 installed, re-run preservation test on 28.2.12.
- [ ] Task 1B.2: Transform proof with pixel rendering test (5 pages, 4 rotations, CropBox, >90% color overlap within 2px). Update `docs/redesign/pdf_coordinates.md`.
- [ ] Task 1B.3: Second viewer test via ACTION_VIEW intent or Share action. Capture screenshot.
- [ ] Task 1B.4: Missing G5a QA scenarios: strikethrough, color change, 2-line selection, remove markup, Copy snackbar, rotated/cropped selections, form fields/bookmarks preservation, encrypted PDF, digitally signed PDF, Replace original on copy, scanned PDF, 100-page PDF benchmarks, unsaved changes back gesture.
- [ ] Task 1B.5: Kill app while saving at 25%, 50%, 75% of save duration. Prove original untouched, no partial files.
- [ ] Task 1B.6: Update `docs/redesign/g5a_evidence.md` with physical phone re-test list and Part 1 summary table (`item | DONE or NOT TESTED | evidence path`). Commit per area.

### [ ] DATA SAFETY GATE CHECK
- Verify every Part 1 data safety item passed. Only proceed to Part 2 if gate is green.

### [ ] Phase 2: G5b Pen & Sign Implementation
- [ ] Task 2.1: Pure stroke mathematical functions (`resample`, `simplify` RDP, `smooth` Catmull-Rom to Bezier, tap-to-dot) and immutable `InkStroke` DTO with unit tests (point counts, tap-to-dot, determinism, caps 5,000 / 300,000).
- [ ] Task 2.2: Extend `PdfAnnotationService` for strokes and placed signatures using Syncfusion page graphics (`drawPath`, `PdfPen`). Unit & integration tests with 5-page transform PDF, pixel sampling, caps, preservation, signed/encrypted handling.
- [ ] Task 2.3: Extract `PdfEditorShell` and `EditorSession` (max 100 undo/redo). Refactor `AnnotateScreen` onto shell. Verify all existing tests pass.
- [ ] Task 2.4: Implement Pen in Annotate: `InkOverlay`, `PenSheet` (6 swatches, 1-12pt slider, eraser toggle), draw mode with pointer management (1 finger draws, 2 fingers pan/zoom with Move/Draw fallback), one-time info banner, ARB strings.
- [ ] Task 2.5: Implement Sign tool: `SignatureRepository` (JSON in app support dir, Android backup exclude check), `SignaturePad`, `SignaturesSheet` (max 5), `PlacedSignatureBox` (dashed border, drag, resize, min 60pt / max 90% width, max 20), `SignScreen`, registry tile (amber/sky in Edit & Manage right after Annotate), `/tools/sign` route, feature flag.
- [ ] Task 2.6: Tests: contract test (11 tools), toolbar 5 items, pen sheet defaults, eraser behavior, undo/redo, signature caps, overflow & RTL harness.
- [ ] Task 2.7: Emulator QA walkthrough: pen drawing, rotated/cropped pages, create/save/place signatures, signed/encrypted PDFs, 100-page 200-strokes benchmark, kill app while saving (25/50/75%), discard dialog. Screenshots under `docs/redesign/img/g5b/` (<300 KB).
- [ ] Task 2.8: Write `docs/redesign/g5b_evidence.md`, update `docs/redesign/08_new_screens.md` and release privacy docs.
- [ ] Task 2.9: Commit per area with Conventional Commits.
