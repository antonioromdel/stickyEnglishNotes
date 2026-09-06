/// Días consecutivos con al menos una revisión, contando desde hoy o ayer.
int studyStreakInDays({
  required Iterable<DateTime> reviewDates,
  required DateTime now,
}) {
  final days = {
    for (final date in reviewDates) DateTime(date.year, date.month, date.day),
  };

  var cursor = DateTime(now.year, now.month, now.day);
  if (!days.contains(cursor)) {
    cursor = cursor.subtract(const Duration(days: 1));
    if (!days.contains(cursor)) return 0;
  }

  var streak = 0;
  while (days.contains(cursor)) {
    streak += 1;
    cursor = cursor.subtract(const Duration(days: 1));
  }
  return streak;
}
