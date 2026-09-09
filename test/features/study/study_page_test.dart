import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stickeenglishnotes/core/theme/theme_controller.dart';
import 'package:stickeenglishnotes/core/tts/tts_controller.dart';
import 'package:stickeenglishnotes/data/database/app_database.dart';
import 'package:stickeenglishnotes/data/providers.dart';
import 'package:stickeenglishnotes/data/repositories/card_groups_repository.dart';
import 'package:stickeenglishnotes/data/repositories/flashcards_repository.dart';
import 'package:stickeenglishnotes/features/groups/application/groups_providers.dart';
import 'package:stickeenglishnotes/features/study/presentation/pages/study_page.dart';

import '../../helpers/fake_tts.dart';
import '../../helpers/test_app.dart';
import '../../helpers/test_data.dart';

void main() {
  setUpAll(configureTestDrift);

  Future<void> pumpStudyPage(
    WidgetTester tester,
    AppDatabase database, {
    List<CardGroup>? groups,
  }) async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWith((ref) => preferences),
          textToSpeechServiceProvider.overrideWith((ref) => FakeTextToSpeechService()),
          appDatabaseProvider.overrideWith((ref) {
            ref.onDispose(database.close);
            return database;
          }),
          cardGroupsProvider.overrideWith(
            (ref) => Stream.value(groups ?? [testGroup()]),
          ),
        ],
        child: const MaterialApp(home: StudyPage()),
      ),
    );
    await tester.pump();
    await tester.pump();
  }

  testWidgets('completa una sesión al valorar una tarjeta', (tester) async {
    final database = AppDatabase.memory();
    final group = (await CardGroupsRepository(database).getAll()).first;
    await FlashcardsRepository(database).create(
      groupIds: {group.id},
      front: 'hello',
      back: 'hola',
    );

    await pumpStudyPage(tester, database);

    expect(find.text('hello'), findsOneWidget);
    expect(find.text('0 / 1'), findsOneWidget);
    expect(find.byKey(const Key('audio-button-study-front-1')), findsOneWidget);

    await tester.tap(find.text('hello'));
    await tester.pump();

    expect(find.text('Bien'), findsOneWidget);
    await tester.tap(find.byKey(const Key('rating-good')));
    await tester.pump();
    await tester.pump();

    expect(find.text('Sesión terminada'), findsOneWidget);
    expect(find.text('Has estudiado 1 tarjeta'), findsOneWidget);

    await disposeTestApp(tester);
  });

  testWidgets('completa la sesión al fallar una tarjeta', (tester) async {
    final database = AppDatabase.memory();
    final group = (await CardGroupsRepository(database).getAll()).first;
    await FlashcardsRepository(database).create(
      groupIds: {group.id},
      front: 'because',
      back: 'porque',
    );

    await pumpStudyPage(tester, database);

    await tester.tap(find.text('because'));
    await tester.pump();

    await tester.tap(find.byKey(const Key('rating-again')));
    await tester.pump();
    await tester.pump();

    expect(find.text('Sesión terminada'), findsOneWidget);
    expect(find.text('Has estudiado 1 tarjeta'), findsOneWidget);

    await disposeTestApp(tester);
  });

  testWidgets('filtra la sesión por grupo', (tester) async {
    final database = AppDatabase.memory();
    final groupsRepo = CardGroupsRepository(database);
    final general = (await groupsRepo.getAll()).first;
    final verbs = await groupsRepo.create(name: 'Verbos');
    final cards = FlashcardsRepository(database);
    await cards.create(groupIds: {general.id}, front: 'hello', back: 'hola');
    await cards.create(groupIds: {verbs.id}, front: 'run', back: 'correr');

    await pumpStudyPage(tester, database, groups: [general, verbs]);

    expect(find.text('hello'), findsOneWidget);

    await tester.tap(find.byKey(const Key('study-group-filter')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key('group-picker-${verbs.id}')));
    await tester.pump();
    await tester.pump();

    expect(find.text('run'), findsOneWidget);
    expect(find.text('hello'), findsNothing);
    expect(find.byKey(const Key('study-group-selected')), findsOneWidget);

    await disposeTestApp(tester);
  });
}
