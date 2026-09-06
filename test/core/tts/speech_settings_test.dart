import 'package:flutter_test/flutter_test.dart';
import 'package:stickeenglishnotes/core/tts/speech_settings.dart';

void main() {
  test('el inglés por defecto es en-GB y puede cambiar a en-US', () {
    expect(SpeechVoice.englishByLocale(null), SpeechVoice.englishGb);
    expect(SpeechVoice.englishByLocale('en-GB').locale, 'en-GB');
    expect(SpeechVoice.englishByLocale('en-US'), SpeechVoice.englishUs);
    expect(SpeechVoice.englishGb.language, 'en');
  });

  test('la velocidad por defecto es 1.0x', () {
    expect(SpeechRate.byName(null), SpeechRate.normal);
    expect(SpeechRate.normal.multiplier, 1.0);
    expect(SpeechRate.slow.multiplier, 0.75);
    expect(SpeechRate.fast.multiplier, 1.25);
  });

  test('elige la voz según el idioma del texto', () {
    const settings = SpeechSettings(
      learningVoice: SpeechVoice.englishUs,
      explanationVoice: SpeechVoice.spanish,
      rate: SpeechRate.slow,
    );

    expect(settings.voiceFor('Although'), SpeechVoice.englishUs);
    expect(
      settings.voiceFor('used to introduce a contrasting idea'),
      SpeechVoice.englishUs,
    );
    expect(settings.voiceFor('Aunque'), SpeechVoice.spanish);
    expect(settings.voiceFor('a pesar de'), SpeechVoice.spanish);
  });
}
