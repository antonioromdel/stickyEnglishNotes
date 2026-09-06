import 'package:flutter/material.dart';

import '../constants/app_radii.dart';
import '../constants/app_spacing.dart';
import '../theme/app_collection_palette.dart';
import '../theme/app_shadows.dart';

class ColoredNoteTile extends StatelessWidget {
  const ColoredNoteTile({
    super.key,
    required this.swatch,
    required this.title,
    this.caption,
    this.onTap,
    this.onLongPress,
  });

  final CollectionSwatch swatch;
  final String title;
  final String? caption;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadii.card),
        boxShadow: AppShadows.colored(swatch.background),
      ),
      child: Material(
        color: swatch.background,
        borderRadius: BorderRadius.circular(AppRadii.card),
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          borderRadius: BorderRadius.circular(AppRadii.card),
          child: Stack(
            children: [
              Positioned(
                top: -18,
                right: -12,
                child: _Bubble(
                  size: 72,
                  color: swatch.onBackground.withValues(alpha: 0.12),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (caption != null) ...[
                      Text(
                        caption!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: swatch.onBackground.withValues(alpha: 0.78),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                    ],
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: swatch.onBackground,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }
}
