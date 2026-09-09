import '../../../data/models/card_enums.dart';

/// Datos del formulario de creación, independientes de la UI.
class CardDraft {
  const CardDraft({
    required this.front,
    required this.back,
    this.example = '',
    this.type = FlashcardType.word,
    this.groupIds = const {},
    this.source = CardSource.manual,
  });

  final String front;
  final String back;
  final String example;
  final FlashcardType type;
  final Set<int> groupIds;
  final CardSource source;

  String get trimmedFront => front.trim();
  String get trimmedBack => back.trim();

  String? get trimmedExample {
    final value = example.trim();
    return value.isEmpty ? null : value;
  }

  String? get frontError {
    if (trimmedFront.isEmpty) return 'Escribe el frente';
    return null;
  }

  String? get backError {
    if (trimmedBack.isEmpty) return 'Escribe el reverso';
    return null;
  }

  bool get isValid => frontError == null && backError == null;
}
