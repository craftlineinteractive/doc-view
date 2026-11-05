import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/file_types.dart';
import '../../data/db/app_database.dart';
import '../../data/models/doc_file.dart';
import '../../data/models/sort_option.dart';
import '../../data/repositories/file_repository.dart';
import '../../data/services/file_operations_service.dart';
import '../../data/services/import_service.dart';
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
        // Automatically refresh category counts and active file queries upon completion
        ref.invalidate(categoryCountsProvider);
        ref.invalidate(filesProvider);
      }
    });
    ref.onDispose(() {
      _subscription?.cancel();
    });
    return ScanProgress.idle;
  }

  /// Triggers a background scan.
  Future<void> startScan({String? rootPath}) async {
    final scanner = ref.read(scannerServiceProvider);
    if (rootPath != null) {
      await scanner.startScan(rootPath: rootPath);
    } else {
      await scanner.startScan();
    }
  }
}

/// Provider for active filesystem scan state.
final scanStateProvider = NotifierProvider<ScanStateNotifier, ScanProgress>(
  ScanStateNotifier.new,
);

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

/// Family provider loading the first 100 files for a specific [FileCategory] (or all if null), sorted by [sortOptionProvider].
final filesProvider =
    FutureProvider.family<List<DocFile>, FileCategory?>((ref, category) async {
  final repository = ref.watch(fileRepositoryProvider);
  final sortOption = ref.watch(sortOptionProvider);
  return repository.getFiles(
    category: category,
    sortOption: sortOption,
    limit: 100,
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

  /// Invalidates all document-related providers across the app.
  void invalidateAll() {
    _ref.invalidate(bookmarksProvider);
    _ref.invalidate(recentsProvider);
    _ref.invalidate(filesProvider);
    _ref.invalidate(categoryCountsProvider);
    _ref.invalidate(searchResultsProvider);
  }
}

/// Provider exposing [FileActionsController].
final fileActionsControllerProvider = Provider<FileActionsController>((ref) {
  return FileActionsController(ref);
});

