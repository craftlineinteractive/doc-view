import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/constants/app_constants.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'data/models/app_settings.dart';
import 'features/files/open_document.dart';
import 'features/providers/providers.dart';

/// Root application widget configuring themes, routing, and lifecycle-driven startup scanning.
class DocReaderApp extends ConsumerStatefulWidget {
  const DocReaderApp({super.key});

  @override
  ConsumerState<DocReaderApp> createState() => _DocReaderAppState();
}

class _DocReaderAppState extends ConsumerState<DocReaderApp>
    with WidgetsBindingObserver {
  bool _dialogShowing = false;
  StreamSubscription<String>? _openWithSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _runStartupLogic();
      _initOpenWithListener();
    });
  }

  @override
  void dispose() {
    _openWithSubscription?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _initOpenWithListener() {
    final openWithService = ref.read(openWithServiceProvider);
    openWithService.initialize();

    // Cold start check
    openWithService.getInitialFile().then((initialPath) {
      if (initialPath != null && mounted) {
        _handleOpenedFile(initialPath);
      }
    });

    // Warm start stream listener
    _openWithSubscription = openWithService.incomingFiles.listen((path) {
      if (mounted) {
        _handleOpenedFile(path);
      }
    });
  }

  Future<void> _handleOpenedFile(String filePath) async {
    final context = rootNavigatorKey.currentContext;
    try {
      final docFile =
          await ref.read(importServiceProvider).importFromPath(filePath);
      ref.invalidate(categoryCountsProvider);
      ref.invalidate(filesProvider);

      if (context != null && context.mounted) {
        openDocument(context, ref, docFile);
      }
    } catch (e) {
      if (context != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open document: $e')),
        );
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkAndStartScanOnResume();
    }
  }

  /// Initial launch orchestration according to platform capabilities.
  Future<void> _runStartupLogic() async {
    final permissionService = ref.read(permissionServiceProvider);

    if (permissionService.isIOS) {
      // iOS: scan Documents folder without requesting system storage permissions
      await ref.read(importServiceProvider).scanAppDocuments();
      ref.invalidate(categoryCountsProvider);
      return;
    }

    if (permissionService.isAndroid) {
      final hasAccess =
          await ref.read(allFilesAccessProvider.notifier).refreshAccess();
      if (hasAccess) {
        final settings = ref.read(settingsProvider);
        if (settings.autoScanMode != AutoScanMode.manualOnly) {
          ref.read(scanStateProvider.notifier).startScan();
        }
      } else {
        _showStoragePermissionDialog();
      }
    }
  }

  static const Duration _rescanInterval = Duration(minutes: 5);

  /// Re-checks permissions when user returns to the app and triggers periodic background rescan.
  Future<void> _checkAndStartScanOnResume() async {
    final permissionService = ref.read(permissionServiceProvider);

    if (permissionService.isIOS) {
      await ref.read(importServiceProvider).scanAppDocuments();
      ref.invalidate(categoryCountsProvider);
      ref.invalidate(filesProvider);
      return;
    }

    if (!permissionService.isAndroid) return;

    final hasAccess =
        await ref.read(allFilesAccessProvider.notifier).refreshAccess();
    if (hasAccess) {
      final settings = ref.read(settingsProvider);
      if (settings.autoScanMode == AutoScanMode.manualOnly) return;

      final scanState = ref.read(scanStateProvider);
      if (!scanState.isScanning) {
        final prefs = await SharedPreferences.getInstance();
        final lastScanMs = prefs.getInt(keyLastScanTime) ?? 0;
        final lastScan = DateTime.fromMillisecondsSinceEpoch(lastScanMs);
        if (DateTime.now().difference(lastScan) > _rescanInterval) {
          ref.read(scanStateProvider.notifier).startScan();
        }
      }
    }
  }

  /// Displays explanation dialog for All Files Access on Android.
  void _showStoragePermissionDialog() {
    if (_dialogShowing) return;

    final navigatorContext = rootNavigatorKey.currentContext;
    if (navigatorContext == null) return;

    _dialogShowing = true;

    showDialog<void>(
      context: navigatorContext,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          icon: const Icon(
            Icons.folder_shared_rounded,
            size: 36,
            color: Color(0xFF1A73E8),
          ),
          title: const Text('Storage Access Required'),
          content: const Text(
            'Doc View needs storage access to scan and display documents '
            '(PDF, Word, Excel, PPT, TXT, Images) stored on your device.\n\n'
            'Your files remain completely private and offline on your device.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                _dialogShowing = false;
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Not now'),
            ),
            ElevatedButton(
              onPressed: () async {
                _dialogShowing = false;
                Navigator.of(dialogContext).pop();

                final granted =
                    await ref.read(allFilesAccessProvider.notifier).requestAccess();
                if (granted) {
                  ref.read(scanStateProvider.notifier).startScan();
                }
              },
              child: const Text('Allow'),
            ),
          ],
        );
      },
    ).then((_) {
      _dialogShowing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    final settings = ref.watch(settingsProvider);

    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: settings.themeMode,
      routerConfig: router,
    );
  }
}
