# Task Plan: Phase 4 (Prompt R-E2) - Merge PDF, Split PDF & Operation Flow QA

## Scope Guard & Hard Rules
- UI layer only. Tools tab has EXACTLY 4 tools (Image to PDF, Scan to PDF, Merge PDF, Split PDF).
- Keep existing services (`pdf_output_service`, `image_to_pdf_service`, `pdf_merge_service`, `pdf_split_service`, `scanner_service`), providers, and tests working.
- Use ONLY shared components, tokens, and ad placeholders from R-B; NO new packages.
- FORBIDDEN: OCR, Print, Add Password, Unlock, Signature, "Share via Secure Link", Compress, Annotate, Word to PDF or any conversion, a toolkit sheet, help or marketing modals, invented error codes or invented free-space numbers, network or cloud features, hard-coded demo documents.
- Run `flutter analyze` after each step.

## Milestones & Status

- [ ] **Step 0: Verification & Baseline Audit (Report & Fix if needed)**
  - [ ] 0a: PPTX in Office viewer in debug and release with 2 different .pptx files. Report typed failure and logcat. Root cause determination (package limitation vs release asset/shrinking). Document in `docs/redesign/04_gaps_and_conflicts.md`. Re-test DOCX and XLSX in release.
  - [ ] 0b: Cold start benchmark (`adb shell am start -W`): report TotalTime for 3 runs in light and dark system themes on API 36 (and note if API 26-27 is absent). Confirm no white flash in dark and no dark flash in light.
  - [ ] 0c: Profile scroll frame times on 100+ page PDF (`flutter run --profile`).
  - [ ] 0d: Launcher icon adaptive icon verification (foreground in 66dp safe zone of 108dp canvas, separate background layer, round and squircle masks). Report only.
  - [ ] 0e: Verify real PDF creation from 5+ photos (reorder, rename, create, share, confirm in "Created by you" with real preview, size, date). Note Cancel button behavior.
  - [ ] Commit any fix from Step 0 separately.

- [ ] **Step 1: Merge PDF Step 1 - "Select PDFs" (`doc_view_mockups/06_tools/03_merge_pdf`)**
  - [ ] 1a: App bar: back button, title "Select PDFs", search icon filtering list by name.
  - [ ] 1b: Source tabs: "All PDFs (N)", "Recent" (modified in last 30 days), "Downloads" (path contains `/Download`, Android only) / "iCloud Drive" (iOS only, opens `file_picker` for PDFs and adds to selection).
  - [ ] 1c: Lazy page count loading with `pdfrx` (concurrency limit 2, in-memory session cache, skeleton chip until loaded, "Protected or damaged" badge for encrypted/unreadable PDFs).
  - [ ] 1d: PDF rows with preview (`FileThumbnail`), name, pages chip, size, date, round check circle. Native ad placeholder after 5th item only.
  - [ ] 1e: Sticky footer: "N selected", pages total (when all known, otherwise small skeleton bar), primary "Next" button (disabled below 2 selected).
  - [ ] 1f: Skeleton and empty states. No docked banner.
  - [ ] Run `flutter analyze`.

- [ ] **Step 2: Merge PDF Step 2 - "Arrange & merge"**
  - [ ] 2a: App bar: back button, title "Arrange & merge", "Clear" text action.
  - [ ] 2b: Reorderable rows: drag handle, thumbnail preview, name, pages chip, remove icon; elevated dragging row, drop-slot indicator.
  - [ ] 2c: Hint banner: "Drag handles to reorder".
  - [ ] 2d: Output file name field with locked ".pdf" suffix, default "Merged_<yyyyMMdd>", sanitized with existing sanitizer.
  - [ ] 2e: "Pre-flight" card: "Ready to merge", "N files · M pages · ~ X MB" (sum of source file sizes with "~").
  - [ ] 2f: Primary button "Merge N PDFs (M pages)" (disabled if < 2 files, invalid name, or any flagged row).
  - [ ] 2g: Error handling: flagged rows (encrypted/damaged) show red error line ("<name> is password-protected or damaged") with a "Remove" button.
  - [ ] 2h: Skeleton state. No ads.
  - [ ] Run `flutter analyze`.

- [ ] **Step 3: Split PDF (`06_tools/04_split_pdf`)**
  - [ ] 3a: Split Picker (`SplitPickerScreen`): single-select radio, "Select PDF to split", sorted by date, preview, pages chip, size. Footer: "1 PDF selected · N pages", primary "Next". Skeleton and empty states.
  - [ ] 3b: Split Config (`SplitConfigScreen`):
    - App bar with back, title "Split PDF", "Reset" action.
    - PDF card: large first-page preview (`FileThumbnail`), name, "N pages · size".
    - Label "PAGE RANGES" with text field (placeholder "1-3, 5, 8-10", clear button, helper "Syntax: 1-3, 5, 8-10").
    - Hint: "Each range becomes a separate PDF file".
    - "GENERATED FILES (N)" chips built by existing `parsePageRanges` ("Pages 1-3 · 3 pgs", "Page 5 · 1 pg").
    - "QUICK SELECT" macros: ONLY "All pages" (1 file per page; disabled with helper if > 100 files) and "Every 5 pages" (ranges of 5; disabled if > 100 files). Omit "Odd pages" and "Even pages" per owner decision.
    - Summary line: "Output: N files · M pages extracted · EST ~ X KB" (estimate = extracted / total * size, with "~").
    - Primary button: "Split into N PDFs" (disabled while empty or invalid).
    - Validation error state: red field with parser's real error messages.
    - Skeleton state. No ads.
  - [ ] Run `flutter analyze`.

- [ ] **Step 4: Wire Shared Operation UI & Interstitial Placeholder**
  - [ ] 4a: Wire `ToolProgressDialog`: Merge ("Merging 2 of 3") and Split ("Splitting 2 of 3") advancing per finished file.
  - [ ] 4b: Wire `ToolResultSheet`: Merge result (single file, real page count and size), Split result (multi-file, real output path).
  - [ ] 4c: Wire `ToolErrorSheet` with retry on failure.
  - [ ] 4d: `InterstitialPlaceholder`: trigger ONLY when a SUCCESSFUL result sheet is dismissed with "Done" (never on launch, never on error, never in progress). Close button appears after 5-second countdown ring. Collapses to `SizedBox.shrink()` in release via `AdConfig.showPlaceholders`.
  - [ ] Run `flutter analyze`.

- [ ] **Step 5: Automated Tests**
  - [ ] 5a: Merge picker tests (tabs, selection count, Next disabled below 2, flagged row disables merge, iOS iCloud Drive tab).
  - [ ] 5b: Merge arrange screen tests (reorder, name validation, pre-flight text, flagged row error display and remove).
  - [ ] 5c: Split picker & config tests (parser errors shown, macros enabled/disabled around 100 files, generated chips, summary estimate with "~").
  - [ ] 5d: Interstitial tests (shown ONLY after successful Done, not after errors, collapses in release).
  - [ ] 5e: Run all tests in project (`flutter test`). Ensure 83+ tests pass.

- [ ] **Step 6: Live E2E QA, Mockup Visual Comparison & Step 0 Reports**
  - [ ] 6a: Live tests on emulator: merge 3 real PDFs, split a real PDF with ranges ("1-3, 5") and "Every 5 pages" macro, attempt encrypted PDF in Merge.
  - [ ] 6b: Capture screenshots in light and dark modes for Merge (select, arrange, error, skeleton) and Split (picker, config, error, skeleton) and result sheets.
  - [ ] 6c: Step 0 reports: PPTX test results, cold start times, PDF profile scroll frame times, adaptive launcher icon review, 5-photo PDF creation.
  - [ ] 6d: Grep for forbidden terms across `lib/` (must be 0 hits).
  - [ ] 6e: Conventional commits per area following GIT COMMIT RULE.
