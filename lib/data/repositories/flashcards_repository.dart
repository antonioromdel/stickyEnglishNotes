import 'package:drift/drift.dart';

import '../database/app_database.dart';
import '../models/card_enums.dart';

class FlashcardsRepository {
  FlashcardsRepository(this._db);

  final AppDatabase _db;

  Future<List<Flashcard>> getAll() {
    return (_db.select(_db.flashcards)
          ..orderBy([(table) => OrderingTerm.desc(table.createdAt)]))
        .get();
  }

  Stream<List<Flashcard>> watchAll() {
    return (_db.select(_db.flashcards)
          ..orderBy([(table) => OrderingTerm.desc(table.createdAt)]))
        .watch();
  }

  Future<List<Flashcard>> getByGroup(int groupId) {
    return (_db.select(_db.flashcards)
          ..where((table) => table.groupId.equals(groupId))
          ..orderBy([(table) => OrderingTerm.desc(table.createdAt)]))
        .get();
  }

  Stream<List<Flashcard>> watchByGroup(int groupId) {
    return (_db.select(_db.flashcards)
          ..where((table) => table.groupId.equals(groupId))
          ..orderBy([(table) => OrderingTerm.desc(table.createdAt)]))
        .watch();
  }

  Future<Flashcard?> getById(int id) {
    return (_db.select(_db.flashcards)..where((table) => table.id.equals(id)))
        .getSingleOrNull();
  }

  Future<List<Flashcard>> getByIds(Iterable<int> ids) async {
    final uniqueIds = ids.toSet();
    if (uniqueIds.isEmpty) return [];

    final found = await (_db.select(_db.flashcards)
          ..where((table) => table.id.isIn(uniqueIds)))
        .get();
    final byId = {for (final card in found) card.id: card};
    return [
      for (final id in ids)
        if (byId[id] != null) byId[id]!,
    ];
  }

  /// Tarjetas pendientes: [Flashcard.nextReviewAt] <= [now].
  Future<List<Flashcard>> getDue({required DateTime now, int? groupId}) {
    return (_db.select(_db.flashcards)
          ..where((table) {
            final due = table.nextReviewAt.isSmallerOrEqualValue(now);
            if (groupId == null) return due;
            return due & table.groupId.equals(groupId);
          })
          ..orderBy([(table) => OrderingTerm.asc(table.nextReviewAt)]))
        .get();
  }

  /// Observa las pendientes evaluando [DateTime.now] en cada emisión,
  /// para incluir tarjetas creadas después de suscribirse.
  Stream<List<Flashcard>> watchDue({int? groupId}) {
    final query = _db.select(_db.flashcards)
      ..orderBy([(table) => OrderingTerm.asc(table.nextReviewAt)]);
    if (groupId != null) {
      query.where((table) => table.groupId.equals(groupId));
    }

    return query.watch().map((cards) {
      final now = DateTime.now();
      return [
        for (final card in cards)
          if (!card.nextReviewAt.isAfter(now)) card,
      ];
    });
  }

  Stream<int> watchDueCount({int? groupId}) {
    return watchDue(groupId: groupId).map((cards) => cards.length);
  }

  Future<Flashcard> create({
    required int groupId,
    required String front,
    required String back,
    FlashcardType type = FlashcardType.word,
    String? example,
    String? audioPath,
    CardDifficulty difficulty = CardDifficulty.normal,
    String tags = '',
    CardSource source = CardSource.manual,
    DateTime? now,
  }) async {
    final timestamp = now ?? DateTime.now();
    final id = await _db.into(_db.flashcards).insert(
      FlashcardsCompanion.insert(
        groupId: groupId,
        type: type,
        front: front,
        back: back,
        example: Value(example),
        audioPath: Value(audioPath),
        difficulty: difficulty,
        tags: Value(tags),
        source: source,
        createdAt: timestamp,
        updatedAt: timestamp,
        nextReviewAt: timestamp,
      ),
    );
    return (await getById(id))!;
  }

  Future<void> updateCard(FlashcardsCompanion companion) {
    return (_db.update(_db.flashcards)
          ..where((table) => table.id.equals(companion.id.value)))
        .write(companion);
  }

  Future<Flashcard> updateDetails({
    required int id,
    required int groupId,
    required String front,
    required String back,
    String? example,
    required FlashcardType type,
  }) async {
    await (_db.update(_db.flashcards)..where((table) => table.id.equals(id)))
        .write(
      FlashcardsCompanion(
        groupId: Value(groupId),
        front: Value(front),
        back: Value(back),
        example: Value(example),
        type: Value(type),
        updatedAt: Value(DateTime.now()),
      ),
    );
    return (await getById(id))!;
  }

  Future<void> updateAfterReview({
    required Flashcard card,
    required int intervalMinutes,
    required int repetitions,
    required DateTime reviewedAt,
    required DateTime nextReviewAt,
    required bool wasCorrect,
  }) {
    return (_db.update(_db.flashcards)
          ..where((table) => table.id.equals(card.id)))
        .write(
      FlashcardsCompanion(
        interval: Value(intervalMinutes),
        repetitions: Value(repetitions),
        lastReviewAt: Value(reviewedAt),
        nextReviewAt: Value(nextReviewAt),
        updatedAt: Value(reviewedAt),
        correctAnswers: Value(card.correctAnswers + (wasCorrect ? 1 : 0)),
        incorrectAnswers: Value(card.incorrectAnswers + (wasCorrect ? 0 : 1)),
      ),
    );
  }

  /// Elimina la tarjeta y, en cascada, sus reviews y errores.
  Future<void> delete(int id) {
    return (_db.delete(_db.flashcards)..where((table) => table.id.equals(id)))
        .go();
  }
}
