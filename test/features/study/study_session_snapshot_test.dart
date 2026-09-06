import 'package:flutter_test/flutter_test.dart';
import 'package:stickeenglishnotes/features/study/domain/study_session_snapshot.dart';

void main() {
  test('codifica y restaura una sesión a medias', () {
    const snapshot = StudySessionSnapshot(
      cardIds: [4, 8, 15],
      index: 1,
      answeredCount: 1,
      groupId: 2,
    );

    final restored = StudySessionSnapshot.decode(snapshot.encode());

    expect(restored, snapshot);
    expect(restored?.isInProgress, isTrue);
  });

  test('una sesión terminada no está en curso', () {
    const snapshot = StudySessionSnapshot(
      cardIds: [1],
      index: 1,
      answeredCount: 1,
    );

    expect(snapshot.isInProgress, isFalse);
    expect(StudySessionSnapshot.decode(''), isNull);
  });
}
