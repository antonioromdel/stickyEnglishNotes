import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stickeenglishnotes/core/theme/theme_controller.dart';
import 'package:stickeenglishnotes/data/database/app_database.dart';
import 'package:stickeenglishnotes/data/models/card_enums.dart';
import 'package:stickeenglishnotes/data/providers.dart';
import 'package:stickeenglishnotes/data/repositories/card_errors_repository.dart';
import 'package:stickeenglishnotes/data/repositories/card_groups_repository.dart';
import 'package:stickeenglishnotes/data/repositories/flashcards_repository.dart';
import 'package:stickeenglishnotes/data/repositories/reviews_repository.dart';
import 'package:stickeenglishnotes/features/home/application/home_providers.dart';
import 'package:stickeenglishnotes/features/statistics/application/statistics_providers.dart';
import 'package:stickeenglishnotes/features/study/application/study_controller.dart';
import 'package:stickeenglishnotes/features/study/domain/spaced_repetition_service.dart';

import '../../helpers/test_app.dart';

void main() {
  setUpAll(configureTestDrift);

  late AppDatabase database;
  late ProviderContainer container;
  late FlashcardsRepository flashcards;
  late SharedPreferences preferences;
  final now = DateTime.utc(2026, 9, 6, 12);

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    preferences = await SharedPreferences.getInstance();
    database = AppDatabase.memory();
    flashcards = FlashcardsRepository(database);
    final group = (await CardGroupsRepository(database).getAll()).first;
    await flashcards.create(
      groupId: group.id,
      front: 'hello',
      back: 'hola',
      now: now,
    );

    container = ProviderContainer.test(
      overrides: [
        sharedPreferencesProvider.overrideWith((ref) => preferences),
        appDatabaseProvider.overrideWith((ref) => database),
      ],
    );
  });

  tearDown(() async {
    container.dispose();
    await database.close();
  });

  test('carga las tarjetas pendientes y avanza al valorar', () async {
    final session = await container.read(studyControllerProvider.future);
    expect(session.cards, hasLength(1));
    expect(session.isFlipped, isFalse);

    container.read(studyControllerProvider.notifier).flip();
    expect(container.read(studyControllerProvider).value?.isFlipped, isTrue);

    await container.read(studyControllerProvider.notifier).rate(
          ReviewRating.good,
          now: now,
        );

    final after = container.read(studyControllerProvider).value;
    expect(after?.isComplete, isTrue);
    expect(after?.answeredCount, 1);

    final reviews = await ReviewsRepository(database).getAll();
    expect(reviews, hasLength(1));
    expect(reviews.single.difficulty, ReviewRating.good);
    expect(reviews.single.newInterval, SpacedRepetitionService.goodMinutes);

    expect(await flashcards.getDue(now: now), isEmpty);
    expect(await CardErrorsRepository(database).getAll(), isEmpty);
  });

  test('Again no se cuelga si Inicio y Progreso están escuchando', () async {
    container.listen(studyStreakProvider, (_, next) {});
    container.listen(dueFlashcardsCountProvider, (_, next) {});
    container.listen(homePreviewCardProvider, (_, next) {});
    container.listen(studyStatsProvider, (_, next) {});

    await container.read(studyControllerProvider.future);
    container.read(studyControllerProvider.notifier).flip();

    await container.read(studyControllerProvider.notifier).rate(
          ReviewRating.again,
          now: now,
        ).timeout(const Duration(seconds: 3));

    final after = container.read(studyControllerProvider).value;
    expect(after?.isComplete, isTrue);
    expect(await CardErrorsRepository(database).getAll(), hasLength(1));
  });

  test('Again registra un error y deja la tarjeta pendiente en 5 minutos', () async {
    await container.read(studyControllerProvider.future);
    container.read(studyControllerProvider.notifier).flip();
    await container.read(studyControllerProvider.notifier).rate(
          ReviewRating.again,
          now: now,
        );

    final errors = await CardErrorsRepository(database).getAll();
    expect(errors, hasLength(1));
    expect(errors.single.correctAnswer, 'hola');

    expect(await flashcards.getDue(now: now), isEmpty);
    expect(
      await flashcards.getDue(now: now.add(const Duration(minutes: 5))),
      hasLength(1),
    );
  });

  test('carga solo las pendientes del grupo elegido', () async {
    final verbs = await CardGroupsRepository(database).create(name: 'Verbos');
    await flashcards.create(
      groupId: verbs.id,
      front: 'run',
      back: 'correr',
      now: now,
    );

    container.read(studyGroupFilterProvider.notifier).select(verbs.id);
    final session = await container.read(studyControllerProvider.future);

    expect(session.groupId, verbs.id);
    expect(session.cards, hasLength(1));
    expect(session.cards.single.front, 'run');
  });

  test('reanuda una sesión a medias con las tarjetas que faltaban', () async {
    final group = (await CardGroupsRepository(database).getAll()).first;
    await flashcards.create(
      groupId: group.id,
      front: 'because',
      back: 'porque',
      now: now,
    );

    final first = await container.read(studyControllerProvider.future);
    expect(first.cards, hasLength(2));

    container.read(studyControllerProvider.notifier).flip();
    await container.read(studyControllerProvider.notifier).rate(
          ReviewRating.good,
          now: now,
        );

    final mid = container.read(studyControllerProvider).value;
    expect(mid?.answeredCount, 1);
    expect(mid?.isFinished, isFalse);

    final resumed = ProviderContainer.test(
      overrides: [
        sharedPreferencesProvider.overrideWith((ref) => preferences),
        appDatabaseProvider.overrideWith((ref) => database),
      ],
    );
    addTearDown(resumed.dispose);

    final session = await resumed.read(studyControllerProvider.future);
    expect(session.answeredCount, 1);
    expect(session.cards, hasLength(2));
    expect(session.index, 1);
    expect(session.current, isNotNull);
    expect(session.isFinished, isFalse);
  });
}
