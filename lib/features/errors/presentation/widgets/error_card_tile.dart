import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_semantic_colors.dart';
import '../../../../core/widgets/paper_card.dart';
import '../../domain/frequent_card_error.dart';

class ErrorCardTile extends StatelessWidget {
  const ErrorCardTile({
    super.key,
    required this.item,
    required this.onOpen,
    required this.onDismiss,
  });

  final FrequentCardError item;
  final VoidCallback onOpen;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final timesLabel = item.times == 1 ? '1 fallo' : '${item.times} fallos';
    final recency = errorRecencyLabel(item.lastAt, DateTime.now());

    return PaperCard(
      onTap: onOpen,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$timesLabel · $recency',
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(item.card.front, style: theme.textTheme.titleLarge),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  item.lastCorrectAnswer,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.semantic.success,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            key: Key('error-dismiss-${item.card.id}'),
            tooltip: 'Quitar de mis errores',
            onPressed: onDismiss,
            icon: Icon(Icons.close_rounded, color: scheme.onSurface),
          ),
        ],
      ),
    );
  }
}
