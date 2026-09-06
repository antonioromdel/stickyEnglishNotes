import 'package:drift/drift.dart';

import 'flashcards_table.dart';

/// Errores del usuario al estudiar. El nombre evita chocar con [Error] de Dart.
@TableIndex(name: 'idx_card_errors_card', columns: {#cardId})
@DataClassName('CardError')
class CardErrors extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get cardId => integer().references(
        Flashcards,
        #id,
        onDelete: KeyAction.cascade,
      )();
  TextColumn get userAnswer => text()();
  TextColumn get correctAnswer => text()();
  TextColumn get note => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
}
