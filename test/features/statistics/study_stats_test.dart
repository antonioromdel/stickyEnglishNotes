import 'package:flutter_test/flutter_test.dart';
import 'package:stickeenglishnotes/data/models/card_enums.dart';
import 'package:stickeenglishnotes/features/statistics/domain/study_stats.dart';

import '../../helpers/test_data.dart';

void main() {
  final now = DateTime(2026, 9, 6, 18);

  test('sin revisiones no hay estudio ni precisión', () {
    final stats = buildStudyStats(
      reviews: const [],
      pendingCards: 4,
      now: now,
    );

    expect(stats.hasStudied, isFalse);
    expect(stats.accuracyPercent, isNull);
    expect(stats.pendingCards, 4);
    expect(stats.streakDays, 0);
    expect(stats.dailyActivity, hasLength(7));
  });

  test('calcula estudiadas, aciertos, fallos y precisión', () {
    final stats = buildStudyStats(
      reviews: [
        testReview(id: 1, cardId: 1, result: ReviewResult.correct),
        testReview(id: 2, cardId: 1, result: ReviewResult.incorrect),
        testReview(id: 3, cardId: 2, result: ReviewResult.correct),
        testReview(id: 4, cardId: 3, result: ReviewResult.correct),
      ],
      pendingCards: 2,
      now: now,
    );

    expect(stats.cardsStudied, 3);
    expect(stats.correctAnswers, 3);
    expect(stats.incorrectAnswers, 1);
    expect(stats.totalReviews, 4);
    expect(stats.accuracyPercent, 75);
    expect(stats.pendingCards, 2);
    expect(stats.streakDays, 1);
  });

  test('agrupa la actividad de los últimos 7 días', () {
    final stats = buildStudyStats(
      reviews: [
        testReview(id: 1, reviewedAt: DateTime(2026, 9, 6, 10)),
        testReview(id: 2, reviewedAt: DateTime(2026, 9, 6, 16)),
        testReview(id: 3, reviewedAt: DateTime(2026, 9, 4, 9)),
        testReview(id: 4, reviewedAt: DateTime(2026, 8, 20, 9)),
      ],
      pendingCards: 0,
      now: now,
    );

    expect(stats.dailyActivity, hasLength(7));
    expect(stats.dailyActivity.first.day, DateTime(2026, 8, 31));
    expect(stats.dailyActivity.last.day, DateTime(2026, 9, 6));
    expect(stats.dailyActivity.last.reviewCount, 2);
    expect(
      stats.dailyActivity.firstWhere((day) => day.day == DateTime(2026, 9, 4)).reviewCount,
      1,
    );
    expect(
      stats.dailyActivity.where((day) => day.day == DateTime(2026, 8, 20)),
      isEmpty,
    );
  });
}
