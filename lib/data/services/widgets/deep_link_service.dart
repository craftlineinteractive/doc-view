import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:home_widget/home_widget.dart';

import '../../repositories/file_repository.dart';
import '../../../features/providers/providers.dart';

class DeepLinkService {
  DeepLinkService({
    this.widgetRef,
    this.ref,
    required this.router,
  });

  final WidgetRef? widgetRef;
  final Ref? ref;
  final GoRouter router;
  StreamSubscription<Uri?>? _sub;

  FileRepository get _repo {
    if (widgetRef != null) return widgetRef!.read(fileRepositoryProvider);
    if (ref != null) return ref!.read(fileRepositoryProvider);
    throw StateError('Neither widgetRef nor ref is available');
  }

  FileActionsController get _actionsController {
    if (widgetRef != null) return widgetRef!.read(fileActionsControllerProvider);
    if (ref != null) return ref!.read(fileActionsControllerProvider);
    throw StateError('Neither widgetRef nor ref is available');
  }

  /// Initializes listening to widget click events and checks cold start intent.
  void init() {
    _sub = HomeWidget.widgetClicked.listen((uri) {
      if (uri != null) {
        handleUri(uri);
      }
    });

    HomeWidget.initiallyLaunchedFromHomeWidget().then((uri) {
      if (uri != null) {
        handleUri(uri);
      }
    });
  }

  void dispose() {
    _sub?.cancel();
  }

  /// Handles a deep link URI (e.g. "docview://open?id=123" or "docview://tools/scan").
  Future<void> handleUri(Uri uri) async {
    if (uri.scheme != 'docview') return;

    final host = uri.host;
    final path = uri.path;

    if (host == 'home' || (host.isEmpty && (path == '/' || path == '/home'))) {
      router.go('/home');
      return;
    }

    if (host == 'gallery' || path == '/gallery') {
      router.push('/debug/gallery');
      return;
    }

    if (host == 'settings-widgets' || path == '/settings-widgets') {
      router.push('/settings-widgets');
      return;
    }

    if (host == 'search' || (host.isEmpty && path == '/search')) {
      router.push('/search');
      return;
    }

    if (host == 'tools' || path.startsWith('/tools')) {
      final tool = path.isNotEmpty && path != '/'
          ? path.replaceFirst('/', '')
          : (uri.pathSegments.isNotEmpty ? uri.pathSegments.last : '');
      if (tool.contains('scan')) {
        router.push('/tools/scan');
      } else if (tool.contains('image-to-pdf')) {
        router.push('/tools/image-to-pdf');
      } else if (tool.contains('import')) {
        router.push('/tools/import');
      } else {
        router.go('/tools');
      }
      return;
    }

    if (host == 'open' || path == '/open') {
      final fileId = uri.queryParameters['id'];
      await openFileById(fileId);
      return;
    }
  }

  /// Validates file ID and opens the document, or safely falls back to /home.
  Future<void> openFileById(String? fileId) async {
    if (fileId == null || fileId.isEmpty) {
      router.go('/home');
      return;
    }

    // Security validation: only alphanumeric, hyphen, underscore
    final idRegex = RegExp(r'^[a-zA-Z0-9_\-]+$');
    if (!idRegex.hasMatch(fileId)) {
      router.go('/home');
      return;
    }

    final id = int.tryParse(fileId);
    if (id == null) {
      router.go('/home');
      return;
    }

    try {
      final file = await _repo.getFileById(id);
      if (file != null) {
        _actionsController.markOpened(file);
        router.push('/viewer', extra: file);
        return;
      }
    } catch (_) {}

    router.go('/home');
  }
}
