import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../data/repositories/card_groups_repository.dart';
import '../../../cards/application/cards_providers.dart';
import '../../../cards/presentation/widgets/browse_flashcards_grid.dart';
import '../../../study/application/study_controller.dart';
import '../../application/groups_providers.dart';
import '../group_actions.dart';

class GroupDetailPage extends ConsumerWidget {
  const GroupDetailPage({super.key, required this.groupId});

  final int groupId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groups = ref.watch(cardGroupsProvider);
    final cards = ref.watch(flashcardsByGroupProvider(groupId));
    final group = groups.maybeWhen(
      data: (items) {
        for (final item in items) {
          if (item.id == groupId) return item;
        }
        return null;
      },
      orElse: () => null,
    );
    final groupName = group?.name ?? 'Grupo';

    return Scaffold(
      appBar: AppBar(
        title: Text(groupName),
        actions: [
          if (group != null)
            PopupMenuButton<String>(
              key: const Key('group-detail-menu'),
              onSelected: (value) async {
                if (value == 'rename') {
                  await renameGroup(context, ref, group);
                } else if (value == 'delete') {
                  final deleted = await deleteGroup(context, ref, group);
                  if (deleted && context.mounted && Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  }
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'rename',
                  child: Text('Renombrar'),
                ),
                if (!CardGroupsRepository.isDefault(group))
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text('Eliminar'),
                  ),
              ],
            ),
        ],
      ),
      floatingActionButton: cards.maybeWhen(
        data: (items) => items.isEmpty
            ? null
            : FloatingActionButton(
                onPressed: () =>
                    context.push(AppRoutes.createCardInGroup(groupId)),
                tooltip: 'Crear tarjeta',
                child: const Icon(Icons.add),
              ),
        orElse: () => null,
      ),
      body: cards.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => const AppEmptyState(
          icon: Icons.error_outline,
          title: 'No se pudieron cargar las tarjetas',
          message: 'Inténtalo de nuevo más tarde.',
        ),
        data: (items) {
          if (items.isEmpty) {
            return AppEmptyState(
              icon: Icons.style_outlined,
              title: 'Este grupo está vacío',
              message: 'Crea una tarjeta para empezar a llenarlo.',
              actionLabel: 'Crear tarjeta',
              onAction: () =>
                  context.push(AppRoutes.createCardInGroup(groupId)),
            );
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.sm,
                  AppSpacing.lg,
                  AppSpacing.md,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    key: const Key('study-group-button'),
                    onPressed: () {
                      startStudySession(ref, groupId: groupId, forceNew: true);
                      context.go(AppRoutes.study);
                    },
                    icon: const Icon(Icons.menu_book_rounded),
                    label: const Text('Estudiar este grupo'),
                  ),
                ),
              ),
              Expanded(child: BrowseFlashcardsGrid(cards: items)),
            ],
          );
        },
      ),
    );
  }
}
