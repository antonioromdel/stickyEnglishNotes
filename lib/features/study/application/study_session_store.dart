import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/theme_controller.dart';
import '../domain/study_session_snapshot.dart';
import 'study_session.dart';

class StudySessionStore extends Notifier<StudySessionSnapshot?> {
  @override
  StudySessionSnapshot? build() {
    return StudySessionSnapshot.decode(
      ref.read(sharedPreferencesProvider).getString(StudySessionSnapshot.storageKey),
    );
  }

  Future<void> saveFrom(StudySession session) async {
    if (session.isFinished || session.cards.isEmpty) {
      await clear();
      return;
    }

    final snapshot = StudySessionSnapshot(
      cardIds: [for (final card in session.cards) card.id],
      index: session.index,
      answeredCount: session.answeredCount,
      groupId: session.groupId,
    );
    await ref.read(sharedPreferencesProvider).setString(
          StudySessionSnapshot.storageKey,
          snapshot.encode(),
        );
    state = snapshot;
  }

  Future<void> clear() async {
    await ref.read(sharedPreferencesProvider).remove(StudySessionSnapshot.storageKey);
    state = null;
  }
}

final studySessionStoreProvider =
    NotifierProvider<StudySessionStore, StudySessionSnapshot?>(
  StudySessionStore.new,
);
