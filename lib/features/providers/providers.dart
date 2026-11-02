import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/file_types.dart';
import '../../data/db/app_database.dart';
import '../../data/models/doc_file.dart';
import '../../data/models/sort_option.dart';
import '../../data/repositories/file_repository.dart';
import '../../data/services/import_service.dart';
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

/// Centralized controller executing file actions and invalidating all dependent providers.
class FileActionsController {
  FileActionsController(this._ref);

  final Ref _ref;

  /// Toggles the bookmark status of [file] and refreshes all relevant providers.
  Future<void> toggleBookmark(DocFile file) async {
    if (file.id == null) return;
    final repository = _ref.read(fileRepositoryProvider);
    await repository.toggleBookmark(file.id!);
    _invalidateAll();
  }

  /// Marks [file] as opened and refreshes all relevant providers.
  Future<void> markOpened(DocFile file) async {
    if (file.id == null) return;
    final repository = _ref.read(fileRepositoryProvider);
    await repository.markOpened(file.id!);
    _invalidateAll();
  }

  void _invalidateAll() {
    _ref.invalidate(bookmarksProvider);
    _ref.invalidate(recentsProvider);
    _ref.invalidate(filesProvider);
    _ref.invalidate(categoryCountsProvider);
  }
}

/// Provider exposing [FileActionsController].
final fileActionsControllerProvider = Provider<FileActionsController>((ref) {
  return FileActionsController(ref);
});

