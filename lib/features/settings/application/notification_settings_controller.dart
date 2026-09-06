import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/theme_controller.dart';
import '../domain/notification_reminder_settings.dart';
import 'notification_permission_client.dart';
import 'study_reminder_scheduler.dart';
import 'study_reminder_service.dart';

final studyReminderSchedulerProvider = Provider<StudyReminderScheduler>((ref) {
  return FlutterStudyReminderScheduler();
});

final notificationPermissionClientProvider =
    Provider<NotificationPermissionClient>((ref) {
  return FlutterNotificationPermissionClient();
});

final studyReminderServiceProvider = Provider<StudyReminderService>((ref) {
  return StudyReminderService(
    ref.watch(sharedPreferencesProvider),
    ref.watch(studyReminderSchedulerProvider),
    ref.watch(notificationPermissionClientProvider),
  );
});

class NotificationSettingsController
    extends Notifier<NotificationReminderSettings> {
  bool _busy = false;
  bool _awaitingPermission = false;
  bool _syncWhenIdle = false;

  bool get isAwaitingPermission => _awaitingPermission;

  @override
  NotificationReminderSettings build() {
    return ref.read(studyReminderServiceProvider).load();
  }

  Future<bool> setEnabled(bool enabled) async {
    if (_busy) return state.enabled;
    _busy = true;
    try {
      if (!enabled) {
        _awaitingPermission = false;
        state = await ref.read(studyReminderServiceProvider).setEnabled(false);
        return false;
      }

      _awaitingPermission = true;
      final service = ref.read(studyReminderServiceProvider);
      final next = await service.setEnabled(true);
      if (!ref.mounted) return next.enabled;

      if (next.enabled) {
        _awaitingPermission = false;
        state = next;
        return true;
      }

      final granted = await ref.read(notificationPermissionClientProvider).isGranted();
      if (!ref.mounted) return false;
      if (granted) {
        _awaitingPermission = false;
        state = await service.applyGrantedPermission();
        return true;
      }

      state = next;
      return false;
    } finally {
      _busy = false;
      if (_syncWhenIdle) {
        _syncWhenIdle = false;
        await syncWithSystem();
      }
    }
  }

  Future<void> toggleWeekday(int weekday) {
    return _update(ref.read(studyReminderServiceProvider).updateSchedule(
          weekdays: state.toggleWeekday(weekday).weekdays,
        ));
  }

  Future<void> setTime({required int hour, required int minute}) {
    return _update(ref.read(studyReminderServiceProvider).updateSchedule(
          hour: hour,
          minute: minute,
        ));
  }

  Future<void> _update(
    Future<NotificationReminderSettings> future,
  ) async {
    if (_busy) return;
    _busy = true;
    try {
      state = await future;
    } finally {
      _busy = false;
    }
  }

  /// Tras el diálogo del sistema, Android a veces no notifica a Flutter.
  /// Devuelve true si hay que avisar de que el permiso se denegó.
  Future<bool> syncWithSystem() async {
    if (_busy) {
      _syncWhenIdle = true;
      return false;
    }

    final granted =
        await ref.read(notificationPermissionClientProvider).isGranted();
    if (!ref.mounted) return false;

    final service = ref.read(studyReminderServiceProvider);
    final stored = service.load();

    if (granted && (_awaitingPermission || stored.enabled || state.enabled)) {
      _awaitingPermission = false;
      state = await service.applyGrantedPermission();
      return false;
    }

    if (!granted && _awaitingPermission) {
      _awaitingPermission = false;
      state = await service.disableLocally();
      return true;
    }

    if (stored != state) {
      state = stored;
    }
    return false;
  }
}

final notificationSettingsProvider = NotifierProvider<
    NotificationSettingsController, NotificationReminderSettings>(
  NotificationSettingsController.new,
);
