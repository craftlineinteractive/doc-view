# Doc View Localization Guidelines & Conventions

**Date**: November 2026  
**Scope**: Flutter `gen-l10n`, Application Resource Bundle (`.arb`) files, string extraction rules, translator guidelines, and pseudo-localization tooling.

---

## 1. Key Naming Architecture

All localization keys in `lib/l10n/app_*.arb` must adhere to camelCase with the structure:
$$\text{key} = \langle\text{area}\rangle\langle\text{Element}\rangle[\langle\text{StateOrRole}\rangle]$$

### Examples:
- `homeEmptyRecentTitle` — Home area, Empty Recent state, Title element
- `homeEmptyRecentSubtitle` — Home area, Empty Recent state, Subtitle element
- `searchFieldHint` — Search area, Field element, Hint state
- `categoryListCount` — Category list area, Count element (ICU plural)
- `dialogDeleteConfirmTitle` — Dialog area, Delete Confirm dialog, Title element
- `onboardingPage1Title` — Onboarding area, Page 1, Title element

---

## 2. ARB Metadata & Placeholder Rules

### 2.1 Mandatory Context Descriptions (`@key`)
Every string key defined in `app_en.arb` **must** have an accompanying `@key` entry with a descriptive string for human translators explaining:
1. Where the message appears in the app.
2. The meaning of any placeholders.
3. Tone (neutral, informative, warning).

```json
"homeScanProgressCount": "{count, plural, =0{Scanning...} =1{Scanning... 1 file found} other{Scanning... {count} files found}}",
"@homeScanProgressCount": {
  "description": "Progress message shown below search bar during background filesystem scan",
  "placeholders": {
    "count": {
      "type": "int",
      "example": "42"
    }
  }
}
```

### 2.2 Strict Typed Placeholders
All placeholders must have explicit types: `int`, `double`, `String`, or `DateTime`.
Never leave untyped placeholders in ARB files.

### 2.3 ICU Plurals Format
Never concatenate strings or pluralize via code branching (`count == 1 ? "file" : "files"`).
Always use standard ICU plural expressions:
```json
"{count, plural, =0{No files} =1{1 file} other{{count} files}}"
```

---

## 3. String Concatenation & Layer Boundaries

### 3.1 No String Concatenation to Form Sentences
Do **not** concatenate localized phrases at runtime (e.g. `context.l10n.delete + " " + fileName`).
Different human languages possess different word orders (Subject-Verb-Object vs Subject-Object-Verb).
Always use parameter placeholders:
```json
"dialogDeleteFileMessage": "Are you sure you want to delete \"{fileName}\"?",
"@dialogDeleteFileMessage": {
  "description": "Confirmation message when permanently deleting a document",
  "placeholders": {
    "fileName": {
      "type": "String",
      "example": "annual_report.pdf"
    }
  }
}
```

### 3.2 UI Layer Mapping (Clean Architecture)
Services and domain repositories must **never** contain localized strings or return user-facing text:
- Repositories and services return typed exceptions / sealed failure classes (e.g. `StoragePermissionDeniedException`, `CorruptedFileException`).
- The UI layer maps typed failures to `context.l10n.*` messages in screens, dialogs, and SnackBars.
- When an unexpected technical error string arrives from a 3rd-party library (e.g. SQLite, pdfium), log the technical stack trace to the console/diagnostics, but present a clean, localized generic error to the user (`context.l10n.errorGeneric`).

---

## 4. Untranslatable Terms List

The following terms represent brand trademarks, file extensions, paper sizes, and standardized binary units that must remain untranslated across all languages:
- **Brand Name**: `Doc View`
- **File Extensions & Types**: `PDF`, `DOC`, `DOCX`, `XLS`, `XLSX`, `PPT`, `PPTX`, `TXT`, `RTF`, `CSV`, `JPG`, `PNG`, `.pdf`, `.docx`, `.xlsx`
- **Paper Standards**: `A4`, `Letter`, `Legal`
- **Units**: `B`, `KB`, `MB`, `GB` (the number is formatted per locale, but unit suffix remains fixed)
- **Engine Identifiers**: `PDFium`, `JavaScript`

---

## 5. Core Glossary (Translator Consistency)

To avoid conflicting translations between different screens, translators must adhere to this standardized terminology:

| English Term | Context / Definition | Guidelines |
| :--- | :--- | :--- |
| **Recent** | Documents opened or imported recently | Noun; do not translate as "Latest" or "Current" |
| **Bookmarks** | User-favorited documents | Noun; do not translate as "Favorites" or "Stars" |
| **Folders** | Physical filesystem directory navigation | Distinct from document collections |
| **Merge** | Combining multiple PDF files into one | Verb/Action; keep distinct from "Join" |
| **Split** | Dividing a multi-page PDF into separate files | Verb/Action; keep distinct from "Cut" |
| **Scan** | Searching storage for office files or camera capture | Distinct from camera OCR (no OCR in app) |
| **Import** | Ingesting files from external pickers (iOS) | Distinct from system file opening |
| **Tools** | Utility screen containing PDF operations | Noun |
| **All files** | Navigation tab and category showing complete library | Distinct from filtered categories |

---

## 6. How to Add a New Language

1. Create `lib/l10n/app_<locale>.arb` (e.g. `lib/l10n/app_es.arb` for Spanish or `lib/l10n/app_de.arb` for German).
2. Set the `@@locale` key:
   ```json
   {
     "@@locale": "es",
     ...
   }
   ```
3. Copy all keys from `lib/l10n/app_en.arb` and provide human translations.
4. Run Flutter code generation:
   ```bash
   flutter gen-l10n
   ```
5. Register the locale in `SettingsRepository.supportedLocaleCodes`.
6. Run automated verification:
   ```bash
   flutter analyze
   flutter test
   ```

---

## 7. How to Regenerate the Debug Pseudo-Locale (`en_XA`)

The `en_XA` pseudo-locale is used during development to verify UI layout expansion (~40% longer strings) and RTL/accent glyph compatibility without requiring manual translations.

To regenerate `lib/l10n/app_en_XA.arb` after adding or updating keys in `app_en.arb`:
```bash
# 1. Run the pseudo-locale generator script
dart run tool/gen_pseudo_locale.dart

# 2. Re-run Flutter code generator to update classes
flutter gen-l10n

# 3. Verify placeholder and ICU syntax preservation
flutter test test/l10n/pseudo_locale_generator_test.dart
```

In release builds (`kReleaseMode`), `en_XA` is automatically stripped from `supportedLocales` and cannot be activated.
