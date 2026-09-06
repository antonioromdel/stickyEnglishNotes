import 'package:flutter_test/flutter_test.dart';
import 'package:stickeenglishnotes/data/database/app_database.dart';
import 'package:stickeenglishnotes/data/models/card_enums.dart';
import 'package:stickeenglishnotes/data/repositories/card_errors_repository.dart';
import 'package:stickeenglishnotes/data/repositories/card_groups_repository.dart';
import 'package:stickeenglishnotes/data/repositories/flashcards_repository.dart';
import 'package:stickeenglishnotes/data/repositories/reviews_repository.dart';

import '../helpers/test_app.dart';

void main() {
  setUpAll(configureTestDrift);

  late AppDatabase database;
  late CardGroupsRepository groups;
  late FlashcardsRepository flashcards;
  late ReviewsRepository reviews;
  late CardErrorsRepository errors;

  setUp(() {
    database = AppDatabase.memory();
    groups = CardGroupsRepository(database);
    flashcards = FlashcardsRepository(database);
    reviews = ReviewsRepository(database);
    errors = CardErrorsRepository(database);
  });

  tearDown(() async {
    await database.close();
  });

  test('crea el grupo General al inicializar la base de datos', () async {
    final all = await groups.getAll();

    expect(all, isNotEmpty);
    expect(all.first.name, 'General');
  });

  test('crea, lee, actualiza y elimina un grupo', () async {
    final created = await groups.create(
      name: 'Viajes',
      description: 'Vocabulario de viaje',
    );

    expect(created.id, greaterThan(0));
    expect(await groups.getById(created.id), isNotNull);

    await groups.updateGroup(id: created.id, name: 'Travel');
    final updated = await groups.getById(created.id);
    expect(updated?.name, 'Travel');

    await groups.delete(created.id);
    expect(await groups.getById(created.id), isNull);
  });

  test('crea flashcards y filtra las pendientes por nextReviewAt', () async {
    final group = (await groups.getAll()).first;
    final now = DateTime.utc(2026, 9, 6, 12);

    final dueCard = await flashcards.create(
      groupId: group.id,
      front: 'apple',
      back: 'manzana',
      now: now.subtract(const Duration(hours: 1)),
    );
    final futureCard = await flashcards.create(
      groupId: group.id,
      front: 'later',
      back: 'después',
      now: now.add(const Duration(days: 2)),
    );

    final due = await flashcards.getDue(now: now);
    final dueIds = due.map((card) => card.id);

    expect(dueIds, contains(dueCard.id));
    expect(dueIds, isNot(contains(futureCard.id)));
  });

  test('watchDueCount incluye una tarjeta creada después de suscribirse', () async {
    final group = (await groups.getAll()).first;
    final counts = <int>[];
    final subscription = flashcards.watchDueCount().listen(counts.add);

    await pumpEventQueue();
    expect(counts, isNotEmpty);
    expect(counts.last, 0);

    await flashcards.create(
      groupId: group.id,
      front: 'hello',
      back: 'hola',
    );
    await pumpEventQueue();

    expect(counts.last, 1);
    await subscription.cancel();
  });

  test('filtra las tarjetas pendientes por grupo', () async {
    final general = (await groups.getAll()).first;
    final verbs = await groups.create(name: 'Verbos');
    final now = DateTime.utc(2026, 9, 6, 12);

    await flashcards.create(
      groupId: general.id,
      front: 'hello',
      back: 'hola',
      now: now,
    );
    final verbCard = await flashcards.create(
      groupId: verbs.id,
      front: 'run',
      back: 'correr',
      now: now,
    );

    final due = await flashcards.getDue(now: now, groupId: verbs.id);

    expect(due, hasLength(1));
    expect(due.single.id, verbCard.id);
  });

  test('al borrar un grupo mueve las tarjetas a General', () async {
    final general = (await groups.getAll()).first;
    final group = await groups.create(name: 'Temporal');
    final card = await flashcards.create(
      groupId: group.id,
      front: 'talk',
      back: 'hablar',
    );

    await reviews.create(
      cardId: card.id,
      result: ReviewResult.incorrect,
      difficulty: ReviewRating.again,
      previousInterval: 0,
      newInterval: 10,
    );
    await errors.create(
      cardId: card.id,
      userAnswer: 'I miss talk',
      correctAnswer: 'I miss talking',
    );

    await groups.delete(group.id);

    expect(await groups.getById(group.id), isNull);
    final moved = await flashcards.getById(card.id);
    expect(moved?.groupId, general.id);
    expect(await reviews.getByCard(card.id), hasLength(1));
    expect(await errors.getByCard(card.id), hasLength(1));
  });

  test('no permite eliminar el grupo General', () async {
    final general = (await groups.getAll()).first;

    await expectLater(groups.delete(general.id), throwsStateError);
    expect(await groups.getById(general.id), isNotNull);
  });

  test('registra reviews y errores de una tarjeta', () async {
    final group = (await groups.getAll()).first;
    final card = await flashcards.create(
      groupId: group.id,
      front: 'because',
      back: 'porque',
    );

    final review = await reviews.create(
      cardId: card.id,
      result: ReviewResult.correct,
      difficulty: ReviewRating.good,
      previousInterval: 0,
      newInterval: 4320,
    );
    final error = await errors.create(
      cardId: card.id,
      userAnswer: 'por que',
      correctAnswer: 'porque',
    );

    expect(review.id, greaterThan(0));
    expect(error.userAnswer, 'por que');
    expect(await reviews.getByCard(card.id), hasLength(1));
    expect(await errors.getByCard(card.id), hasLength(1));

    await errors.deleteByCard(card.id);
    expect(await errors.getByCard(card.id), isEmpty);
    expect(await reviews.getByCard(card.id), hasLength(1));
  });

  test('watchAllWithCards une cada error con su tarjeta', () async {
    final group = (await groups.getAll()).first;
    final card = await flashcards.create(
      groupId: group.id,
      front: 'hello',
      back: 'hola',
    );
    await errors.create(
      cardId: card.id,
      userAnswer: 'hello',
      correctAnswer: 'hola',
    );

    final rows = await errors.watchAllWithCards().first;
    expect(rows, hasLength(1));
    expect(rows.first.card.id, card.id);
    expect(rows.first.card.front, 'hello');
    expect(rows.first.error.correctAnswer, 'hola');
  });

  test('updateAfterReview programa la siguiente revisión', () async {
    final group = (await groups.getAll()).first;
    final now = DateTime.utc(2026, 9, 6, 12);
    final card = await flashcards.create(
      groupId: group.id,
      front: 'apple',
      back: 'manzana',
      now: now,
    );

    await flashcards.updateAfterReview(
      card: card,
      intervalMinutes: 4320,
      repetitions: 1,
      reviewedAt: now,
      nextReviewAt: now.add(const Duration(days: 3)),
      wasCorrect: true,
    );

    final updated = await flashcards.getById(card.id);
    expect(updated?.repetitions, 1);
    expect(updated?.correctAnswers, 1);
    expect(updated?.incorrectAnswers, 0);
    expect(await flashcards.getDue(now: now), isEmpty);
    expect(
      await flashcards.getDue(now: now.add(const Duration(days: 3))),
      isNotEmpty,
    );
  });
}
