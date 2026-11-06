import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_settings.dart';

/// Repository responsible for persisting and loading application preferences.
class SettingsRepository {
  SettingsRepository({this.preferences});

  SharedPreferences? preferences;

  static const String keyThemeMode = 'app_settings_theme_mode';
  static const String keyAutoScanMode = 'app_settings_auto_scan_mode';
  static const String keyIncludeImages = 'app_settings_include_images';

  Future<SharedPreferences> _getPrefs() async {
    preferences ??= await SharedPreferences.getInstance();
    return preferences!;
  }

  /// Loads settings from SharedPreferences, falling back to defaults on missing or corrupted values.
  Future<AppSettings> loadSettings() async {
    final prefs = await _getPrefs();
    final themeStr = prefs.getString(keyThemeMode);
    final scanStr = prefs.getString(keyAutoScanMode);
    final includeImages = prefs.getBool(keyIncludeImages) ?? true;

    return AppSettings(
      themeMode: themeModeFromString(themeStr),
      autoScanMode: AutoScanMode.fromString(scanStr),
      includeImages: includeImages,
    );
  }

  /// Persists selected [ThemeMode].
  Future<void> saveThemeMode(ThemeMode themeMode) async {
    final prefs = await _getPrefs();
    await prefs.setString(keyThemeMode, themeMode.name);
  }

  /// Persists selected [AutoScanMode].
  Future<void> saveAutoScanMode(AutoScanMode mode) async {
    final prefs = await _getPrefs();
    await prefs.setString(keyAutoScanMode, mode.name);
  }

  /// Persists image inclusion toggle.
  Future<void> saveIncludeImages(bool includeImages) async {
    final prefs = await _getPrefs();
    await prefs.setBool(keyIncludeImages, includeImages);
  }
}

