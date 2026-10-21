import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stickeenglishnotes/core/theme/app_theme.dart';
import 'package:stickeenglishnotes/features/tutorial/presentation/pages/tutorial_page.dart';
import 'package:stickeenglishnotes/features/tutorial/presentation/tutorial_content.dart';

void main() {
  test('el tutorial explica el estudio y las tres respuestas', () {
    final text = tutorialSteps
        .map((step) => '${step.title} ${step.body}')
        .join('\n');

    expect(text, contains('sin conexión'));
    expect(text, contains('3 caracteres'));
    expect(text, contains('No recuerdo'));
    expect(text, contains('¡He acertado!'));
    expect(text, contains('¡Acertado!'));
    expect(text, contains('2 días'));
    expect(text, contains('Mis errores'));
  });

  testWidgets('muestra los pasos del tutorial', (tester) async {
    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.light, home: const TutorialPage()),
    );

    expect(find.text('Tutorial'), findsOneWidget);
    expect(find.text('Tarjetas para recordar'), findsOneWidget);

    await tester.scrollUntilVisible(find.text('Las tres respuestas'), 400);
    expect(find.textContaining('vuelve al día siguiente'), findsOneWidget);
  });
}
