import 'package:flutter/material.dart';

/// Paleta base del producto.
///
/// Los widgets deben leer colores desde [ThemeData] / [ColorScheme],
/// no desde esta clase.
abstract final class AppColors {
  static const Color seed = Color(0xFF6D4AFF);

  static const Color lightPrimary = Color(0xFF6D4AFF);
  static const Color lightSecondary = Color(0xFFFF7A59);
  static const Color lightBackground = Color(0xFFF4F1FC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceContainer = Color(0xFFEBE6F8);
  static const Color lightOnSurface = Color(0xFF1C1730);
  static const Color lightError = Color(0xFFB42318);
  static const Color lightSuccess = Color(0xFF2F9B6A);
  static const Color lightHeroStart = Color(0xFF8B6CFF);
  static const Color lightHeroEnd = Color(0xFF5B3BE8);
  static const Color lightOnHero = Color(0xFFFFFFFF);

  static const Color darkPrimary = Color(0xFFB8A4FF);
  static const Color darkSecondary = Color(0xFFFF8F73);
  static const Color darkBackground = Color(0xFF14111C);
  static const Color darkSurface = Color(0xFF1C1830);
  static const Color darkSurfaceContainer = Color(0xFF262040);
  static const Color darkOnSurface = Color(0xFFF0ECFF);
  static const Color darkError = Color(0xFFFFB4AB);
  static const Color darkSuccess = Color(0xFF6FDBA8);
  static const Color darkHeroStart = Color(0xFF6D4AFF);
  static const Color darkHeroEnd = Color(0xFF3D2BB5);
  static const Color darkOnHero = Color(0xFFFFFFFF);
}
