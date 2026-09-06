import '../../../data/models/card_enums.dart';

class ReviewSchedule {
  const ReviewSchedule({
    required this.intervalMinutes,
    required this.nextReviewAt,
    required this.repetitions,
    required this.result,
  });

  final int intervalMinutes;
  final DateTime nextReviewAt;
  final int repetitions;
  final ReviewResult result;
}
