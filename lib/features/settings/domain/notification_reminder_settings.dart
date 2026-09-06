class NotificationReminderSettings {
  const NotificationReminderSettings({
    required this.enabled,
    required this.weekdays,
    required this.hour,
    required this.minute,
  });

  static const defaults = NotificationReminderSettings(
    enabled: false,
    weekdays: {1, 2, 3, 4, 5, 6, 7},
    hour: 9,
    minute: 0,
  );

  static const weekdayOrder = [1, 2, 3, 4, 5, 6, 7];

  static const weekdayLabels = {
    1: 'L',
    2: 'M',
    3: 'X',
    4: 'J',
    5: 'V',
    6: 'S',
    7: 'D',
  };

  final bool enabled;
  final Set<int> weekdays;
  final int hour;
  final int minute;

  String get timeLabel {
    final hours = hour.toString().padLeft(2, '0');
    final minutes = minute.toString().padLeft(2, '0');
    return '$hours:$minutes';
  }

  List<int> get sortedWeekdays {
    return weekdayOrder.where(weekdays.contains).toList();
  }

  NotificationReminderSettings copyWith({
    bool? enabled,
    Set<int>? weekdays,
    int? hour,
    int? minute,
  }) {
    return NotificationReminderSettings(
      enabled: enabled ?? this.enabled,
      weekdays: weekdays ?? this.weekdays,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
    );
  }

  NotificationReminderSettings toggleWeekday(int weekday) {
    if (!weekdayOrder.contains(weekday)) return this;

    final next = {...weekdays};
    if (next.contains(weekday)) {
      if (next.length <= 1) return this;
      next.remove(weekday);
    } else {
      next.add(weekday);
    }
    return copyWith(weekdays: next);
  }

  @override
  bool operator ==(Object other) {
    return other is NotificationReminderSettings &&
        enabled == other.enabled &&
        hour == other.hour &&
        minute == other.minute &&
        _sameDays(weekdays, other.weekdays);
  }

  @override
  int get hashCode => Object.hash(enabled, hour, minute, Object.hashAll(sortedWeekdays));
}

bool _sameDays(Set<int> left, Set<int> right) {
  if (left.length != right.length) return false;
  return left.containsAll(right);
}

DateTime nextWeeklyOccurrence({
  required DateTime now,
  required int weekday,
  required int hour,
  required int minute,
}) {
  var candidate = DateTime(now.year, now.month, now.day, hour, minute);
  while (candidate.weekday != weekday || !candidate.isAfter(now)) {
    candidate = candidate.add(const Duration(days: 1));
  }
  return candidate;
}
