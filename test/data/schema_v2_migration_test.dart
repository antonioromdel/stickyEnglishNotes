import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:stickeenglishnotes/data/database/app_database.dart';
import 'package:stickeenglishnotes/data/repositories/flashcards_repository.dart';
import 'package:stickeenglishnotes/data/repositories/reviews_repository.dart';

import '../helpers/test_app.dart';

void main() {
  setUpAll(configureTestDrift);

  test('migra tarjetas, grupos y reviews del esquema 1 al 2', () async {
    final sqlite = _openSchemaV1();
    _insertV1Sample(sqlite);

    final database = AppDatabase.connect(NativeDatabase.opened(sqlite));
    addTearDown(database.close);

    final cards = FlashcardsRepository(database);
    final reviews = ReviewsRepository(database);
    final all = await cards.getAll();
    final groupIds = await cards.getGroupIds(all.single.id);
    final due = await cards.getDue(now: DateTime.utc(2026, 9, 11));
    final storedReviews = await reviews.getAll();

    expect(all, hasLength(1));
    expect(all.single.front, 'apple');
    expect(groupIds, isNotEmpty);
    expect(due.map((card) => card.id), contains(all.single.id));
    expect(storedReviews, hasLength(1));
    expect(
      await _hasColumn(database, 'flashcards', 'group_id'),
      isFalse,
    );
  });

  test('completa un upgrade a medias con el índice viejo todavía presente', () async {
    final sqlite = _openSchemaV1();
    _insertV1Sample(sqlite);
    sqlite.execute(
      'CREATE TABLE card_group_memberships ('
      'card_id INTEGER NOT NULL REFERENCES flashcards (id) ON DELETE CASCADE, '
      'group_id INTEGER NOT NULL REFERENCES card_groups (id) ON DELETE CASCADE, '
      'PRIMARY KEY (card_id, group_id)'
      ')',
    );
    sqlite.execute(
      'INSERT INTO card_group_memberships (card_id, group_id) '
      'SELECT id, group_id FROM flashcards',
    );

    final database = AppDatabase.connect(NativeDatabase.opened(sqlite));
    addTearDown(database.close);

    final cards = FlashcardsRepository(database);
    final all = await cards.getAll();
    final groupIds = await cards.getGroupIds(all.single.id);

    expect(all, hasLength(1));
    expect(groupIds, isNotEmpty);
    expect(
      await _hasColumn(database, 'flashcards', 'group_id'),
      isFalse,
    );
  });
}

Database _openSchemaV1() {
  final sqlite = sqlite3.openInMemory();
  sqlite.execute('PRAGMA foreign_keys = OFF');
  sqlite.execute(
    'CREATE TABLE card_groups ('
    'id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, '
    'name TEXT NOT NULL, '
    'description TEXT NULL, '
    'created_at INTEGER NOT NULL, '
    'updated_at INTEGER NOT NULL'
    ')',
  );
  sqlite.execute(
    'CREATE TABLE flashcards ('
    'id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, '
    'group_id INTEGER NOT NULL REFERENCES card_groups (id) ON DELETE CASCADE, '
    'type INTEGER NOT NULL, '
    'front TEXT NOT NULL, '
    'back TEXT NOT NULL, '
    'example TEXT NULL, '
    'audio_path TEXT NULL, '
    'difficulty INTEGER NOT NULL, '
    'tags TEXT NOT NULL DEFAULT \'\', '
    'source INTEGER NOT NULL, '
    'created_at INTEGER NOT NULL, '
    'updated_at INTEGER NOT NULL, '
    'last_review_at INTEGER NULL, '
    'next_review_at INTEGER NOT NULL, '
    'interval INTEGER NOT NULL DEFAULT 0, '
    'repetitions INTEGER NOT NULL DEFAULT 0, '
    'correct_answers INTEGER NOT NULL DEFAULT 0, '
    'incorrect_answers INTEGER NOT NULL DEFAULT 0'
    ')',
  );
  sqlite.execute(
    'CREATE INDEX idx_flashcards_next_review ON flashcards (next_review_at)',
  );
  sqlite.execute(
    'CREATE INDEX idx_flashcards_group ON flashcards (group_id)',
  );
  sqlite.execute(
    'CREATE TABLE reviews ('
    'id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, '
    'card_id INTEGER NOT NULL REFERENCES flashcards (id) ON DELETE CASCADE, '
    'result INTEGER NOT NULL, '
    'difficulty INTEGER NOT NULL, '
    'reviewed_at INTEGER NOT NULL, '
    'previous_interval INTEGER NOT NULL, '
    'new_interval INTEGER NOT NULL'
    ')',
  );
  sqlite.execute(
    'CREATE TABLE card_errors ('
    'id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, '
    'card_id INTEGER NOT NULL REFERENCES flashcards (id) ON DELETE CASCADE, '
    'user_answer TEXT NOT NULL, '
    'correct_answer TEXT NOT NULL, '
    'note TEXT NULL, '
    'created_at INTEGER NOT NULL'
    ')',
  );
  sqlite.execute(
    'CREATE INDEX idx_reviews_card ON reviews (card_id)',
  );
  sqlite.execute(
    'CREATE INDEX idx_card_errors_card ON card_errors (card_id)',
  );
  sqlite.execute('PRAGMA user_version = 1');
  return sqlite;
}

void _insertV1Sample(Database sqlite) {
  final created = DateTime.utc(2026, 1, 1).millisecondsSinceEpoch ~/ 1000;
  sqlite.execute(
    'INSERT INTO card_groups (id, name, description, created_at, updated_at) '
    'VALUES (1, \'General\', \'Grupo inicial\', ?, ?)',
    [created, created],
  );
  sqlite.execute(
    'INSERT INTO flashcards ('
    'id, group_id, type, front, back, difficulty, source, '
    'created_at, updated_at, next_review_at'
    ') VALUES (1, 1, 0, \'apple\', \'manzana\', 1, 0, ?, ?, ?)',
    [created, created, created],
  );
  sqlite.execute(
    'INSERT INTO reviews ('
    'card_id, result, difficulty, reviewed_at, previous_interval, new_interval'
    ') VALUES (1, 0, 2, ?, 0, 10)',
    [created],
  );
}

Future<bool> _hasColumn(
  AppDatabase database,
  String table,
  String column,
) async {
  final rows = await database.customSelect('PRAGMA table_info($table)').get();
  return rows.any((row) => row.read<String>('name') == column);
}
