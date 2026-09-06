import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../models/card_enums.dart';
import 'tables/card_errors_table.dart';
import 'tables/card_groups_table.dart';
import 'tables/flashcards_table.dart';
import 'tables/reviews_table.dart';

part 'app_database.g.dart';

/// Base de datos local (Drift + SQLite).
///
/// Decisiones:
/// - IDs enteros autoincrementales: estables y únicos, no índices de lista.
/// - Borrar un [CardGroup] mueve sus flashcards al grupo General.
/// - Borrar una [Flashcard] elimina en cascada reviews y errores.
/// - [Flashcards.interval] se expresa en minutos para poder representar
///   tanto "5 minutos" (Again) como días.
@DriftDatabase(tables: [CardGroups, Flashcards, Reviews, CardErrors])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.memory() : super(NativeDatabase.memory());

  AppDatabase.connect(super.executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (migrator) async {
        await migrator.createAll();
        final now = DateTime.now();
        await into(cardGroups).insert(
          CardGroupsCompanion.insert(
            name: 'General',
            description: const Value('Grupo inicial'),
            createdAt: now,
            updatedAt: now,
          ),
        );
      },
      beforeOpen: (details) async {
        await customStatement('PRAGMA foreign_keys = ON');
      },
    );
  }
}

QueryExecutor _openConnection() {
  return driftDatabase(name: 'sticky_english_notes');
}
