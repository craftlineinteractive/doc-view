import 'dart:async';
import 'package:flutter/services.dart';

/// Platform channel service listening to external "Open with" document requests.
class OpenWithService {
  static const MethodChannel _channel =
      MethodChannel('com.craftlineinteractive.docview/open_with');

  final StreamController<String> _fileController =
      StreamController<String>.broadcast();

  bool _initialized = false;

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
    try {
      final path = await _channel.invokeMethod<String>('getInitialFile');
      return (path != null && path.isNotEmpty) ? path : null;
    } catch (_) {
      return null;
    }
  }

  void dispose() {
    _fileController.close();
  }
}

