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
    final query = _cardsInGroup(groupId)
      ..orderBy([OrderingTerm.desc(_db.flashcards.createdAt)]);
    return query.get().then(_readCards);
  }

  Stream<List<Flashcard>> watchByGroup(int groupId) {
    final query = _cardsInGroup(groupId)
      ..orderBy([OrderingTerm.desc(_db.flashcards.createdAt)]);
    return query.watch().map(_readCards);
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

  Stream<List<CardGroupMembership>> watchMemberships() {
    return _db.select(_db.cardGroupMemberships).watch();
  }

  Future<Set<int>> getGroupIds(int cardId) async {
    final rows = await (_db.select(_db.cardGroupMemberships)
          ..where((table) => table.cardId.equals(cardId)))
        .get();
    return {for (final row in rows) row.groupId};
  }

  /// Tarjetas pendientes: [Flashcard.nextReviewAt] <= [now].
  Future<List<Flashcard>> getDue({required DateTime now, int? groupId}) async {
    if (groupId == null) {
      return (_db.select(_db.flashcards)
            ..where((table) => table.nextReviewAt.isSmallerOrEqualValue(now))
            ..orderBy([(table) => OrderingTerm.asc(table.nextReviewAt)]))
          .get();
    }

    final query = _cardsInGroup(groupId)
      ..where(_db.flashcards.nextReviewAt.isSmallerOrEqualValue(now))
      ..orderBy([OrderingTerm.asc(_db.flashcards.nextReviewAt)]);
    return _readCards(await query.get());
  }

  /// Observa las pendientes evaluando [DateTime.now] en cada emisión,
  /// para incluir tarjetas creadas después de suscribirse.
  Stream<List<Flashcard>> watchDue({int? groupId}) {
    final Stream<List<Flashcard>> source;
    if (groupId == null) {
      source = (_db.select(_db.flashcards)
            ..orderBy([(table) => OrderingTerm.asc(table.nextReviewAt)]))
          .watch();
    } else {
      final query = _cardsInGroup(groupId)
        ..orderBy([OrderingTerm.asc(_db.flashcards.nextReviewAt)]);
      source = query.watch().map(_readCards);
    }

    return source.map((cards) {
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
    required Set<int> groupIds,
    required String front,
    required String back,
    FlashcardType type = FlashcardType.word,
    String? example,
    String? audioPath,
    CardDifficulty difficulty = CardDifficulty.normal,
    String tags = '',
    CardSource source = CardSource.manual,
    DateTime? now,
  }) {
    return _db.transaction(() async {
      final timestamp = now ?? DateTime.now();
      final id = await _db.into(_db.flashcards).insert(
        FlashcardsCompanion.insert(
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
      await _replaceMemberships(id, groupIds);
      return (await getById(id))!;
    });
  }

  Future<void> updateCard(FlashcardsCompanion companion) {
    return (_db.update(_db.flashcards)
          ..where((table) => table.id.equals(companion.id.value)))
        .write(companion);
  }

  Future<Flashcard> updateDetails({
    required int id,
    required Set<int> groupIds,
    required String front,
    required String back,
    String? example,
    required FlashcardType type,
  }) {
    return _db.transaction(() async {
      await (_db.update(_db.flashcards)..where((table) => table.id.equals(id)))
          .write(
        FlashcardsCompanion(
          front: Value(front),
          back: Value(back),
          example: Value(example),
          type: Value(type),
          updatedAt: Value(DateTime.now()),
        ),
      );
      await _replaceMemberships(id, groupIds);
      return (await getById(id))!;
    });
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

  /// Elimina la tarjeta y, en cascada, sus reviews, errores y pertenencias.
  Future<void> delete(int id) {
    return (_db.delete(_db.flashcards)..where((table) => table.id.equals(id)))
        .go();
  }

  JoinedSelectStatement _cardsInGroup(int groupId) {
    return _db.select(_db.flashcards).join([
      innerJoin(
        _db.cardGroupMemberships,
        _db.cardGroupMemberships.cardId.equalsExp(_db.flashcards.id),
      ),
    ])..where(_db.cardGroupMemberships.groupId.equals(groupId));
  }

  List<Flashcard> _readCards(List<TypedResult> rows) {
    return [for (final row in rows) row.readTable(_db.flashcards)];
  }

  Future<void> _replaceMemberships(int cardId, Set<int> groupIds) async {
    if (groupIds.isEmpty) {
      throw ArgumentError('La tarjeta debe pertenecer a un grupo.');
    }

    await (_db.delete(_db.cardGroupMemberships)
          ..where((table) => table.cardId.equals(cardId)))
        .go();

    for (final groupId in groupIds) {
      await _db.into(_db.cardGroupMemberships).insert(
            CardGroupMembershipsCompanion.insert(
              cardId: cardId,
              groupId: groupId,
            ),
          );
    }
  }
}
