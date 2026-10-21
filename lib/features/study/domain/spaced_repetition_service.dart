import '../../../data/models/card_enums.dart';
import 'review_schedule.dart';

/// Programa la próxima revisión a partir de la valoración.
///
/// Los intervalos no crecen con el historial: cada botón significa
/// siempre el mismo plazo, para que el estudio de mañana sea predecible.
/// [ReviewRating.easy] se conserva por revisiones ya guardadas y no
/// se ofrece en la pantalla.
class SpacedRepetitionService {
  const SpacedRepetitionService();

  static const int againMinutes = 5;
  static const int hardMinutes = 24 * 60;
  static const int goodMinutes = 2 * 24 * 60;
  static const int easyMinutes = 4 * 24 * 60;

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

    final intervalMinutes = switch (rating) {
      ReviewRating.hard => hardMinutes,
      ReviewRating.good => goodMinutes,
      ReviewRating.easy => easyMinutes,
      ReviewRating.again => againMinutes,
    };

    return ReviewSchedule(
      intervalMinutes: intervalMinutes,
      nextReviewAt: now.add(Duration(minutes: intervalMinutes)),
      repetitions: currentRepetitions + 1,
      result: ReviewResult.correct,
    );
  }
}
