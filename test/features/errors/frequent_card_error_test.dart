import 'package:flutter_test/flutter_test.dart';
import 'package:stickeenglishnotes/features/errors/domain/frequent_card_error.dart';

import '../../helpers/test_data.dart';

void main() {
  final now = DateTime.utc(2026, 9, 6, 18);

  test('agrupa fallos de la misma tarjeta y prioriza los más frecuentes', () {
    final cardA = testFlashcard(id: 1, front: 'hello', back: 'hola');
    final cardB = testFlashcard(id: 2, front: 'because', back: 'porque');
    final rows = [
      (
        error: testCardError(
          id: 1,
          cardId: 1,
          userAnswer: 'hello',
          correctAnswer: 'hola',
          createdAt: now,
        ),
        card: cardA,
      ),
      (
        error: testCardError(
          id: 2,
          cardId: 2,
          userAnswer: 'because',
          correctAnswer: 'porque',
          createdAt: now.subtract(const Duration(hours: 1)),
        ),
        card: cardB,
      ),
      (
        error: testCardError(
          id: 3,
          cardId: 2,
          userAnswer: 'becose',
          correctAnswer: 'porque',
          createdAt: now.subtract(const Duration(days: 1)),
        ),
        card: cardB,
      ),
      (
        error: testCardError(
          id: 4,
          cardId: 2,
          userAnswer: 'becouse',
          correctAnswer: 'porque',
          createdAt: now.subtract(const Duration(days: 2)),
        ),
        card: cardB,
      ),
    ];

    final grouped = groupFrequentErrors(rows);

    expect(grouped, hasLength(2));
    expect(grouped.first.card.id, 2);
    expect(grouped.first.times, 3);
    expect(grouped.first.lastAt, now.subtract(const Duration(hours: 1)));
    expect(grouped.first.lastCorrectAnswer, 'porque');
    expect(grouped.last.card.id, 1);
    expect(grouped.last.times, 1);
  });

  test('describe la recencia del último fallo', () {
    expect(errorRecencyLabel(now, now), 'Hoy');
    expect(
      errorRecencyLabel(now.subtract(const Duration(days: 1)), now),
      'Ayer',
    );
    expect(
      errorRecencyLabel(now.subtract(const Duration(days: 4)), now),
      'Hace 4 días',
    );
  });
}
