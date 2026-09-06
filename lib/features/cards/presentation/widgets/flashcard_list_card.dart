import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/paper_card.dart';
import '../../../../data/database/app_database.dart';
import '../card_type_labels.dart';

class FlashcardListCard extends StatelessWidget {
  const FlashcardListCard({super.key, required this.card});

  final Flashcard card;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PaperCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            cardTypeLabel(card.type),
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(card.front, style: theme.textTheme.titleLarge),
          const SizedBox(height: AppSpacing.sm),
          Text(card.back, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}
