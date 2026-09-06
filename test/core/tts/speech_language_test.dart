import 'package:flutter_test/flutter_test.dart';
import 'package:stickeenglishnotes/core/tts/speech_language.dart';

void main() {
  test('asume inglés si el texto está vacío o no es claro', () {
    expect(detectSpeechLanguage(''), DetectedSpeechLanguage.english);
    expect(detectSpeechLanguage('Although'), DetectedSpeechLanguage.english);
    expect(detectSpeechLanguage('look after'), DetectedSpeechLanguage.english);
  });

  test('detecta definiciones en inglés', () {
    expect(
      detectSpeechLanguage('used to introduce a contrasting idea'),
      DetectedSpeechLanguage.english,
    );
    expect(
      detectSpeechLanguage('I miss talking to people.'),
      DetectedSpeechLanguage.english,
    );
  });

  test('detecta español por palabras y signos propios', () {
    expect(detectSpeechLanguage('Aunque'), DetectedSpeechLanguage.spanish);
    expect(detectSpeechLanguage('a pesar de'), DetectedSpeechLanguage.spanish);
    expect(detectSpeechLanguage('¿Qué significa?'), DetectedSpeechLanguage.spanish);
    expect(detectSpeechLanguage('el significado de la palabra'), DetectedSpeechLanguage.spanish);
  });
}
