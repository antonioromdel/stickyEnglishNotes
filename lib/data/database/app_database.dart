import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../models/card_enums.dart';
import 'tables/card_errors_table.dart';
import 'tables/card_group_memberships_table.dart';
import 'tables/card_groups_table.dart';
import 'tables/flashcards_table.dart';
import 'tables/reviews_table.dart';

part 'app_database.g.dart';

/// Base de datos local (Drift + SQLite).
///
/// Decisiones:
/// - IDs enteros autoincrementales: estables y únicos, no índices de lista.
/// - Una [Flashcard] puede pertenecer a varios [CardGroup] (N:N).
/// - Borrar un [CardGroup] quita esa pertenencia. Si una tarjeta se queda
///   sin grupo, pasa a General.
/// - Borrar una [Flashcard] elimina en cascada reviews, errores y pertenencias.
/// - [Flashcards.interval] se expresa en minutos para poder representar
///   tanto "5 minutos" (Again) como días.
@DriftDatabase(
  tables: [
    CardGroups,
    Flashcards,
    CardGroupMemberships,
    Reviews,
    CardErrors,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.memory() : super(NativeDatabase.memory());

  AppDatabase.connect(super.executor);

  @override
  int get schemaVersion => 2;

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
      onUpgrade: (migrator, from, to) async {
        if (from < 2) {
          await _migrateFlashcardsToManyGroups(migrator);
        }
      },
      beforeOpen: (details) async {
        if (!details.wasCreated) {
          // Repara un upgrade a medias (p. ej. si falló al recrear el índice
          // idx_flashcards_group) aunque user_version ya sea 2.
          await _migrateFlashcardsToManyGroups(createMigrator());
        }
        await customStatement('PRAGMA foreign_keys = ON');
      },
    );
  }

  /// Pasa de `flashcards.group_id` a la tabla N:N. Es idempotente: un intento
  /// previo puede haber creado pertenencias y dejado el índice viejo, que
  /// [Migrator.alterTable] volvería a crear sobre una columna ya borrada.
  Future<void> _migrateFlashcardsToManyGroups(Migrator migrator) async {
    await customStatement('PRAGMA foreign_keys = OFF');
    try {
      if (!await _hasTable('card_group_memberships')) {
        await migrator.createTable(cardGroupMemberships);
      }
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_card_group_memberships_group '
        'ON card_group_memberships (group_id)',
      );

      if (await _hasColumn('flashcards', 'group_id')) {
        await customStatement(
          'INSERT OR IGNORE INTO card_group_memberships (card_id, group_id) '
          'SELECT id, group_id FROM flashcards',
        );
        await customStatement('DROP INDEX IF EXISTS idx_flashcards_group');
        await migrator.alterTable(TableMigration(flashcards));
      }

      await _ensureOrphanCardsInGeneral();
    } finally {
      await customStatement('PRAGMA foreign_keys = ON');
    }
  }

  Future<void> _ensureOrphanCardsInGeneral() async {
    if (!await _hasTable('card_group_memberships')) return;
    if (await _hasColumn('flashcards', 'group_id')) return;

    final orphans = await customSelect(
      'SELECT id FROM flashcards '
      'WHERE id NOT IN (SELECT card_id FROM card_group_memberships)',
    ).get();
    if (orphans.isEmpty) return;

    final general = await (select(cardGroups)
          ..where((table) => table.name.equals('General')))
        .getSingleOrNull();
    final generalId = general?.id ??
        await into(cardGroups).insert(
          CardGroupsCompanion.insert(
            name: 'General',
            description: const Value('Grupo inicial'),
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        );

    for (final row in orphans) {
      await into(cardGroupMemberships).insert(
        CardGroupMembershipsCompanion.insert(
          cardId: row.read<int>('id'),
          groupId: generalId,
        ),
        mode: InsertMode.insertOrIgnore,
      );
    }
  }

  Future<bool> _hasTable(String name) async {
    final rows = await customSelect(
      "SELECT 1 FROM sqlite_master WHERE type = 'table' AND name = ?",
      variables: [Variable<String>(name)],
    ).get();
    return rows.isNotEmpty;
  }

  Future<bool> _hasColumn(String table, String column) async {
    final rows = await customSelect('PRAGMA table_info($table)').get();
    return rows.any((row) => row.read<String>('name') == column);
  }
}

QueryExecutor _openConnection() {
  return driftDatabase(name: 'sticky_english_notes');
}
