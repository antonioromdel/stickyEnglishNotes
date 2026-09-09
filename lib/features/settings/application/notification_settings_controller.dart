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
      final service = ref.read(studyReminderServiceProvider);
      if (!enabled) {
        _awaitingPermission = false;
        state = state.copyWith(enabled: false);
        await service.setEnabled(false);
        return false;
      }

      _awaitingPermission = true;
      final permissions = ref.read(notificationPermissionClientProvider);
      final granted = await permissions.request();
      if (!ref.mounted) return false;

      if (!granted && !await permissions.isGranted()) {
        if (!ref.mounted) return false;
        return false;
      }

      _awaitingPermission = false;
      state = state.copyWith(enabled: true);
      state = await service.applyGrantedPermission();
      return true;
    } finally {
      _busy = false;
      if (_syncWhenIdle) {
        _syncWhenIdle = false;
        await syncWithSystem();
      }
    }
  }

  Future<void> toggleWeekday(int weekday) {
    final next = state.toggleWeekday(weekday);
    if (next == state) return Future.value();
    state = next;
    return ref.read(studyReminderServiceProvider).updateSchedule(
          weekdays: next.weekdays,
        );
  }

  Future<void> setTime({required int hour, required int minute}) {
    state = state.copyWith(hour: hour, minute: minute);
    return ref.read(studyReminderServiceProvider).updateSchedule(
          hour: hour,
          minute: minute,
        );
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

    if (granted && _awaitingPermission) {
      _awaitingPermission = false;
      state = state.copyWith(enabled: true);
      state = await service.applyGrantedPermission();
      return false;
    }

    if (!granted && _awaitingPermission) {
      _awaitingPermission = false;
      state = await service.disableLocally();
      return true;
    }

    return false;
  }
}

final notificationSettingsProvider = NotifierProvider<
    NotificationSettingsController, NotificationReminderSettings>(
  NotificationSettingsController.new,
);
