import 'package:drift/drift.dart';

import '../database/app_database.dart';

class CardErrorsRepository {
  CardErrorsRepository(this._db);

  final AppDatabase _db;

  Future<List<CardError>> getAll() {
    return (_db.select(_db.cardErrors)
          ..orderBy([(table) => OrderingTerm.desc(table.createdAt)]))
        .get();
  }

  Stream<List<CardError>> watchAll() {
    return (_db.select(_db.cardErrors)
          ..orderBy([(table) => OrderingTerm.desc(table.createdAt)]))
        .watch();
  }

  Stream<List<({CardError error, Flashcard card})>> watchAllWithCards() {
    final query = _db.select(_db.cardErrors).join([
      innerJoin(
        _db.flashcards,
        _db.flashcards.id.equalsExp(_db.cardErrors.cardId),
      ),
    ])..orderBy([OrderingTerm.desc(_db.cardErrors.createdAt)]);

    return query.watch().map((rows) {
      return [
        for (final row in rows)
          (
            error: row.readTable(_db.cardErrors),
            card: row.readTable(_db.flashcards),
          ),
      ];
    });
  }

  Future<List<CardError>> getByCard(int cardId) {
    return (_db.select(_db.cardErrors)
          ..where((table) => table.cardId.equals(cardId))
          ..orderBy([(table) => OrderingTerm.desc(table.createdAt)]))
        .get();
  }

  Future<CardError> create({
    required int cardId,
    required String userAnswer,
    required String correctAnswer,
    String? note,
    DateTime? createdAt,
  }) async {
    final id = await _db.into(_db.cardErrors).insert(
      CardErrorsCompanion.insert(
        cardId: cardId,
        userAnswer: userAnswer,
        correctAnswer: correctAnswer,
        note: Value(note),
        createdAt: createdAt ?? DateTime.now(),
      ),
    );
    return (_db.select(_db.cardErrors)..where((table) => table.id.equals(id)))
        .getSingle();
  }

  Future<void> delete(int id) {
    return (_db.delete(_db.cardErrors)..where((table) => table.id.equals(id)))
        .go();
  }

  Future<void> deleteByCard(int cardId) {
    return (_db.delete(_db.cardErrors)
          ..where((table) => table.cardId.equals(cardId)))
        .go();
  }
}
