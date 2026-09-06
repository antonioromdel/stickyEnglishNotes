import 'package:flutter_test/flutter_test.dart';
import 'package:stickeenglishnotes/features/cards/application/cards_providers.dart';

import '../../helpers/test_data.dart';

void main() {
  final cards = [
    testFlashcard(id: 1, groupId: 1, front: 'hello'),
    testFlashcard(id: 2, groupId: 2, front: 'run'),
  ];

  test('sin grupo muestra todas las tarjetas', () {
    expect(filterFlashcardsByGroup(cards, null), cards);
  });

  test('con grupo muestra solo las tarjetas de ese grupo', () {
    final filtered = filterFlashcardsByGroup(cards, 2);

    expect(filtered, hasLength(1));
    expect(filtered.single.front, 'run');
  });
}
