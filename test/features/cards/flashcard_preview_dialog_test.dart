import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stickeenglishnotes/core/theme/app_theme.dart';
import 'package:stickeenglishnotes/data/database/app_database.dart';
import 'package:stickeenglishnotes/core/theme/theme_controller.dart';
import 'package:stickeenglishnotes/core/tts/tts_controller.dart';
import 'package:stickeenglishnotes/features/cards/presentation/widgets/flashcard_preview_dialog.dart';

import '../../helpers/fake_tts.dart';
import '../../helpers/test_data.dart';

void main() {
  Future<void> pumpPreview(
    WidgetTester tester, {
    Flashcard? card,
    List<Flashcard> cards = const [],
    void Function(Flashcard card)? onEdit,
    Future<void> Function(Flashcard card)? onDelete,
  }) async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWith((ref) => preferences),
          textToSpeechServiceProvider.overrideWith(
            (ref) => FakeTextToSpeechService(),
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          home: FlashcardPreviewDialog(
            card: card ?? testFlashcard(),
            cards: cards,
            onEdit: onEdit,
            onDelete: onDelete,
          ),
        ),
      ),
    );
  }

  bool isOnScreen(WidgetTester tester, String text) {
    final finder = find.text(text);
    if (finder.evaluate().isEmpty) return false;

    final screen =
        Offset.zero & tester.getSize(find.byType(FlashcardPreviewDialog));
    for (final element in finder.evaluate()) {
      final box = element.renderObject;
      if (box is! RenderBox || !box.hasSize) continue;
      final rect = box.localToGlobal(Offset.zero) & box.size;
      if (rect.overlaps(screen) &&
          rect.center.dy > screen.top &&
          rect.center.dy < screen.bottom) {
        return true;
      }
    }
    return false;
  }

  testWidgets('muestra el frente y voltea al tocar la tarjeta', (tester) async {
    await pumpPreview(tester);

    expect(find.text('hello'), findsOneWidget);
    expect(find.text('hola'), findsNothing);
    expect(find.byKey(const Key('preview-close-button')), findsOneWidget);

    await tester.tap(find.text('hello'));
    await tester.pumpAndSettle();

    expect(find.text('hola'), findsOneWidget);
    expect(find.text('hello'), findsNothing);
  });

  testWidgets('muestra acciones de editar y eliminar', (tester) async {
    await pumpPreview(tester, onEdit: (_) {}, onDelete: (_) async {});

    expect(find.byKey(const Key('preview-edit-1')), findsOneWidget);
    expect(find.byKey(const Key('preview-delete-1')), findsOneWidget);

    final scheme = Theme.of(
      tester.element(find.byKey(const Key('preview-edit-1'))),
    ).colorScheme;
    final edit = tester.widget<FilledButton>(
      find.byKey(const Key('preview-edit-1')),
    );
    final delete = tester.widget<FilledButton>(
      find.byKey(const Key('preview-delete-1')),
    );

    expect(edit.style?.backgroundColor?.resolve({}), scheme.primary);
    expect(edit.style?.foregroundColor?.resolve({}), scheme.onPrimary);
    expect(delete.style?.backgroundColor?.resolve({}), scheme.error);
    expect(delete.style?.foregroundColor?.resolve({}), scheme.onError);
  });

  testWidgets('al deslizar pasa a la tarjeta siguiente y a la anterior', (
    tester,
  ) async {
    final cards = [
      testFlashcard(id: 1, front: 'hello', back: 'hola'),
      testFlashcard(id: 2, front: 'because', back: 'porque'),
      testFlashcard(id: 3, front: 'run', back: 'correr'),
    ];

    await pumpPreview(tester, card: cards[1], cards: cards);
    await tester.pump();

    expect(isOnScreen(tester, 'because'), isTrue);
    expect(isOnScreen(tester, 'hello'), isFalse);
    expect(isOnScreen(tester, 'run'), isFalse);

    await tester.fling(
      find.byKey(const Key('preview-feed')),
      const Offset(0, -500),
      1500,
    );
    await tester.pumpAndSettle();

    expect(isOnScreen(tester, 'run'), isTrue);
    expect(isOnScreen(tester, 'because'), isFalse);

    await tester.fling(
      find.byKey(const Key('preview-feed')),
      const Offset(0, 500),
      1500,
    );
    await tester.pumpAndSettle();

    expect(isOnScreen(tester, 'because'), isTrue);
    expect(isOnScreen(tester, 'run'), isFalse);
  });
}
