import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stickeenglishnotes/features/settings/application/study_reminder_service.dart';

import '../../helpers/fake_notifications.dart';

void main() {
  late SharedPreferences preferences;
  late FakeStudyReminderScheduler scheduler;
  late FakeNotificationPermissionClient permissions;
  late StudyReminderService service;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    preferences = await SharedPreferences.getInstance();
    scheduler = FakeStudyReminderScheduler();
    permissions = FakeNotificationPermissionClient();
    service = StudyReminderService(preferences, scheduler, permissions);
  });

  test('al abrir no pide permiso y apaga si el sistema lo retiró', () async {
    await service.setEnabled(true);
    permissions.granted = false;
    permissions.requestCount = 0;

    final settings = await service.reconcile();

    expect(settings.enabled, isFalse);
    expect(permissions.requestCount, 0);
    expect(scheduler.cancelCount, greaterThan(0));
  });

  test('activar pide permiso y solo programa si se acepta', () async {
    permissions.requestShouldGrant = false;

    final denied = await service.setEnabled(true);
    expect(denied.enabled, isFalse);
    expect(permissions.requestCount, 1);
    expect(scheduler.lastScheduled, isNull);

    permissions.requestShouldGrant = true;
    final accepted = await service.setEnabled(true);
    expect(accepted.enabled, isTrue);
    expect(scheduler.lastScheduled?.enabled, isTrue);
  });

  test('desactivar cancela avisos y revoca el permiso', () async {
    await service.setEnabled(true);
    expect(permissions.granted, isTrue);

    final disabled = await service.setEnabled(false);

    expect(disabled.enabled, isFalse);
    expect(permissions.granted, isFalse);
    expect(permissions.revokeCount, 1);
    expect(scheduler.lastScheduled, isNull);
  });

  test('cambiar días u hora reprograme el recordatorio', () async {
    await service.setEnabled(true);

    final updated = await service.updateSchedule(
      weekdays: {1, 3, 5},
      hour: 19,
      minute: 30,
    );

    expect(updated.weekdays, {1, 3, 5});
    expect(updated.timeLabel, '19:30');
    expect(scheduler.lastScheduled?.hour, 19);
    expect(scheduler.lastScheduled?.weekdays, {1, 3, 5});
  });
}
