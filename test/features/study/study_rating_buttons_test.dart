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

    expect(find.text('Otra vez'), findsOneWidget);
    expect(find.text('Difícil'), findsOneWidget);
    expect(find.text('Bien'), findsOneWidget);
    expect(find.text('Fácil'), findsOneWidget);

    await tester.tap(find.byKey(const Key('rating-good')));
    expect(selected, ReviewRating.good);
  });
}
