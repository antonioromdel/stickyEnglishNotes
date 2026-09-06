import 'package:stickeenglishnotes/data/database/app_database.dart';
import 'package:stickeenglishnotes/data/models/card_enums.dart';

final _now = DateTime(2026, 9, 6, 12);

Flashcard testFlashcard({
  int id = 1,
  int groupId = 1,
  String front = 'hello',
  String back = 'hola',
  String? example,
}) {
  return Flashcard(
    id: id,
    groupId: groupId,
    type: FlashcardType.word,
    front: front,
    back: back,
    example: example,
    difficulty: CardDifficulty.normal,
    tags: '',
    source: CardSource.manual,
    createdAt: _now,
    updatedAt: _now,
    nextReviewAt: _now,
    interval: 0,
    repetitions: 0,
    correctAnswers: 0,
    incorrectAnswers: 0,
  );
}

Review testReview({
  int id = 1,
  int cardId = 1,
  ReviewResult result = ReviewResult.correct,
  ReviewRating difficulty = ReviewRating.good,
  DateTime? reviewedAt,
}) {
  return Review(
    id: id,
    cardId: cardId,
    result: result,
    difficulty: difficulty,
    reviewedAt: reviewedAt ?? _now,
    previousInterval: 0,
    newInterval: 4320,
  );
}

CardError testCardError({
  int id = 1,
  int cardId = 1,
  String userAnswer = 'hello',
  String correctAnswer = 'hola',
  DateTime? createdAt,
}) {
  return CardError(
    id: id,
    cardId: cardId,
    userAnswer: userAnswer,
    correctAnswer: correctAnswer,
    createdAt: createdAt ?? _now,
  );
}

CardGroup testGroup({
  int id = 1,
  String name = 'General',
  String? description = 'Grupo inicial',
}) {
  return CardGroup(
    id: id,
    name: name,
    description: description,
    createdAt: _now,
    updatedAt: _now,
  );
}
