# Task Plan: Doc Reader Phase 1B (Data, Scanning, Import, UI)

## Goal
Implement the complete data persistence layer, file classification, background isolate scanner, cross-platform file import, Riverpod state management, and the mobile UI for the Flutter Doc Reader app.

## Architecture & Layers
1. **Domain & Data**:
   - `core/constants/file_types.dart`: `FileCategory` enum, extension mapping, `categoryFromPath`, colors, icons, labels.
   - `data/models/doc_file.dart`: `DocFile` entity with mapping and immutability (`copyWith`).
   - `data/db/app_database.dart`: SQLite database via `sqflite`, version 1 with indexed queries.
   - `data/repositories/file_repository.dart`: Upsert batch with preservation of user state, `removeMissing`, counts by category, paginated querying.
2. **Services**:
   - `data/services/permission_service.dart`: Device info check, scoped storage logic for Android 30+ vs <30, iOS handling.
   - `data/services/scanner_service.dart`: Background `Isolate` file system walker with blacklist filtering, batching (500), progress streaming, and DB sync.
   - `data/services/import_service.dart`: File picker integration, persistent storage copy with collision handling, iOS app documents scanner.
3. **State Management**:
   - `features/providers/providers.dart`: Riverpod providers for DB, repo, services, scan state, counts, paginated files.
4. **Presentation & UI**:
   - `core/utils/format_utils.dart`: Date formatting (MM/dd/yyyy) and size formatting (KB/MB).
   - `features/files/widgets/file_tile.dart`: Category icon, title, metadata subtitle, non-functional action buttons.
   - `features/home/home_screen.dart`: Category 4x2 grid with live counts, recent/bookmarks tabs, scan progress indicator, FAB manual import.
   - `features/files/files_screen.dart`: Category file listing with pagination and empty state.
   - `features/settings/settings_screen.dart`: Rescan now button (Android) and Import files button.
   - `app.dart` / Startup logic: Permission prompt dialog, app lifecycle observer (`WidgetsBindingObserver`), background scan trigger on resume.

## Phases & Tasks
- [x] Task 1: File types & categorization (`lib/core/constants/file_types.dart`)
- [x] Task 2: DocFile model (`lib/data/models/doc_file.dart`)
- [x] Task 3: SQLite AppDatabase (`lib/data/db/app_database.dart`)
- [x] Task 4: File repository (`lib/data/repositories/file_repository.dart`)
- [x] Task 5: Permission service (`lib/data/services/permission_service.dart`)
- [x] Task 6: Isolate scanner service (`lib/data/services/scanner_service.dart`)
- [x] Task 7: Import service (`lib/data/services/import_service.dart`)
- [x] Task 8: Riverpod providers (`lib/features/providers/providers.dart`)
- [x] Task 9: Formatting utilities & File tile component (`lib/core/utils/format_utils.dart`, `lib/features/files/widgets/file_tile.dart`)
- [x] Task 10: Screen implementations & routes (`home_screen.dart`, `files_screen.dart`, `settings_screen.dart`, `app_router.dart`)
- [x] Task 11: Startup logic & lifecycle observer in `app.dart`
- [x] Task 12: Verification & Test Suite (`flutter analyze`, `flutter test`, `flutter build bundle`)
