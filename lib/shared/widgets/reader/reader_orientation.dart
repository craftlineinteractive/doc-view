import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Standard color filter matrix for inverting reader document surfaces (White <-> Black).
const List<double> kReaderInvertColorMatrix = [
  -1,  0,  0, 0, 255,
   0, -1,  0, 0, 255,
   0,  0, -1, 0, 255,
   0,  0,  0, 1,   0,
];

/// Reusable controller managing reader screen orientation locking and restoration.
///
/// Features:
/// - Toggles between portrait and landscape orientations.
/// - Restores all device orientations on dispose or when the app is backgrounded.
/// - Follows system lifecycle events via [WidgetsBindingObserver].
class ReaderOrientationController with WidgetsBindingObserver {
  bool _isDisposed = false;

  ReaderOrientationController() {
    WidgetsBinding.instance.addObserver(this);
  }

  /// Toggles orientation between portrait and landscape.
  void toggle(BuildContext context) {
    if (_isDisposed) return;
    final isPortrait = MediaQuery.orientationOf(context) == Orientation.portrait;
    if (isPortrait) {
      SystemChrome.setPreferredOrientations(const [
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      SystemChrome.setPreferredOrientations(const [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
  }

  /// Restores standard unconstrained device orientations.
  void restore() {
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
      restore();
    }
  }

  /// Cleans up lifecycle observers and restores orientations.
  void dispose() {
    if (_isDisposed) return;
    _isDisposed = true;
    WidgetsBinding.instance.removeObserver(this);
    restore();
  }
}
