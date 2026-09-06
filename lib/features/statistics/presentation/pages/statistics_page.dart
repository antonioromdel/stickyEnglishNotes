import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_semantic_colors.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/paper_card.dart';
import '../../../study/application/study_controller.dart';
import '../../application/statistics_providers.dart';
import '../../domain/study_stats.dart';
import '../widgets/daily_activity_chart.dart';
import '../widgets/progress_metric_card.dart';

class StatisticsPage extends ConsumerWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(studyStatsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Progreso')),
      body: stats.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => const AppEmptyState(
          icon: Icons.error_outline,
          title: 'No se pudo cargar el progreso',
          message: 'Inténtalo de nuevo más tarde.',
        ),
        data: (value) {
          if (!value.hasStudied) {
            return AppEmptyState(
              icon: Icons.insights_outlined,
              title: 'Aún no hay estadísticas',
              message:
                  'Cuando estudies, aquí verás precisión, racha y actividad diaria.',
              actionLabel: 'Estudiar',
              onAction: () {
                startStudySession(ref);
                context.go(AppRoutes.study);
              },
            );
          }

          return _StatsBody(stats: value);
        },
      ),
    );
  }
}

class _StatsBody extends StatelessWidget {
  const _StatsBody({required this.stats});

  final StudyStats stats;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final semantics = theme.semantic;
    final accuracy = stats.accuracyPercent ?? 0;
    final streakLabel = stats.streakDays == 1
        ? '1 día de racha'
        : '${stats.streakDays} días de racha';

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.sm,
        AppSpacing.xl,
        AppSpacing.xxxl,
      ),
      children: [
        PaperCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(streakLabel, style: theme.textTheme.bodySmall),
              const SizedBox(height: AppSpacing.sm),
              Text(
                '$accuracy%',
                key: const Key('stats-accuracy'),
                style: theme.textTheme.displaySmall,
              ),
              Text('Precisión', style: theme.textTheme.titleMedium),
              const SizedBox(height: AppSpacing.lg),
              ClipRRect(
                borderRadius: BorderRadius.circular(99),
                child: LinearProgressIndicator(
                  value: accuracy / 100,
                  minHeight: 8,
                  color: semantics.success,
                  backgroundColor: scheme.primary.withValues(alpha: 0.12),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                '${stats.correctAnswers} aciertos · ${stats.incorrectAnswers} fallos',
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Row(
          children: [
            Expanded(
              child: ProgressMetricCard(
                label: 'Estudiadas',
                value: '${stats.cardsStudied}',
                icon: Icons.style_outlined,
                color: scheme.primary,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: ProgressMetricCard(
                label: 'Pendientes',
                value: '${stats.pendingCards}',
                icon: Icons.schedule_outlined,
                color: semantics.accent,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: ProgressMetricCard(
                label: 'Aciertos',
                value: '${stats.correctAnswers}',
                icon: Icons.check_circle_outline,
                color: semantics.success,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: ProgressMetricCard(
                label: 'Fallos',
                value: '${stats.incorrectAnswers}',
                icon: Icons.replay,
                color: scheme.error,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        PaperCard(
          onTap: () => context.push(AppRoutes.errors),
          child: Row(
            children: [
              Icon(Icons.replay, color: scheme.error),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Mis errores', style: theme.textTheme.titleMedium),
                    Text(
                      'Revisa las tarjetas que has fallado',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: scheme.onSurface.withValues(alpha: 0.48),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        PaperCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Actividad diaria', style: theme.textTheme.titleMedium),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Revisiones de los últimos 7 días',
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(height: AppSpacing.xl),
              DailyActivityChart(days: stats.dailyActivity),
            ],
          ),
        ),
      ],
    );
  }
}
