import 'package:drift/drift.dart';

import '../database/app_database.dart';
import '../models/card_enums.dart';

class ReviewsRepository {
  ReviewsRepository(this._db);

  final AppDatabase _db;

  Future<List<Review>> getByCard(int cardId) {
    return (_db.select(_db.reviews)
          ..where((table) => table.cardId.equals(cardId))
          ..orderBy([(table) => OrderingTerm.desc(table.reviewedAt)]))
        .get();
  }

  Future<List<Review>> getAll() {
    return (_db.select(_db.reviews)
          ..orderBy([(table) => OrderingTerm.desc(table.reviewedAt)]))
        .get();
  }

  Stream<List<Review>> watchAll() {
    return (_db.select(_db.reviews)
          ..orderBy([(table) => OrderingTerm.desc(table.reviewedAt)]))
        .watch();
  }

  Future<Review> create({
    required int cardId,
    required ReviewResult result,
    required ReviewRating difficulty,
    required int previousInterval,
    required int newInterval,
    DateTime? reviewedAt,
  }) async {
    final id = await _db.into(_db.reviews).insert(
      ReviewsCompanion.insert(
        cardId: cardId,
        result: result,
        difficulty: difficulty,
        reviewedAt: reviewedAt ?? DateTime.now(),
        previousInterval: previousInterval,
        newInterval: newInterval,
      ),
    );
    return (_db.select(_db.reviews)..where((table) => table.id.equals(id)))
        .getSingle();
  }
}
