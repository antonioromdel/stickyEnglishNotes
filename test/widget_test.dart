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
    expect(find.text('Traductor'), findsOneWidget);
    expect(find.text('Textos'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Mis errores'), 200);
    expect(find.text('Mis errores'), findsOneWidget);

    await disposeTestApp(tester);
  });

  testWidgets('navega a ajustes y cambia el tema', (tester) async {
    await pumpTestApp(tester);

    await tester.tap(find.byKey(const Key('open-drawer-button')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('drawer-settings')));
    await tester.pumpAndSettle();

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

  testWidgets('abre el formulario de nueva tarjeta desde inicio', (
    tester,
  ) async {
    await pumpTestApp(tester);

    await tester.tap(find.text('Crear tarjeta'));
    await tester.pump();
    await tester.pump();

    expect(find.text('Nueva tarjeta'), findsOneWidget);
    expect(find.text('Frente'), findsOneWidget);
    expect(find.text('Reverso'), findsOneWidget);

    await disposeTestApp(tester);
  });

  testWidgets('abre progreso desde el menú lateral', (tester) async {
    await pumpTestApp(tester);

    await tester.tap(find.byKey(const Key('open-drawer-button')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('drawer-logo')), findsOneWidget);
    expect(find.byKey(const Key('drawer-progress')), findsOneWidget);
    expect(find.byKey(const Key('drawer-settings')), findsOneWidget);
    expect(find.byKey(const Key('drawer-tutorial')), findsOneWidget);
    expect(find.byKey(const Key('drawer-rate')), findsOneWidget);

    await tester.tap(find.byKey(const Key('drawer-progress')));
    await tester.pumpAndSettle();

    expect(find.text('Aún no hay estadísticas'), findsOneWidget);

    await disposeTestApp(tester);
  });

  testWidgets('tutorial y valóranos están en desarrollo', (tester) async {
    await pumpTestApp(tester);

    await tester.tap(find.byKey(const Key('open-drawer-button')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('drawer-tutorial')));
    await tester.pumpAndSettle();

    expect(find.text('Tutorial'), findsOneWidget);
    expect(find.text('Tarjetas para recordar'), findsOneWidget);
    expect(find.text('En desarrollo'), findsNothing);

    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('open-drawer-button')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('drawer-rate')));
    await tester.pumpAndSettle();

    expect(find.text('Valóranos'), findsOneWidget);
    expect(find.text('En desarrollo'), findsOneWidget);

    await disposeTestApp(tester);
  });

  testWidgets('traductor y textos están en desarrollo', (tester) async {
    await pumpTestApp(tester);

    await tester.tap(find.text('Traductor'));
    await tester.pumpAndSettle();
    expect(find.text('En desarrollo'), findsOneWidget);

    await tester.tap(find.text('Textos'));
    await tester.pumpAndSettle();
    expect(find.text('En desarrollo'), findsWidgets);
    expect(
      find.text('Esta sección estará disponible más adelante.'),
      findsWidgets,
    );

    await disposeTestApp(tester);
  });
}
