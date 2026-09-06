import 'package:flutter_test/flutter_test.dart';
import 'package:stickeenglishnotes/features/settings/domain/notification_reminder_settings.dart';

void main() {
  test('formatea la hora en 24 horas', () {
    expect(
      const NotificationReminderSettings(
        enabled: false,
        weekdays: {1},
        hour: 9,
        minute: 5,
      ).timeLabel,
      '09:05',
    );
  });

  test('no deja el recordatorio sin ningún día', () {
    final settings = const NotificationReminderSettings(
      enabled: true,
      weekdays: {1},
      hour: 9,
      minute: 0,
    );

    expect(settings.toggleWeekday(1), settings);
    expect(settings.toggleWeekday(2).weekdays, {1, 2});
  });

  test('calcula la siguiente ocurrencia semanal', () {
    final mondayMorning = DateTime(2026, 9, 7, 8);

    expect(
      nextWeeklyOccurrence(
        now: mondayMorning,
        weekday: DateTime.monday,
        hour: 9,
        minute: 0,
      ),
      DateTime(2026, 9, 7, 9),
    );
    expect(
      nextWeeklyOccurrence(
        now: DateTime(2026, 9, 7, 10),
        weekday: DateTime.monday,
        hour: 9,
        minute: 0,
      ),
      DateTime(2026, 9, 14, 9),
    );
  });
}
