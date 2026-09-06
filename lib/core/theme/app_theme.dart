import 'package:flutter/material.dart';

import '../constants/app_radii.dart';
import 'app_colors.dart';
import 'app_semantic_colors.dart';

abstract final class AppTheme {
  static const String displayFont = 'PlusJakartaSans';
  static const String bodyFont = 'Manrope';

  static ThemeData get light => _build(
        brightness: Brightness.light,
        colorScheme: const ColorScheme.light(
          primary: AppColors.lightPrimary,
          onPrimary: Colors.white,
          secondary: AppColors.lightSecondary,
          onSecondary: Colors.white,
          surface: AppColors.lightBackground,
          onSurface: AppColors.lightOnSurface,
          surfaceContainerLowest: AppColors.lightSurface,
          surfaceContainerLow: AppColors.lightSurfaceContainer,
          surfaceContainer: AppColors.lightSurfaceContainer,
          error: AppColors.lightError,
          onError: Colors.white,
        ),
        semantics: const AppSemanticColors(
          success: AppColors.lightSuccess,
          accent: AppColors.lightSecondary,
          heroStart: AppColors.lightHeroStart,
          heroEnd: AppColors.lightHeroEnd,
          onHero: AppColors.lightOnHero,
        ),
      );

  static ThemeData get dark => _build(
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.darkPrimary,
          onPrimary: Color(0xFF2A1B6B),
          secondary: AppColors.darkSecondary,
          onSecondary: Color(0xFF4A160C),
          surface: AppColors.darkBackground,
          onSurface: AppColors.darkOnSurface,
          surfaceContainerLowest: AppColors.darkSurface,
          surfaceContainerLow: AppColors.darkSurfaceContainer,
          surfaceContainer: AppColors.darkSurfaceContainer,
          error: AppColors.darkError,
          onError: Color(0xFF690005),
        ),
        semantics: const AppSemanticColors(
          success: AppColors.darkSuccess,
          accent: AppColors.darkSecondary,
          heroStart: AppColors.darkHeroStart,
          heroEnd: AppColors.darkHeroEnd,
          onHero: AppColors.darkOnHero,
        ),
      );

  static ThemeData _build({
    required Brightness brightness,
    required ColorScheme colorScheme,
    required AppSemanticColors semantics,
  }) {
    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      fontFamily: bodyFont,
    );

    return base.copyWith(
      scaffoldBackgroundColor: colorScheme.surface,
      extensions: <ThemeExtension<dynamic>>[semantics],
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: displayFont,
          fontWeight: FontWeight.w700,
          fontSize: 22,
          color: colorScheme.onSurface,
        ),
      ),
      cardTheme: CardThemeData(
        color: colorScheme.surfaceContainerLowest,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.card),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colorScheme.surfaceContainerLowest,
        elevation: 0,
        height: 72,
        indicatorColor: colorScheme.primary.withValues(alpha: 0.16),
        indicatorShape: const StadiumBorder(),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontFamily: bodyFont,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            fontSize: 12,
            color: selected
                ? colorScheme.primary
                : colorScheme.onSurface.withValues(alpha: 0.64),
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected
                ? colorScheme.primary
                : colorScheme.onSurface.withValues(alpha: 0.64),
          );
        }),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(48, 56),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.lg),
          ),
          textStyle: const TextStyle(
            fontFamily: displayFont,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(48, 56),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          foregroundColor: colorScheme.primary,
          backgroundColor: colorScheme.primary.withValues(alpha: 0.06),
          side: BorderSide(color: colorScheme.primary.withValues(alpha: 0.28)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.lg),
          ),
          textStyle: const TextStyle(
            fontFamily: displayFont,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerLowest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.md),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.md),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.md),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.sm),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: colorScheme.surfaceContainerLowest,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.lg),
        ),
      ),
      textTheme: _textTheme(colorScheme.onSurface),
    );
  }

  static TextTheme _textTheme(Color onSurface) {
    return TextTheme(
      displaySmall: TextStyle(
        fontFamily: displayFont,
        fontWeight: FontWeight.w800,
        fontSize: 40,
        letterSpacing: -1.0,
        height: 1.1,
        color: onSurface,
      ),
      headlineMedium: TextStyle(
        fontFamily: displayFont,
        fontWeight: FontWeight.w800,
        fontSize: 32,
        letterSpacing: -0.6,
        height: 1.15,
        color: onSurface,
      ),
      titleLarge: TextStyle(
        fontFamily: displayFont,
        fontWeight: FontWeight.w700,
        fontSize: 20,
        color: onSurface,
      ),
      titleMedium: TextStyle(
        fontFamily: displayFont,
        fontWeight: FontWeight.w700,
        fontSize: 16,
        color: onSurface,
      ),
      bodyLarge: TextStyle(
        fontFamily: bodyFont,
        fontWeight: FontWeight.w500,
        fontSize: 16,
        height: 1.45,
        color: onSurface,
      ),
      bodyMedium: TextStyle(
        fontFamily: bodyFont,
        fontWeight: FontWeight.w500,
        fontSize: 14,
        height: 1.45,
        color: onSurface,
      ),
      bodySmall: TextStyle(
        fontFamily: bodyFont,
        fontWeight: FontWeight.w500,
        fontSize: 13,
        height: 1.4,
        color: onSurface.withValues(alpha: 0.68),
      ),
      labelLarge: TextStyle(
        fontFamily: bodyFont,
        fontWeight: FontWeight.w700,
        fontSize: 14,
        color: onSurface,
      ),
      labelMedium: TextStyle(
        fontFamily: bodyFont,
        fontWeight: FontWeight.w600,
        fontSize: 12,
        color: onSurface,
      ),
    );
  }
}
