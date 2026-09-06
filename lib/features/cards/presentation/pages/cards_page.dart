import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../data/database/app_database.dart';
import '../../../groups/application/groups_providers.dart';
import '../../application/cards_providers.dart';
import '../widgets/browse_flashcards_grid.dart';
import '../widgets/cards_group_filter_bar.dart';

class CardsPage extends ConsumerWidget {
  const CardsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cards = ref.watch(flashcardsProvider);
    final groups = ref.watch(cardGroupsProvider);
    final selectedGroupId = ref.watch(cardsGroupFilterProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Tarjetas')),
      floatingActionButton: cards.maybeWhen(
        data: (items) => items.isEmpty
            ? null
            : FloatingActionButton(
                onPressed: () => context.push(AppRoutes.createCard),
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
          final groupsList = groups.maybeWhen(
            data: (value) => value,
            orElse: () => const <CardGroup>[],
          );
          final visible = filterFlashcardsByGroup(items, selectedGroupId);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (groupsList.isNotEmpty)
                CardsGroupFilterBar(
                  groups: groupsList,
                  selectedGroupId: selectedGroupId,
                  onSelected: (groupId) {
                    ref.read(cardsGroupFilterProvider.notifier).select(groupId);
                  },
                ),
              Expanded(child: _CardsBody(allCards: items, visibleCards: visible)),
            ],
          );
        },
      ),
    );
  }
}

class _CardsBody extends StatelessWidget {
  const _CardsBody({
    required this.allCards,
    required this.visibleCards,
  });

  final List<Flashcard> allCards;
  final List<Flashcard> visibleCards;

  @override
  Widget build(BuildContext context) {
    if (allCards.isEmpty) {
      return AppEmptyState(
        icon: Icons.style_outlined,
        title: 'No tienes tarjetas todavía.',
        message: 'Crea tu primera tarjeta para comenzar a estudiar.',
        actionLabel: 'Crear tarjeta',
        onAction: () => context.push(AppRoutes.createCard),
      );
    }

    if (visibleCards.isEmpty) {
      return const AppEmptyState(
        icon: Icons.filter_alt_outlined,
        title: 'No hay tarjetas en este grupo',
        message: 'Prueba con otro grupo o crea una tarjeta nueva.',
      );
    }

    return BrowseFlashcardsGrid(cards: visibleCards);
  }
}
