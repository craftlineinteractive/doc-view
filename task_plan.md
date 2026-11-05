# Step 2 Implementation Plan: Directories Hardening & Isolate Safety

> **Goal:** Fix the Directories browser feature (`/directories`) on Android emulator (API 36) where it gets stuck on breadcrumb "Root" with error `"Can't open this folder - Permission denied or folder inaccessible"`. Enforce Isolate Safety Rule everywhere across `lib/`, introduce typed directory states, resilient per-entry directory listing in an isolated service, single permission provider, dynamic root resolution, and full test suite.

**Hard Rule:**
- The Tools tab must remain untouched (exactly the 4 tools created in Phase 3B; do not touch `lib/features/tools/`).
- Do NOT rewrite unrelated files.
- No new packages.
- Touch targets $\ge 48\text{dp}$.

---

## Tasks

### Phase 1: Isolate Audit & Safety Enforcement
- [x] Task 1.1: Audit all `Isolate.run`, `compute(`, and `Isolate.spawn` calls in `lib/`.
- [x] Task 1.2: Refactor `lib/data/services/pdf/image_to_pdf_service.dart` to top-level worker with immutable DTO.
- [x] Task 1.3: Refactor `lib/features/viewer/txt_viewer_screen.dart` to top-level worker with immutable DTO.
- [x] Task 1.4: Compile audit report table for reply.

### Phase 2: Root Path Resolution Utility
- [x] Task 2.1: Implement `lib/core/utils/root_path_resolver.dart` with `deriveAndroidRoot` cutting at `/Android` and `resolveRootDirectory` with unit-testable fallbacks.

### Phase 3: Directory Lister Service & DTOs
- [x] Task 3.1: Implement `lib/features/directories/services/directory_lister.dart` with `DirectoryEntryDto`, top-level `listDirectorySync`, and top-level `listDirectoryEntries` via `Isolate.run`.
- [x] Task 3.2: Implement per-entry resilience (try/catch around stat, skipping broken symlinks/hidden files, filtering unsupported file types, alpha sorting).

### Phase 4: Single Permission Provider & Directories Screen Hardening
- [x] Task 4.1: Add `allFilesAccessProvider` in `lib/features/providers/providers.dart` with auto-refresh on app resume and settings return.
- [x] Task 4.2: Replace generic error in `lib/features/directories/directories_screen.dart` with typed states:
  - `loading`
  - `permissionRequired` ("Doc Reader needs All files access to browse your folders." + "Grant access" + "Import files instead")
  - `folderAccessDenied` ("This folder is protected by Android." + "Go back")
  - `notFound` ("This folder no longer exists." + "Go to Root")
  - `empty` ("No supported files or folders here.")
  - `unknownError` (short message + "Retry")
- [x] Task 4.3: Implement tappable breadcrumb segments ($\ge 48\text{dp}$) and back navigation (PopScope + AppBar arrow).
- [x] Task 4.4: Remove all `[DIRDBG]` temporary debug logs.

### Phase 5: Regression & Unit Tests
- [x] Task 5.1: Unit test for root path resolver in `test/unit_test.dart`.
- [x] Task 5.2: Unit test for directory lister via real `Isolate.run` against `Directory.systemTemp.createTemp` directory with subfolder, `.pdf`, `.secret`, `.xyz`.
- [x] Task 5.3: Unit test for `image_to_pdf_service` / TXT reader isolate workers.
- [x] Task 5.4: Widget test for `DirectoryPermissionRequiredState` showing "Grant access" button.

### Phase 6: Verification & QA
- [x] Task 6.1: Run `flutter analyze` & ensure 0 issues (PASSED).
- [x] Task 6.2: Run `flutter test` & verify all tests pass (43/43 PASSED).
- [x] Task 6.3: Build split debug APK and install on emulator (`adb install -r -d` succeeded).
- [x] Task 6.4: Provide manual QA test checklist.
