import 'package:flutter/material.dart';

import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_semantic_colors.dart';
import '../../../../data/models/card_enums.dart';

class StudyRatingButtons extends StatelessWidget {
  const StudyRatingButtons({super.key, required this.onRated});

  static const double barHeight = 96;

  final ValueChanged<ReviewRating> onRated;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final success = Theme.of(context).semantic.success;

    return SizedBox(
      height: barHeight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _RatingButton(
            key: const Key('rating-again'),
            label: 'No recuerdo',
            color: scheme.error,
            onPressed: () => onRated(ReviewRating.again),
          ),
          const SizedBox(width: AppSpacing.sm),
          _RatingButton(
            key: const Key('rating-hard'),
            label: '¡He acertado!',
            hint: '1 día',
            color: scheme.primary,
            onPressed: () => onRated(ReviewRating.hard),
          ),
          const SizedBox(width: AppSpacing.sm),
          _RatingButton(
            key: const Key('rating-good'),
            label: '¡Acertado!',
            hint: 'Recordar en 2 días',
            color: success,
            onPressed: () => onRated(ReviewRating.good),
          ),
        ],
      ),
    );
  }
}

class _RatingButton extends StatelessWidget {
  const _RatingButton({
    super.key,
    required this.label,
    this.hint,
    required this.color,
    required this.onPressed,
  });

  final String label;
  final String? hint;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final subtitle = hint;

    return Expanded(
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: color,
          backgroundColor: color.withValues(alpha: 0.08),
          side: BorderSide(color: color.withValues(alpha: 0.4)),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xs,
            vertical: AppSpacing.sm,
          ),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.lg),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelLarge?.copyWith(
                color: color,
                height: 1.2,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: color.withValues(alpha: 0.8),
                  height: 1.2,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
