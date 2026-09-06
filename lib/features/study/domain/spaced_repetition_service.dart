import 'dart:math';

import '../../../data/models/card_enums.dart';
import 'review_schedule.dart';

/// Algoritmo SRS inicial, sustituible más adelante (p. ej. por SM-2).
class SpacedRepetitionService {
  const SpacedRepetitionService();

  static const int againMinutes = 5;
  static const int hardMinutes = 24 * 60;
  static const int goodMinutes = 2 * 24 * 60;
  static const int easyMinutes = 4 * 24 * 60;

  static const double hardMultiplier = 1.2;
  static const double goodMultiplier = 2.0;
  static const double easyMultiplier = 2.5;

  ReviewSchedule calculateNextReview({
    required ReviewRating rating,
    required int currentIntervalMinutes,
    required int currentRepetitions,
    required DateTime now,
  }) {
    if (rating == ReviewRating.again) {
      return ReviewSchedule(
        intervalMinutes: againMinutes,
        nextReviewAt: now.add(const Duration(minutes: againMinutes)),
        repetitions: 0,
        result: ReviewResult.incorrect,
      );
    }

    final baseMinutes = _baseMinutes(rating);
    final isFirstReview =
        currentRepetitions == 0 || currentIntervalMinutes == 0;
    final nextInterval = isFirstReview
        ? baseMinutes
        : max(
            baseMinutes,
            (currentIntervalMinutes * _multiplier(rating)).round(),
          );

    return ReviewSchedule(
      intervalMinutes: nextInterval,
      nextReviewAt: now.add(Duration(minutes: nextInterval)),
      repetitions: currentRepetitions + 1,
      result: ReviewResult.correct,
    );
  }

  int _baseMinutes(ReviewRating rating) {
    return switch (rating) {
      ReviewRating.again => againMinutes,
      ReviewRating.hard => hardMinutes,
      ReviewRating.good => goodMinutes,
      ReviewRating.easy => easyMinutes,
    };
  }

  double _multiplier(ReviewRating rating) {
    return switch (rating) {
      ReviewRating.again => 0,
      ReviewRating.hard => hardMultiplier,
      ReviewRating.good => goodMultiplier,
      ReviewRating.easy => easyMultiplier,
    };
  }
}
