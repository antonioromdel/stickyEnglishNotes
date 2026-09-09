import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/database/app_database.dart';
import '../../../data/providers.dart';
import '../../../data/repositories/card_groups_repository.dart';
import '../../../data/repositories/flashcards_repository.dart';
import '../domain/card_draft.dart';

class CreateCardController {
  CreateCardController(this._flashcards, this._groups);

  final FlashcardsRepository _flashcards;
  final CardGroupsRepository _groups;

  Future<Flashcard> create(CardDraft draft) async {
    if (!draft.isValid) {
      throw ArgumentError(draft.frontError ?? draft.backError);
    }

    final groupIds = await _resolveGroupIds(draft.groupIds);

    return _flashcards.create(
      groupIds: groupIds,
      front: draft.trimmedFront,
      back: draft.trimmedBack,
      example: draft.trimmedExample,
      type: draft.type,
      source: draft.source,
    );
  }

  Future<Flashcard> update({
    required int cardId,
    required CardDraft draft,
  }) async {
    if (!draft.isValid) {
      throw ArgumentError(draft.frontError ?? draft.backError);
    }

    final existing = await _flashcards.getById(cardId);
    if (existing == null) {
      throw StateError('La tarjeta no existe.');
    }

    final currentGroups = await _flashcards.getGroupIds(cardId);
    final groupIds = await _resolveGroupIds(
      draft.groupIds.isEmpty ? currentGroups : draft.groupIds,
    );

    return _flashcards.updateDetails(
      id: cardId,
      groupIds: groupIds,
      front: draft.trimmedFront,
      back: draft.trimmedBack,
      example: draft.trimmedExample,
      type: draft.type,
    );
  }

  Future<void> delete(int cardId) {
    return _flashcards.delete(cardId);
  }

  Future<Set<int>> _resolveGroupIds(Set<int> groupIds) async {
    final valid = <int>{};
    for (final groupId in groupIds) {
      final group = await _groups.getById(groupId);
      if (group != null) valid.add(group.id);
    }
    if (valid.isNotEmpty) return valid;

    final groups = await _groups.getAll();
    if (groups.isEmpty) {
      throw StateError('No hay ningún grupo para guardar la tarjeta.');
    }

    return {CardGroupsRepository.defaultIdOf(groups) ?? groups.first.id};
  }
}

final createCardControllerProvider = Provider<CreateCardController>((ref) {
  return CreateCardController(
    ref.watch(flashcardsRepositoryProvider),
    ref.watch(cardGroupsRepositoryProvider),
  );
});
