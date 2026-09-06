import 'package:drift/drift.dart';

import '../../models/card_enums.dart';
import 'flashcards_table.dart';

@TableIndex(name: 'idx_reviews_card', columns: {#cardId})
class Reviews extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get cardId => integer().references(
        Flashcards,
        #id,
        onDelete: KeyAction.cascade,
      )();
  IntColumn get result => intEnum<ReviewResult>()();
  IntColumn get difficulty => intEnum<ReviewRating>()();
  DateTimeColumn get reviewedAt => dateTime()();

  /// Intervalos en minutos, igual que [Flashcards.interval].
  IntColumn get previousInterval => integer()();
  IntColumn get newInterval => integer()();
}
