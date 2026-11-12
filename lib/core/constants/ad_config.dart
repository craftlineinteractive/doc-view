import 'package:flutter/foundation.dart';

/// Configuration for advertisement display and placeholders.
class AdConfig {
  AdConfig._();

  /// Whether to display placeholder ad slots.
  /// Defaults to [kDebugMode] so placeholders collapse in release builds.
  static bool showPlaceholders = kDebugMode;
}
