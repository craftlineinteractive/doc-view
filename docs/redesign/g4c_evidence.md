# Phase G4c Evidence: The Recycle Bin & Delete Flow Redesign

## 1. Step 0 Gate Verification
- **Baseline Git Status**: Clean (`6de8110` applied).
- **Static Analysis**: `flutter analyze` clean (0 warnings, 0 errors, 0 lints).
- **Test Baseline**: 531 tests passing at baseline -> **580 tests passing** in G4c (+49 new tests).
- **Inverted Guardrail**: Scanned 137 surviving `lib/` files with 0 violations.

---

## 2. Architecture & Data Safety

### A. Crash-Safe 7-Step Transactional Move (`TrashService`)
User data safety is guaranteed by strict sequencing:
1. **Staging Copy**: Stream-copied to `<app_support>/recycle_bin/<uuid>.part`.
2. **Byte & Checksum Verification**: Source and staged copy byte size and SHA-256 hashes must match exactly.
3. **Atomic Rename**: Staged `.part` file is renamed to `<app_support>/recycle_bin/<uuid>.<ext>`.
4. **Database Transaction**: Record inserted into `trash` table recording original metadata, paths, and 30-day expiration timestamp (`expires_ms = now + 30 days`).
5. **Original Deletion**: Source file is unlinked.
6. **Rollback on Delete Failure**: If unlinking the original fails, the staged bin copy is deleted and the database transaction is rolled back. The original user document is never left in an unreferenced or corrupted state.
7. **Cache Refresh**: Providers invalidated and recents/bookmarks cleaned.

### B. Restore Logic & Collision Handling
- If the original folder path was deleted, the restore flow automatically recreates directory trees (`create(recursive: true)`).
- If a file with the original name already exists at the target location, `buildRestorePath` pure utility generates `<name> (restored).<ext>`, incrementing with `<name> (restored 2).<ext>` if needed.
- Restores original file timestamps and previous bookmark/imported state.

### C. Background Auto-Purge (`TrashPurgeService`)
- Throttled via `SharedPreferences` to run at most once every 6 hours (`trash_last_purge_ms`).
- Automatically triggered asynchronously during app initialization in `SplashScreen`.
- Deletes expired items where `expires_ms <= now`.
- Cleans up orphaned staging files (`.part` files or unindexed bin files older than 24 hours).
- Prunes ghost records whose physical files on disk no longer exist.

### D. Database Migration (Schema v3)
- Incremented `databaseVersion = 3` in `AppDatabase`.
- Created `trash` table with columns:
  - `id` (TEXT PRIMARY KEY)
  - `trash_path` (TEXT NOT NULL)
  - `original_path` (TEXT NOT NULL)
  - `original_name` (TEXT NOT NULL)
  - `extension` (TEXT NOT NULL)
  - `size_bytes` (INTEGER NOT NULL)
  - `category` (TEXT NOT NULL)
  - `original_modified_ms` (INTEGER NOT NULL)
  - `deleted_ms` (INTEGER NOT NULL)
  - `expires_ms` (INTEGER NOT NULL)
  - `was_bookmarked` (INTEGER NOT NULL)
  - `was_imported` (INTEGER NOT NULL)
  - `last_opened_ms` (INTEGER)
- Created index `idx_trash_expires` on `expires_ms`.

---

## 3. Delete Flow Replacement & UX
- **Move to Trash Replacement**:
  - `FileOptionsSheet`: "Delete" option moves file to Recycle bin, displaying 6-second transient `SnackBar` with `"Undo"` action.
  - `FilesScreen` & `SearchScreen`: Batch delete moves selected files to Recycle bin with 6-second `SnackBar` and `"Undo"`.
- **Oversized File Handling (> 200 MB)**:
  - Documents exceeding `trashMaxFileBytes = 200 * 1024 * 1024` prompt a dedicated dialog (`trashDialogTooLargeTitle`) explaining the 200 MB Recycle bin limitation and offering Cancel or Delete permanently.

---

## 4. UI Implementation (`/tools/recycle-bin`)
- **`RecycleBinScreen`**:
  - Ad-free layout with `DocScaffold` (`showDockedBanner: false`, `isAdLoaded: false`).
  - Dismissible `InfoBanner` with 30-day retention warning.
  - `DocEmptyState` when bin is empty.
  - `FileRow` with custom days-left chip (highlighted in error tint when <= 3 days left).
  - Multi-select mode with `DocSelectionAppBar` and bottom action dock (Restore, Delete forever).
  - Empty bin confirmation dialog triggered from app bar in normal mode.
- **`TrashOptionsSheet`**: Contextual bottom sheet for trashed item (Restore, Delete forever, Details).
- **`TrashDetailsSheet`**: Full metadata inspector (Original location, Date deleted, Expires in).
- **`toolRegistry`**: `recycle_bin` placed under `ToolSection.others` between `import_files` and `print_pdf` (9 visible tools total).

---

## 5. Test Suite Verification
- **Unit Tests**:
  - `test/core/utils/restore_file_name_test.dart` (6 tests)
  - `test/data/models/trash_item_model_test.dart` (4 tests)
  - `test/data/services/trash_service_test.dart` (8 tests)
  - `test/data/services/trash_purge_service_test.dart` (4 tests)
  - `test/data/db/app_database_migration_test.dart` (1 test)
- **Widget & Interaction Tests**:
  - `test/features/tools/recycle_bin_screen_test.dart` (7 tests)
  - `test/widget_test.dart` (9 tools verification)
  - `test/features/tools/tool_contract_test.dart` (7 tests)
  - `test/features/ad_placement_test.dart` (all tests passing)
- **Localization, Overflow & RTL Harness**:
  - `test/l10n/l10n_overflow_and_rtl_test.dart` (all 240 configuration permutations passing at 1.0x and 2.0x text scale in en and pseudo-locale).
- **Inverted Guardrail**:
  - `test/l10n/no_hardcoded_strings_test.dart` (137 surviving `lib/` files scanned, 0 violations).
- **Overall Result**: **580 passing tests**, 0 failures, 0 errors.

---

## 6. Device & QA Screenshots

### Device Status
- **Connected Emulator**: `emulator-5554` (sdk_gphone64_x86_64, Android 16 / API 36).
- **Physical Phone**: Not connected during this run (checked via `adb devices -l`; transport id: 1 only). Live verification and screenshot capture performed directly on `emulator-5554`.

### Verified Screenshot Artifacts (`docs/redesign/img/g4c/`)
All artifacts are rendered at native device resolution and optimized under the 300 KB limit:

| File Name | Description | Dimensions | Size |
|---|---|---|---|
| `tools_tab_recycle_bin.png` | Tools tab showing Recycle bin tile under Others | 1080 × 2400 | 128 KB |
| `recycle_bin_empty.png` | Empty Recycle bin screen with InfoBanner and empty state | 1080 × 2400 | 42 KB |
| `recycle_bin_list.png` | Non-empty Recycle bin with days-left badges | 1080 × 2400 | 70 KB |
| `trash_options_sheet.png` | Modal bottom sheet with Restore, Delete forever, Details | 1080 × 2400 | 28 KB |
| `trash_details_sheet.png` | Details sheet showing original location and expiration | 1080 × 2400 | 37 KB |
| `recycle_bin_selection.png` | Multi-selection mode with DocSelectionAppBar and dock | 1080 × 2400 | 75 KB |
| `recycle_bin_empty_dialog.png` | Empty bin confirmation dialog | 1080 × 2400 | 54 KB |
