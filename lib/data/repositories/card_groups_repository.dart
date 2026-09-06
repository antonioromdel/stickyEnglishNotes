import 'package:drift/drift.dart';

import '../database/app_database.dart';

class CardGroupsRepository {
  static const defaultName = 'General';

  CardGroupsRepository(this._db);

  final AppDatabase _db;

  static bool isDefault(CardGroup group) => group.name == defaultName;

  static int? defaultIdOf(List<CardGroup> groups) {
    for (final group in groups) {
      if (isDefault(group)) return group.id;
    }
    return groups.isEmpty ? null : groups.first.id;
  }

  Future<CardGroup> getOrCreateDefault() async {
    final existing = await getAll();
    for (final group in existing) {
      if (isDefault(group)) return group;
    }
    return create(name: defaultName, description: 'Grupo inicial');
  }

  Future<List<CardGroup>> getAll() {
    return (_db.select(_db.cardGroups)
          ..orderBy([(table) => OrderingTerm.asc(table.name)]))
        .get();
  }

  Stream<List<CardGroup>> watchAll() {
    return (_db.select(_db.cardGroups)
          ..orderBy([(table) => OrderingTerm.asc(table.name)]))
        .watch();
  }

  Future<CardGroup?> getById(int id) {
    return (_db.select(_db.cardGroups)
          ..where((table) => table.id.equals(id)))
        .getSingleOrNull();
  }

  Future<CardGroup> create({
    required String name,
    String? description,
  }) async {
    final now = DateTime.now();
    final id = await _db.into(_db.cardGroups).insert(
      CardGroupsCompanion.insert(
        name: name,
        description: Value(description),
        createdAt: now,
        updatedAt: now,
      ),
    );
    return (await getById(id))!;
  }

  Future<void> updateGroup({
    required int id,
    required String name,
    String? description,
  }) {
    return (_db.update(_db.cardGroups)..where((table) => table.id.equals(id)))
        .write(
      CardGroupsCompanion(
        name: Value(name),
        description: Value(description),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Elimina el grupo y mueve sus tarjetas al grupo General.
  ///
  /// El grupo General no se puede eliminar.
  Future<void> delete(int id) {
    return _db.transaction(() async {
      final group = await getById(id);
      if (group == null) return;
      if (isDefault(group)) {
        throw StateError('No se puede eliminar el grupo $defaultName');
      }

      final general = await getOrCreateDefault();
      await (_db.update(_db.flashcards)
            ..where((table) => table.groupId.equals(id)))
          .write(
        FlashcardsCompanion(
          groupId: Value(general.id),
          updatedAt: Value(DateTime.now()),
        ),
      );
      await (_db.delete(_db.cardGroups)..where((table) => table.id.equals(id)))
          .go();
    });
  }
}
