import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../domain/notification_reminder_settings.dart';
import 'notification_permission_client.dart';

abstract class StudyReminderScheduler {
  Future<void> initialize();

  Future<void> schedule(NotificationReminderSettings settings);

  Future<void> cancelAll();
}

class FlutterStudyReminderScheduler implements StudyReminderScheduler {
  FlutterStudyReminderScheduler({FlutterLocalNotificationsPlugin? plugin})
      : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;
  bool _ready = false;

  static const _channelName = 'Recordatorios de estudio';
  static const _channelDescription =
      'Avisos para estudiar un rato cada día';
  static const _title = 'Hora de estudiar';
  static const _body =
      'Tus flashcards te esperan. Un poco cada día marca la diferencia.';

  @override
  Future<void> initialize() async {
    if (_ready) return;

    tzdata.initializeTimeZones();
    await _setLocalTimezone();

    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('ic_stat_notify'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
      macOS: DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
    );

    await _plugin.initialize(settings: initializationSettings);
    _ready = true;
  }

  @override
  Future<void> schedule(NotificationReminderSettings settings) async {
    await initialize();
    await _plugin.cancelAll();
    if (!settings.enabled || settings.weekdays.isEmpty) return;

    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        studyReminderChannelId,
        _channelName,
        channelDescription: _channelDescription,
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
      macOS: DarwinNotificationDetails(),
    );

    final now = DateTime.now();
    for (final weekday in settings.sortedWeekdays) {
      final next = nextWeeklyOccurrence(
        now: now,
        weekday: weekday,
        hour: settings.hour,
        minute: settings.minute,
      );
      final scheduled = tz.TZDateTime(
        tz.local,
        next.year,
        next.month,
        next.day,
        next.hour,
        next.minute,
      );

      await _plugin.zonedSchedule(
        id: weekday,
        title: _title,
        body: _body,
        scheduledDate: scheduled,
        notificationDetails: details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      );
    }
  }

  @override
  Future<void> cancelAll() async {
    if (!_ready) {
      try {
        await initialize();
      } on Object {
        return;
      }
    }
    await _plugin.cancelAll();
  }

  Future<void> _setLocalTimezone() async {
    try {
      final info = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(info.identifier));
    } on Object catch (error, stackTrace) {
      debugPrint('No se pudo leer la zona horaria: $error\n$stackTrace');
      tz.setLocalLocation(tz.UTC);
    }
  }
}
