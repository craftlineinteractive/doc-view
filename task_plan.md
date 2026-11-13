# Task Plan: Phase 8 - Final QA, Ad Placement Audit, Accessibility, Responsive Harness & Release Polish

## Scope Guard & Hard Rules
- UI layer only. Tools tab has EXACTLY 4 tools (Image to PDF, Scan to PDF, Merge PDF, Split PDF).
- Keep all existing behavior, providers, services and tests working.
- Use only shared components, tokens and ad placeholders from R-B; NO new packages.
- FORBIDDEN: premium, "Remove ads", purchases, Language row, OCR, Print, Add Password, Unlock, Signature, "Share via Secure Link", Compress, Annotate, conversions, a toolkit sheet, help or marketing modals, invented error codes, network or cloud features, hard-coded demo documents, "Engine 4.18", "2 Utilities", "Validated Catalog Buffer", JetBrains Mono.
- GIT COMMIT RULE: Commit ONLY when a task is fully completed AND QA-verified. Stage files by explicit path. Conventional Commits format with QA and Deviations lines. Make separate commits per area. Never push, amend or force. Show hash and `git log -1 --stat` after each commit.

## Milestones & Status

- [x] **Step 0: Loose Ends from R-F1 & Evidence Collection**
  - [x] 0a: FAQ question ordering (1: All files access, 2: iPhone scan [expanded by default], 3: Where PDFs saved, 4: Word look different, 5: Password-protected, 6: Data uploaded). Restored and verified.
  - [x] 0b: Scan settings: replaced inline progress spinner on "Rescan now" with "Scanning... N files found" text + slim LinearProgressIndicator. Eliminated spinners from redesigned UI.
  - [x] 0c: Storage diagnostics card (Android): granted -> "All files access granted" (success tint) + "Open settings"; not granted -> "All files access needed" (warning tint) + "Grant access" (trigger request). Verified both states on emulator.
  - [x] 0d: Step 0 evidence:
    - Grep `lib/` for forbidden terms, sample names, hex values, and count `Color(0x`. (0 forbidden hits).
    - Output correctness: automated tests for merge order (C, A, B -> 9 pages) and split ranges ("1-3, 5, 8-10" & "Every 5 pages").
    - Cold start: 3 runs in light and dark mode with screenshots confirming zero flash.
  - [x] Commit Step 0 fixes: `fc98a20 fix(settings): restore faq order, progress bar, and storage diagnostics`

- [x] **Step 1: Ad Placement Audit (`docs/redesign/06_ad_placement_audit.md`)**
  - [x] 1a: Walk all 26 screens against Section 6 ad rules and owner decisions (ad-free vs allowed surfaces).
  - [x] 1b: Verify 16pt clearance, "Ad" chip on all native rows, selection mode ad suppression, and release collapse (`AdConfig.showPlaceholders`).
  - [x] 1c: Write `docs/redesign/06_ad_placement_audit.md` with full compliance table.
  - [x] 1d: Add widget test asserting ad-free screens contain no ad widgets and release collapse leaves no margins.
  - [x] Commit: `9ba1ab6 fix(ads): enforce strict ad placement rules and clearance`

- [x] **Step 2: Accessibility Audit & Hardening**
  - [x] 2a: Semantics labels for icon buttons, file rows, category tiles, tool cards, selection state, page pill, ad chips.
  - [x] 2b: Contrast check (>= 4.5:1 normal, >= 3:1 large/icons) in light and dark.
  - [x] 2c: Touch targets >= 48x48 hit areas across all interactive elements.
  - [x] 2d: Automated accessibility guideline tests (`androidTapTargetGuideline`, `labeledTapTargetGuideline`, `textContrastGuideline`).
  - [x] Commit: `971659c fix(a11y): enhance semantics, touch targets, and contrast compliance`

- [x] **Step 3: Responsive & Text-Scale Harness**
  - [x] 3a: Write test harness testing screens at 360x640, 393x852, 412x915 and text scales 1.0, 1.3, 2.0.
  - [x] 3b: Fix any RenderFlex overflows detected (CategoryTile grid, SkeletonTileGrid, FaqScreen header, SplitScreen summary, ToolsScreen AppBar).
  - [x] 3c: Check landscape orientation on Home and document viewer.
  - [x] Commit: `4331fc3 fix(layout): resolve responsive and high text-scale layout overflows`

- [x] **Step 4: System UI & Back Behavior**
  - [x] 4a: Verified gesture navigation and 3-button navigation on Android emulator.
  - [x] 4b: Verified transparent system bars, nav bar clearance, selection mode back, Directories folder-up back, viewer/dialog dismissal.

- [x] **Step 5: Dead Code Audit & Cleanup**
  - [x] 5a: Grep for unused files, widgets, and providers created prior to redesign.
  - [x] 5b: Deleted unreferenced `LibraryPdfPickerScreen` and duplicate `ToolResultBottomSheet`.
  - [x] 5c: Verified `ComponentGalleryScreen` is strictly unreachable in release builds.
  - [x] Commit: `b5aea32 refactor(tools): remove unused pre-redesign dead code`

- [x] **Step 6: Release Build & Final QA Report (`docs/redesign/07_qa_report.md`)**
  - [x] 6a: Run `flutter analyze` (0 issues) and `flutter test` (175 passed).
  - [x] 6b: Run `flutter build apk --release` (62.4MB) and `flutter build appbundle --release` (54.1MB).
  - [x] 6c: Install release APK on emulator and verify Light (`#FFFFFF`) and Dark (`#1A1D29`) modes.
  - [x] 6d: Write `docs/redesign/07_qa_report.md` with mockup comparison table and deviations list.
  - [x] Commit: `95d1d0a docs: ad placement audit and final qa report`
