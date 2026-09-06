import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stickeenglishnotes/core/theme/app_theme.dart';
import 'package:stickeenglishnotes/features/statistics/application/statistics_providers.dart';
import 'package:stickeenglishnotes/features/statistics/domain/study_stats.dart';
import 'package:stickeenglishnotes/features/statistics/presentation/pages/statistics_page.dart';

void main() {
  testWidgets('muestra el estado vacío si aún no hay revisiones', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          studyStatsProvider.overrideWith(
            (ref) => Stream.value(StudyStats.empty()),
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          home: const StatisticsPage(),
        ),
      ),
    );
    await tester.pump();
    await tester.pump();

    expect(find.text('Aún no hay estadísticas'), findsOneWidget);
    expect(find.byKey(const Key('stats-accuracy')), findsNothing);
  });

  testWidgets('muestra métricas reales de estudio', (tester) async {
    final today = DateTime(2026, 9, 6);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          studyStatsProvider.overrideWith(
            (ref) => Stream.value(
              StudyStats(
                cardsStudied: 5,
                correctAnswers: 8,
                incorrectAnswers: 2,
                pendingCards: 3,
                streakDays: 4,
                dailyActivity: [
                  for (var offset = 6; offset >= 0; offset--)
                    DailyActivity(
                      day: today.subtract(Duration(days: offset)),
                      reviewCount: offset == 0 ? 4 : 1,
                    ),
                ],
              ),
            ),
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          home: const StatisticsPage(),
        ),
      ),
    );
    await tester.pump();
    await tester.pump();

    expect(find.text('80%'), findsOneWidget);
    expect(find.text('4 días de racha'), findsOneWidget);
    expect(find.text('5'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
    expect(find.text('8'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Actividad diaria'),
      200,
    );
    expect(find.text('Mis errores'), findsOneWidget);
    expect(find.text('Actividad diaria'), findsOneWidget);
  });
}
