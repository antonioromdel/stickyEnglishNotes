import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../study/application/study_controller.dart';
import '../../../study/application/study_session_store.dart';
import '../../application/home_providers.dart';
import '../widgets/home_hero_card.dart';
import '../widgets/home_shortcut_chip.dart';
import '../widgets/home_streak_badge.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dueCount = ref.watch(dueFlashcardsCountProvider);
    final previewCard = ref.watch(homePreviewCardProvider);
    final streak = ref.watch(studyStreakProvider);
    final canContinue = ref.watch(studySessionStoreProvider)?.isInProgress ?? false;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xl,
            AppSpacing.lg,
            AppSpacing.xl,
            AppSpacing.xxl,
          ),
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Hola 👋', style: theme.textTheme.headlineMedium),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        '¿Qué quieres practicar hoy?',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: scheme.onSurface.withValues(alpha: 0.68),
                        ),
                      ),
                    ],
                  ),
                ),
                streak.maybeWhen(
                  data: (days) => HomeStreakBadge(days: days),
                  orElse: () => const SizedBox.shrink(),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xxl),
            HomeHeroCard(
              word: previewCard.maybeWhen(
                data: (card) => card?.front ?? 'hello',
                orElse: () => 'hello',
              ),
              onTap: () => _startStudy(context, ref),
            ),
            const SizedBox(height: AppSpacing.lg),
            dueCount.when(
              loading: () => const LinearProgressIndicator(minHeight: 2),
              error: (error, _) => Text(
                'No se pudo cargar el progreso.',
                style: theme.textTheme.bodyMedium?.copyWith(color: scheme.error),
              ),
              data: (count) => _DueSummary(count: count),
            ),
            const SizedBox(height: AppSpacing.xl),
            DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadii.lg),
                boxShadow: AppShadows.colored(scheme.primary),
              ),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => _startStudy(context, ref),
                  icon: Icon(
                    canContinue
                        ? Icons.play_arrow_rounded
                        : Icons.menu_book_rounded,
                  ),
                  label: Text(canContinue ? 'Continuar' : 'Estudiar'),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => context.push(AppRoutes.createCard),
                icon: const Icon(Icons.add_rounded),
                label: const Text('Crear tarjeta'),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: HomeShortcutChip(
                    icon: Icons.style_outlined,
                    label: 'Mis tarjetas',
                    onTap: () => context.push(AppRoutes.cards),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: HomeShortcutChip(
                    icon: Icons.folder_outlined,
                    label: 'Ver grupos',
                    onTap: () => context.push(AppRoutes.groups),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            HomeShortcutChip(
              icon: Icons.replay,
              label: 'Mis errores',
              onTap: () => context.push(AppRoutes.errors),
            ),
          ],
        ),
      ),
    );
  }

  void _startStudy(BuildContext context, WidgetRef ref) {
    startStudySession(ref);
    context.go(AppRoutes.study);
  }
}

class _DueSummary extends StatelessWidget {
  const _DueSummary({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final label = count == 1
        ? '1 tarjeta pendiente'
        : '$count tarjetas pendientes';

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: scheme.primary.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(AppRadii.xl),
        ),
        child: Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(color: scheme.primary),
        ),
      ),
    );
  }
}
