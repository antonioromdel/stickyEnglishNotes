import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stickeenglishnotes/core/theme/app_theme.dart';
import 'package:stickeenglishnotes/core/widgets/flashcard_face_text.dart';

void main() {
  test('una sola línea no necesita texto compacto', () {
    expect(needsCompactCardText('hola'), isFalse);
    expect(needsCompactCardText('  hola\n  '), isFalse);
  });

  test('varias líneas necesitan texto compacto', () {
    expect(
      needsCompactCardText('Present simple\nSe usa para hábitos'),
      isTrue,
    );
  });

  testWidgets('muestra el reverso grande si es una sola línea', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const Scaffold(
          body: SizedBox(
            width: 320,
            child: FlashcardFaceText(text: 'hola', adaptToLines: true),
          ),
        ),
      ),
    );

    final text = tester.widget<Text>(find.text('hola'));
    expect(text.style?.fontSize, 40);
  });

  testWidgets('reduce el reverso si tiene varias líneas', (tester) async {
    const value = 'Present simple\nSe usa para hábitos y rutinas';
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const Scaffold(
          body: SizedBox(
            width: 320,
            child: FlashcardFaceText(text: value, adaptToLines: true),
          ),
        ),
      ),
    );

    final text = tester.widget<Text>(find.text(value));
    expect(text.style?.fontSize, 20);
  });
}
