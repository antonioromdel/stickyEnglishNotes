import 'package:google_mlkit_translation/google_mlkit_translation.dart';

/// Traduce un texto entre dos idiomas.
abstract class TranslatorEngine {
  const TranslatorEngine();

  Future<String> translate({
    required String text,
    required TranslateLanguage source,
    required TranslateLanguage target,
  });

  Future<void> close();
}
