import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stickeenglishnotes/core/theme/app_collection_palette.dart';
import 'package:stickeenglishnotes/core/theme/app_theme.dart';
import 'package:stickeenglishnotes/core/theme/theme_controller.dart';
import 'package:stickeenglishnotes/core/tts/tts_controller.dart';
import 'package:stickeenglishnotes/features/cards/presentation/widgets/flashcard_preview_dialog.dart';

import '../../helpers/fake_tts.dart';
import '../../helpers/test_data.dart';

void main() {
  Future<void> pumpPreview(
    WidgetTester tester, {
    VoidCallback? onEdit,
    Future<void> Function()? onDelete,
  }) async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWith((ref) => preferences),
          textToSpeechServiceProvider.overrideWith((ref) => FakeTextToSpeechService()),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          home: FlashcardPreviewDialog(
            card: testFlashcard(),
            swatch: AppCollectionPalette.light.first,
            onEdit: onEdit,
            onDelete: onDelete,
          ),
        ),
      ),
    );
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
    await pumpPreview(
      tester,
      onEdit: () {},
      onDelete: () async {},
    );

    expect(find.byKey(const Key('preview-edit-button')), findsOneWidget);
    expect(find.byKey(const Key('preview-delete-button')), findsOneWidget);
  });
}
