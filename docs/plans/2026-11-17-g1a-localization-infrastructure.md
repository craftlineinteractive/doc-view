# G1a Localization Infrastructure & Phase 1 String Extraction Implementation Plan

> **Goal:** Establish full localization infrastructure for Doc View (Flutter `gen-l10n`, debug pseudo-locale `en_XA`, locale setting, RTL readiness, conventions guide, guardrail lint test, test helpers) and extract 100% of user-facing strings for core/shared, launch/onboarding/permissions, Home, Search, Category lists, Image grid, and Sort sheet into `lib/l10n/app_en.arb`.

**Architecture:** 
- Official Flutter localization via `flutter_localizations` SDK package and `l10n.yaml` driving `AppLocalizations`.
- Clean Dart extension `context.l10n` providing typed string access across UI widgets.
- Persisted `localeCode` in `SettingsRepository` watched by `MaterialApp` for real-time locale switching.
- Automated `tool/gen_pseudo_locale.dart` creating `en_XA` (~40% text expansion, accented glyphs, preserved ICU syntax).
- Regex-based guardrail test `test/l10n/no_hardcoded_strings_test.dart` preventing regressions in migrated areas.
- Automated RTL and high text-scale overflow test suites.

**Tech Stack:** Flutter 3.29.0, Dart 3.7.0, `flutter_localizations`, `intl`, `shared_preferences`, `flutter_riverpod`.

---

### Task 1: Localization Infrastructure Setup (pubspec, l10n.yaml, tool, extension)
- Files:
  - Modify: `pubspec.yaml` (add `flutter_localizations: sdk: flutter`, `flutter: generate: true`)
  - Create: `l10n.yaml`
  - Create: `lib/l10n/app_en.arb` (initial keys)
  - Create: `lib/core/extensions/l10n_extension.dart`
  - Create: `tool/gen_pseudo_locale.dart`
  - Test: `test/l10n/pseudo_locale_generator_test.dart`
- Steps:
  1. Update `pubspec.yaml` and run `flutter pub get`.
  2. Create `l10n.yaml` configured for synthetic gen_l10n.
  3. Create starter `lib/l10n/app_en.arb`.
  4. Run `flutter gen-l10n` to verify code generation.
  5. Implement `context.l10n` extension.
  6. Implement `tool/gen_pseudo_locale.dart` and verify preservation of placeholders (`{name}`) and ICU plurals (`{count, plural, ...}`).
  7. Write and run unit test `test/l10n/pseudo_locale_generator_test.dart`.
  8. Verify with `flutter analyze` and `flutter test`.
  9. Commit: `build(l10n): setup flutter l10n infrastructure and pseudo-locale generator`.

### Task 2: Locale Setting Persistence & Provider
- Files:
  - Modify: `lib/features/settings/data/settings_repository.dart`
  - Modify: `lib/features/settings/presentation/providers/settings_provider.dart` (or create `locale_provider.dart`)
  - Modify: `lib/app.dart` (wire `localizationsDelegates`, `supportedLocales`, `locale`, `localeResolutionCallback`)
  - Test: `test/l10n/locale_settings_test.dart`
- Steps:
  1. Add `getLocaleCode()` and `setLocaleCode(String?)` to `SettingsRepository` with SharedPreferences key `setting_locale_code`.
  2. Create `localeProvider` exposing `Locale?` (null = follow system, valid code e.g. 'en' or 'en_XA' in debug). Fall back to null if invalid/unsupported.
  3. Wire `MaterialApp` in `lib/app.dart` to consume `localeProvider`, provide `AppLocalizations.localizationsDelegates`, and add fallback resolver to English.
  4. Write unit tests for null default, round trip, and invalid code fallback.
  5. Commit: `feat(settings): add persisted locale code setting and live app provider`.

### Task 3: Conventions Documentation
- Files:
  - Create: `docs/l10n/README.md`
- Steps:
  1. Document key naming standard `<area><Element>`.
  2. Document mandatory `@description` and typed placeholders.
  3. Document ICU plurals format.
  4. Document strict UI layer mapping (no text in services/providers).
  5. Document untranslatable terms (Doc View, PDF, DOCX, XLSX, PPTX, A4, MB/KB).
  6. Document core terms glossary (Recent, Bookmarks, Folders, Merge, Split, Scan, Import).
  7. Document how to add a language and regenerate pseudo-locale.
  8. Commit: `docs(l10n): add localization guidelines, glossary, and conventions`.

### Task 4: Date, Number & Relative Time Formatting
- Files:
  - Modify: `lib/core/utils/format_utils.dart`
  - Test: `test/l10n/format_utils_test.dart`
- Steps:
  1. Refactor `FormatUtils` to accept `BuildContext` or `Locale` / active locale string for date, number, and file size formatting.
  2. Keep unit abbreviations (KB, MB, GB) while formatting numbers via `NumberFormat.decimalPattern(locale)`.
  3. Map relative times to localized strings / ARB plurals.
  4. Add unit tests for `en` and decimal-comma locale (e.g. `de_DE` / `fr_FR`).
  5. Report behavior of Arabic digits (`ar`) in intl.
  6. Commit: `refactor(core): make format utils locale-aware with intl`.

### Task 5: Guardrail Test & Allowlist
- Files:
  - Create: `test/l10n/hardcoded_allowlist.txt`
  - Create: `test/l10n/no_hardcoded_strings_test.dart`
- Steps:
  1. Write scanner in `no_hardcoded_strings_test.dart` targeting migrated directories.
  2. Scan for hard-coded strings in `Text(`, `title:`, `label:`, `hintText:`, `tooltip:`, `semanticsLabel:`.
  3. Load allowlist entries (path + reason).
  4. Verify test runs and detects violations.
  5. Commit: `test(l10n): add no hardcoded strings guardrail test and allowlist`.

### Task 6: Extract Strings & RTL Readiness - Core & Shared Widgets
- Files:
  - `lib/core/` and `lib/shared/` widgets (dialogs, sheets, bottom nav, error/empty states, buttons).
  - Modify: `lib/l10n/app_en.arb`
  - Update layout directionals (`EdgeInsetsDirectional`, `AlignmentDirectional`, chevron mirroring).
- Steps:
  1. Extract bottom nav labels: Home, Tools, Settings.
  2. Extract shared dialogs: confirmation dialogs, error banners, discard changes dialogs.
  3. Extract empty state widgets & retry buttons.
  4. Replace non-directional paddings with directionals where layout mirrors in RTL.
  5. Regenerate `app_en_XA.arb` via `dart run tool/gen_pseudo_locale.dart` and re-run `flutter gen-l10n`.
  6. Verify tests pass.
  7. Commit: `refactor(l10n): localize core and shared widgets with RTL directionals`.

### Task 7: Extract Strings & RTL Readiness - Launch Flow (Splash, Onboarding, Permissions)
- Files:
  - `lib/features/onboarding/` (pages 1-3)
  - `lib/features/splash/`
  - `lib/features/permissions/`
  - Modify: `lib/l10n/app_en.arb`
- Steps:
  1. Extract onboarding headlines, body paragraphs, and next/skip/start buttons.
  2. Extract permission request headings, rationale descriptions, grant access buttons, and storage diagnostics.
  3. Update directional layout constraints and back/next icons.
  4. Regenerate ARB and run tests.
  5. Commit: `refactor(l10n): localize launch onboarding and permission flows`.

### Task 8: Extract Strings & RTL Readiness - Home, Search, Category Lists, Image Grid, Sort Sheet
- Files:
  - `lib/features/home/` (tabs, search bar placeholder, category tiles, empty recent/bookmarks, scan progress)
  - `lib/features/search/` (hints, empty states, results count plurals)
  - `lib/features/files/` (category list app bars, empty states, sort bottom sheet, image grid)
  - Modify: `lib/l10n/app_en.arb`
- Steps:
  1. Extract Home strings: search bar hint, Recent / Bookmarks tabs, empty state titles & descriptions, scan progress strings.
  2. Extract Search strings: search field hint, "No files found", recent search queries, clear all.
  3. Extract Category list & Sort sheet strings: sort options (Name A-Z, Date modified, Size), category headers.
  4. Extract Image grid strings: selection counter, bulk actions.
  5. Verify directional layout and icon mirroring.
  6. Commit: `refactor(l10n): localize home, search, category lists, image grid, and sort sheet`.

### Task 9: Test Infrastructure (`pump_app.dart`), Component Gallery Toggles & QA Harness
- Files:
  - Create: `test/helpers/pump_app.dart`
  - Update: existing widget tests to wrap with `pumpApp`
  - Modify: `lib/features/dev/presentation/component_gallery_screen.dart` (add "Pseudo-locale (en_XA)" and "Force RTL" switches)
  - Create: `test/l10n/l10n_overflow_and_rtl_test.dart`
- Steps:
  1. Implement `pumpApp` providing localization delegates and default `Locale('en')`.
  2. Update existing tests so they compile and pass without weakening English assertions.
  3. Add dev gallery toggles for live verification.
  4. Add automated widget tests for `en_XA` and RTL at text scales 1.0 and 2.0 to detect overflows.
  5. Run emulator QA checks in light mode with `en_XA` and Force RTL.
  6. Commit: `test(l10n): add pump_app test helper, dev gallery toggles, and l10n overflow tests`.

### Task 10: Final Verification, G1b Unmigrated Inventory & Report
- Steps:
  1. Run `flutter analyze` (must be 0 issues).
  2. Run `flutter test` (must pass all tests, count >= 175).
  3. Grep migrated directories for remaining hard-coded strings.
  4. Inventory all remaining files/strings deferred to G1b.
  5. Report completion with exact counts, commit hashes, and logs.
