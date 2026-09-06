import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/database/app_database.dart';
import '../../../data/providers.dart';
import '../domain/study_streak.dart';

final dueFlashcardsCountProvider = StreamProvider<int>((ref) {
  return ref.watch(flashcardsRepositoryProvider).watchDueCount();
});

final homePreviewCardProvider = StreamProvider<Flashcard?>((ref) {
  return ref.watch(flashcardsRepositoryProvider).watchDue().map(
    (cards) => cards.isEmpty ? null : cards.first,
  );
});

final studyStreakProvider = StreamProvider<int>((ref) {
  return ref.watch(reviewsRepositoryProvider).watchAll().map((reviews) {
    return studyStreakInDays(
      reviewDates: reviews.map((review) => review.reviewedAt),
      now: DateTime.now(),
    );
  });
});
