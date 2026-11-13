import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;

import '../../core/constants/file_types.dart';
import '../../core/utils/root_path_resolver.dart';
import '../../data/models/doc_file.dart';
import '../../shared/widgets/skeletons/skeleton_variants.dart';
import '../files/open_document.dart';
import '../files/widgets/file_tile.dart';
import '../providers/providers.dart';
import 'services/directory_lister.dart';

/// Screen providing hierarchical filesystem navigation with typed states,
/// resilient isolate directory listing, and integrated document actions.
class DirectoriesScreen extends ConsumerStatefulWidget {
  const DirectoriesScreen({super.key});

  @override
  ConsumerState<DirectoriesScreen> createState() => _DirectoriesScreenState();
}

class _DirectoriesScreenState extends ConsumerState<DirectoriesScreen> {
  String? _rootPath;
  String? _currentPath;
  DirectoryViewState _viewState = const DirectoryLoadingState();

  Map<String, DocFile> _indexedDocs = {};
  final ScrollController _breadcrumbScrollController = ScrollController();

  bool get _isAtRoot =>
      _currentPath == null || _rootPath == null || _currentPath == _rootPath;

  @override
  void initState() {
    super.initState();
    _initDirectory();
  }

  @override
  void dispose() {
    _breadcrumbScrollController.dispose();
    super.dispose();
  }

  /// Initializes the directory browser by verifying permissions and resolving the device root.
  Future<void> _initDirectory() async {
    setState(() {
      _viewState = const DirectoryLoadingState();
    });

    final permService = ref.read(permissionServiceProvider);
    if (permService.isAndroid) {
      final hasAccess =
          await ref.read(allFilesAccessProvider.notifier).refreshAccess();
      if (!hasAccess) {
        if (mounted) {
          setState(() {
            _viewState = const DirectoryPermissionRequiredState();
          });
        }
        return;
      }
    }

    final root = await resolveRootDirectory();
    _rootPath = root;
    _currentPath = root;

    await _loadDirectory(root);
  }

  /// Loads contents of [dirPath] using the isolate worker and updates [_viewState].
  Future<void> _loadDirectory(String dirPath) async {
    setState(() {
      _viewState = const DirectoryLoadingState();
    });

    try {
      final dir = Directory(dirPath);
      if (!dir.existsSync()) {
        if (mounted) {
          setState(() {
            _viewState = DirectoryNotFoundState(dirPath);
          });
        }
        return;
      }

      // Safe isolate listing with per-entry resilience
      final entries = await listDirectoryEntries(dirPath);

      if (entries.isEmpty) {
        if (mounted) {
          setState(() {
            _viewState = DirectoryEmptyState(dirPath);
          });
          _scrollBreadcrumbsToEnd();
        }
        return;
      }

      // Batch load indexed DocFiles for file entries
      final fileEntries = entries.where((e) => !e.isDirectory).toList();
      final repository = ref.read(fileRepositoryProvider);

      final filePaths = fileEntries.map((e) => e.path).toList();
      final existingDocs = filePaths.isNotEmpty
          ? await repository.getByPaths(filePaths)
          : <DocFile>[];

      final existingMap = {for (final d in existingDocs) d.path: d};
      final docsToUpsert = <DocFile>[];

      for (final entry in fileEntries) {
        if (!existingMap.containsKey(entry.path)) {
          final cat = FileCategory.values.firstWhere(
            (c) => c.name == entry.categoryName,
            orElse: () => FileCategory.other,
          );
          final ext = p.extension(entry.path).replaceAll('.', '').toLowerCase();
          final newDoc = DocFile(
            path: entry.path,
            name: entry.name,
            extension: ext,
            sizeBytes: entry.sizeBytes,
            modified: DateTime.fromMillisecondsSinceEpoch(entry.modifiedMs),
            category: cat,
            isImported: true,
          );
          docsToUpsert.add(newDoc);
        }
      }

      if (docsToUpsert.isNotEmpty) {
        await repository.upsertBatch(docsToUpsert);
        final freshDocs = await repository.getByPaths(filePaths);
        existingMap.addAll({for (final d in freshDocs) d.path: d});
      }

      if (mounted) {
        setState(() {
          _indexedDocs = existingMap;
          _viewState = DirectoryContentState(
            path: dirPath,
            entries: entries,
          );
        });
        _scrollBreadcrumbsToEnd();
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _viewState = mapListingExceptionToState(error, dirPath);
        });
      }
    }
  }

  void _navigateToFolder(String folderPath) {
    setState(() {
      _currentPath = folderPath;
    });
    _loadDirectory(folderPath);
  }

  bool _navigateUp() {
    if (_isAtRoot) {
      return false;
    }
    final parent = p.dirname(_currentPath!);
    if (parent.length < _rootPath!.length || !parent.startsWith(_rootPath!)) {
      _navigateToFolder(_rootPath!);
    } else {
      _navigateToFolder(parent);
    }
    return true;
  }

  void _scrollBreadcrumbsToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_breadcrumbScrollController.hasClients) {
        _breadcrumbScrollController.jumpTo(
          _breadcrumbScrollController.position.maxScrollExtent,
        );
      }
    });
  }

  List<String> _buildBreadcrumbSegments() {
    if (_currentPath == null || _rootPath == null) return [];
    if (_currentPath == _rootPath) return ['Root'];

    final relative = p.relative(_currentPath!, from: _rootPath);
    final parts = p.split(relative);
    return ['Root', ...parts];
  }

  String _pathForBreadcrumbIndex(int index, List<String> segments) {
    if (index == 0 || _rootPath == null) return _rootPath!;
    final subparts = segments.sublist(1, index + 1);
    final isPosix = !_rootPath!.contains(r'\');
    final context = isPosix ? p.posix : p.windows;
    return context.joinAll([_rootPath!, ...subparts]);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Auto-reload folder if permission was granted while screen was open or in background
    ref.listen<AsyncValue<bool>>(allFilesAccessProvider, (prev, next) {
      final granted = next.value ?? false;
      if (granted && _viewState is DirectoryPermissionRequiredState) {
        _initDirectory();
      }
    });

    return PopScope(
      canPop: _isAtRoot,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        _navigateUp();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            icon: const Icon(Icons.arrow_back),
            tooltip: _isAtRoot ? 'Back' : 'Up one level',
            onPressed: () {
              if (!_navigateUp()) {
                Navigator.of(context).pop();
              }
            },
          ),
          title: const Text('Directories'),
          centerTitle: false,
        ),
        body: _viewState is DirectoryPermissionRequiredState
            ? _buildPermissionPrompt(theme)
            : Column(
                children: [
                  _buildBreadcrumbs(theme),
                  const Divider(height: 1),
                  Expanded(
                    child: _buildContent(theme),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildBreadcrumbs(ThemeData theme) {
    final segments = _buildBreadcrumbSegments();

    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      alignment: Alignment.centerLeft,
      child: ListView.separated(
        controller: _breadcrumbScrollController,
        scrollDirection: Axis.horizontal,
        itemCount: segments.length,
        separatorBuilder: (_, _) => Icon(
          Icons.chevron_right,
          size: 18,
          color: theme.iconTheme.color?.withValues(alpha: 0.4),
        ),
        itemBuilder: (context, index) {
          final isLast = index == segments.length - 1;
          final segment = segments[index];

          return InkWell(
            borderRadius: BorderRadius.circular(6),
            onTap: isLast
                ? null
                : () {
                    final targetPath = _pathForBreadcrumbIndex(index, segments);
                    _navigateToFolder(targetPath);
                  },
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 48, minWidth: 48),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Center(
                  child: Text(
                    segment,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: isLast ? FontWeight.bold : FontWeight.w500,
                      color: isLast
                          ? theme.colorScheme.primary
                          : theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent(ThemeData theme) {
    final state = _viewState;

    if (state is DirectoryLoadingState) {
      return const SkeletonFileList(itemCount: 6);
    }

    if (state is DirectoryFolderAccessDeniedState) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.security_rounded,
                  size: 40,
                  color: Colors.amber,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'This folder is protected by Android.',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Android restricts access to system and app private folders.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: _navigateUp,
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Go back'),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (state is DirectoryNotFoundState) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.redAccent.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.folder_off_rounded,
                  size: 40,
                  color: Colors.redAccent,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'This folder no longer exists.',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (_rootPath != null) {
                      _navigateToFolder(_rootPath!);
                    }
                  },
                  icon: const Icon(Icons.home_outlined),
                  label: const Text('Go to Root'),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (state is DirectoryEmptyState) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.folder_open_rounded,
                size: 64,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
              ),
              const SizedBox(height: 16),
              Text(
                'No supported files or folders here.',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (state is DirectoryUnknownErrorState) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline_rounded,
                size: 64,
                color: Colors.redAccent,
              ),
              const SizedBox(height: 16),
              Text(
                'Error opening folder',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                state.message,
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (_currentPath != null) {
                      _loadDirectory(_currentPath!);
                    }
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (state is DirectoryContentState) {
      final entries = state.entries;

      return ListView.separated(
        itemCount: entries.length,
        separatorBuilder: (_, _) => Divider(
          height: 1,
          indent: 72,
          color: theme.dividerColor.withValues(alpha: 0.2),
        ),
        itemBuilder: (context, index) {
          final entry = entries[index];

          if (entry.isDirectory) {
            return ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              leading: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.folder_rounded,
                  color: Colors.amber,
                  size: 26,
                ),
              ),
              title: Text(
                entry.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                entry.itemCount != null
                    ? '${entry.itemCount} item${entry.itemCount == 1 ? '' : 's'}'
                    : 'Folder',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.6),
                ),
              ),
              trailing: const Icon(Icons.chevron_right, size: 20),
              onTap: () => _navigateToFolder(entry.path),
            );
          }

          final docFile = _indexedDocs[entry.path];
          if (docFile != null) {
            return FileTile(
              file: docFile,
              onTap: () async {
                final fileExists = File(docFile.path).existsSync();
                if (!fileExists) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('File no longer exists')),
                    );
                  }
                  return;
                }
                await ref.read(fileRepositoryProvider).upsert(docFile);
                if (context.mounted) {
                  openDocument(context, ref, docFile);
                }
              },
            );
          }

          // Fallback placeholder while indexing
          return ListTile(
            leading: const SizedBox(
              width: 48,
              height: 48,
              child: Icon(Icons.insert_drive_file_outlined),
            ),
            title: Text(entry.name),
          );
        },
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildPermissionPrompt(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.folder_shared_rounded,
                size: 40,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Storage Access Required',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Doc View needs All files access to browse your folders.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 48,
              child: FilledButton.icon(
                onPressed: () async {
                  final granted = await ref
                      .read(allFilesAccessProvider.notifier)
                      .requestAccess();
                  if (granted) {
                    await _initDirectory();
                  }
                },
                icon: const Icon(Icons.lock_open_rounded),
                label: const Text('Grant access'),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 48,
              child: OutlinedButton.icon(
                onPressed: () async {
                  final count =
                      await ref.read(importServiceProvider).importFiles();
                  if (count > 0 && mounted) {
                    ref.read(fileActionsControllerProvider).invalidateAll();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Imported $count file${count == 1 ? '' : 's'}',
                        ),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.file_upload_outlined),
                label: const Text('Import files instead'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
