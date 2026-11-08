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
  static const String keyOnboardingCompleted = 'app_settings_onboarding_completed';
  static const String keyRecentSearches = 'app_settings_recent_searches';

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

  /// Returns whether user has completed the onboarding flow.
  Future<bool> isOnboardingCompleted() async {
    final prefs = await _getPrefs();
    return prefs.getBool(keyOnboardingCompleted) ?? false;
  }

  /// Persists onboarding completion state.
  Future<void> setOnboardingCompleted(bool completed) async {
    final prefs = await _getPrefs();
    await prefs.setBool(keyOnboardingCompleted, completed);
  }

  /// Loads up to 10 persisted recent search queries.
  Future<List<String>> loadRecentSearches() async {
    final prefs = await _getPrefs();
    return prefs.getStringList(keyRecentSearches) ?? <String>[];
  }

  /// Adds a query to recent searches (FIFO, capped at 10 items, deduplicated).
  Future<List<String>> addRecentSearch(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return loadRecentSearches();
    final prefs = await _getPrefs();
    final current = (prefs.getStringList(keyRecentSearches) ?? <String>[]).toList();
    current.removeWhere((item) => item.toLowerCase() == trimmed.toLowerCase());
    current.insert(0, trimmed);
    if (current.length > 10) {
      current.removeRange(10, current.length);
    }
    await prefs.setStringList(keyRecentSearches, current);
    return current;
  }

  /// Clears persisted search history.
  Future<void> clearRecentSearches() async {
    final prefs = await _getPrefs();
    await prefs.remove(keyRecentSearches);
  }
}

