import 'dart:convert';

class StudySessionSnapshot {
  const StudySessionSnapshot({
    required this.cardIds,
    required this.index,
    required this.answeredCount,
    this.groupId,
  });

  static const storageKey = 'study_session_snapshot';

  final List<int> cardIds;
  final int index;
  final int answeredCount;
  final int? groupId;

  bool get isInProgress => cardIds.isNotEmpty && index < cardIds.length;

  String encode() => jsonEncode({
        'cardIds': cardIds,
        'index': index,
        'answeredCount': answeredCount,
        'groupId': groupId,
      });

  static StudySessionSnapshot? decode(String? raw) {
    if (raw == null || raw.isEmpty) return null;

    try {
      final json = jsonDecode(raw);
      if (json is! Map<String, dynamic>) return null;

      final ids = (json['cardIds'] as List<dynamic>?)
              ?.map((value) => value is int ? value : int.tryParse('$value'))
              .whereType<int>()
              .toList() ??
          const <int>[];

      return StudySessionSnapshot(
        cardIds: ids,
        index: json['index'] as int? ?? 0,
        answeredCount: json['answeredCount'] as int? ?? 0,
        groupId: json['groupId'] as int?,
      );
    } on Object {
      return null;
    }
  }

  @override
  bool operator ==(Object other) {
    return other is StudySessionSnapshot &&
        other.index == index &&
        other.answeredCount == answeredCount &&
        other.groupId == groupId &&
        _sameIds(other.cardIds, cardIds);
  }

  @override
  int get hashCode => Object.hash(index, answeredCount, groupId, Object.hashAll(cardIds));
}

bool _sameIds(List<int> left, List<int> right) {
  if (left.length != right.length) return false;
  for (var i = 0; i < left.length; i++) {
    if (left[i] != right[i]) return false;
  }
  return true;
}
