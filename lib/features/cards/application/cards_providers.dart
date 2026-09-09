import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/database/app_database.dart';
import '../../../data/providers.dart';

final flashcardsProvider = StreamProvider<List<Flashcard>>((ref) {
  return ref.watch(flashcardsRepositoryProvider).watchAll();
});

final flashcardsByGroupProvider =
    StreamProvider.family<List<Flashcard>, int>((ref, groupId) {
  return ref.watch(flashcardsRepositoryProvider).watchByGroup(groupId);
});

final cardGroupMembershipsProvider =
    StreamProvider<List<CardGroupMembership>>((ref) {
  return ref.watch(flashcardsRepositoryProvider).watchMemberships();
});

class CardsGroupFilter extends Notifier<int?> {
  @override
  int? build() => null;

  void select(int? groupId) => state = groupId;
}

final cardsGroupFilterProvider = NotifierProvider<CardsGroupFilter, int?>(
  CardsGroupFilter.new,
);

Map<int, Set<int>> groupIdsByCard(List<CardGroupMembership> memberships) {
  final grouped = <int, Set<int>>{};
  for (final membership in memberships) {
    grouped.putIfAbsent(membership.cardId, () => {}).add(membership.groupId);
  }
  return grouped;
}

Map<int, int> cardCountByGroup(List<CardGroupMembership> memberships) {
  final counts = <int, int>{};
  for (final membership in memberships) {
    counts[membership.groupId] = (counts[membership.groupId] ?? 0) + 1;
  }
  return counts;
}

List<Flashcard> filterFlashcardsByGroup(
  List<Flashcard> cards,
  int? groupId,
  Map<int, Set<int>> groupsByCard,
) {
  if (groupId == null) return cards;
  return [
    for (final card in cards)
      if (groupsByCard[card.id]?.contains(groupId) ?? false) card,
  ];
}
