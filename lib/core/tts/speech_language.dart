enum DetectedSpeechLanguage { english, spanish }

/// Detecta inglés o español en el propio dispositivo, sin APIs.
/// Si no hay señales claras, asume inglés: es el idioma que más se guarda.
DetectedSpeechLanguage detectSpeechLanguage(String text) {
  final normalized = text.toLowerCase().trim();
  if (normalized.isEmpty) return DetectedSpeechLanguage.english;

  var spanish = 0;
  var english = 0;

  for (final rune in normalized.runes) {
    final character = String.fromCharCode(rune);
    if (_strongSpanishCharacters.contains(character)) {
      spanish += 3;
    } else if (_spanishAccents.contains(character)) {
      spanish += 2;
    }
  }

  final words = normalized
      .split(RegExp(r'[^a-záéíóúüñ]+'))
      .where((word) => word.length >= 2);

  for (final word in words) {
    if (_spanishWords.contains(word)) spanish += 2;
    if (_englishWords.contains(word)) english += 2;
  }

  if (spanish > english) return DetectedSpeechLanguage.spanish;
  return DetectedSpeechLanguage.english;
}

const _strongSpanishCharacters = {'ñ', '¿', '¡'};

const _spanishAccents = {'á', 'é', 'í', 'ó', 'ú', 'ü'};

const _spanishWords = {
  'el',
  'la',
  'los',
  'las',
  'un',
  'una',
  'del',
  'que',
  'por',
  'para',
  'con',
  'es',
  'son',
  'hay',
  'pero',
  'este',
  'esta',
  'esto',
  'muy',
  'más',
  'tambien',
  'también',
  'cuando',
  'donde',
  'dónde',
  'como',
  'cómo',
  'está',
  'están',
  'hola',
  'aunque',
  'porque',
  'gracias',
  'palabra',
  'significado',
  'definicion',
  'definición',
  'pesar',
};

const _englishWords = {
  'the',
  'of',
  'to',
  'and',
  'in',
  'is',
  'it',
  'for',
  'on',
  'with',
  'as',
  'that',
  'this',
  'from',
  'by',
  'or',
  'are',
  'was',
  'be',
  'been',
  'have',
  'has',
  'not',
  'but',
  'they',
  'you',
  'we',
  'an',
  'used',
  'meaning',
  'means',
  'which',
  'when',
  'what',
  'who',
  'how',
  'definition',
  'word',
  'despite',
  'although',
  'because',
};
