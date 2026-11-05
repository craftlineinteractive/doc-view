# Directories Hardening & Isolate Safety Progress

| Date | Task | Status | Notes |
| :--- | :--- | :--- | :--- |
| 2026-11-05 | Diagnosis (Step 1) | Completed | Unsendable `_AsyncCompleter` in `_loadCurrentDirectory()` closure |
| 2026-11-05 | Task 1.1: Isolate Audit | Completed | Audited all 4 isolate usages across `lib/` |
| 2026-11-05 | Task 1.2: Refactor `image_to_pdf_service.dart` | Completed | Top-level worker `compilePdfInWorker` + `PdfCompilationPayload` |
| 2026-11-05 | Task 1.3: Refactor `txt_viewer_screen.dart` | Completed | Top-level synchronous worker `readTxtFileWorker` |
| 2026-11-05 | Task 2.1: Root Path Resolver | Completed | `deriveAndroidRoot` + `resolveRootDirectory` in `root_path_resolver.dart` |
| 2026-11-05 | Task 3.1: Directory Lister Service | Completed | `directory_lister.dart` with `DirectoryEntryDto` and per-entry resilience |
| 2026-11-05 | Task 4.1: Permission Provider | Completed | `allFilesAccessProvider` with resume and settings refresh |
| 2026-11-05 | Task 4.2: Typed Directory States | Completed | `loading`, `permissionRequired`, `folderAccessDenied`, `notFound`, `empty`, `unknownError` |
| 2026-11-05 | Task 5.1-5.4: Test Suite | Completed | 43/43 tests passing (unit + regression + widget) |
| 2026-11-05 | Task 6.1: `flutter analyze` | Completed | 0 issues found |
| 2026-11-05 | Task 6.2: `flutter test` | Completed | 43/43 tests passing |
| 2026-11-05 | Fix Native ABI Mismatch Crash | Completed | Excluded mismatched ABIs in packaging; pure `arm64-v8a` APK built & installed |
| 2026-11-05 | Live Verification | Completed | App launched and verified running with Root directory and all folders displayed |
