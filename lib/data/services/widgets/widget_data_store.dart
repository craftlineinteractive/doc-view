import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';

import '../../models/doc_file.dart';

/// Storage manager keeping Android App Widgets synchronized with recent files.
///
/// CRITICAL PRIVACY CONTRACT:
/// NEVER stores file paths in the widget store. Only stores:
/// - id (string)
/// - name (string)
/// - type (string, e.g. "PDF")
/// - modified (integer milliseconds since epoch)
class WidgetDataStore {
  static const String keyRecentFilesJson = 'recent_files_json';
  static const String recentFilesWidgetProvider = 'RecentFilesWidgetReceiver';
  static const String quickToolsWidgetProvider = 'QuickToolsWidgetReceiver';
  static const MethodChannel _widgetChannel =
      MethodChannel('com.craftlineinteractive.docview/widgets');

  WidgetDataStore({HomeWidgetStorage? storage})
      : _storage = storage ?? const DefaultHomeWidgetStorage();

  final HomeWidgetStorage _storage;

  /// Updates the recent files widget with up to 5 [files].
  /// Enforces privacy by stripping paths and keeping only id, name, type, and modified timestamp.
  Future<void> updateRecentFiles(List<DocFile> files) async {
    try {
      final items = files.take(5).map((f) {
        return <String, dynamic>{
          'id': f.id?.toString() ?? '',
          'name': f.name,
          'type': f.extension.isNotEmpty ? f.extension.toUpperCase() : 'PDF',
          'modified': f.modified.millisecondsSinceEpoch,
        };
      }).toList();

      final jsonStr = jsonEncode(items);
      await _storage.saveWidgetData<String>(keyRecentFilesJson, jsonStr);
      await _storage.updateWidget(
        name: recentFilesWidgetProvider,
        androidName: recentFilesWidgetProvider,
      );
    } catch (e) {
      debugPrint('WidgetDataStore.updateRecentFiles failed: $e');
    }
  }

  /// Removes a file matching [fileId] from the widget store if present.
  Future<void> removeFile(String fileId) async {
    try {
      final raw = await _storage.getWidgetData<String>(keyRecentFilesJson);
      if (raw == null || raw.isEmpty) return;

      final dynamic decoded = jsonDecode(raw);
      if (decoded is! List) return;

      final updated = decoded.where((item) {
        if (item is Map) {
          return item['id']?.toString() != fileId;
        }
        return true;
      }).toList();

      await _storage.saveWidgetData<String>(keyRecentFilesJson, jsonEncode(updated));
      await _storage.updateWidget(
        name: recentFilesWidgetProvider,
        androidName: recentFilesWidgetProvider,
      );
    } catch (e) {
      debugPrint('WidgetDataStore.removeFile failed: $e');
    }
  }

  /// Clears recent files from the widget store (e.g. when recent history is cleared).
  Future<void> clearRecentHistory() async {
    try {
      await _storage.saveWidgetData<String>(keyRecentFilesJson, '[]');
      await _storage.updateWidget(
        name: recentFilesWidgetProvider,
        androidName: recentFilesWidgetProvider,
      );
    } catch (e) {
      debugPrint('WidgetDataStore.clearRecentHistory failed: $e');
    }
  }

  /// Checks if pin app widget is supported by the current launcher (Android 8.0+).
  Future<bool> isPinSupported() async {
    if (!Platform.isAndroid) return false;
    try {
      final result = await _widgetChannel.invokeMethod<bool>('isPinSupported');
      return result ?? false;
    } catch (_) {
      return false;
    }
  }

  /// Requests pinning the specified widget ('recent_files' or 'quick_tools').
  Future<bool> requestPinWidget(String widgetName) async {
    if (!Platform.isAndroid) return false;
    try {
      final result = await _widgetChannel.invokeMethod<bool>(
        'requestPinWidget',
        {'widget': widgetName},
      );
      return result ?? false;
    } catch (_) {
      return false;
    }
  }
}

/// Abstract storage interface to allow unit testing without native platform channels.
abstract class HomeWidgetStorage {
  Future<bool?> saveWidgetData<T>(String id, T? data);
  Future<T?> getWidgetData<T>(String id, {T? defaultValue});
  Future<bool?> updateWidget({String? name, String? androidName, String? iOSName});
}

class DefaultHomeWidgetStorage implements HomeWidgetStorage {
  const DefaultHomeWidgetStorage();

  @override
  Future<bool?> saveWidgetData<T>(String id, T? data) =>
      HomeWidget.saveWidgetData<T>(id, data);

  @override
  Future<T?> getWidgetData<T>(String id, {T? defaultValue}) =>
      HomeWidget.getWidgetData<T>(id, defaultValue: defaultValue);

  @override
  Future<bool?> updateWidget({String? name, String? androidName, String? iOSName}) =>
      HomeWidget.updateWidget(name: name, androidName: androidName, iOSName: iOSName);
}

final widgetDataStoreProvider = Provider<WidgetDataStore>((ref) {
  return WidgetDataStore();
});
