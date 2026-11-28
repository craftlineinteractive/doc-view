import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

/// Release-safe logger for Doc View.
///
/// Strictly guarantees that NO file names, full filesystem paths, or user PII
/// are printed to Android logcat or developer consoles.
/// Only the typed area, reason code, and exception type are emitted.
class AppLog {
  const AppLog._();

  /// Logs an error in a release-safe manner to Android logcat and developer timeline.
  ///
  /// - [area]: Module or component identifier (e.g. 'Tools', 'Viewer', 'Billing', 'Router')
  /// - [reasonName]: Typed, stable error reason identifier (e.g. 'permission_denied', 'save_failed')
  /// - [error]: Optional caught exception or error object (only runtimeType is logged)
  /// - [stack]: Optional stack trace
  static void e(
    String area,
    String reasonName, [
    Object? error,
    StackTrace? stack,
  ]) {
    final errorType = error != null ? error.runtimeType.toString() : 'None';
    final payload = '[$area] $reasonName (type: $errorType)';

    // In release mode on Android, developer.log and print emit to logcat
    developer.log(
      payload,
      name: 'DocView.$area',
      error: errorType,
      stackTrace: stack,
      level: 1000,
    );

    // Ensure it appears in standard logcat output without PII
    final argDetail = error is ArgumentError ? ': ${error.message}' : '';
    // ignore: avoid_print
    print('[DocView.$area] $reasonName (error: $errorType$argDetail)');
  }

  /// Logs an informational event in a release-safe manner.
  static void i(String area, String message) {
    developer.log(
      '[$area] $message',
      name: 'DocView.$area',
      level: 800,
    );
    if (kDebugMode) {
      debugPrint('[DocView.$area] $message');
    }
  }
}
