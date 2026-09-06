import 'package:flutter_test/flutter_test.dart';
import 'package:stickeenglishnotes/features/home/domain/study_streak.dart';

void main() {
  final today = DateTime(2026, 9, 6);

  test('sin revisiones la racha es 0', () {
    expect(
      studyStreakInDays(reviewDates: const [], now: today),
      0,
    );
  });

  test('cuenta días consecutivos hasta hoy', () {
    final streak = studyStreakInDays(
      reviewDates: [
        DateTime(2026, 9, 6, 10),
        DateTime(2026, 9, 5, 18),
        DateTime(2026, 9, 4, 9),
      ],
      now: today,
    );

    expect(streak, 3);
  });

  test('mantiene la racha si el último estudio fue ayer', () {
    final streak = studyStreakInDays(
      reviewDates: [DateTime(2026, 9, 5, 21), DateTime(2026, 9, 4, 8)],
      now: today,
    );

    expect(streak, 2);
  });

  test('se rompe si hay un hueco de un día', () {
    final streak = studyStreakInDays(
      reviewDates: [DateTime(2026, 9, 6), DateTime(2026, 9, 3)],
      now: today,
    );

    expect(streak, 1);
  });
}
