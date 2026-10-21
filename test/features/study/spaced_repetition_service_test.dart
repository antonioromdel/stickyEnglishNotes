import 'package:flutter_test/flutter_test.dart';
import 'package:stickeenglishnotes/data/models/card_enums.dart';
import 'package:stickeenglishnotes/features/study/domain/spaced_repetition_service.dart';

void main() {
  const srs = SpacedRepetitionService();
  final now = DateTime.utc(2026, 9, 6, 12);

  group('primera revisión', () {
    test('Again programa 5 minutos y reinicia repeticiones', () {
      final schedule = srs.calculateNextReview(
        rating: ReviewRating.again,
        currentIntervalMinutes: 0,
        currentRepetitions: 0,
        now: now,
      );

      expect(schedule.intervalMinutes, SpacedRepetitionService.againMinutes);
      expect(schedule.nextReviewAt, now.add(const Duration(minutes: 5)));
      expect(schedule.repetitions, 0);
      expect(schedule.result, ReviewResult.incorrect);
    });

    test('¡He acertado! programa 1 día y cuenta como acierto', () {
      final schedule = srs.calculateNextReview(
        rating: ReviewRating.hard,
        currentIntervalMinutes: SpacedRepetitionService.goodMinutes,
        currentRepetitions: 4,
        now: now,
      );

      expect(schedule.intervalMinutes, SpacedRepetitionService.hardMinutes);
      expect(schedule.nextReviewAt, now.add(const Duration(days: 1)));
      expect(schedule.repetitions, 5);
      expect(schedule.result, ReviewResult.correct);
    });

    test('¡Acertado! programa 2 días y cuenta como acierto', () {
      final schedule = srs.calculateNextReview(
        rating: ReviewRating.good,
        currentIntervalMinutes: SpacedRepetitionService.hardMinutes,
        currentRepetitions: 3,
        now: now,
      );

      expect(schedule.intervalMinutes, SpacedRepetitionService.goodMinutes);
      expect(schedule.nextReviewAt, now.add(const Duration(days: 2)));
      expect(schedule.repetitions, 4);
      expect(schedule.result, ReviewResult.correct);
    });

    test('Easy programa 4 días', () {
      final schedule = srs.calculateNextReview(
        rating: ReviewRating.easy,
        currentIntervalMinutes: 0,
        currentRepetitions: 0,
        now: now,
      );

      expect(schedule.intervalMinutes, SpacedRepetitionService.easyMinutes);
      expect(schedule.nextReviewAt, now.add(const Duration(days: 4)));
      expect(schedule.repetitions, 1);
      expect(schedule.result, ReviewResult.correct);
    });
  });

  group('revisiones posteriores', () {
    test('Again vuelve a 5 minutos aunque hubiera un intervalo largo', () {
      final schedule = srs.calculateNextReview(
        rating: ReviewRating.again,
        currentIntervalMinutes: SpacedRepetitionService.easyMinutes,
        currentRepetitions: 4,
        now: now,
      );

      expect(schedule.intervalMinutes, SpacedRepetitionService.againMinutes);
      expect(schedule.repetitions, 0);
      expect(schedule.result, ReviewResult.incorrect);
    });
  });
}
