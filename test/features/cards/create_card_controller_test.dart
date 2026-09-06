import 'package:flutter_test/flutter_test.dart';
import 'package:stickeenglishnotes/data/database/app_database.dart';
import 'package:stickeenglishnotes/data/models/card_enums.dart';
import 'package:stickeenglishnotes/data/repositories/card_groups_repository.dart';
import 'package:stickeenglishnotes/data/repositories/flashcards_repository.dart';
import 'package:stickeenglishnotes/features/cards/application/create_card_controller.dart';
import 'package:stickeenglishnotes/features/cards/domain/card_draft.dart';

import '../../helpers/test_app.dart';

void main() {
  late AppDatabase database;
  late CreateCardController controller;
  late FlashcardsRepository flashcards;

  setUpAll(configureTestDrift);

  setUp(() {
    database = AppDatabase.memory();
    flashcards = FlashcardsRepository(database);
    controller = CreateCardController(
      flashcards,
      CardGroupsRepository(database),
    );
  });

  tearDown(() async {
    await database.close();
  });

  test('guarda una tarjeta en el grupo General', () async {
    final card = await controller.create(
      const CardDraft(
        front: '  because  ',
        back: '  porque  ',
        example: 'I stayed because it was raining.',
        type: FlashcardType.word,
      ),
    );

    expect(card.front, 'because');
    expect(card.back, 'porque');
    expect(card.example, 'I stayed because it was raining.');
    expect(card.source, CardSource.manual);

    final group = await CardGroupsRepository(database).getById(card.groupId);
    expect(group?.name, 'General');
    expect(await flashcards.getAll(), hasLength(1));
  });

  test('no crea la tarjeta si el borrador no es válido', () async {
    expect(
      () => controller.create(const CardDraft(front: '', back: 'hola')),
      throwsArgumentError,
    );
    expect(await flashcards.getAll(), isEmpty);
  });

  test('guarda la tarjeta en el grupo elegido', () async {
    final verbs = await CardGroupsRepository(database).create(name: 'Verbos');

    final card = await controller.create(
      CardDraft(
        front: 'run',
        back: 'correr',
        groupId: verbs.id,
      ),
    );

    expect(card.groupId, verbs.id);
  });

  test('actualiza el contenido y el grupo de una tarjeta', () async {
    final verbs = await CardGroupsRepository(database).create(name: 'Verbos');
    final created = await controller.create(
      const CardDraft(front: 'run', back: 'correr'),
    );

    final updated = await controller.update(
      cardId: created.id,
      draft: CardDraft(
        front: 'running',
        back: 'corriendo',
        groupId: verbs.id,
      ),
    );

    expect(updated.front, 'running');
    expect(updated.back, 'corriendo');
    expect(updated.groupId, verbs.id);
  });

  test('elimina una tarjeta', () async {
    final created = await controller.create(
      const CardDraft(front: 'run', back: 'correr'),
    );

    await controller.delete(created.id);

    expect(await flashcards.getById(created.id), isNull);
  });
}
