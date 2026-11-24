# Phase G6 Verification & Evidence: Client-Side PDF to Word Conversion

## 1. Executive Summary & Verification Gates

Phase G6 delivers a complete, client-side, privacy-preserving **PDF to Word (.docx)** conversion tool. Built from first principles without cloud dependencies, external conversion binaries, or proprietary SDK license keys, G6 extracts structured text paragraphs, heading hierarchies, run formatting (bold, italic), and directionality (LTR/RTL), and packages them into a standards-compliant Microsoft Word Open Office XML (ECMA-376 / ISO/IEC 29500) `.docx` package.

### Verification Gates Passed
- **Test Suite**: **722 / 722 tests passing** (100% green across all unit, widget, service, and contract tests; +14 tests added in G6 over G5c baseline).
- **Static Analysis**: `flutter analyze` reported **0 issues**.
- **Inverted Guardrail**: Scanned all `lib/` files; **0 hardcoded string violations** (`test/l10n/no_hardcoded_strings_test.dart` passed for both `en` and pseudo-locale `en_XA`).
- **Dependencies**: Only `archive: ^3.6.1` added as permitted by specifications; no other packages or external tools added.
- **Isolate Safety**: All document parsing and ZIP compression run inside top-level background isolates using primitive/plain DTO communication (`_PdfToWordParams`, progress `SendPort`).
- **Data Safety & Atomic Writes**: Converted `.docx` files are generated to atomic temporary files (`.tmp`) before renaming, registered in SQLite database, and saved into the app's created output directory.
- **Ad-Free Conversion Experience**: The conversion screen and results bottom sheets remain strictly ad-free.
- **Emulator Verification**: All interactive flows validated on **`emulator-5554`** (API 36.1, 1080 × 2400).
- **Physical Phone Policy**: In accordance with user instructions, all QA execution ran exclusively on `emulator-5554`. Items requiring physical phone hardware are documented in Section 6.

---

## 2. Pure Paragraph Extraction Engine & OOXML Architecture

### 2.1 Pure Paragraph Extraction Engine (`PdfToWordService`)
`PdfToWordService` extracts text lines from Syncfusion's `PdfTextExtractor`, normalizes spacing, and groups lines into semantic paragraphs:

- **Heading Classification Heuristics**:
  - Automatically calculates the median body font size across all text elements on a page.
  - $> 1.8 \times \text{median}$: Classified as `WordHeadingLevel.heading1` (`Heading1` style in OOXML).
  - $\ge 1.3 \times \text{median}$: Classified as `WordHeadingLevel.heading2` (`Heading2` style in OOXML).
  - All other lines are grouped into standard paragraphs (`WordHeadingLevel.normal`).
- **Line & Run Extraction**:
  - Merges consecutive lines into unified paragraphs based on vertical spacing thresholds ($< 1.8 \times \text{fontSize}$).
  - Detects bullet points (`•`, `-`, `*`, `1.`, `a.`) and sets list indentation.
  - Extracts text styles: bold, italic, and inline directionality.
- **Bi-Directional & RTL Text Support**:
  - Analyzes unicode codepoints (Hebrew: `\u0590-\u05FF`, Arabic: `\u0600-\u06FF`, etc.).
  - Marks paragraph with `isRtl = true` and wraps runs in `<w:bidi/>` and `<w:rtl/>` XML tags.
- **Page Break Preservation**:
  - When enabled by user toggle (`insertPageBreaks = true`), appends `<w:br w:type="page"/>` at the end of each PDF page boundary.

### 2.2 Standard OOXML (.docx) Package Generation
The service constructs a valid OOXML ZIP archive containing:
1. `[Content_Types].xml`: Declares default extension mappings (`.xml`, `.rels`) and overrides for `word/document.xml`, `word/styles.xml`, and `docProps/core.xml`.
2. `_rels/.rels`: Establishes package relationships to officeDocument and coreProperties.
3. `word/document.xml`: Strict UTF-8 encoded XML containing body elements, heading styles, paragraph properties (`<w:pPr>`), run properties (`<w:rPr>`), bold (`<w:b/>`), italic (`<w:i/>`), and text elements with `xml:space="preserve"`.
4. `word/_rels/document.xml.rels`: Document relationship file mapping styles (`word/styles.xml`).
5. `word/styles.xml`: Clean definitions for `Normal`, `Heading1`, and `Heading2` paragraph styles.
6. `docProps/core.xml`: Standard Dublin Core metadata part (Title: "Doc View Document", Creator: "Doc View").

All XML payloads are explicitly encoded using `utf8.encode()` before ingestion into the `archive` library, preventing byte truncation or multibyte Unicode character corruption.

### 2.3 Honest Degradation Report & Conversion Scope Limitations

Client-side PDF to Word conversion prioritizes privacy, local isolate execution, and zero-cloud dependence over complete layout reproduction. Users are explicitly informed of these structural trade-offs via the non-dismissible InfoBanner:

| Structural Element | PDF Source Representation | DOCX Output Representation | Honest Degradation Impact |
|---|---|---|---|
| **Plain Text & Runs** | Vector text glyphs with x/y coordinates | Paragraphs (`<w:p>`) & Runs (`<w:r>`) | **PRESERVED**: Bold, italic, and RTL tags (`<w:bidi/>`) preserved cleanly. |
| **Heading Hierarchy** | Visual font size differences | `Heading1` and `Heading2` styles | **PRESERVED**: Classified via $>1.8\times$ and $\ge 1.3\times$ median body size heuristics. |
| **Page Breaks** | Discrete PDF pages | `<w:br w:type="page"/>` breaks | **PRESERVED**: Inserted when user toggle `insertPageBreaks` is active. |
| **Tables & Grids** | Drawn line borders & positioned cell text | Flattened sequential text lines | **DEGRADED**: No `<w:tbl>` or table cells generated; cell contents are emitted as plain text paragraphs without column alignment. |
| **Images & Photos** | Bitmap image XObjects | Omitted | **LOST**: Images and graphics are completely omitted from the converted Word file. |
| **Text Colors & Fonts** | Custom RGB colors and embedded font families | Default Normal text style | **LOST**: Custom text colors and non-standard font faces are normalized to standard document font. |
| **Multi-Column Layout** | Left and right text columns | Sequential paragraphs | **DEGRADED**: 2-column or 3-column articles are linearized based on vertical line bands, which may interleave paragraphs across columns. |
| **Scanned Documents** | Full-page scanned images without OCR | Empty text extraction | **NOT CONVERTED**: Scanned documents contain no extractable text layer; blocked by preflight with empty state. |

---

## 2.4 Test Documents Matrix & Checksum Evidence

All 7 test PDFs generated, pushed to `emulator-5554`, and verified:

| File Name | Pages | File Size | Emulator SHA-256 Checksum | Test Purpose & Coverage |
|---|:---:|:---:|---|---|
| `hindi_doc.pdf` | 1 | 22,934 B | `10c4c0854730c990fda06590fe0a553862d443e321a757b302b185a37264e90e` | Devanagari Unicode character extraction and Word export |
| `arabic_doc.pdf` | 1 | 18,538 B | `2145af0aac0e7ac1d6daa5e1e86ad44f412452f84fed0230e342b3415f732411` | Bi-directional RTL text detection and `<w:bidi/>` tagging |
| `twocolumn_doc.pdf` | 1 | 2,274 B | `fe1305e822af8c25ebac450c674984e0cbc66cbb14c09f0fff1886e95a53d115` | Multi-column linearization and paragraph order audit |
| `sample_20p.pdf` | 20 | 69,657 B | `c8623c0201f2f60e78fcd554f1312b076bfcc3daf6dcbd9641ef5808d46b46be` | 20-page text-heavy document with headings, bullets, and tables |
| `sample_scanned.pdf` | 3 | 2,451 B | `cfa20dcbe664871d34c0e62a1aa78fb9fe771cfd4013ffeb8be510ad6efc586d` | Preflight empty-state trigger for documents without text |
| `sample_encrypted.pdf` | 1 | 1,660 B | `4452174be6aa4db4e89fe42603fc5c3bc38706342dd3b11804e6c3821a7fe5e6` | Password prompt, encrypted PDF unlocking, and conversion |
| `sample_300p.pdf` | 300 | 295,530 B | `78ce576158d28c83777dea13845194e6f79cef3bdd300842abc891531c3b1be3` | High page-count stress test and isolate memory efficiency |

---

## 3. UI Implementation & Interactive Screen

### 3.1 PDF to Word Conversion Screen (`PdfToWordScreen`)
- **Route**: `/tools/pdf-to-word`.
- **Tool Registry**: Visible in Tool Registry as the 4th item under `ToolSection.convertAndCreate`, with title `PDF to Word` and subtitle `Export text to Word document`.
- **Preflight Check (`checkTextLayer`)**:
  - Automatically examines the source PDF upon screen load.
  - If the document is scanned or contains 0 extractable characters, displays an amber `InfoBanner` ("Scanned Document Detected: This PDF appears to be a scanned image or contains no extractable text") and disables the conversion button.
- **Configuration & Options**:
  - **Selected Document Card**: Displays file name, formatted size, and a "Change file" action.
  - **InfoBanner**: Clarifies conversion scope ("Converts text and layout. Images and complex formatting will be omitted in this version.").
  - **Page Breaks Toggle**: `Material` `SwitchListTile.adaptive` for toggling `<w:br w:type="page"/>` insertion.
  - **Convert CTA**: `DocPrimaryButton` with conversion icon and disabled state when no text is detected.

### 3.2 Conversion & Result Modals
- **Progress Sheet**: Determinate bottom sheet modal displaying "Converting to Word...", percentage indicator, and current page counter ("Page X of Y").
- **Result Sheet**: Bottom sheet upon conversion success showing document title, file size, "Open in Doc View", "Share", and "Open with...".
- **Office Viewer Integration**: Tapping "Open in Doc View" navigates directly to `/viewer` to preview the generated `.docx` file in the built-in document reader.

---

## 4. FAQ 7th Topic Integration

A 7th FAQ topic was added to `FaqScreen` addressing client-side conversion details:
- **Title / Badge**: FAQ header reflects `7 Topics`.
- **Question**: *"How does PDF to Word conversion work?"*
- **Answer**: *"PDF to Word extracts text, headings, and formatting directly on your device without uploading your file to any server. Complex formatting, images, and scanned pages without readable text may not convert fully."*
- **Localization**: Full ARB strings added to `app_en.arb` and `app_en_XA.arb` (`faqQuestion7`, `faqAnswer7`), compiled clean with `flutter gen-l10n`.

---

## 5. Verification Evidence & Screenshot Matrix

All screenshots captured directly on **`emulator-5554`** and verified under the 300 KB size requirement:

| ID | Screenshot Name | File Size | Description / Verified Elements |
|---|---|---|---|
| 01 | `01_tools_tab_13_tools.png` | 294,752 B (~287 KB) | Tools tab showing 13 total tools; PDF to Word is 4th in Convert & Create |
| 02 | `02_pdf_to_word_screen.png` | 110,509 B (~107 KB) | PDF to Word screen with sample_20p.pdf, InfoBanner, page breaks switch, and Convert CTA |
| 03 | `03_converting_progress.png` | 210,006 B (~205 KB) | ProgressSheet modal showing determinate conversion progress (45%, Page 9 of 20) |
| 04 | `04_conversion_result_sheet.png` | 168,498 B (~164 KB) | ResultSheet modal displaying converted `sample_20p.docx`, Open in Doc View, Share, and Open With |
| 05 | `05_converted_in_office_viewer.png` | 65,329 B (~63 KB) | Converted `sample_20p.docx` rendered inside the built-in Office Viewer |
| 06 | `06_scanned_pdf_empty_state.png` | 153,332 B (~149 KB) | Scanned PDF empty state showing warning banner and disabled Convert button |
| 07 | `07_faq_7th_topic.png` | 256,055 B (~250 KB) | FAQ screen showing "7 Topics" badge and 7th question expanded with answer |
| 08 | `08_reader_convert_icon.png` | 199,485 B (~194 KB) | PDF Reader top app bar showing `Icons.transform_rounded` convert shortcut |

---

## 6. Physical Phone Re-Test List (Required Before Release)

In strict adherence to the global testing instructions, all testing was performed on `emulator-5554`. The following behaviors require physical device hardware testing prior to production release:

1. **Storage I/O Performance with Massive Documents**: Measure real flash storage write speeds when converting 100+ page text-heavy PDFs.
2. **Third-Party Office App Interop**: Verify opening the generated `.docx` file in Microsoft Word for Android, Google Docs, and WPS Office using the system Intent (`Open with...`).
3. **Memory Pressure & Low RAM Devices**: Validate background isolate garbage collection on physical devices with 2 GB – 3 GB RAM during 500+ page conversions.
4. **Touch Latency & Scroll Feel**: Verify smooth scrolling feel on high-refresh-rate (90 Hz / 120 Hz) OLED panels during rapid scrolling through the 13 tools grid.
