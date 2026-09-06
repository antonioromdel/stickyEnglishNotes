import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stickeenglishnotes/core/theme/app_theme.dart';
import 'package:stickeenglishnotes/features/errors/application/errors_providers.dart';
import 'package:stickeenglishnotes/features/errors/domain/frequent_card_error.dart';
import 'package:stickeenglishnotes/features/errors/presentation/pages/errors_page.dart';

import '../../helpers/test_data.dart';

void main() {
  testWidgets('muestra estado vacío cuando no hay fallos', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          frequentCardErrorsProvider.overrideWith((ref) => Stream.value([])),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          home: const ErrorsPage(),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Aún no hay errores'), findsOneWidget);
    expect(
      find.textContaining('Cuando marques Otra vez'),
      findsOneWidget,
    );
  });

  testWidgets('lista los fallos agrupados por tarjeta', (tester) async {
    final item = FrequentCardError(
      card: testFlashcard(front: 'because', back: 'porque'),
      times: 3,
      lastAt: DateTime.now(),
      lastCorrectAnswer: 'porque',
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          frequentCardErrorsProvider.overrideWith((ref) => Stream.value([item])),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          home: const ErrorsPage(),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('because'), findsOneWidget);
    expect(find.text('porque'), findsOneWidget);
    expect(find.textContaining('3 fallos'), findsOneWidget);
    expect(find.text('Crear tarjeta'), findsNothing);
  });

  testWidgets('pide confirmación antes de quitar un error', (tester) async {
    final item = FrequentCardError(
      card: testFlashcard(front: 'because', back: 'porque'),
      times: 1,
      lastAt: DateTime.now(),
      lastCorrectAnswer: 'porque',
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          frequentCardErrorsProvider.overrideWith((ref) => Stream.value([item])),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          home: const ErrorsPage(),
        ),
      ),
    );
    await tester.pump();

    await tester.tap(find.byKey(const Key('error-dismiss-1')));
    await tester.pumpAndSettle();

    expect(find.text('Quitar de mis errores'), findsWidgets);
    expect(find.textContaining('La tarjeta no se borra'), findsOneWidget);

    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();

    expect(find.text('because'), findsOneWidget);
  });
}
