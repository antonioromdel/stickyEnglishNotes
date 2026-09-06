import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/database/app_database.dart';
import '../../../data/providers.dart';
import '../../../data/repositories/card_groups_repository.dart';

class GroupsController {
  GroupsController(this._groups);

  final CardGroupsRepository _groups;

  String? validateName(String name) {
    if (name.trim().isEmpty) return 'Escribe un nombre';
    return null;
  }

  Future<CardGroup> create({required String name, String? description}) {
    final error = validateName(name);
    if (error != null) throw ArgumentError(error);

    return _groups.create(name: name.trim(), description: description);
  }

  Future<void> rename({required int id, required String name}) {
    final error = validateName(name);
    if (error != null) throw ArgumentError(error);

    return _groups.updateGroup(id: id, name: name.trim());
  }

  Future<void> delete(int id) {
    return _groups.delete(id);
  }
}

final groupsControllerProvider = Provider<GroupsController>((ref) {
  return GroupsController(ref.watch(cardGroupsRepositoryProvider));
});
