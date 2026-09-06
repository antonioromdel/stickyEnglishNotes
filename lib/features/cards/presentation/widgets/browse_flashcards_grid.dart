import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_collection_palette.dart';
import '../../../../core/widgets/app_confirm_dialog.dart';
import '../../../../core/widgets/colored_note_tile.dart';
import '../../../../data/database/app_database.dart';
import '../../application/create_card_controller.dart';
import '../card_type_labels.dart';
import 'flashcard_preview_dialog.dart';

class BrowseFlashcardsGrid extends ConsumerWidget {
  const BrowseFlashcardsGrid({super.key, required this.cards});

  final List<Flashcard> cards;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        childAspectRatio: 0.86,
      ),
      itemCount: cards.length,
      itemBuilder: (context, index) {
        final card = cards[index];
        final swatch = AppCollectionPalette.forId(
          card.id,
          Theme.of(context).brightness,
        );

        return ColoredNoteTile(
          key: Key('browse-card-${card.id}'),
          swatch: swatch,
          caption: cardTypeLabel(card.type),
          title: card.front,
          onTap: () => showFlashcardPreview(
            context: context,
            card: card,
            onEdit: () => context.push(AppRoutes.editCard(card.id)),
            onDelete: () => _deleteCard(context, ref, card),
          ),
        );
      },
    );
  }
}

Future<void> _deleteCard(
  BuildContext context,
  WidgetRef ref,
  Flashcard card,
) async {
  final confirmed = await showAppConfirmDialog(
    context: context,
    title: 'Eliminar tarjeta',
    message: 'Esta tarjeta se borrará de forma permanente.',
  );
  if (!confirmed) return;

  try {
    await ref.read(createCardControllerProvider).delete(card.id);
    if (!context.mounted) return;
    Navigator.of(context, rootNavigator: true).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tarjeta eliminada'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  } catch (error, stackTrace) {
    debugPrint('No se pudo eliminar la tarjeta: $error\n$stackTrace');
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('No se pudo eliminar la tarjeta.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
