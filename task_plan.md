# Task Plan: G1a Localization Infrastructure & String Extraction

## Scope Guard & Hard Rules
- **UI layer only**: keep all behavior, providers, services and existing tests working. The Tools tab and its exactly-4-tools test remain UNTOUCHED.
- **No new features**: English only in release + debug pseudo-locale (`en_XA`). NO translations into other languages or machine translation.
- **Packages**: Only `flutter_localizations` (sdk: flutter) is added. `intl` is already installed.
- **Forbidden**: OCR, network/cloud, hardcoded demo documents.
- **Git Commit Rule**: Commit ONLY when an area is complete & QA-verified (`flutter analyze` clean, `flutter test` passing, emulator verified). Conventional Commits per area. Stage by explicit path. Never push.

## Milestones & Status

- [x] **Step 0: Baseline Verification & Clean Tree Report**
  - [x] Check git status (clean) and log (-5 commits).
  - [x] Baseline analyze (0 issues) and test count (175 passing).

- [x] **Task 1: Localization Infrastructure (build(l10n))**
  - [x] Add `flutter_localizations` & `generate: true` to `pubspec.yaml`.
  - [x] Create `l10n.yaml` (arb-dir: lib/l10n, template-arb-file: app_en.arb).
  - [x] Create `lib/core/extensions/l10n_extension.dart` (`context.l10n`).
  - [x] Create `tool/gen_pseudo_locale.dart` for debug-only `en_XA` generation.
  - [x] Add unit test `test/l10n/pseudo_locale_generator_test.dart`.
  - [x] Commit: `f2ee13f build(l10n): setup flutter l10n infrastructure and pseudo-locale generator`.

- [x] **Task 2: Locale Setting & Provider (feat(settings))**
  - [x] Add nullable `localeCode` to `SettingsRepository` with SharedPreferences persistence.
  - [x] Add `localeProvider` watched by `MaterialApp` in `lib/app.dart`.
  - [x] Fallback to null (system default) on invalid/unsupported stored code.
  - [x] Unit tests for persistence round-trip and fallback.
  - [x] Commit: `d96d7ef feat(settings): add persisted locale code setting and live app provider`.

- [x] **Task 3: Conventions Documentation (docs(l10n))**
  - [x] Write `docs/l10n/README.md` covering key naming, @description, ICU plurals, untranslatable terms, glossary, and how-tos.
  - [x] Commit: `63fb8a7 docs(l10n): add localization guidelines, glossary, and conventions`.

- [x] **Task 4: Formatting Utilities (refactor(core))**
  - [x] Update `lib/core/utils/format_utils.dart` to format dates, numbers, and file sizes using active locale.
  - [x] Unit tests with `en` and decimal-comma locale (`de`/`fr`).
  - [x] Report intl Arabic digits behavior.
  - [x] Commit: `4a0c365 refactor(core): make format utils locale-aware with intl`.

- [x] **Task 5: Guardrail Test (test(l10n))**
  - [x] Create `test/l10n/hardcoded_allowlist.txt`.
  - [x] Create `test/l10n/no_hardcoded_strings_test.dart` for regex linting of migrated areas.
  - [x] Commit: `3b52a3b test(l10n): add no hardcoded strings guardrail test and allowlist`.

- [x] **Task 6: String Extraction & RTL - Core & Shared (refactor(l10n))**
  - [x] Extract user-facing strings in `lib/core` and `lib/shared`.
  - [x] Convert to directional paddings/alignments and RTL chevrons.
  - [x] Commit: `dec2502 refactor(l10n): localize core and shared widgets with RTL directionals`.

- [x] **Task 7: String Extraction & RTL - Launch Flow (refactor(l10n))**
  - [x] Extract strings in `lib/features/splash/`, `lib/features/onboarding/`, `lib/features/permissions/`.
  - [x] Convert to directional layout.
  - [x] Commit: `e485e77 refactor(l10n): localize launch onboarding and permission flows`.

- [x] **Task 8: String Extraction & RTL - Home, Search, Lists, Image Grid, Sort Sheet (refactor(l10n))**
  - [x] Extract strings in Home (tabs, tiles, empty states, scan progress).
  - [x] Extract strings in Search, Category lists, Image grid, Sort sheet.
  - [x] Convert to directional layout.
  - [x] Enforce 0 violations in `no_hardcoded_strings_test.dart`.
  - [x] Commit: `0688a66 refactor(l10n): localize home, search, files, and sort sheets`.

- [x] **Task 9: Test Infrastructure, Dev Gallery & QA (test(l10n))**
  - [x] Create `test/helpers/pump_app.dart`.
  - [x] Add "Pseudo-locale (en_XA)" and "Force RTL" switches to dev gallery.
  - [x] Add automated widget tests for `en_XA` and RTL overflow at scale 1.0 & 2.0 (`test/l10n/l10n_overflow_and_rtl_test.dart`).
  - [x] Fix artwork scaling and responsive row layout under high text scales.
  - [x] Commit: `e16dc17 test(l10n): add pump_app test helper, dev gallery toggles, and l10n overflow harness`.

- [x] **Task 10: Final Inventory & Report**
  - [x] Count extracted ARB keys (265 ARB entries).
  - [x] Guardrail scan: 0 violations across all 8 target directories.
  - [x] All 206 tests passing, 0 analyzer issues.
  - [x] Strict separation of deferred G1b areas preserved.
