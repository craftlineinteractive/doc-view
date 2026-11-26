import 'dart:async';

/// Guard preventing App Open ads from triggering when returning from
/// external system activities (camera, file picker, printer, share).
class ExternalActivityGuard {
  ExternalActivityGuard._();

  static bool _isInExternalActivity = false;

  /// Returns true if an external activity is currently active or recently dismissed.
  static bool get isInExternalActivity => _isInExternalActivity;

  /// Sets the external activity flag directly.
  static void setInExternalActivity(bool value) {
    _isInExternalActivity = value;
  }

  /// Runs [action] under the guard and holds the guard for 1.5 seconds after
  /// completion so that Android lifecycle resume events do not trigger App Open ads.
  static Future<T> guard<T>(Future<T> Function() action) async {
    _isInExternalActivity = true;
    try {
      return await action();
    } finally {
      Timer(const Duration(milliseconds: 1500), () {
        _isInExternalActivity = false;
      });
    }
  }
}
