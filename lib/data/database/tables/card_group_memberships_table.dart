import 'package:drift/drift.dart';

import 'card_groups_table.dart';
import 'flashcards_table.dart';

/// Relación N:N entre tarjetas y grupos.
@DataClassName('CardGroupMembership')
@TableIndex(name: 'idx_card_group_memberships_group', columns: {#groupId})
class CardGroupMemberships extends Table {
  IntColumn get cardId => integer().references(
        Flashcards,
        #id,
        onDelete: KeyAction.cascade,
      )();
  IntColumn get groupId => integer().references(
        CardGroups,
        #id,
        onDelete: KeyAction.cascade,
      )();

  @override
  Set<Column> get primaryKey => {cardId, groupId};
}
