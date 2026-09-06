import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stickeenglishnotes/core/theme/app_collection_palette.dart';

void main() {
  test('asigna el mismo color a un id de forma estable', () {
    final first = AppCollectionPalette.forId(3, Brightness.light);
    final second = AppCollectionPalette.forId(3, Brightness.light);

    expect(first.background, second.background);
    expect(
      AppCollectionPalette.forId(1, Brightness.light).background,
      isNot(AppCollectionPalette.forId(2, Brightness.light).background),
    );
  });
}
