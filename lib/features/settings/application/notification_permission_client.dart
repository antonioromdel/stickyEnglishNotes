import 'package:flutter_local_notifications/flutter_local_notifications.dart';

abstract class NotificationPermissionClient {
  Future<bool> isGranted();

  Future<bool> request();
}

class FlutterNotificationPermissionClient implements NotificationPermissionClient {
  FlutterNotificationPermissionClient({FlutterLocalNotificationsPlugin? plugin})
      : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;

  @override
  Future<bool> isGranted() async {
    final android = _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) {
      return await android.areNotificationsEnabled() ?? false;
    }

    final ios = _plugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();
    if (ios != null) {
      final options = await ios.checkPermissions();
      return options?.isEnabled ?? false;
    }

    final macOS = _plugin
        .resolvePlatformSpecificImplementation<
            MacOSFlutterLocalNotificationsPlugin>();
    if (macOS != null) {
      final options = await macOS.checkPermissions();
      return options?.isEnabled ?? false;
    }

    return false;
  }

  @override
  Future<bool> request() async {
    final android = _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) {
      final requested = await android.requestNotificationsPermission();
      if (requested == true) return true;
      return isGranted();
    }

    final ios = _plugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();
    if (ios != null) {
      final requested = await ios.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      if (requested == true) return true;
      return isGranted();
    }

    final macOS = _plugin
        .resolvePlatformSpecificImplementation<
            MacOSFlutterLocalNotificationsPlugin>();
    if (macOS != null) {
      final requested = await macOS.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      if (requested == true) return true;
      return isGranted();
    }

    return false;
  }
}

const studyReminderChannelId = 'study_reminders';
