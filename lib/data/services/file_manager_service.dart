import 'dart:io';

import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

/// Opens the platform's native file manager (DocumentsUI on Android, Files app on iOS).
/// Returns `false` if no handler is available so callers can fall back to the
/// in-app Directories screen without crashing.
class FileManagerService {
  FileManagerService({
    MethodChannel? channel,
    this.isAndroidOverride,
    this.isIOSOverride,
    this.urlLauncher,
  }) : _channel = channel ?? const MethodChannel(channelName);

  static const String channelName = 'com.craftlineinteractive.docview/file_manager';
  static const String methodOpenSystemFileManager = 'openSystemFileManager';
  static final Uri iosFilesAppUri = Uri.parse('shareddocuments://');

  final MethodChannel _channel;
  final bool? isAndroidOverride;
  final bool? isIOSOverride;
  final Future<bool> Function(Uri uri)? urlLauncher;

  bool get _isAndroid => isAndroidOverride ?? Platform.isAndroid;
  bool get _isIOS => isIOSOverride ?? Platform.isIOS;

  /// Attempts to launch the native system file manager.
  /// Returns `true` if handled externally, or `false` if unavailable.
  Future<bool> openSystemFileManager() async {
    if (_isAndroid) {
      try {
        final opened = await _channel.invokeMethod<bool>(methodOpenSystemFileManager);
        return opened ?? false;
      } on PlatformException {
        return false;
      } on MissingPluginException {
        return false;
      } catch (_) {
        return false;
      }
    }

    if (_isIOS) {
      try {
        if (urlLauncher != null) {
          return await urlLauncher!(iosFilesAppUri);
        }
        if (await canLaunchUrl(iosFilesAppUri)) {
          return await launchUrl(
            iosFilesAppUri,
            mode: LaunchMode.externalApplication,
          );
        }
        return false;
      } catch (_) {
        return false;
      }
    }

    return false;
  }
}
