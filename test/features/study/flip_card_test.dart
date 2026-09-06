import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stickeenglishnotes/features/study/presentation/widgets/flip_card.dart';

void main() {
  testWidgets('muestra el reverso después de voltear', (tester) async {
    var flipped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: StatefulBuilder(
          builder: (context, setState) {
            return FlipCard(
              isFlipped: flipped,
              onTap: () => setState(() => flipped = !flipped),
              front: const Text('frente'),
              back: const Text('reverso'),
            );
          },
        ),
      ),
    );

    expect(find.text('frente'), findsOneWidget);
    expect(find.text('reverso'), findsNothing);

    await tester.tap(find.text('frente'));
    await tester.pumpAndSettle();

    expect(find.text('reverso'), findsOneWidget);
    expect(find.text('frente'), findsNothing);
  });
}
