import 'package:flutter/material.dart';

/// Sombras suaves para dar profundidad a tarjetas y acciones.
abstract final class AppShadows {
  static List<BoxShadow> card(Brightness brightness) {
    final opacity = brightness == Brightness.dark ? 0.28 : 0.07;
    return [
      BoxShadow(
        color: Colors.black.withValues(alpha: opacity),
        blurRadius: 24,
        offset: const Offset(0, 8),
      ),
    ];
  }

  static List<BoxShadow> colored(Color color) {
    return [
      BoxShadow(
        color: color.withValues(alpha: 0.36),
        blurRadius: 22,
        offset: const Offset(0, 10),
      ),
    ];
  }
}
