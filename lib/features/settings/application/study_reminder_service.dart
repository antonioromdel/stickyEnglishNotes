import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/notification_reminder_settings.dart';
import 'notification_permission_client.dart';
import 'study_reminder_scheduler.dart';

const _enabledKey = 'notification_reminder_enabled';
const _weekdaysKey = 'notification_reminder_weekdays';
const _hourKey = 'notification_reminder_hour';
const _minuteKey = 'notification_reminder_minute';

class StudyReminderService {
  StudyReminderService(
    this._preferences,
    this._scheduler,
    this._permissions,
  );

  final SharedPreferences _preferences;
  final StudyReminderScheduler _scheduler;
  final NotificationPermissionClient _permissions;

  NotificationReminderSettings load() {
    final rawDays = _preferences.getString(_weekdaysKey);
    final parsedDays = rawDays
            ?.split(',')
            .map(int.tryParse)
            .whereType<int>()
            .where(NotificationReminderSettings.weekdayOrder.contains)
            .toSet() ??
        <int>{};

    return NotificationReminderSettings(
      enabled: _preferences.getBool(_enabledKey) ?? false,
      weekdays: parsedDays.isEmpty
          ? NotificationReminderSettings.defaults.weekdays
          : parsedDays,
      hour: _preferences.getInt(_hourKey) ??
          NotificationReminderSettings.defaults.hour,
      minute: _preferences.getInt(_minuteKey) ??
          NotificationReminderSettings.defaults.minute,
    );
  }

  Future<void> initialize() async {
    await _scheduler.initialize();
    await reconcile();
  }

  Future<NotificationReminderSettings> reconcile() async {
    final settings = load();
    if (!settings.enabled) {
      await _scheduler.cancelAll();
      return settings;
    }

    final granted = await _permissions.isGranted();
    if (!granted) {
      return _persistAndApply(settings.copyWith(enabled: false));
    }

    await _scheduler.schedule(settings);
    return settings;
  }

  Future<NotificationReminderSettings> setEnabled(bool enabled) async {
    final current = load();
    if (!enabled) {
      final disabled = current.copyWith(enabled: false);
      await _save(disabled);
      await _scheduler.cancelAll();
      await _permissions.revoke();
      return disabled;
    }

    final granted = await _permissions.request();
    if (!granted) {
      final disabled = current.copyWith(enabled: false);
      await _save(disabled);
      await _scheduler.cancelAll();
      return disabled;
    }

    return applyGrantedPermission();
  }

  Future<NotificationReminderSettings> applyGrantedPermission() {
    return _persistAndApply(load().copyWith(enabled: true));
  }

  Future<NotificationReminderSettings> disableLocally() async {
    final disabled = load().copyWith(enabled: false);
    await _save(disabled);
    await _scheduler.cancelAll();
    return disabled;
  }

  Future<NotificationReminderSettings> updateSchedule({
    Set<int>? weekdays,
    int? hour,
    int? minute,
  }) {
    return _persistAndApply(
      load().copyWith(weekdays: weekdays, hour: hour, minute: minute),
    );
  }

  Future<NotificationReminderSettings> _persistAndApply(
    NotificationReminderSettings settings,
  ) async {
    await _save(settings);
    try {
      if (settings.enabled) {
        await _scheduler.schedule(settings);
      } else {
        await _scheduler.cancelAll();
      }
    } on Object catch (error, stackTrace) {
      debugPrint(
        'No se pudo aplicar el recordatorio: $error\n$stackTrace',
      );
    }
    return settings;
  }

  Future<void> _save(NotificationReminderSettings settings) async {
    await _preferences.setBool(_enabledKey, settings.enabled);
    await _preferences.setString(
      _weekdaysKey,
      settings.sortedWeekdays.join(','),
    );
    await _preferences.setInt(_hourKey, settings.hour);
    await _preferences.setInt(_minuteKey, settings.minute);
  }
}
