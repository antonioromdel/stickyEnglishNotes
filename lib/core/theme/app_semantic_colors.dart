import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Colores semánticos y de marca que no cubre [ColorScheme].
@immutable
class AppSemanticColors extends ThemeExtension<AppSemanticColors> {
  const AppSemanticColors({
    required this.success,
    required this.accent,
    required this.heroStart,
    required this.heroEnd,
    required this.onHero,
  });

  final Color success;
  final Color accent;
  final Color heroStart;
  final Color heroEnd;
  final Color onHero;

  LinearGradient get heroGradient {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [heroStart, heroEnd],
    );
  }

  @override
  AppSemanticColors copyWith({
    Color? success,
    Color? accent,
    Color? heroStart,
    Color? heroEnd,
    Color? onHero,
  }) {
    return AppSemanticColors(
      success: success ?? this.success,
      accent: accent ?? this.accent,
      heroStart: heroStart ?? this.heroStart,
      heroEnd: heroEnd ?? this.heroEnd,
      onHero: onHero ?? this.onHero,
    );
  }

  @override
  AppSemanticColors lerp(ThemeExtension<AppSemanticColors>? other, double t) {
    if (other is! AppSemanticColors) return this;
    return AppSemanticColors(
      success: Color.lerp(success, other.success, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      heroStart: Color.lerp(heroStart, other.heroStart, t)!,
      heroEnd: Color.lerp(heroEnd, other.heroEnd, t)!,
      onHero: Color.lerp(onHero, other.onHero, t)!,
    );
  }
}

extension AppThemeSemantics on ThemeData {
  AppSemanticColors get semantic {
    return extension<AppSemanticColors>() ??
        const AppSemanticColors(
          success: AppColors.lightSuccess,
          accent: AppColors.lightSecondary,
          heroStart: AppColors.lightHeroStart,
          heroEnd: AppColors.lightHeroEnd,
          onHero: AppColors.lightOnHero,
        );
  }
}
