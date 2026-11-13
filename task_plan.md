# Task Plan: Phase 7 (Prompt R-F) - Settings & Clean-Up

## Scope Guard & Hard Rules
- UI layer only. Tools tab has EXACTLY 4 tools (Image to PDF, Scan to PDF, Merge PDF, Split PDF).
- Keep all existing behavior, providers, services, and tests working.
- Use only shared components, tokens, and ad placeholders from R-B; NO new packages.
- FORBIDDEN: premium, "Remove ads" banners, purchases or subscriptions, a Language row, OCR, Print, Add Password, Unlock, Signature, "Share via Secure Link", Compress, Annotate, conversions, a toolkit sheet, help or marketing modals, invented error codes, network or cloud features, hard-coded demo documents, "Engine 4.18", "2 Utilities", JetBrains Mono.
- GIT COMMIT RULE: commit ONLY when fully completed and QA-verified. Stage files by explicit path. Conventional Commits format with QA and Deviations lines. Make separate commits per area.

## Milestones & Status

- [x] **Step 0: Clean-Up & Verification from R-E2 Report**
  - [x] 0a: Board fluff grep: grep `lib/` for forbidden phrases. Removed user-facing occurrences (Split PDF card shows only file name, "N pages · size" and preview; no badge). (Commit `d272df9`)
  - [x] 0b: Demo data grep: grep `lib/` for hard-coded file names. Output confirmed empty.
  - [x] 0c: Dark palette audit: Replaced rogue color literals in Merge, Split, Tools, and Created-by-you.
  - [x] 0d: Output correctness: Verified merge and split range parser unit tests.
  - [x] 0e: Record "+ Add PDF" button and R-E2 additions in `docs/redesign/04_gaps_and_conflicts.md`.
  - [x] 0f: Cold start measurements: 3 runs in light/dark mode, confirm no flash.

- [x] **Step 1: Settings Tab (`doc_view_mockups/07_settings/01_settings_tab`)**
  - [x] 1a: Header "Settings" (Space Grotesk) with pale-blue gradient in light mode; transparent system bars; NO premium, remove-ads or language rows.
  - [x] 1b: Rows (>=56pt, 2px outlined icons, title SemiBold 16, subtitle Medium 13 secondary, chevron, ripple) and section headers using shared `SettingsRow`/`SettingsSectionHeader`; Inter only.
  - [x] 1c: Top group: "File manager" (/directories), "Import files", "Rescan now" (Android only; subtitle "Last scan: today, 4:31 PM" / "Never scanned"; hidden on iOS).
  - [x] 1d: Section "General": "Scan settings", "App theme", "Clear recent history".
  - [x] 1e: Section "Help": "FAQ", "Send feedback", "Share app", "Rate us".
  - [x] 1f: Section "About": "Privacy policy", "Open-source licenses", "Version" (tap does nothing, long-press opens component gallery in `kDebugMode` only).
  - [x] 1g: Row hiding: rows with empty constant (`supportEmail`, `storeShareUrl`, `storeRateUrl`, `privacyPolicyUrl`) are HIDDEN.
  - [x] 1h: Skeletons & docked banner placeholder above bottom nav.

- [x] **Step 2: Settings Sub-Screens (`07_settings/02_settings_sub_screens`)**
  - [x] 2a: App theme bottom sheet: Title "App theme", subtitle "Select visual appearance for Doc View", three selectable cards with mini phone previews drawn with widgets: "System default", "Light" ("Clean white"), "Dark" ("Deep navy"); selected card has 2px blue border and check; primary "Apply theme" updating theme live.
  - [x] 2b: Scan settings screen: Back bar "Scan settings"; section "Scan frequency" with radios ("Scan on app open", "Manual only"); section "Document filters" with switch "Include images" and helper; Storage diagnostics card (Android only, real state, "MANAGE_EXTERNAL_STORAGE"); outlined "Rescan now" button with inline progress; docked banner placeholder.
  - [x] 2c: Snackbar "Image list updated" with action "Rescan now" after toggling Include images.

- [x] **Step 3: FAQ Screen (`07_settings/03_faq`)**
  - [x] 3a: Back bar "FAQ" with "6 Topics" header count.
  - [x] 3b: Accordion cards (16pt radius, tile background, hairline, Bold 16, animated rotating chevron, single-expand, 2nd question expanded by default).
  - [x] 3c: FAQ question 2 answer for "Is my data uploaded anywhere?" exactly per owner decision: "Your documents never leave your device. Doc View opens, converts and stores files locally. The app shows ads served by Google AdMob, which can use limited device data as described in our Privacy Policy."
  - [x] 3d: Tonal button "Still need help? Send feedback" (hidden when `supportEmail` is empty).
  - [x] 3e: Record AdMob & 100% offline note in `docs/redesign/04_gaps_and_conflicts.md`.
  - [x] 3f: Skeleton variant & docked banner placeholder.

- [x] **Step 4: Clear Recent History Dialog**
  - [x] 4a: Confirm dialog: title "Clear recent history?", body "Files will be removed from Recent. Your files and bookmarks are not affected.", Cancel and Clear buttons.
  - [x] 4b: Snackbar "Recent history cleared".

- [x] **Step 5: Automated Tests**
  - [x] 5a: Settings tab tests (row ordering, subtitles, hidden empty constants, platform checks, no forbidden rows).
  - [x] 5b: Theme selection sheet tests (cards, selection, live update via Apply).
  - [x] 5c: Scan settings tests (radios persist, Include images toggle triggers snackbar with action).
  - [x] 5d: FAQ screen tests (6 topics, single-expand accordion, 2nd expanded by default, feedback button hidden when empty).
  - [x] 5e: Clear history dialog flow test.
  - [x] 5f: Run full test suite (`flutter test`) - all 99 tests pass.

- [x] **Step 6: Live QA, Visual Verification & Final Reports**
  - [x] 6a: Emulator verification in light & dark modes with screenshots.
  - [x] 6b: Real command outputs for Step 0 and forbidden checks.
  - [x] 6c: Files-changed and deviations tables.
  - [x] 6d: Git commits per area according to GIT COMMIT RULE (`d272df9` and `7aa4744`).
