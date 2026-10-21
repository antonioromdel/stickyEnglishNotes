import 'package:flutter_test/flutter_test.dart';
import 'package:stickeenglishnotes/features/cards/application/cards_providers.dart';

import '../../helpers/test_data.dart';

void main() {
  final cards = [
    testFlashcard(id: 1, front: 'hello', back: 'hola'),
    testFlashcard(id: 2, front: 'because', back: 'porque'),
  ];

  test('con menos de 3 caracteres no filtra', () {
    expect(filterFlashcardsByText(cards, ''), cards);
    expect(filterFlashcardsByText(cards, 'ho'), cards);
    expect(filterFlashcardsByText(cards, '  ho  '), cards);
  });

  test('busca en el frente sin distinguir mayúsculas', () {
    final filtered = filterFlashcardsByText(cards, 'HEL');

    expect(filtered, hasLength(1));
    expect(filtered.single.front, 'hello');
  });

  test('busca en el reverso', () {
    final filtered = filterFlashcardsByText(cards, 'por');

    expect(filtered, hasLength(1));
    expect(filtered.single.front, 'because');
  });

  test('sin coincidencias devuelve una lista vacía', () {
    expect(filterFlashcardsByText(cards, 'xyz'), isEmpty);
  });
}
