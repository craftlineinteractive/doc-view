import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/file_types.dart';
import '../../data/db/app_database.dart';
import '../../data/models/doc_file.dart';
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

/// Family provider loading the first 100 files for a specific [FileCategory] (or all if null).
final filesProvider =
    FutureProvider.family<List<DocFile>, FileCategory?>((ref, category) async {
  final repository = ref.watch(fileRepositoryProvider);
  return repository.getFiles(category: category, limit: 100);
});
