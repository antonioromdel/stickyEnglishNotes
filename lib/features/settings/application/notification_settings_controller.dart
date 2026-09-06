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

  @override
  NotificationReminderSettings build() {
    return ref.read(studyReminderServiceProvider).load();
  }

  Future<bool> setEnabled(bool enabled) async {
    if (_busy) return state.enabled;
    _busy = true;
    try {
      state = await ref.read(studyReminderServiceProvider).setEnabled(enabled);
      return state.enabled;
    } finally {
      _busy = false;
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
}

final notificationSettingsProvider = NotifierProvider<
    NotificationSettingsController, NotificationReminderSettings>(
  NotificationSettingsController.new,
);
