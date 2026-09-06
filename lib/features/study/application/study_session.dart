import '../../../data/database/app_database.dart';

class StudySession {
  const StudySession({
    required this.cards,
    required this.index,
    required this.isFlipped,
    required this.answeredCount,
    required this.hasLibraryCards,
    this.groupId,
  });

  final List<Flashcard> cards;
  final int index;
  final bool isFlipped;
  final int answeredCount;
  final bool hasLibraryCards;
  final int? groupId;

  Flashcard? get current {
    if (isFinished) return null;
    return cards[index];
  }

  bool get isFinished => cards.isEmpty || index >= cards.length;

  bool get isComplete => answeredCount > 0 && index >= cards.length;

  bool get isEmptyLibrary => cards.isEmpty && !hasLibraryCards;

  bool get isCaughtUp => cards.isEmpty && hasLibraryCards;

  double get progress {
    if (cards.isEmpty) return 0;
    return answeredCount / cards.length;
  }

  StudySession copyWith({
    List<Flashcard>? cards,
    int? index,
    bool? isFlipped,
    int? answeredCount,
    bool? hasLibraryCards,
    int? groupId,
  }) {
    return StudySession(
      cards: cards ?? this.cards,
      index: index ?? this.index,
      isFlipped: isFlipped ?? this.isFlipped,
      answeredCount: answeredCount ?? this.answeredCount,
      hasLibraryCards: hasLibraryCards ?? this.hasLibraryCards,
      groupId: groupId ?? this.groupId,
    );
  }
}
