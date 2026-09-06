import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_semantic_colors.dart';
import '../../../../data/models/card_enums.dart';

class StudyRatingButtons extends StatelessWidget {
  const StudyRatingButtons({super.key, required this.onRated});

  final ValueChanged<ReviewRating> onRated;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final success = Theme.of(context).semantic.success;

    return Row(
      children: [
        _RatingButton(
          key: const Key('rating-again'),
          label: 'Otra vez',
          hint: '5 min',
          color: scheme.error,
          onPressed: () => onRated(ReviewRating.again),
        ),
        const SizedBox(width: AppSpacing.sm),
        _RatingButton(
          key: const Key('rating-hard'),
          label: 'Difícil',
          hint: '1 día',
          color: scheme.secondary,
          onPressed: () => onRated(ReviewRating.hard),
        ),
        const SizedBox(width: AppSpacing.sm),
        _RatingButton(
          key: const Key('rating-good'),
          label: 'Bien',
          hint: '2 días',
          color: scheme.primary,
          onPressed: () => onRated(ReviewRating.good),
        ),
        const SizedBox(width: AppSpacing.sm),
        _RatingButton(
          key: const Key('rating-easy'),
          label: 'Fácil',
          hint: '4 días',
          color: success,
          onPressed: () => onRated(ReviewRating.easy),
        ),
      ],
    );
  }
}

class _RatingButton extends StatelessWidget {
  const _RatingButton({
    super.key,
    required this.label,
    required this.hint,
    required this.color,
    required this.onPressed,
  });

  final String label;
  final String hint;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Expanded(
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: color,
          side: BorderSide(color: color.withValues(alpha: 0.4)),
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          minimumSize: const Size(48, 48),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: theme.textTheme.labelLarge?.copyWith(color: color),
              ),
              Text(
                hint,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: color.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
