import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuickAccessNotificationService {
  static const int notificationId = 1001;
  static const String channelId = 'docview_quick_access';
  static const String channelName = 'Quick Access';
  static const String channelDescription = 'Quick access tools for Doc View';
  static const String prefKeyEnabled = 'pref_quick_access_notification_enabled';

  static const String actionScan = 'action_scan';
  static const String actionImageToPdf = 'action_image_to_pdf';
  static const String actionSearch = 'action_search';

  QuickAccessNotificationService({
    FlutterLocalNotificationsPlugin? plugin,
  }) : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;
  void Function(String route)? onNavigate;

  Future<void> init({void Function(String route)? onNavigate}) async {
    this.onNavigate = onNavigate;
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);

    await _plugin.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        final actionId = response.actionId;
        if (actionId == actionScan) {
          this.onNavigate?.call('/tools/scan');
        } else if (actionId == actionImageToPdf) {
          this.onNavigate?.call('/tools/image-to-pdf');
        } else if (actionId == actionSearch) {
          this.onNavigate?.call('/search');
        } else {
          this.onNavigate?.call('/home');
        }
      },
    );

    final prefs = await SharedPreferences.getInstance();
    final isEnabled = prefs.getBool(prefKeyEnabled) ?? false;
    if (isEnabled && Platform.isAndroid) {
      await showNotification();
    }
  }

  Future<bool> isEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(prefKeyEnabled) ?? false;
  }

  Future<bool> requestPermission() async {
    if (!Platform.isAndroid) return false;
    final androidImpl = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (androidImpl == null) return false;
    final granted = await androidImpl.requestNotificationsPermission();
    return granted ?? false;
  }

  Future<void> setEnabled(
    bool enabled, {
    String title = 'Doc View Quick Tools',
    String body = 'Scan, convert, or search documents',
    String scanLabel = 'Scan',
    String imageToPdfLabel = 'Image to PDF',
    String searchLabel = 'Search',
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(prefKeyEnabled, enabled);
    if (enabled) {
      await showNotification(
        title: title,
        body: body,
        scanLabel: scanLabel,
        imageToPdfLabel: imageToPdfLabel,
        searchLabel: searchLabel,
      );
    } else {
      await cancelNotification();
    }
  }

  Future<void> showNotification({
    String title = 'Doc View Quick Tools',
    String body = 'Scan, convert, or search documents',
    String scanLabel = 'Scan',
    String imageToPdfLabel = 'Image to PDF',
    String searchLabel = 'Search',
  }) async {
    if (!Platform.isAndroid) return;

    final androidDetails = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      importance: Importance.low,
      priority: Priority.low,
      ongoing: true,
      autoCancel: false,
      showWhen: false,
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction(
          actionScan,
          scanLabel,
          showsUserInterface: true,
        ),
        AndroidNotificationAction(
          actionImageToPdf,
          imageToPdfLabel,
          showsUserInterface: true,
        ),
        AndroidNotificationAction(
          actionSearch,
          searchLabel,
          showsUserInterface: true,
        ),
      ],
    );

    final details = NotificationDetails(android: androidDetails);
    await _plugin.show(
      id: notificationId,
      title: title,
      body: body,
      notificationDetails: details,
    );
  }

  Future<void> cancelNotification() async {
    await _plugin.cancel(id: notificationId);
  }
}

final quickAccessNotificationServiceProvider =
    Provider<QuickAccessNotificationService>((ref) {
  return QuickAccessNotificationService();
});
