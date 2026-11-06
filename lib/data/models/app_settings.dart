import 'package:flutter/material.dart';

/// Supported background auto-scan triggers.
enum AutoScanMode {
  onOpen('On app launch & resume', 'Scan storage automatically on open if > 5m since last scan'),
  manualOnly('Manual only', 'Never scan automatically; use pull-to-refresh or Rescan now');

  const AutoScanMode(this.label, this.description);

  final String label;
  final String description;

  /// Resilient parsing falling back to [AutoScanMode.onOpen].
  static AutoScanMode fromString(String? value) {
    if (value == null) return AutoScanMode.onOpen;
    return AutoScanMode.values.firstWhere(
      (e) => e.name == value,
      orElse: () => AutoScanMode.onOpen,
    );
  }
}

/// Helper converting string value to [ThemeMode] with default fallback.
ThemeMode themeModeFromString(String? value) {
  if (value == null) return ThemeMode.system;
  return ThemeMode.values.firstWhere(
    (e) => e.name == value,
    orElse: () => ThemeMode.system,
  );
}

/// Immutable data model holding user preferences.
class AppSettings {
  const AppSettings({
    this.themeMode = ThemeMode.system,
    this.autoScanMode = AutoScanMode.onOpen,
    this.includeImages = true,
  });

  final ThemeMode themeMode;
  final AutoScanMode autoScanMode;
  final bool includeImages;

  AppSettings copyWith({
    ThemeMode? themeMode,
    AutoScanMode? autoScanMode,
    bool? includeImages,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      autoScanMode: autoScanMode ?? this.autoScanMode,
      includeImages: includeImages ?? this.includeImages,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppSettings &&
          runtimeType == other.runtimeType &&
          themeMode == other.themeMode &&
          autoScanMode == other.autoScanMode &&
          includeImages == other.includeImages;

  @override
  int get hashCode => Object.hash(themeMode, autoScanMode, includeImages);
}

