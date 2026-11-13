import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

/// Service managing storage and document access permissions across Android and iOS.
class PermissionService {
  PermissionService({
    DeviceInfoPlugin? deviceInfo,
    bool? isAndroidOverride,
    bool? isIOSOverride,
  })  : _deviceInfo = deviceInfo ?? DeviceInfoPlugin(),
        _isAndroid = isAndroidOverride,
        _isIOS = isIOSOverride;

  final DeviceInfoPlugin _deviceInfo;
  final bool? _isAndroid;
  final bool? _isIOS;

  bool get isAndroid => _isAndroid ?? Platform.isAndroid;
  bool get isIOS => _isIOS ?? Platform.isIOS;

  int? _androidSdkInt;

  /// Returns the Android SDK version, caching it after first fetch.
  Future<int> getAndroidSdkInt() => _getAndroidSdkInt();

  Future<int> _getAndroidSdkInt() async {
    if (_androidSdkInt != null) return _androidSdkInt!;
    try {
      final info = await _deviceInfo.androidInfo;
      _androidSdkInt = info.version.sdkInt;
      return _androidSdkInt!;
    } catch (_) {
      // Default to recent Android API level if lookup fails
      return 33;
    }
  }

  /// Checks if the application has access to scan all external files.
  /// - iOS: always returns `false` (scanning external storage is unsupported on iOS).
  /// - Android >= API 30: checks `Permission.manageExternalStorage.isGranted`.
  /// - Android < API 30: checks `Permission.storage.isGranted`.
  Future<bool> hasAllFilesAccess() async {
    if (isIOS) {
      return false;
    }

    if (!isAndroid) {
      return false;
    }

    try {
      final sdkInt = await _getAndroidSdkInt();
      if (sdkInt >= 30) {
        return await Permission.manageExternalStorage.isGranted;
      } else {
        return await Permission.storage.isGranted;
      }
    } catch (_) {
      return false;
    }
  }

  /// Requests storage permissions required to scan external files.
  /// Handles system settings redirection for `manageExternalStorage` gracefully.
  Future<bool> requestAllFilesAccess() async {
    if (isIOS || !isAndroid) {
      return false;
    }

    try {
      final sdkInt = await _getAndroidSdkInt();
      if (sdkInt >= 30) {
        var status = await Permission.manageExternalStorage.request();
        if (status.isGranted) {
          return true;
        }

        // On Android 11+ (API 30+), if not granted, prompt opening app settings
        if (status.isPermanentlyDenied || status.isDenied) {
          await openAppSettings();
        }

        return await Permission.manageExternalStorage.isGranted;
      } else {
        final status = await Permission.storage.request();
        if (status.isPermanentlyDenied) {
          await openAppSettings();
        }
        return status.isGranted;
      }
    } catch (_) {
      return false;
    }
  }

  /// Opens app settings for Doc View.
  Future<bool> openAppSettingsScreen() => openAppSettings();
}

