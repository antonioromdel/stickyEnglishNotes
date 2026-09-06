import 'package:flutter/material.dart';

@immutable
class CollectionSwatch {
  const CollectionSwatch({
    required this.background,
    required this.onBackground,
  });

  final Color background;
  final Color onBackground;
}

/// Paleta de notas de colores, estable por id.
abstract final class AppCollectionPalette {
  static const List<CollectionSwatch> light = [
    CollectionSwatch(background: Color(0xFF6D4AFF), onBackground: Color(0xFFFFFFFF)),
    CollectionSwatch(background: Color(0xFFFF7A59), onBackground: Color(0xFFFFFFFF)),
    CollectionSwatch(background: Color(0xFF2EC4B6), onBackground: Color(0xFF08332F)),
    CollectionSwatch(background: Color(0xFFF4B942), onBackground: Color(0xFF3D2C05)),
    CollectionSwatch(background: Color(0xFFF472B6), onBackground: Color(0xFFFFFFFF)),
    CollectionSwatch(background: Color(0xFF5B9DFF), onBackground: Color(0xFFFFFFFF)),
    CollectionSwatch(background: Color(0xFF34D399), onBackground: Color(0xFF06381F)),
    CollectionSwatch(background: Color(0xFFA78BFA), onBackground: Color(0xFFFFFFFF)),
  ];

  static const List<CollectionSwatch> dark = [
    CollectionSwatch(background: Color(0xFF8B6CFF), onBackground: Color(0xFFFFFFFF)),
    CollectionSwatch(background: Color(0xFFFF8F73), onBackground: Color(0xFF3A120A)),
    CollectionSwatch(background: Color(0xFF4DD6C9), onBackground: Color(0xFF08332F)),
    CollectionSwatch(background: Color(0xFFF6C85B), onBackground: Color(0xFF3D2C05)),
    CollectionSwatch(background: Color(0xFFF9A8D4), onBackground: Color(0xFF4A1030)),
    CollectionSwatch(background: Color(0xFF7EB3FF), onBackground: Color(0xFF0B1D3A)),
    CollectionSwatch(background: Color(0xFF6EE7B7), onBackground: Color(0xFF06381F)),
    CollectionSwatch(background: Color(0xFFC4B5FD), onBackground: Color(0xFF2A1A4A)),
  ];

  static CollectionSwatch forId(int id, Brightness brightness) {
    final palette = brightness == Brightness.dark ? dark : light;
    return palette[id.abs() % palette.length];
  }
}
