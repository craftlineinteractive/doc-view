# Doc View: AI redesign prompts (run in order)

Run R-A first (analysis, no code). Then R-B, R-C, R-D, R-E, R-F one at a time. Start each one only when the previous one passes `flutter analyze` and `flutter test`. Paste ONE prompt per request.

Place this folder at `<flutter project>/doc_view_mockups/` before starting.

---

## R-A: Analyze the mockups and write the plan (NO CODE)

```
SKILLS TO APPLY FOR THIS TASK: codebase-onboarding, writing-plans, planning-with-files, flutter-expert, mobile-design, anti-ui-slop, clean-code.

GOAL: I want the whole Flutter app "Doc View" redesigned to look EXACTLY like the approved mockups in the folder `doc_view_mockups/` (project root). First analyze, then write a plan. In THIS task you write NO app code.

HARD RULES (apply to every task in this redesign):
- UI layer only. Keep all existing behavior, providers, services, DB, scanner, isolates and tests working. Do not rename or delete business logic.
- The Tools tab has EXACTLY 4 tools: Image to PDF, Scan to PDF, Merge PDF, Split PDF. Never add others (no Compress, Annotate, Sign, OCR, Word to PDF, recycle bin, print).
- Android is the primary platform (first release); iOS must also work with the same UI. Do not copy the iPhone chrome in the mockups (9:41 clock, Dynamic Island, home indicator).
- Isolate safety: functions passed to Isolate.run/compute must be top-level/static and receive only primitives or plain DTOs.
- No new packages unless a task explicitly allows one.

STEP 1: Read `doc_view_mockups/README.md`, `doc_view_mockups/manifest.json` and `doc_view_mockups/00_design_system/DESIGN.md` completely. README section 1 explains how to read the mockups (they are presentation boards; only the 393x852 phone frames are app UI).

STEP 2: For each of the 24 screen folders (listed in README section 6): open `screen.png` (if present; 2 folders have none) and read the phone frames inside `code.html`. Extract exact colors, font sizes/weights, radii, paddings, icon names (Material Symbols Outlined), texts, states and the ad placement of each frame. Ignore workbench chrome and marketing text.

STEP 3: Audit the current `lib/`: list every screen, widget, provider and service, and map each to its mockup folder.

STEP 4: Create these files in `docs/redesign/`:
1. 01_design_tokens.md: colors (light and dark), typography (family, size, weight, line height per style), spacing, radii, elevation, motion, ad sizes. Resolve any conflict between DESIGN.md and the HTML in favor of the HTML phone frames and list the conflict.
2. 02_component_inventory.md: every common component (use README section 8 as the starting list), with variants, states, props, where used (mockup folders) and the proposed Dart file path and class name.
3. 03_screen_map.md: for each mockup: existing Dart file(s), what must change, new files needed.
4. 04_gaps_and_conflicts.md: README sections 9 and 10, plus anything you find (features in the mockups that need new behavior, things that contradict the HARD RULES). For each item propose: implement / omit / ask me.
5. 05_build_plan.md: ordered tasks (foundation, components, then screens grouped like prompts R-B to R-F) with exact file paths and a verification step for each.
Also create task_plan.md and progress.md (add both to .gitignore).

STEP 5: Reply with a summary in at most 25 lines and a numbered list of at most 10 questions that really block you (do not ask about things the README already answers).

DONE CRITERIA: no code changed; `flutter analyze` result unchanged; the docs exist and are consistent with the README.
```

---

## R-B: Foundation: tokens, fonts, icons, theme, shared components

```
SKILLS TO APPLY FOR THIS TASK: codebase-onboarding, writing-plans, planning-with-files, flutter-expert, mobile-design, anti-ui-slop, clean-code, performance-profiling, verification-before-completion.

CONTEXT: R-A is done (docs/redesign/*). Read docs/redesign/01_design_tokens.md, 02_component_inventory.md, 05_build_plan.md and the HARD RULES from R-A (same rules apply). Implement the design foundation and the shared component library. Do NOT redesign screens yet.

1. Fonts: bundle Inter (400, 500, 600, 700, 800) and Space Grotesk (600, 700) as asset fonts under assets/fonts/ with their OFL license files, and declare them in pubspec.yaml. The app is offline: do NOT use the google_fonts package or runtime font downloads. If you cannot obtain the font files, STOP and tell me exactly which files to download and where to put them.
2. Icons: the mockups use Material Symbols Outlined. Verify on pub.dev that the package `material_symbols_icons` supports the current Flutter SDK; if yes, add it and use it (outlined style, weight 400, grade 0) via one central `AppIcons` class mapping every icon name used in the mockups. If not suitable, use Flutter's built-in Icons and report the closest equivalents.
3. Theme (core/theme/): AppColors tokens for light and dark (exact hex from the README/DESIGN.md), a ThemeExtension<DocViewTokens> holding tile, divider band, hairline, section header, blue tint, shimmer colors, reader canvas, and the file-type color map (PDF, Word, Excel, PPT, TXT, Image, Folders with solid and tint variants for light and dark). Typography styles named like DESIGN.md (headline-xl/lg/sm in Space Grotesk; title-md, label-lg/md/xs, body-lg/md/sm in Inter). Component themes (buttons 16pt radius and 56 height, inputs 12 radius 48 height, cards 20 radius, bottom sheets 28 top radius, dialogs 24, snackbars). Keep ThemeMode system/light/dark as already implemented.
4. System UI: edge-to-edge on Android, transparent status/navigation bars with icon brightness following the theme, correct SafeArea handling. No fake status bar.
5. Shared components (lib/shared/widgets/...), exactly as listed in docs/redesign/02_component_inventory.md and README section 8: app scaffold + bottom nav, app bar variants, underline tabs, filter chips, breadcrumb bar, category tile + file-type glyph/badge, file row (default/bookmarked/selected) + folder row + file thumbnail, buttons (primary/secondary/tonal/destructive/text/icon/FAB/bottom action bar), text fields (search, labeled+error, locked-suffix rename, password, number, ranges), segmented control, checkbox/radio/switch, bottom sheet/options row/dialog/progress dialog/result sheet/snackbar, info banner, page pill, empty and error states, settings row + section header, FAQ card, tool card, reorderable page row, dashed add card, onboarding page indicator.
6. Skeletons: ONE shared Shimmer widget (single AnimationController, 1.4s sweep, light #E9EDF5 to #F5F7FB, dark #262B3A to #30364A) plus skeleton variants for file row, tile grid, folder row, tool card, settings row, PDF page, ad slot. Respect reduced motion (MediaQuery.disableAnimations: show static blocks). No spinners anywhere.
7. Ad placeholders (NO AdMob SDK yet): AdBannerSlot (60pt, "AD" pill, collapses to zero height when empty/failed, animated), NativeAdRow (68pt), NativeAdCard, InterstitialPlaceholder (close appears after a 5s countdown ring). They render placeholder content from a simple model so the real SDK can plug in later. Enforce the 16pt clearance rule via the scaffold (the FAB must never overlap an ad).
8. Debug-only component gallery screen (only in kDebugMode, reachable from Settings > hidden long-press on the version row or a debug route) showing every component in light and dark, with text scale 1.0 and 2.0 toggle.
9. Tests: widget tests for the 10 most important components (file row states, buttons sizes >= 48pt, text field error, skeleton reduced-motion, ad slot collapse) and golden tests only if the project already uses goldens.

RULES: const constructors, no logic in build(), every tappable target >= 48x48, every icon button has a tooltip/semantics label. No new packages except material_symbols_icons (if verified).
DONE CRITERIA (verification-before-completion): run `flutter analyze` and `flutter test`; report results; run the app on an Android emulator and open the gallery in light and dark; list files created; list deviations from the mockups.
```

---

## R-C: Launch flow, Home, Search, file lists

```
SKILLS TO APPLY FOR THIS TASK: codebase-onboarding, planning-with-files, flutter-expert, mobile-design, anti-ui-slop, clean-code, verification-before-completion.

CONTEXT: R-A and R-B are done. Use only the shared components and tokens from R-B. HARD RULES from R-A apply. Redesign these screens to match the mockups exactly, keeping existing logic:
1. Splash (doc_view_mockups/01_launch/01_splash): wordmark on ONE line (the mockup PNG has a wrapping bug), subtle floating pages, glow, shimmer line, version label; navigate when startup is ready.
2. Onboarding 1-3 (01_launch/02..04): one PageView with a shared layout; pages 1-2 have Skip, page 3 has back arrow + "Step 3 of 3"; illustrations built with Flutter widgets/CustomPaint (no new packages); show only once (persist in shared_preferences). Page 3 shows exactly the four tools.
3. Permissions (01_launch/05_permissions_privacy): Android Frame A, iOS Frame B (platform-specific), Frame C "Free with ads" explainer (UI only; AdMob consent comes later). Reuse the existing permission logic (allFilesAccess provider).
4. Home (02_home/01 and 02): header, 4x2 category grid (label the last tile "Folders / Browse"), Recent/Bookmarks tabs, rows, native ad placeholder row, FAB (never overlapping an ad), docked banner placeholder + bottom nav, all state variants (bookmarks populated/empty, recent empty, scanning, permission gate) and the skeleton.
5. Search (03_search/01): all 5 states; native ad placeholder at result position 6; no docked banner. Add recent searches (persist the last 10 queries in shared_preferences) since the mockup shows them.
6. Category file lists (NOT in the mockups): build from the design system: PDF/Word/Excel/PPT/TXT as file rows with the AppBar "PDF" + "92 files", sort + search + select icons; Image category as a 3-column thumbnail grid (cacheWidth, errorBuilder); skeleton and empty states; a Sort bottom sheet (Date / Name / Size, ascending/descending) using existing sortOptionProvider; native ad row after the 4th and every 8th row.
7. FileTile/preview: PDF rows show the first-page thumbnail (render once, cache on disk in the app cache dir, skeleton while loading, never block the UI; if too heavy, fall back to the type badge and report).

RULES: keep every existing test passing; add widget tests for Home states and Search states. Show Light, Dark and Skeleton for every screen.
DONE CRITERIA: `flutter analyze`, `flutter test`; run on an Android emulator and compare each screen with its screen.png in light and dark; list every deviation and every new behavior added.
```

---

## R-D: File management and viewers

```
SKILLS TO APPLY FOR THIS TASK: codebase-onboarding, planning-with-files, flutter-expert, mobile-design, anti-ui-slop, clean-code, systematic-debugging (only if something breaks), verification-before-completion.

CONTEXT: R-A to R-C are done. HARD RULES from R-A apply. Redesign to match the mockups exactly, keeping existing logic:
1. File actions (04_file_management/01_file_actions): options sheet (7 actions), rename dialog with locked suffix + inline error, delete dialog with file chip, details sheet (120x150 preview, key-values, copy path pill, Open file). Ignore the stale "Annotations/Export Ops" nav labels.
2. Multi-select (04_file_management/02): selection app bar, check circles, contextual bottom dock replacing nav, banner suppressed, confirm dialog, snackbar. Do NOT add drag handles.
3. Directories (04_file_management/03): breadcrumb, folders/files sections, six states (normal, permission required, protected, empty, not found, skeleton). Item counts and sort chips are new: add sort chips (Name, Size) using the existing listing; compute item counts lazily or omit (report which).
4. PDF reader (05_viewers/01): top bar with "N Pages • size", page pill, floating bottom toolbar (Pages, Go to, Share, More), More sheet, dark canvas with un-inverted white page, skeleton; NO ads. The "Pages" button opens a simple page-thumbnail sheet (or hide it and report).
5. PDF states (05_viewers/02): password dialog (retry), Go to page dialog with validation, corrupt screen, missing-file screen.
6. Office viewer (05_viewers/03): keep the offline_document_viewer package isolated in office_viewer_screen.dart; apply the mockup chrome (bar actions, banners, outline sheet, search bar with counter, error). Omit the sheet-tab "+" button; omit the "Filter" chip.
7. Image and TXT viewers (05_viewers/04): black canvas HUD, info chip, 2.5x pill; TXT bar with A-/A+ and monospace toggle, font-size sheet, truncation banner, skeletons; NO ads.

RULES: keep tests passing; add widget tests for the rename validation UI, delete dialog, selection mode and the Directories states.
DONE CRITERIA: `flutter analyze`, `flutter test`; run on an Android emulator; open a real PDF, DOCX, XLSX, image and TXT; compare with the PNGs (office viewer has no PNG: use the HTML); list deviations and new behaviors.
```

---

## R-E: Tools (exactly 4) and operation results

```
SKILLS TO APPLY FOR THIS TASK: codebase-onboarding, planning-with-files, flutter-expert, mobile-design, anti-ui-slop, clean-code, performance-profiling, verification-before-completion.

CONTEXT: R-A to R-D are done. HARD RULES from R-A apply: EXACTLY 4 tools. Redesign to match the mockups exactly, keeping existing services (pdf output, image-to-pdf, merge, split) working:
1. Tools tab (06_tools/01): header "Tools" + search, sections "Convert & Create" (Image to PDF, Scan to PDF) and "Edit & Manage" (Merge PDF, Split PDF), glossy gradient tool icons (draw with gradients and Material Symbols, no images), "Created by you" horizontal cards + See All (reuse the PDF list design) + empty state, skeleton, docked banner placeholder. Do NOT render "Engine 4.18" or "2 Utilities".
2. Image to PDF + scan review (06_tools/02): segmented A4/Fit, locked-suffix name field, reorderable rows with drop placeholder, dashed add card, footer with count + estimated size and a static "A4 High Res" info chip (do not add a quality option unless trivial; report), empty state, skeleton, scan review layout; NO ads.
3. Merge (06_tools/03): select step with search + tabs (All PDFs, Recent, Downloads; show "iCloud Drive" on iOS only), check circles, native ad placeholder in the list, footer; arrange step with reorder, pre-flight card, "Merge N PDFs (M Pages)" button (compute page counts lazily with placeholders), error variant, skeleton.
4. Split (06_tools/04): picker, config screen with range field + live chips, quick-select macros (All pages, Odd pages, Even pages, Every 5 pages: they fill the range field using the existing parser), approximate output summary (label estimates with "~"), error state, skeleton; NO ads.
5. Progress and results (06_tools/05): determinate progress dialog (show remaining time only if measurable), single success sheet, split success sheet, error sheet (show the REAL error text, never invented codes), interstitial placeholder shown only after a successful result, never on launch. Backdrop must be the real 4-tool Tools screen.

RULES: heavy work stays off the UI isolate; keep existing tests passing; update the 4-tools widget test and integration test to match any key changes (still asserting exactly 4); add tests for the macro-to-range logic.
DONE CRITERIA: `flutter analyze`, `flutter test`; run all four tools end to end on an Android emulator; list deviations and new behaviors.
```

---

## R-F: Settings, ads placement polish, accessibility, release check

```
SKILLS TO APPLY FOR THIS TASK: codebase-onboarding, planning-with-files, flutter-expert, mobile-design, anti-ui-slop, clean-code, accessibility-compliance-accessibility-audit, performance-profiling, verification-before-completion.

CONTEXT: R-A to R-E are done. HARD RULES from R-A apply.
1. Settings tab (07_settings/01): sections and rows exactly as the mockup (no premium, no language rows), "Last scan" subtitle from stored timestamp, docked banner placeholder, skeleton. Use Inter (no JetBrains Mono).
2. Sub-screens (07_settings/02): App theme sheet with three preview cards + Apply theme (updates the existing theme setting), Scan settings screen (radios, Include images switch, storage diagnostics card on Android only, Open settings, Rescan now), snackbar "Image list updated" with Rescan now.
3. FAQ (07_settings/03): accordion with animated chevron, all six answers (reuse the Phase 5A texts), feedback button.
4. Ad placement audit (08_ads/01): verify every screen follows README section 4 rule 3: ad-free surfaces really have no ad slot; >= 16pt clearance from any button/FAB; failed ads collapse; interstitial only after tool success. Write docs/redesign/06_ad_placement_audit.md with a table screen by screen.
5. Accessibility: semantics labels for every icon button and file row, contrast >= 4.5:1 for body text in light and dark, text scale 2.0 without overflow on Home, file rows, Tools, dialogs and sheets; touch targets >= 48x48; focus/reading order; use flutter_test accessibility guidelines (androidTapTargetGuideline, labeledTapTargetGuideline, textContrastGuideline) on the main screens.
6. Responsive check: no overflow on 360x640, 393x852 and 412x915 (Android) and at text scale 1.3 and 2.0.
7. Final QA: run `flutter analyze`, `flutter test`, the integration test, and `flutter build apk --release`; install the release build on a real Android device if available; walk through every screen in light and dark and produce docs/redesign/07_qa_report.md listing every remaining deviation from the mockups with screenshots paths.

DONE CRITERIA: all commands pass; the 4-tools tests pass; qa report written.
```
