import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/file_types.dart';
import '../../data/db/app_database.dart';
import '../../data/models/app_settings.dart';
import '../../data/models/doc_file.dart';
import '../../data/models/sort_option.dart';
import '../../data/repositories/file_repository.dart';
import '../../data/repositories/settings_repository.dart';
import '../../data/services/file_operations_service.dart';
import '../../data/services/import_service.dart';
import '../../data/services/open_with_service.dart';
import '../../data/services/pdf/image_to_pdf_service.dart';
import '../../data/services/pdf/pdf_merge_service.dart';
import '../../data/services/pdf/pdf_output_service.dart';
import '../../data/services/pdf/pdf_split_service.dart';
import '../../data/services/permission_service.dart';
import '../../data/services/scanner_service.dart';

export '../../core/router/app_router.dart' show routerProvider;

/// Database instance provider.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase.instance;
});

/// File repository provider.
final fileRepositoryProvider = Provider<FileRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return FileRepository(database: db);
});

/// Permission service provider.
final permissionServiceProvider = Provider<PermissionService>((ref) {
  return PermissionService();
});

/// AsyncNotifier tracking global storage / all-files access permission.
/// Serves as the single source of truth for both scanner and directories.
class AllFilesAccessNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async {
    final service = ref.watch(permissionServiceProvider);
    return service.hasAllFilesAccess();
  }

  /// Re-checks permission status from the system.
  Future<bool> refreshAccess() async {
    final service = ref.read(permissionServiceProvider);
    final hasAccess = await service.hasAllFilesAccess();
    state = AsyncData(hasAccess);
    return hasAccess;
  }

  /// Prompts the user to grant all-files access (or opens settings on API 30+).
  Future<bool> requestAccess() async {
    final service = ref.read(permissionServiceProvider);
    final granted = await service.requestAllFilesAccess();
    state = AsyncData(granted);
    return granted;
  }
}

/// Provider exposing reactive all files access permission status.
final allFilesAccessProvider =
    AsyncNotifierProvider<AllFilesAccessNotifier, bool>(
  AllFilesAccessNotifier.new,
);

/// Scanner service provider.
final scannerServiceProvider = Provider<ScannerService>((ref) {
  final repository = ref.watch(fileRepositoryProvider);
  final service = ScannerService(repository: repository);
  ref.onDispose(service.dispose);
  return service;
});

/// Import service provider.
final importServiceProvider = Provider<ImportService>((ref) {
  final repository = ref.watch(fileRepositoryProvider);
  return ImportService(repository: repository);
});

/// Open With service provider for external document opening.
final openWithServiceProvider = Provider<OpenWithService>((ref) {
  final service = OpenWithService();
  ref.onDispose(service.dispose);
  return service;
});

/// PDF output service provider.
final pdfOutputServiceProvider = Provider<PdfOutputService>((ref) {
  final repository = ref.watch(fileRepositoryProvider);
  final actionsController = ref.watch(fileActionsControllerProvider);
  return PdfOutputService(
    repository: repository,
    actionsController: actionsController,
  );
});

/// Image to PDF service provider.
final imageToPdfServiceProvider = Provider<ImageToPdfService>((ref) {
  final outputService = ref.watch(pdfOutputServiceProvider);
  return ImageToPdfService(outputService: outputService);
});

/// PDF merge service provider.
final pdfMergeServiceProvider = Provider<PdfMergeService>((ref) {
  final outputService = ref.watch(pdfOutputServiceProvider);
  return PdfMergeService(outputService: outputService);
});

/// PDF split service provider.
final pdfSplitServiceProvider = Provider<PdfSplitService>((ref) {
  final outputService = ref.watch(pdfOutputServiceProvider);
  return PdfSplitService(outputService: outputService);
});

/// Key for persisting last completed scan timestamp in SharedPreferences.
const String keyLastScanTime = 'last_completed_scan_timestamp';

/// Provider exposing the last scan completed timestamp.
final lastScanTimeProvider = FutureProvider<DateTime?>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  final timestamp = prefs.getInt(keyLastScanTime);
  if (timestamp == null) return null;
  return DateTime.fromMillisecondsSinceEpoch(timestamp);
});

/// Settings repository provider.
final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository();
});

/// Notifier managing application settings state and persistence.
class SettingsNotifier extends Notifier<AppSettings> {
  @override
  AppSettings build() {
    _loadSettings();
    return const AppSettings();
  }

  Future<void> _loadSettings() async {
    final repository = ref.read(settingsRepositoryProvider);
    state = await repository.loadSettings();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = state.copyWith(themeMode: mode);
    final repository = ref.read(settingsRepositoryProvider);
    await repository.saveThemeMode(mode);
  }

  Future<void> setAutoScanMode(AutoScanMode mode) async {
    state = state.copyWith(autoScanMode: mode);
    final repository = ref.read(settingsRepositoryProvider);
    await repository.saveAutoScanMode(mode);
  }

  Future<void> setIncludeImages(bool include) async {
    state = state.copyWith(includeImages: include);
    final repository = ref.read(settingsRepositoryProvider);
    await repository.saveIncludeImages(include);
  }
}

/// Provider exposing application preferences.
final settingsProvider = NotifierProvider<SettingsNotifier, AppSettings>(
  SettingsNotifier.new,
);

/// Notifier tracking background scan state, progress counts, and completion.
class ScanStateNotifier extends Notifier<ScanProgress> {
  StreamSubscription<ScanProgress>? _subscription;

  @override
  ScanProgress build() {
    final scanner = ref.watch(scannerServiceProvider);
    _subscription?.cancel();
    _subscription = scanner.progressStream.listen((progress) {
      state = progress;
      if (progress.isDone) {
        SharedPreferences.getInstance().then((prefs) {
          prefs.setInt(keyLastScanTime, DateTime.now().millisecondsSinceEpoch);
        }).catchError((_) {});

        // Automatically refresh category counts and active file queries upon completion
        ref.invalidate(categoryCountsProvider);
        ref.invalidate(filesProvider);
        ref.invalidate(lastScanTimeProvider);
      }
    });
    ref.onDispose(() {
      _subscription?.cancel();
    });
    return ScanProgress.idle;
  }

  /// Triggers a background scan.
  Future<void> startScan({String? rootPath, bool? includeImages}) async {
    final scanner = ref.read(scannerServiceProvider);
    final shouldIncludeImages =
        includeImages ?? ref.read(settingsProvider).includeImages;
    if (rootPath != null) {
      await scanner.startScan(
        rootPath: rootPath,
        includeImages: shouldIncludeImages,
      );
    } else {
      await scanner.startScan(includeImages: shouldIncludeImages);
    }
  }

  /// Refreshes files according to platform capability and returns the file count.
  /// On iOS, scans app documents and returns count.
  /// On Android, initiates scan and awaits completion, returning files found.
  /// Returns -1 if permission is required on Android.
  Future<int> refreshScan() async {
    final permissionService = ref.read(permissionServiceProvider);
    if (permissionService.isIOS) {
      final count = await ref.read(importServiceProvider).scanAppDocuments();
      ref.invalidate(categoryCountsProvider);
      ref.invalidate(filesProvider);
      return count;
    }

    if (permissionService.isAndroid) {
      final hasAccess =
          await ref.read(allFilesAccessProvider.notifier).refreshAccess();
      if (!hasAccess) {
        return -1;
      }

      final scanner = ref.read(scannerServiceProvider);
      if (state.isScanning) {
        return state.filesFound;
      }

      final completer = Completer<int>();
      late StreamSubscription<ScanProgress> sub;
      sub = scanner.progressStream.listen((progress) {
        if (progress.isDone) {
          sub.cancel();
          if (!completer.isCompleted) {
            completer.complete(progress.filesFound);
          }
        }
      });

      final shouldIncludeImages = ref.read(settingsProvider).includeImages;
      await scanner.startScan(includeImages: shouldIncludeImages);
      return completer.future;
    }

    return 0;
  }
}

/// Provider for active filesystem scan state.
final scanStateProvider = NotifierProvider<ScanStateNotifier, ScanProgress>(
  ScanStateNotifier.new,
);

/// Centralized pull-to-refresh execution showing feedback SnackBar or permission prompt.
Future<void> handlePullToRefreshScan(BuildContext context, WidgetRef ref) async {
  final count = await ref.read(scanStateProvider.notifier).refreshScan();
  if (count == -1) {
    final granted =
        await ref.read(allFilesAccessProvider.notifier).requestAccess();
    if (granted) {
      final newCount =
          await ref.read(scanStateProvider.notifier).refreshScan();
      if (context.mounted && newCount >= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Scan complete: $newCount files')),
        );
      }
    }
  } else if (context.mounted && count >= 0) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Scan complete: $count files')),
    );
  }
}

/// Provider fetching file counts grouped by category.
final categoryCountsProvider =
    FutureProvider<Map<FileCategory, int>>((ref) async {
  final repository = ref.watch(fileRepositoryProvider);
  return repository.countsByCategory();
});

/// Notifier managing persisted sort option. Default is date descending.
class SortOptionNotifier extends Notifier<SortOption> {
  static const _keyField = 'sort_field';
  static const _keyDirection = 'sort_direction';

  @override
  SortOption build() {
    _loadPersistedOption();
    return SortOption.defaultOption;
  }

  Future<void> _loadPersistedOption() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final fieldName = prefs.getString(_keyField);
      final dirName = prefs.getString(_keyDirection);
      if (fieldName != null && dirName != null) {
        final field = SortField.values
                .where((e) => e.name == fieldName)
                .firstOrNull ??
            SortField.date;
        final dir = SortDirection.values
                .where((e) => e.name == dirName)
                .firstOrNull ??
            SortDirection.desc;
        state = SortOption(field: field, direction: dir);
      }
    } catch (_) {}
  }

  Future<void> setSortOption(SortOption option) async {
    state = option;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyField, option.field.name);
      await prefs.setString(_keyDirection, option.direction.name);
    } catch (_) {}
  }
}

/// Provider for user-selected [SortOption].
final sortOptionProvider =
    NotifierProvider<SortOptionNotifier, SortOption>(SortOptionNotifier.new);

/// Family provider loading all files for a specific [FileCategory] (or all if null), sorted by [sortOptionProvider].
final filesProvider =
    FutureProvider.family<List<DocFile>, FileCategory?>((ref, category) async {
  final repository = ref.watch(fileRepositoryProvider);
  final sortOption = ref.watch(sortOptionProvider);
  return repository.getFiles(
    category: category,
    sortOption: sortOption,
    limit: null,
  );
});

/// Provider fetching all bookmarked files.
final bookmarksProvider = FutureProvider<List<DocFile>>((ref) async {
  final repository = ref.watch(fileRepositoryProvider);
  return repository.getBookmarks();
});

/// Provider fetching recently opened files (up to 30).
final recentsProvider = FutureProvider<List<DocFile>>((ref) async {
  final repository = ref.watch(fileRepositoryProvider);
  return repository.getRecents(limit: 30);
});

/// Provider fetching documents created by Doc View tools.
final createdFilesProvider = FutureProvider<List<DocFile>>((ref) async {
  final repository = ref.watch(fileRepositoryProvider);
  return repository.getCreatedFiles(limit: 50);
});

/// Notifier managing the current text search query.
class SearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String query) => state = query;
  void clear() => state = '';
}

/// Provider for current search text query.
final searchQueryProvider =
    NotifierProvider<SearchQueryNotifier, String>(SearchQueryNotifier.new);

/// Notifier managing the optional category filter for search.
class SearchCategoryNotifier extends Notifier<FileCategory?> {
  @override
  FileCategory? build() => null;

  void setCategory(FileCategory? category) => state = category;
}

/// Provider for search category filter.
final searchCategoryProvider =
    NotifierProvider<SearchCategoryNotifier, FileCategory?>(
  SearchCategoryNotifier.new,
);

/// Provider searching files matching [searchQueryProvider] and [searchCategoryProvider] with a 300ms debounce.
final searchResultsProvider = FutureProvider<List<DocFile>>((ref) async {
  final query = ref.watch(searchQueryProvider).trim();
  final category = ref.watch(searchCategoryProvider);

  if (query.isEmpty) {
    return const [];
  }

  var didDispose = false;
  ref.onDispose(() => didDispose = true);
  await Future.delayed(const Duration(milliseconds: 300));
  if (didDispose) return const [];

  final repository = ref.watch(fileRepositoryProvider);
  return repository.searchFiles(query, category: category);
});

/// File operations service provider.
final fileOperationsServiceProvider = Provider<FileOperationsService>((ref) {
  final repository = ref.watch(fileRepositoryProvider);
  return FileOperationsService(repository: repository);
});

/// Centralized controller executing file actions and invalidating all dependent providers.
class FileActionsController {
  FileActionsController(this._ref);

  final Ref _ref;

  /// Toggles the bookmark status of [file] and refreshes all relevant providers.
  Future<void> toggleBookmark(DocFile file) async {
    if (file.id == null) return;
    final repository = _ref.read(fileRepositoryProvider);
    await repository.toggleBookmark(file.id!);
    invalidateAll();
  }

  /// Marks [file] as opened and refreshes all relevant providers.
  Future<void> markOpened(DocFile file) async {
    if (file.id == null) return;
    final repository = _ref.read(fileRepositoryProvider);
    await repository.markOpened(file.id!);
    invalidateAll();
  }

  /// Deletes [file] from the database and refreshes all relevant providers.
  Future<void> deleteFile(int id) async {
    final repository = _ref.read(fileRepositoryProvider);
    await repository.deleteFile(id);
    invalidateAll();
  }

  /// Renames [file] with [newBaseName], updates disk and database, and invalidates providers.
  Future<RenameResult> renameFile(DocFile file, String newBaseName) async {
    final service = _ref.read(fileOperationsServiceProvider);
    final result = await service.rename(file, newBaseName);
    if (result is RenameSuccess) {
      invalidateAll();
    }
    return result;
  }

  /// Deletes multiple [files] from disk and database, and invalidates providers if any were deleted.
  Future<DeleteResult> deleteFiles(List<DocFile> files) async {
    final service = _ref.read(fileOperationsServiceProvider);
    final result = await service.delete(files);
    if (result.hasDeletions) {
      invalidateAll();
    }
    return result;
  }

  /// Shares one or multiple [files] via the system share sheet.
  Future<void> shareFiles(List<DocFile> files) async {
    final service = _ref.read(fileOperationsServiceProvider);
    await service.share(files);
  }

  /// Clears recent history by resetting last_opened to NULL for all records.
  Future<int> clearRecentHistory() async {
    final repository = _ref.read(fileRepositoryProvider);
    final count = await repository.clearRecentHistory();
    _ref.invalidate(recentsProvider);
    return count;
  }

  /// Invalidates all document-related providers across the app.
  void invalidateAll() {
    _ref.invalidate(bookmarksProvider);
    _ref.invalidate(recentsProvider);
    _ref.invalidate(createdFilesProvider);
    _ref.invalidate(filesProvider);
    _ref.invalidate(categoryCountsProvider);
    _ref.invalidate(searchResultsProvider);
  }
}

/// Provider exposing [FileActionsController].
final fileActionsControllerProvider = Provider<FileActionsController>((ref) {
  return FileActionsController(ref);
});

/// Notifier managing persisted recent search queries.
class RecentSearchesNotifier extends AsyncNotifier<List<String>> {
  @override
  Future<List<String>> build() async {
    final repository = ref.read(settingsRepositoryProvider);
    return repository.loadRecentSearches();
  }

  Future<void> addSearch(String query) async {
    final repository = ref.read(settingsRepositoryProvider);
    final updated = await repository.addRecentSearch(query);
    state = AsyncData(updated);
  }

  Future<void> clearAll() async {
    final repository = ref.read(settingsRepositoryProvider);
    await repository.clearRecentSearches();
    state = const AsyncData([]);
  }
}

/// Provider exposing reactive recent search queries list.
final recentSearchesProvider =
    AsyncNotifierProvider<RecentSearchesNotifier, List<String>>(
  RecentSearchesNotifier.new,
);


