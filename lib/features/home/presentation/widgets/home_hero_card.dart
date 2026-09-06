import 'package:flutter/material.dart';

import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_semantic_colors.dart';
import '../../../../core/theme/app_shadows.dart';

class HomeHeroCard extends StatelessWidget {
  const HomeHeroCard({
    super.key,
    required this.word,
    this.onTap,
  });

  final String word;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final semantic = theme.semantic;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadii.card),
        boxShadow: AppShadows.colored(semantic.heroEnd),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadii.card),
          child: Ink(
            height: 220,
            decoration: BoxDecoration(
              gradient: semantic.heroGradient,
              borderRadius: BorderRadius.circular(AppRadii.card),
            ),
            child: Stack(
              children: [
                const _HeroBubbles(),
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        word,
                        style: theme.textTheme.displaySmall?.copyWith(
                          color: semantic.onHero,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        'Toca para estudiar',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: semantic.onHero.withValues(alpha: 0.82),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HeroBubbles extends StatelessWidget {
  const _HeroBubbles();

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).semantic.onHero;

    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: -28,
            right: -16,
            child: _Bubble(size: 120, color: color.withValues(alpha: 0.12)),
          ),
          Positioned(
            bottom: -36,
            left: -20,
            child: _Bubble(size: 140, color: color.withValues(alpha: 0.10)),
          ),
          Positioned(
            top: 48,
            left: 24,
            child: _Bubble(size: 28, color: color.withValues(alpha: 0.16)),
          ),
        ],
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
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
