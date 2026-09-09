import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:stickeenglishnotes/core/theme/app_theme.dart';
import 'package:stickeenglishnotes/features/cards/application/cards_providers.dart';
import 'package:stickeenglishnotes/features/groups/application/groups_providers.dart';
import 'package:stickeenglishnotes/features/groups/presentation/pages/group_detail_page.dart';
import 'package:stickeenglishnotes/features/groups/presentation/pages/groups_page.dart';

import '../../helpers/test_data.dart';

void main() {
  testWidgets('muestra los grupos en grid y abre el detalle', (tester) async {
    final router = GoRouter(
      initialLocation: '/groups',
      routes: [
        GoRoute(
          path: '/groups',
          builder: (context, state) => const GroupsPage(),
          routes: [
            GoRoute(
              path: ':groupId',
              builder: (context, state) {
                return GroupDetailPage(
                  groupId: int.parse(state.pathParameters['groupId']!),
                );
              },
            ),
          ],
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          cardGroupsProvider.overrideWith(
            (ref) => Stream.value([testGroup()]),
          ),
          flashcardsProvider.overrideWith(
            (ref) => Stream.value([
              testFlashcard(front: 'hello', back: 'hola'),
            ]),
          ),
          flashcardsByGroupProvider(1).overrideWith(
            (ref) => Stream.value([
              testFlashcard(front: 'hello', back: 'hola'),
            ]),
          ),
          cardGroupMembershipsProvider.overrideWith(
            (ref) => Stream.value([
              testMembership(cardId: 1, groupId: 1),
            ]),
          ),
        ],
        child: MaterialApp.router(
          theme: AppTheme.light,
          routerConfig: router,
        ),
      ),
    );
    await tester.pump();
    await tester.pump();

    expect(find.text('General'), findsOneWidget);
    expect(find.text('1 tarjeta'), findsOneWidget);
    expect(find.text('hola'), findsNothing);

    await tester.tap(find.text('General'));
    await tester.pumpAndSettle();

    expect(find.text('hello'), findsOneWidget);
    expect(find.text('hola'), findsNothing);
  });

  testWidgets('muestra el botón para crear un grupo', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          cardGroupsProvider.overrideWith(
            (ref) => Stream.value([testGroup()]),
          ),
          flashcardsProvider.overrideWith((ref) => Stream.value([])),
          cardGroupMembershipsProvider.overrideWith((ref) => Stream.value([])),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          home: const GroupsPage(),
        ),
      ),
    );
    await tester.pump();
    await tester.pump();

    expect(find.byKey(const Key('create-group-button')), findsOneWidget);
  });
}
