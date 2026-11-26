import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Platform channel service listening to external "Open with" document requests.
class OpenWithService {
  static const MethodChannel _channel =
      MethodChannel('com.craftlineinteractive.docview/open_with');

  final StreamController<String> _fileController =
      StreamController<String>.broadcast();

  bool _initialized = false;
  String? _cachedInitialFile;
  bool _checkedInitial = false;

  /// Stream of incoming file paths received during runtime (warm start).
  Stream<String> get incomingFiles => _fileController.stream;

  /// Initializes the method call handler for incoming files.
  void initialize() {
    if (_initialized) return;
    _initialized = true;

    _channel.setMethodCallHandler((call) async {
      if (call.method == 'onFileReceived' && call.arguments is String) {
        final path = call.arguments as String;
        if (path.isNotEmpty) {
          _fileController.add(path);
        }
      }
    });
  }

  /// Retrieves initial file path that launched the app (cold start), if any.
  Future<String?> getInitialFile() async {
    if (_checkedInitial) return _cachedInitialFile;
    try {
      final path = await _channel.invokeMethod<String>('getInitialFile');
      _checkedInitial = true;
      _cachedInitialFile = (path != null && path.isNotEmpty) ? path : null;
      return _cachedInitialFile;
    } catch (_) {
      _checkedInitial = true;
      return null;
    }
  }

  /// Consumes the initial file so it won't be reopened repeatedly.
  void consumeInitialFile() {
    _cachedInitialFile = null;
  }

  /// Injects an initial file path for testing purposes.
  @visibleForTesting
  void setInitialFileForTesting(String? path) {
    _checkedInitial = true;
    _cachedInitialFile = path;
  }

  void dispose() {
    _fileController.close();
  }
}

