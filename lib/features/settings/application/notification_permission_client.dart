import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

abstract class NotificationPermissionClient {
  Future<bool> isGranted();

  Future<bool> request();

  Future<void> revoke();
}

class FlutterNotificationPermissionClient implements NotificationPermissionClient {
  FlutterNotificationPermissionClient({
    FlutterLocalNotificationsPlugin? plugin,
    MethodChannel? channel,
  })  : _plugin = plugin ?? FlutterLocalNotificationsPlugin(),
        _channel = channel ??
            const MethodChannel('stickeenglishnotes/permissions');

  final FlutterLocalNotificationsPlugin _plugin;
  final MethodChannel _channel;

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

  @override
  Future<void> revoke() async {
    try {
      await _plugin.cancelAll();
    } on Object catch (error, stackTrace) {
      debugPrint('No se pudieron cancelar las notificaciones: $error\n$stackTrace');
    }

    final android = _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) {
      try {
        await android.deleteNotificationChannel(channelId: studyReminderChannelId);
      } on Object catch (error, stackTrace) {
        debugPrint('No se pudo borrar el canal de avisos: $error\n$stackTrace');
      }
    }

    try {
      await _channel.invokeMethod<bool>('revokeNotificationPermission');
    } on MissingPluginException {
      // En tests o plataformas sin canal nativo no hay permiso que revocar.
    } on Object catch (error, stackTrace) {
      debugPrint('No se pudo revocar el permiso de notificaciones: $error\n$stackTrace');
    }
  }
}

const studyReminderChannelId = 'study_reminders';
