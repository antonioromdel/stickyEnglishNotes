import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stickeenglishnotes/features/translator/application/mlkit_translator_engine.dart';
import 'package:stickeenglishnotes/features/translator/application/translator_controller.dart';
import 'package:stickeenglishnotes/features/translator/application/translator_engine.dart';
import 'package:stickeenglishnotes/features/translator/presentation/pages/translator_page.dart';

import 'helpers/fake_translator.dart';

void main() {
  testWidgets('traduce al escribir y permite copiar', (tester) async {
    await _pump(tester, const EchoTranslatorEngine());

    expect(find.text('Español'), findsOneWidget);
    expect(find.text('Inglés'), findsOneWidget);
    expect(find.text('La traducción aparecerá aquí'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('translator-input')), 'hola');
    await tester.pump();
    await tester.pump();

    expect(find.text('hola'), findsWidgets);
    expect(find.byKey(const Key('translator-copy')), findsOneWidget);

    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async => null,
    );
    addTearDown(() {
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      );
    });

    await tester.tap(find.byKey(const Key('translator-copy')));
    await tester.pump();
    await tester.pump();
    expect(find.text('Traducción copiada'), findsOneWidget);
  });

  testWidgets('intercambia los idiomas', (tester) async {
    await _pump(tester, const EchoTranslatorEngine());

    await tester.tap(find.byKey(const Key('translator-swap')));
    await tester.pump();

    expect(
      find.descendant(
        of: find.byKey(const Key('translator-source')),
        matching: find.text('Inglés'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byKey(const Key('translator-target')),
        matching: find.text('Español'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('elige otro idioma de destino', (tester) async {
    await _pump(tester, const EchoTranslatorEngine());

    await tester.tap(find.byKey(const Key('translator-target')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('translator-language-search')),
      'franc',
    );
    await tester.pump();
    await tester.tap(find.byKey(const Key('translator-language-Francés')));
    await tester.pumpAndSettle();

    expect(
      find.descendant(
        of: find.byKey(const Key('translator-target')),
        matching: find.text('Francés'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('muestra el error de traducción', (tester) async {
    await _pump(
      tester,
      FakeTranslatorEngine(
        (text, source, target) async => throw StateError('sin modelo'),
      ),
    );

    await tester.enterText(find.byKey(const Key('translator-input')), 'hola');
    await tester.pump();
    await tester.pump();

    expect(find.byKey(const Key('translator-error')), findsOneWidget);
    expect(find.textContaining('No se pudo traducir'), findsOneWidget);
  });
}

Future<void> _pump(WidgetTester tester, TranslatorEngine engine) {
  return tester.pumpWidget(
    ProviderScope(
      overrides: [
        translatorEngineProvider.overrideWith((ref) => engine),
        translatorDebounceProvider.overrideWith((ref) => Duration.zero),
      ],
      child: const MaterialApp(home: TranslatorPage()),
    ),
  );
}
