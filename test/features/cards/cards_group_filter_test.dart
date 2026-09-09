import 'package:flutter_test/flutter_test.dart';
import 'package:stickeenglishnotes/features/cards/application/cards_providers.dart';

import '../../helpers/test_data.dart';

void main() {
  final cards = [
    testFlashcard(id: 1, front: 'hello'),
    testFlashcard(id: 2, front: 'run'),
  ];
  final groupsByCard = {
    1: {1},
    2: {2},
  };

  test('sin grupo muestra todas las tarjetas', () {
    expect(filterFlashcardsByGroup(cards, null, groupsByCard), cards);
  });

  test('con grupo muestra solo las tarjetas de ese grupo', () {
    final filtered = filterFlashcardsByGroup(cards, 2, groupsByCard);

    expect(filtered, hasLength(1));
    expect(filtered.single.front, 'run');
  });

  test('una tarjeta en varios grupos aparece en cada uno', () {
    final shared = [
      testFlashcard(id: 3, front: 'because'),
    ];
    final memberships = {
      3: {1, 2},
    };

    expect(filterFlashcardsByGroup(shared, 1, memberships), shared);
    expect(filterFlashcardsByGroup(shared, 2, memberships), shared);
    expect(filterFlashcardsByGroup(shared, 3, memberships), isEmpty);
  });
}
