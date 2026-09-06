import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/app_confirm_dialog.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../cards/presentation/widgets/flashcard_preview_dialog.dart';
import '../../application/errors_providers.dart';
import '../../domain/frequent_card_error.dart';
import '../widgets/error_card_tile.dart';

class ErrorsPage extends ConsumerWidget {
  const ErrorsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final errors = ref.watch(frequentCardErrorsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Mis errores')),
      body: errors.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => const AppEmptyState(
          icon: Icons.error_outline,
          title: 'No se pudieron cargar los errores',
          message: 'Inténtalo de nuevo más tarde.',
        ),
        data: (items) {
          if (items.isEmpty) {
            return const AppEmptyState(
              icon: Icons.replay,
              title: 'Aún no hay errores',
              message:
                  'Cuando marques Otra vez al estudiar, las tarjetas que falles aparecerán aquí.',
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.xl,
              AppSpacing.sm,
              AppSpacing.xl,
              AppSpacing.xxxl,
            ),
            itemCount: items.length,
            separatorBuilder: (context, index) =>
                const SizedBox(height: AppSpacing.md),
            itemBuilder: (context, index) {
              final item = items[index];
              return ErrorCardTile(
                key: Key('error-card-${item.card.id}'),
                item: item,
                onOpen: () => showFlashcardPreview(
                  context: context,
                  card: item.card,
                ),
                onDismiss: () => _dismiss(context, ref, item),
              );
            },
          );
        },
      ),
    );
  }
}

Future<void> _dismiss(
  BuildContext context,
  WidgetRef ref,
  FrequentCardError item,
) async {
  final confirmed = await showAppConfirmDialog(
    context: context,
    title: 'Quitar de mis errores',
    message: 'La tarjeta no se borra. Solo deja de aparecer en esta lista.',
    confirmLabel: 'Quitar',
  );
  if (!confirmed) return;

  try {
    await ref.read(errorsControllerProvider).dismissCard(item.card.id);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Error quitado'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  } catch (error, stackTrace) {
    debugPrint('No se pudo quitar el error: $error\n$stackTrace');
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('No se pudo quitar el error.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
