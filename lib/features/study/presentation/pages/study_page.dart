import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/tts/speech_settings_controller.dart';
import '../../../../core/tts/tts_controller.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../data/database/app_database.dart';
import '../../../../data/models/card_enums.dart';
import '../../../groups/application/groups_providers.dart';
import '../../application/study_controller.dart';
import '../../application/study_session.dart';
import '../widgets/flip_card.dart';
import '../widgets/study_card_face.dart';
import '../widgets/study_group_filter_bar.dart';
import '../widgets/study_progress_bar.dart';
import '../widgets/study_rating_buttons.dart';

class StudyPage extends ConsumerWidget {
  const StudyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(studyControllerProvider);
    final groups = ref.watch(cardGroupsProvider);
    final selectedGroupId = ref.watch(studyGroupFilterProvider);
    final groupsList = groups.maybeWhen(
      data: (value) => value,
      orElse: () => const <CardGroup>[],
    );
    final groupName = _groupName(groupsList, selectedGroupId);

    return Scaffold(
      appBar: AppBar(title: const Text('Estudiar')),
      body: session.when(
        skipLoadingOnReload: true,
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => AppEmptyState(
          icon: Icons.error_outline,
          title: 'No se pudo empezar la sesión',
          message: 'Inténtalo de nuevo.',
          actionLabel: 'Reintentar',
          onAction: () => ref.read(studyControllerProvider.notifier).restart(),
        ),
        data: (data) => Column(
          children: [
            if (groupsList.isNotEmpty)
              StudyGroupFilterBar(
                groups: groupsList,
                selectedGroupId: selectedGroupId,
                onSelected: (groupId) {
                  ref.read(studyGroupFilterProvider.notifier).select(groupId);
                },
              ),
            Expanded(
              child: _StudyBody(session: data, groupName: groupName),
            ),
          ],
        ),
      ),
    );
  }
}

class _StudyBody extends ConsumerWidget {
  const _StudyBody({required this.session, this.groupName});

  final StudySession session;
  final String? groupName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final speech = ref.watch(speechSettingsProvider);

    if (session.isEmptyLibrary) {
      return AppEmptyState(
        icon: Icons.menu_book_outlined,
        title: groupName == null
            ? 'Todavía no hay sesión'
            : 'Este grupo está vacío',
        message: groupName == null
            ? 'Crea tu primera tarjeta para comenzar a estudiar.'
            : 'Crea una tarjeta en $groupName para estudiarlo.',
        actionLabel: 'Crear tarjeta',
        onAction: () => context.push(
          session.groupId == null
              ? AppRoutes.createCard
              : AppRoutes.createCardInGroup(session.groupId!),
        ),
      );
    }

    if (session.isCaughtUp) {
      return AppEmptyState(
        icon: Icons.event_available_outlined,
        title: 'Estás al día',
        message: groupName == null
            ? 'No hay tarjetas pendientes ahora. Vuelve más tarde.'
            : 'No hay pendientes en $groupName. Prueba otro grupo o vuelve más tarde.',
      );
    }

    if (session.isComplete) {
      return _SessionComplete(answeredCount: session.answeredCount);
    }

    final card = session.current;
    if (card == null) {
      return session.answeredCount > 0
          ? _SessionComplete(answeredCount: session.answeredCount)
          : AppEmptyState(
              icon: Icons.event_available_outlined,
              title: 'Estás al día',
              message: groupName == null
                  ? 'No hay tarjetas pendientes ahora. Vuelve más tarde.'
                  : 'No hay pendientes en $groupName. Prueba otro grupo o vuelve más tarde.',
            );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.sm,
        AppSpacing.xl,
        AppSpacing.lg,
      ),
      child: Column(
        children: [
          StudyProgressBar(
            current: session.answeredCount,
            total: session.cards.length,
          ),
          const SizedBox(height: AppSpacing.xl),
          Expanded(
            child: FlipCard(
              key: ValueKey(card.id),
              isFlipped: session.isFlipped,
              onTap: () {
                ref.read(ttsControllerProvider.notifier).stop();
                ref.read(studyControllerProvider.notifier).flip();
              },
              front: StudyCardFace(
                key: const Key('study-card-front'),
                text: card.front,
                caption: 'Toca para voltear',
                voice: speech.voiceFor(card.front),
                utteranceId: 'study-front-${card.id}',
              ),
              back: StudyCardFace(
                key: const Key('study-card-back'),
                text: card.back,
                example: card.example,
                caption: '¿Qué tal lo recuerdas?',
                adaptToLines: true,
                voice: speech.voiceFor(card.back),
                utteranceId: 'study-back-${card.id}',
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          SizedBox(
            height: 80,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: session.isFlipped
                  ? StudyRatingButtons(
                      onRated: (rating) => _rate(context, ref, rating),
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _rate(
    BuildContext context,
    WidgetRef ref,
    ReviewRating rating,
  ) async {
    try {
      await ref.read(ttsControllerProvider.notifier).stop();
      await ref.read(studyControllerProvider.notifier).rate(rating);
    } catch (error, stackTrace) {
      debugPrint('No se pudo guardar la revisión: $error\n$stackTrace');
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo guardar la respuesta.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}

class _SessionComplete extends ConsumerWidget {
  const _SessionComplete({required this.answeredCount});

  final int answeredCount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final label = answeredCount == 1
        ? 'Has estudiado 1 tarjeta'
        : 'Has estudiado $answeredCount tarjetas';

    return AppEmptyState(
      icon: Icons.check_circle_outline,
      title: 'Sesión terminada',
      message: label,
      actionLabel: 'Estudiar de nuevo',
      onAction: () => ref.read(studyControllerProvider.notifier).restart(),
    );
  }
}

String? _groupName(List<CardGroup> groups, int? groupId) {
  if (groupId == null) return null;
  for (final group in groups) {
    if (group.id == groupId) return group.name;
  }
  return null;
}
