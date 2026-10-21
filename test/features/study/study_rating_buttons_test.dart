import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stickeenglishnotes/data/models/card_enums.dart';
import 'package:stickeenglishnotes/features/study/presentation/widgets/study_rating_buttons.dart';

void main() {
  testWidgets('notifica la valoración pulsada', (tester) async {
    ReviewRating? selected;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StudyRatingButtons(onRated: (rating) => selected = rating),
        ),
      ),
    );

    expect(find.text('No recuerdo'), findsOneWidget);
    expect(find.text('5 min'), findsNothing);
    expect(find.text('¡He acertado!'), findsOneWidget);
    expect(find.text('¡Acertado!'), findsOneWidget);
    expect(find.text('Recordar en 2 días'), findsOneWidget);
    expect(find.text('Difícil'), findsNothing);
    expect(find.text('Fácil'), findsNothing);

    final again = tester.getSize(find.byKey(const Key('rating-again')));
    final tomorrow = tester.getSize(find.byKey(const Key('rating-hard')));
    final later = tester.getSize(find.byKey(const Key('rating-good')));
    expect(again, tomorrow);
    expect(tomorrow, later);

    await tester.tap(find.byKey(const Key('rating-hard')));
    expect(selected, ReviewRating.hard);

    await tester.tap(find.byKey(const Key('rating-good')));
    expect(selected, ReviewRating.good);
  });
}
