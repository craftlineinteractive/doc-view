# Project Findings & Discoveries

## Ecosystem & Environment
- Flutter SDK: 3.44.9 (Dart 3.12.2) on Windows
- Riverpod: v3.4.3
- GoRouter: v17.5.0
- Sqflite: v2.4.5
- DeviceInfoPlus: v13.3.0
- PermissionHandler: v13.0.2
- FilePicker: v13.3.1
- PathProvider: v2.1.6

## Technical Nuances
- Riverpod 3.x uses modern Provider patterns.
- GoRouter 17.x: StatefulShellRoute with query parameter support `/files?category=pdf`.
- SQLite ON CONFLICT: `INSERT INTO files (...) VALUES (...) ON CONFLICT(path) DO UPDATE SET name = excluded.name, extension = excluded.extension, size_bytes = excluded.size_bytes, modified = excluded.modified, category = excluded.category`.
- Dart Isolate: `Isolate.spawn` runs pure Dart code; `dart:io` `Directory.list` works without Flutter bindings inside the isolate. Communication to main thread via `SendPort`/`ReceivePort`.
- iOS Documents: `getApplicationDocumentsDirectory()`. Picker returns temporary cached files that must be copied into an `imported/` subfolder.

