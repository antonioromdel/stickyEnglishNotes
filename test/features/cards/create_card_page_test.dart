import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stickeenglishnotes/core/theme/theme_controller.dart';
import 'package:stickeenglishnotes/data/database/app_database.dart';
import 'package:stickeenglishnotes/data/providers.dart';
import 'package:stickeenglishnotes/data/repositories/card_groups_repository.dart';
import 'package:stickeenglishnotes/data/repositories/flashcards_repository.dart';
import 'package:stickeenglishnotes/features/cards/presentation/pages/create_card_page.dart';
import 'package:stickeenglishnotes/features/groups/application/groups_providers.dart';

import '../../helpers/test_app.dart';

void main() {
  setUpAll(configureTestDrift);

  Future<AppDatabase> pumpCreatePage(
    WidgetTester tester, {
    AppDatabase? database,
    List<CardGroup>? groups,
  }) async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final db = database ?? AppDatabase.memory();
    final groupList = groups ?? await CardGroupsRepository(db).getAll();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWith((ref) => preferences),
          appDatabaseProvider.overrideWith((ref) {
            ref.onDispose(db.close);
            return db;
          }),
          cardGroupsProvider.overrideWith((ref) => Stream.value(groupList)),
        ],
        child: MaterialApp(
          home: Builder(
            builder: (context) {
              return Scaffold(
                body: Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const CreateCardPage(),
                        ),
                      );
                    },
                    child: const Text('Abrir'),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.tap(find.text('Abrir'));
    await tester.pump();
    await tester.pump();
    return db;
  }

  testWidgets('muestra error si el frente está vacío', (tester) async {
    await pumpCreatePage(tester);

    await tester.tap(find.byKey(const Key('card-save-button')));
    await tester.pump();

    expect(find.text('Escribe el frente'), findsOneWidget);
    expect(find.text('Escribe el reverso'), findsOneWidget);

    await disposeTestApp(tester);
  });

  testWidgets('guarda la tarjeta y muestra feedback', (tester) async {
    final database = await pumpCreatePage(tester);

    await tester.enterText(find.byKey(const Key('card-front-field')), 'hello');
    await tester.enterText(find.byKey(const Key('card-back-field')), 'hola');
    await tester.tap(find.byKey(const Key('card-save-button')));
    await tester.pump();
    await tester.pump();

    expect(find.byType(CreateCardPage), findsNothing);
    expect(find.text('Tarjeta guardada'), findsOneWidget);

    final cards = await FlashcardsRepository(database).getAll();
    expect(cards, hasLength(1));
    expect(cards.single.front, 'hello');
    expect(cards.single.back, 'hola');

    await disposeTestApp(tester);
  });

  testWidgets('permite elegir el grupo de la tarjeta', (tester) async {
    final database = AppDatabase.memory();
    final verbs = await CardGroupsRepository(database).create(name: 'Verbos');
    final groups = await CardGroupsRepository(database).getAll();

    await pumpCreatePage(tester, database: database, groups: groups);

    await tester.ensureVisible(find.byKey(const Key('card-group-button')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('card-group-button')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key('group-picker-${verbs.id}')));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('card-front-field')), 'run');
    await tester.enterText(find.byKey(const Key('card-back-field')), 'correr');
    await tester.tap(find.byKey(const Key('card-save-button')));
    await tester.pump();
    await tester.pump();

    final cards = await FlashcardsRepository(database).getAll();
    expect(cards.single.groupId, verbs.id);

    await disposeTestApp(tester);
  });
}
