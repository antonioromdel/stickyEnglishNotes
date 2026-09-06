import '../../../data/database/app_database.dart';

class FrequentCardError {
  const FrequentCardError({
    required this.card,
    required this.times,
    required this.lastAt,
    required this.lastCorrectAnswer,
  });

  final Flashcard card;
  final int times;
  final DateTime lastAt;
  final String lastCorrectAnswer;
}

List<FrequentCardError> groupFrequentErrors(
  Iterable<({CardError error, Flashcard card})> rows,
) {
  final byCard = <int, FrequentCardError>{};

  for (final row in rows) {
    final existing = byCard[row.card.id];
    if (existing == null) {
      byCard[row.card.id] = FrequentCardError(
        card: row.card,
        times: 1,
        lastAt: row.error.createdAt,
        lastCorrectAnswer: row.error.correctAnswer,
      );
      continue;
    }

    final isNewer = row.error.createdAt.isAfter(existing.lastAt);
    byCard[row.card.id] = FrequentCardError(
      card: row.card,
      times: existing.times + 1,
      lastAt: isNewer ? row.error.createdAt : existing.lastAt,
      lastCorrectAnswer:
          isNewer ? row.error.correctAnswer : existing.lastCorrectAnswer,
    );
  }

  return byCard.values.toList()
    ..sort((a, b) {
      final byTimes = b.times.compareTo(a.times);
      if (byTimes != 0) return byTimes;
      return b.lastAt.compareTo(a.lastAt);
    });
}

String errorRecencyLabel(DateTime lastAt, DateTime now) {
  final lastDay = DateTime(lastAt.year, lastAt.month, lastAt.day);
  final today = DateTime(now.year, now.month, now.day);
  final days = today.difference(lastDay).inDays;

  if (days <= 0) return 'Hoy';
  if (days == 1) return 'Ayer';
  return 'Hace $days días';
}
