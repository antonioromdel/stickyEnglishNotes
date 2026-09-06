import 'speech_language.dart';

/// Voces y velocidad de pronunciación, independientes del motor TTS.
class SpeechVoice {
  const SpeechVoice({
    required this.language,
    required this.locale,
    required this.label,
  });

  final String language;
  final String locale;
  final String label;

  static const englishGb = SpeechVoice(
    language: 'en',
    locale: 'en-GB',
    label: 'Reino Unido',
  );

  static const englishUs = SpeechVoice(
    language: 'en',
    locale: 'en-US',
    label: 'Estados Unidos',
  );

  static const spanish = SpeechVoice(
    language: 'es',
    locale: 'es-ES',
    label: 'Español',
  );

  static const englishVoices = [englishGb, englishUs];

  static SpeechVoice englishByLocale(String? locale) {
    if (locale == englishUs.locale) return englishUs;
    return englishGb;
  }

  @override
  bool operator ==(Object other) {
    return other is SpeechVoice &&
        other.language == language &&
        other.locale == locale;
  }

  @override
  int get hashCode => Object.hash(language, locale);
}

enum SpeechRate {
  slow(0.75, '0.75x'),
  normal(1.0, '1.0x'),
  fast(1.25, '1.25x');

  const SpeechRate(this.multiplier, this.label);

  final double multiplier;
  final String label;

  static SpeechRate byName(String? raw) {
    return SpeechRate.values.asNameMap()[raw] ?? SpeechRate.normal;
  }
}

class SpeechSettings {
  const SpeechSettings({
    required this.learningVoice,
    required this.explanationVoice,
    required this.rate,
  });

  static const defaults = SpeechSettings(
    learningVoice: SpeechVoice.englishGb,
    explanationVoice: SpeechVoice.spanish,
    rate: SpeechRate.normal,
  );

  final SpeechVoice learningVoice;
  final SpeechVoice explanationVoice;
  final SpeechRate rate;

  SpeechVoice voiceFor(String text) {
    return detectSpeechLanguage(text) == DetectedSpeechLanguage.spanish
        ? explanationVoice
        : learningVoice;
  }

  SpeechSettings copyWith({
    SpeechVoice? learningVoice,
    SpeechVoice? explanationVoice,
    SpeechRate? rate,
  }) {
    return SpeechSettings(
      learningVoice: learningVoice ?? this.learningVoice,
      explanationVoice: explanationVoice ?? this.explanationVoice,
      rate: rate ?? this.rate,
    );
  }
}
