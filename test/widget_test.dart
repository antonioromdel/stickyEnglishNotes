import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/test_app.dart';

void main() {
  setUpAll(configureTestDrift);

  testWidgets('muestra el inicio y la navegación principal', (tester) async {
    await pumpTestApp(tester);

    expect(find.textContaining('Hola'), findsOneWidget);
    expect(find.text('Estudiar'), findsWidgets);
    expect(find.text('Inicio'), findsOneWidget);
    expect(find.text('Progreso'), findsOneWidget);
    expect(find.text('Ajustes'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Mis errores'), 200);
    expect(find.text('Mis errores'), findsOneWidget);

    await disposeTestApp(tester);
  });

  testWidgets('navega a ajustes y cambia el tema', (tester) async {
    await pumpTestApp(tester);

    await tester.tap(find.text('Ajustes'));
    await tester.pump();
    await tester.pump();

    final darkTile = find.widgetWithText(ListTile, 'Oscuro');
    await tester.scrollUntilVisible(darkTile, 300);
    await tester.ensureVisible(darkTile);
    await tester.pumpAndSettle();
    expect(find.text('Apariencia'), findsOneWidget);

    await tester.tap(darkTile);
    await tester.pump();
    await tester.pump();

    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.themeMode, ThemeMode.dark);

    await disposeTestApp(tester);
  });

  testWidgets('abre el formulario de nueva tarjeta desde inicio', (tester) async {
    await pumpTestApp(tester);

    await tester.tap(find.text('Crear tarjeta'));
    await tester.pump();
    await tester.pump();

    expect(find.text('Nueva tarjeta'), findsOneWidget);
    expect(find.text('Frente'), findsOneWidget);
    expect(find.text('Reverso'), findsOneWidget);

    await disposeTestApp(tester);
  });
}
