import 'package:flutter_test/flutter_test.dart';
import 'package:stickeenglishnotes/data/models/card_enums.dart';
import 'package:stickeenglishnotes/features/cards/domain/card_draft.dart';

void main() {
  test('es válido cuando frente y reverso tienen texto', () {
    const draft = CardDraft(front: ' hello ', back: ' hola ');

    expect(draft.isValid, isTrue);
    expect(draft.trimmedFront, 'hello');
    expect(draft.trimmedBack, 'hola');
    expect(draft.trimmedExample, isNull);
  });

  test('rechaza frente o reverso vacíos', () {
    const emptyFront = CardDraft(front: '   ', back: 'hola');
    const emptyBack = CardDraft(front: 'hello', back: '');

    expect(emptyFront.isValid, isFalse);
    expect(emptyFront.frontError, 'Escribe el frente');
    expect(emptyBack.isValid, isFalse);
    expect(emptyBack.backError, 'Escribe el reverso');
  });

  test('normaliza el ejemplo vacío a null', () {
    const draft = CardDraft(
      front: 'hello',
      back: 'hola',
      example: '  ',
      type: FlashcardType.phrase,
    );

    expect(draft.trimmedExample, isNull);
    expect(draft.type, FlashcardType.phrase);
  });
}
