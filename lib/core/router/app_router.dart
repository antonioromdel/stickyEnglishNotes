import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/cards/presentation/pages/cards_page.dart';
import '../../features/errors/presentation/pages/errors_page.dart';
import '../../features/cards/presentation/pages/create_card_page.dart';
import '../../features/groups/presentation/pages/group_detail_page.dart';
import '../../features/groups/presentation/pages/groups_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/home/presentation/pages/main_shell.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/statistics/presentation/pages/statistics_page.dart';
import '../../features/study/presentation/pages/study_page.dart';
import 'app_routes.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.home,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.study,
                builder: (context, state) => const StudyPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.progress,
                builder: (context, state) => const StatisticsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.settings,
                builder: (context, state) => const SettingsPage(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.createCard,
        builder: (context, state) {
          final groupId = state.uri.queryParameters['groupId'];
          return CreateCardPage(
            initialGroupId: groupId == null ? null : int.tryParse(groupId),
          );
        },
      ),
      GoRoute(
        path: '/cards/:cardId/edit',
        builder: (context, state) {
          return CreateCardPage(
            cardId: int.parse(state.pathParameters['cardId']!),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.cards,
        builder: (context, state) => const CardsPage(),
      ),
      GoRoute(
        path: AppRoutes.errors,
        builder: (context, state) => const ErrorsPage(),
      ),
      GoRoute(
        path: AppRoutes.groups,
        builder: (context, state) => const GroupsPage(),
        routes: [
          GoRoute(
            path: ':groupId',
            builder: (context, state) {
              final groupId = int.parse(state.pathParameters['groupId']!);
              return GroupDetailPage(groupId: groupId);
            },
          ),
        ],
      ),
    ],
  );
});
