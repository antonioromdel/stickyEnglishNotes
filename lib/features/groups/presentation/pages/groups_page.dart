import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_collection_palette.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/colored_note_tile.dart';
import '../../../cards/application/cards_providers.dart';
import '../../application/groups_providers.dart';
import '../group_actions.dart';

class GroupsPage extends ConsumerWidget {
  const GroupsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groups = ref.watch(cardGroupsProvider);
    final cards = ref.watch(flashcardsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Grupos')),
      floatingActionButton: FloatingActionButton(
        key: const Key('create-group-button'),
        onPressed: () => createGroup(context, ref),
        tooltip: 'Crear grupo',
        child: const Icon(Icons.add),
      ),
      body: groups.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => const AppEmptyState(
          icon: Icons.error_outline,
          title: 'No se pudieron cargar los grupos',
          message: 'Inténtalo de nuevo más tarde.',
        ),
        data: (items) {
          if (items.isEmpty) {
            return AppEmptyState(
              icon: Icons.folder_outlined,
              title: 'No hay grupos',
              message: 'Crea un grupo para organizar tus tarjetas.',
              actionLabel: 'Crear grupo',
              onAction: () => createGroup(context, ref),
            );
          }

          final counts = <int, int>{};
          cards.maybeWhen(
            data: (allCards) {
              for (final card in allCards) {
                counts[card.groupId] = (counts[card.groupId] ?? 0) + 1;
              }
            },
            orElse: () {},
          );

          return GridView.builder(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.sm,
              AppSpacing.lg,
              AppSpacing.xxxl,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: AppSpacing.md,
              mainAxisSpacing: AppSpacing.md,
              childAspectRatio: 0.92,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final group = items[index];
              final count = counts[group.id] ?? 0;
              final swatch = AppCollectionPalette.forId(
                group.id,
                Theme.of(context).brightness,
              );
              final caption = count == 1 ? '1 tarjeta' : '$count tarjetas';

              return ColoredNoteTile(
                key: Key('group-tile-${group.id}'),
                swatch: swatch,
                caption: caption,
                title: group.name,
                onTap: () => context.push(AppRoutes.groupDetail(group.id)),
                onLongPress: () => showGroupActionsSheet(context, ref, group),
              );
            },
          );
        },
      ),
    );
  }
}
