import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stickeenglishnotes/features/study/presentation/widgets/study_card_transition.dart';

void main() {
  testWidgets('desliza de una tarjeta a la siguiente', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: StudyCardTransition(cardId: 1, child: Text('uno')),
        ),
      ),
    );

    expect(find.text('uno'), findsOneWidget);

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: StudyCardTransition(cardId: 2, child: Text('dos')),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('uno'), findsOneWidget);
    expect(find.text('dos'), findsOneWidget);

    await tester.pumpAndSettle();

    expect(find.text('uno'), findsNothing);
    expect(find.text('dos'), findsOneWidget);
  });
}
