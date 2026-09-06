import '../../../data/database/app_database.dart';
import '../../../data/models/card_enums.dart';
import '../../home/domain/study_streak.dart';

class DailyActivity {
  const DailyActivity({required this.day, required this.reviewCount});

  final DateTime day;
  final int reviewCount;
}

class StudyStats {
  const StudyStats({
    required this.cardsStudied,
    required this.correctAnswers,
    required this.incorrectAnswers,
    required this.pendingCards,
    required this.streakDays,
    required this.dailyActivity,
  });

  factory StudyStats.empty({int pendingCards = 0}) {
    return StudyStats(
      cardsStudied: 0,
      correctAnswers: 0,
      incorrectAnswers: 0,
      pendingCards: pendingCards,
      streakDays: 0,
      dailyActivity: const [],
    );
  }

  final int cardsStudied;
  final int correctAnswers;
  final int incorrectAnswers;
  final int pendingCards;
  final int streakDays;
  final List<DailyActivity> dailyActivity;

  int get totalReviews => correctAnswers + incorrectAnswers;

  bool get hasStudied => totalReviews > 0;

  int? get accuracyPercent {
    if (totalReviews == 0) return null;
    return ((correctAnswers / totalReviews) * 100).round();
  }
}

StudyStats buildStudyStats({
  required Iterable<Review> reviews,
  required int pendingCards,
  required DateTime now,
}) {
  var correctAnswers = 0;
  var incorrectAnswers = 0;
  final studiedIds = <int>{};
  final reviewsByDay = <DateTime, int>{};

  for (final review in reviews) {
    studiedIds.add(review.cardId);
    if (review.result == ReviewResult.correct) {
      correctAnswers += 1;
    } else {
      incorrectAnswers += 1;
    }

    final day = DateTime(
      review.reviewedAt.year,
      review.reviewedAt.month,
      review.reviewedAt.day,
    );
    reviewsByDay[day] = (reviewsByDay[day] ?? 0) + 1;
  }

  final today = DateTime(now.year, now.month, now.day);
  final dailyActivity = <DailyActivity>[];
  for (var offset = 6; offset >= 0; offset--) {
    final day = today.subtract(Duration(days: offset));
    dailyActivity.add(
      DailyActivity(day: day, reviewCount: reviewsByDay[day] ?? 0),
    );
  }

  return StudyStats(
    cardsStudied: studiedIds.length,
    correctAnswers: correctAnswers,
    incorrectAnswers: incorrectAnswers,
    pendingCards: pendingCards,
    streakDays: studyStreakInDays(
      reviewDates: reviews.map((review) => review.reviewedAt),
      now: now,
    ),
    dailyActivity: dailyActivity,
  );
}
