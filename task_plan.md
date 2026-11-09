# Task Plan: Phase 3 (R-D2) - Document Viewers Redesign & Precision Engineering

## Scope Guard & Hard Rules
- UI layer only. Tools tab has EXACTLY 4 tools (Image to PDF, Scan to PDF, Merge PDF, Split PDF).
- Use only shared components, tokens, and ad placeholders from R-B; NO new packages.
- Viewers show REAL opened files (`pdfrx` for PDF, `offline_document_viewer` for Office, `Image.file` for images, real text for TXT).
- NO ads anywhere in viewers (no banner, no native, no interstitial).
- Dark mode keeps PDF page white on dark canvas (#11131B, never invert page).
- FORBIDDEN: OCR, Print, Add Password, Unlock (tool), Signature, "Share via Secure Link", toolkit sheets, in-PDF text search, annotations, export tools, marketing modals, "256-bit encryption", network/cloud features, hard-coded demo documents.
- Run `flutter analyze` after each step.

## Implementation Steps

- [x] **Step 1: File Details Bottom Sheet Reusable Component**
  - Path: `lib/features/files/widgets/file_details_sheet.dart`
  - 120x150 preview, key-value rows (Name, Type, Size as "2.5 MB (2,621,440 bytes)", Modified, Location with copy button and snackbar, Bookmarked).
  - Page count chip "PG 1/N" on preview only if known.
  - Primary "Open file" CTA button.

- [x] **Step 2: PDF Reader Chassis & Floating Controls (`05_viewers/01_pdf_reader`)**
  - Path: `lib/features/viewer/pdf_viewer_screen.dart`, `lib/features/viewer/widgets/*`
  - Auto-hiding top bar: back, file name with "N Pages • size" subtitle, bookmark toggle, 3-dot overflow.
  - Reader canvas: Light `#EEF0F5`, Dark `#11131B`, faint page shadow, un-inverted white pages in dark mode.
  - Floating tabular page pill "3 / 120" with idle auto-fade and scroll-trigger reappearance.
  - Floating bottom toolbar: Pages, Go to, Share, More.
  - Pages bottom sheet: Page NUMBER tiles grid (no thumbnails), current page highlighted, jumps to page on tap.
  - More sheet: Share, Open in another app, Details, Add/Remove bookmark.
  - Shimmer skeleton placeholder while loading.
  - Android gesture navigation safe-area padding.

- [x] **Step 3: PDF States (`05_viewers/02_pdf_reader_states`)**
  - Password dialog over blurred backdrop: lock icon, obscure eye toggle, error on retry, Cancel and Unlock.
  - Go to page dialog: number field, hint "Enter a page between 1 and N", inline validation, Cancel and Go.
  - Corrupt file screen: "Can't open this PDF" with "Open in another app" and "Back".
  - Missing file screen: "This file no longer exists" with "Back to files" (deletes DB record).

- [x] **Step 4: Office Viewer (`05_viewers/03_office_viewer`)**
  - Path: `lib/features/viewer/office_viewer_screen.dart`
  - Kept `offline_document_viewer` imported ONLY in `office_viewer_screen.dart`.
  - Shared bar: back, file name, search, outline (shown only when outline exists), bookmark, 3-dot.
  - Banners: "Legacy format: text only" for doc/ppt/xls/rtf; "Large spreadsheet: showing the first 3000 rows" when truncated. Dismissible.
  - Search mode: search field with match counter ("5 matches"), prev/next chevrons.
  - Outline sheet: indented list, jumps on tap.
  - Error states: password-protected, too large, unsupported, generic, all with "Open in another app".
  - Skeleton page while opening.

- [x] **Step 5: Image Viewer (`05_viewers/04_image_txt_viewer`)**
  - Path: `lib/features/viewer/image_viewer_screen.dart`
  - Black canvas, `InteractiveViewer` (1x-5x), double-tap zoom to 2.5x/1x.
  - Tap-to-toggle translucent top bar.
  - Bottom info chip: "W × H • size" decoded from real image metadata.
  - Zoom pill "2.5x" visible only when scaled with Reset action.
  - Skeleton while decoding.

- [x] **Step 6: TXT Viewer (`05_viewers/04_image_txt_viewer`)**
  - Path: `lib/features/viewer/txt_viewer_screen.dart`
  - 1 MB cap, isolate read, line height 1.5, `SelectionArea`.
  - Top bar: back, file name, "A-", "A+", monospace toggle, bookmark, typography sheet button, 3-dot.
  - Persisted font size (12-28) and monospace settings.
  - Truncation banner "Showing first 1 MB • Open in another app for full content".
  - Typography bottom sheet with slider (12-28) and live preview line.
  - Skeleton text lines while reading; error state with "Open in another app".

- [x] **Step 7: Automated Tests & Verification**
  - Unit/widget tests in `test/features/viewer_test.dart` for PDF password dialog, Go to dialog validation, Pages sheet jump, DocFoldedIcon labels, FileTypeBadge.
  - All 72 tests passing.
  - `flutter analyze` 0 issues.
  - Direct splash launch verified on emulator-5554.
  - Home screen category icons verified without rounded border background.
