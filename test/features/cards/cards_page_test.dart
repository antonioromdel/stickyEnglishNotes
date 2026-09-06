import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stickeenglishnotes/core/theme/app_theme.dart';
import 'package:stickeenglishnotes/core/theme/theme_controller.dart';
import 'package:stickeenglishnotes/core/tts/tts_controller.dart';
import 'package:stickeenglishnotes/features/cards/application/cards_providers.dart';
import 'package:stickeenglishnotes/features/cards/presentation/pages/cards_page.dart';
import 'package:stickeenglishnotes/features/groups/application/groups_providers.dart';

import '../../helpers/fake_tts.dart';
import '../../helpers/test_data.dart';

void main() {
  Future<SharedPreferences> prefs() async {
    SharedPreferences.setMockInitialValues({});
    return SharedPreferences.getInstance();
  }

  testWidgets('muestra solo el frente de las tarjetas', (tester) async {
    final preferences = await prefs();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWith((ref) => preferences),
          textToSpeechServiceProvider.overrideWith((ref) => FakeTextToSpeechService()),
          cardGroupsProvider.overrideWith(
            (ref) => Stream.value([testGroup()]),
          ),
          flashcardsProvider.overrideWith(
            (ref) => Stream.value([
              testFlashcard(front: 'because', back: 'porque'),
            ]),
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          home: const CardsPage(),
        ),
      ),
    );
    await tester.pump();
    await tester.pump();

    expect(find.text('because'), findsOneWidget);
    expect(find.text('porque'), findsNothing);

    await tester.tap(find.text('because'));
    await tester.pumpAndSettle();

    expect(find.text('because'), findsWidgets);
    expect(find.byKey(const Key('preview-close-button')), findsOneWidget);
  });

  testWidgets('filtra las tarjetas por grupo', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          cardGroupsProvider.overrideWith(
            (ref) => Stream.value([
              testGroup(id: 1, name: 'General'),
              testGroup(id: 2, name: 'Verbos'),
            ]),
          ),
          flashcardsProvider.overrideWith(
            (ref) => Stream.value([
              testFlashcard(id: 1, groupId: 1, front: 'hello', back: 'hola'),
              testFlashcard(id: 2, groupId: 2, front: 'run', back: 'correr'),
            ]),
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          home: const CardsPage(),
        ),
      ),
    );
    await tester.pump();
    await tester.pump();

    expect(find.text('Filtrar por grupo'), findsOneWidget);
    expect(find.byKey(const Key('cards-filter-selected')), findsNothing);
    expect(find.text('hello'), findsOneWidget);
    expect(find.text('run'), findsOneWidget);

    await tester.tap(find.byKey(const Key('cards-filter-button')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('cards-filter-group-list')), findsOneWidget);
    await tester.tap(find.byKey(const Key('cards-filter-group-2')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('cards-filter-selected')), findsOneWidget);
    expect(find.text('Verbos'), findsOneWidget);
    expect(find.text('run'), findsOneWidget);
    expect(find.text('hello'), findsNothing);
    expect(find.text('correr'), findsNothing);

    await tester.tap(find.byTooltip('Quitar filtro'));
    await tester.pump();

    expect(find.byKey(const Key('cards-filter-selected')), findsNothing);
    expect(find.text('hello'), findsOneWidget);
    expect(find.text('run'), findsOneWidget);
  });
}
