import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stickeenglishnotes/features/study/presentation/widgets/study_progress_bar.dart';

void main() {
  testWidgets('muestra el progreso de la sesión', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: StudyProgressBar(current: 2, total: 5),
        ),
      ),
    );

    expect(find.text('2 / 5'), findsOneWidget);
    final indicator = tester.widget<LinearProgressIndicator>(
      find.byType(LinearProgressIndicator),
    );
    expect(indicator.value, 0.4);
  });
}
