import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers.dart';
import '../../home/application/home_providers.dart';
import '../domain/study_stats.dart';

/// Combina reviews y pendientes sin consultar Drift desde el listener.
/// Una query extra ahí puede bloquear el isolate al registrar un fallo.
final studyStatsProvider = StreamProvider<StudyStats>((ref) {
  final pending = ref.watch(dueFlashcardsCountProvider).maybeWhen(
    data: (count) => count,
    orElse: () => 0,
  );

  return ref.watch(reviewsRepositoryProvider).watchAll().map((items) {
    return buildStudyStats(
      reviews: items,
      pendingCards: pending,
      now: DateTime.now(),
    );
  });
});
