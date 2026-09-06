import 'package:drift/drift.dart';

import '../../models/card_enums.dart';
import 'card_groups_table.dart';

/// Tabla de flashcards.
///
/// Se llama [Flashcards] (y no Cards) para no chocar con el widget
/// [Card] de Flutter. [interval] se guarda en minutos.
@TableIndex(name: 'idx_flashcards_next_review', columns: {#nextReviewAt})
@TableIndex(name: 'idx_flashcards_group', columns: {#groupId})
@DataClassName('Flashcard')
class Flashcards extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get groupId => integer().references(
        CardGroups,
        #id,
        onDelete: KeyAction.cascade,
      )();
  IntColumn get type => intEnum<FlashcardType>()();
  TextColumn get front => text()();
  TextColumn get back => text()();
  TextColumn get example => text().nullable()();
  TextColumn get audioPath => text().nullable()();
  IntColumn get difficulty => intEnum<CardDifficulty>()();
  TextColumn get tags => text().withDefault(const Constant(''))();
  IntColumn get source => intEnum<CardSource>()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get lastReviewAt => dateTime().nullable()();
  DateTimeColumn get nextReviewAt => dateTime()();

  /// Intervalo hasta la próxima revisión, en minutos.
  IntColumn get interval => integer().withDefault(const Constant(0))();
  IntColumn get repetitions => integer().withDefault(const Constant(0))();
  IntColumn get correctAnswers => integer().withDefault(const Constant(0))();
  IntColumn get incorrectAnswers => integer().withDefault(const Constant(0))();
}
