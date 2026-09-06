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

class CardsGroupFilter extends Notifier<int?> {
  @override
  int? build() => null;

  void select(int? groupId) => state = groupId;
}

final cardsGroupFilterProvider = NotifierProvider<CardsGroupFilter, int?>(
  CardsGroupFilter.new,
);

List<Flashcard> filterFlashcardsByGroup(
  List<Flashcard> cards,
  int? groupId,
) {
  if (groupId == null) return cards;
  return cards.where((card) => card.groupId == groupId).toList();
}
