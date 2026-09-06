import '../../../data/models/card_enums.dart';

String cardTypeLabel(FlashcardType type) {
  return switch (type) {
    FlashcardType.word => 'Palabra',
    FlashcardType.phrase => 'Frase',
    FlashcardType.sentence => 'Oración',
  };
}
