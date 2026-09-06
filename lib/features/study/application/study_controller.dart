import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/card_enums.dart';
import '../../../data/providers.dart';
import '../../../data/repositories/card_errors_repository.dart';
import '../../../data/repositories/flashcards_repository.dart';
import '../../../data/repositories/reviews_repository.dart';
import '../domain/spaced_repetition_service.dart';
import 'study_session.dart';
import 'study_session_store.dart';

class StudyGroupFilter extends Notifier<int?> {
  @override
  int? build() => null;

  void select(int? groupId) {
    if (state == groupId) return;
    state = groupId;
  }
}

final studyGroupFilterProvider = NotifierProvider<StudyGroupFilter, int?>(
  StudyGroupFilter.new,
);

void startStudySession(
  WidgetRef ref, {
  int? groupId,
  bool forceNew = false,
}) {
  if (forceNew) {
    ref.read(studySessionStoreProvider.notifier).clear();
    ref.read(studyGroupFilterProvider.notifier).select(groupId);
    ref.invalidate(studyControllerProvider);
    return;
  }

  final snapshot = ref.read(studySessionStoreProvider);
  if (snapshot != null && snapshot.isInProgress) {
    ref.read(studyGroupFilterProvider.notifier).select(snapshot.groupId);
    final session = ref.read(studyControllerProvider).value;
    if (session == null || session.isFinished || session.groupId != snapshot.groupId) {
      ref.invalidate(studyControllerProvider);
    }
    return;
  }

  ref.read(studyGroupFilterProvider.notifier).select(groupId);
  ref.invalidate(studyControllerProvider);
}

class StudyController extends AsyncNotifier<StudySession> {
  FlashcardsRepository get _flashcards =>
      ref.read(flashcardsRepositoryProvider);
  ReviewsRepository get _reviews => ref.read(reviewsRepositoryProvider);
  CardErrorsRepository get _errors => ref.read(cardErrorsRepositoryProvider);
  SpacedRepetitionService get _srs => ref.read(spacedRepetitionServiceProvider);

  bool _saving = false;

  @override
  Future<StudySession> build() {
    final groupId = ref.watch(studyGroupFilterProvider);
    return _load(DateTime.now(), groupId: groupId);
  }

  Future<void> restart({DateTime? now}) async {
    await ref.read(studySessionStoreProvider.notifier).clear();
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _load(
        now ?? DateTime.now(),
        groupId: ref.read(studyGroupFilterProvider),
        ignoreSnapshot: true,
      ),
    );
    final session = state.value;
    if (session != null) await _persist(session);
  }

  void flip() {
    final session = state.value;
    if (session == null || session.current == null) return;
    final next = session.copyWith(isFlipped: !session.isFlipped);
    state = AsyncData(next);
    _persist(next);
  }

  Future<void> rate(ReviewRating rating, {DateTime? now}) async {
    final session = state.value;
    final card = session?.current;
    if (session == null || card == null || !session.isFlipped || _saving) {
      return;
    }

    _saving = true;
    final reviewedAt = now ?? DateTime.now();

    try {
      final schedule = _srs.calculateNextReview(
        rating: rating,
        currentIntervalMinutes: card.interval,
        currentRepetitions: card.repetitions,
        now: reviewedAt,
      );
      final wasCorrect = schedule.result == ReviewResult.correct;

      await _flashcards.updateAfterReview(
        card: card,
        intervalMinutes: schedule.intervalMinutes,
        repetitions: schedule.repetitions,
        reviewedAt: reviewedAt,
        nextReviewAt: schedule.nextReviewAt,
        wasCorrect: wasCorrect,
      );
      await _reviews.create(
        cardId: card.id,
        result: schedule.result,
        difficulty: rating,
        previousInterval: card.interval,
        newInterval: schedule.intervalMinutes,
        reviewedAt: reviewedAt,
      );
      if (!wasCorrect) {
        await _errors.create(
          cardId: card.id,
          userAnswer: card.front,
          correctAnswer: card.back,
          createdAt: reviewedAt,
        );
      }

      final next = session.copyWith(
        index: session.index + 1,
        isFlipped: false,
        answeredCount: session.answeredCount + 1,
      );
      await _persist(next);
      if (!ref.mounted) return;
      state = AsyncData(next);
    } finally {
      _saving = false;
    }
  }

  Future<void> _persist(StudySession session) {
    return ref.read(studySessionStoreProvider.notifier).saveFrom(session);
  }

  Future<StudySession> _load(
    DateTime now, {
    int? groupId,
    bool ignoreSnapshot = false,
  }) async {
    if (!ignoreSnapshot) {
      final restored = await _restore(groupId);
      if (restored != null) return restored;
    }

    final due = await _flashcards.getDue(now: now, groupId: groupId);
    if (due.isNotEmpty) {
      final session = StudySession(
        cards: due,
        index: 0,
        isFlipped: false,
        answeredCount: 0,
        hasLibraryCards: true,
        groupId: groupId,
      );
      await _persist(session);
      return session;
    }

    await ref.read(studySessionStoreProvider.notifier).clear();
    final library = groupId == null
        ? await _flashcards.getAll()
        : await _flashcards.getByGroup(groupId);
    return StudySession(
      cards: const [],
      index: 0,
      isFlipped: false,
      answeredCount: 0,
      hasLibraryCards: library.isNotEmpty,
      groupId: groupId,
    );
  }

  Future<StudySession?> _restore(int? groupId) async {
    final snapshot = ref.read(studySessionStoreProvider);
    if (snapshot == null || !snapshot.isInProgress) return null;
    if (snapshot.groupId != groupId) return null;

    final found = await _flashcards.getByIds(snapshot.cardIds);
    if (found.isEmpty) {
      await ref.read(studySessionStoreProvider.notifier).clear();
      return null;
    }

    final byId = {for (final card in found) card.id: card};
    final cards = [
      for (final id in snapshot.cardIds)
        if (byId[id] != null) byId[id]!,
    ];
    final stillBefore = snapshot.cardIds
        .take(snapshot.index)
        .where(byId.containsKey)
        .length;

    final session = StudySession(
      cards: cards,
      index: stillBefore,
      isFlipped: false,
      answeredCount: snapshot.answeredCount,
      hasLibraryCards: true,
      groupId: snapshot.groupId,
    );

    if (session.isFinished) {
      await ref.read(studySessionStoreProvider.notifier).clear();
      return null;
    }

    return session;
  }
}

final spacedRepetitionServiceProvider = Provider<SpacedRepetitionService>((ref) {
  return const SpacedRepetitionService();
});

final studyControllerProvider =
    AsyncNotifierProvider<StudyController, StudySession>(StudyController.new);
