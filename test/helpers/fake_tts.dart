import 'package:stickeenglishnotes/core/tts/text_to_speech_service.dart';

class FakeTextToSpeechService implements TextToSpeechService {
  final spoken = <String>[];
  final languages = <String>[];
  final rates = <double>[];
  final pitches = <double>[];
  int stopCount = 0;
  int pauseCount = 0;
  int disposeCount = 0;
  TtsFailure? failWith;

  @override
  Future<void> speak(String text) async {
    if (failWith != null) throw TtsException(failWith!);
    if (text.trim().isEmpty) {
      throw const TtsException(TtsFailure.emptyText);
    }
    spoken.add(text);
  }

  @override
  Future<void> stop() async {
    stopCount += 1;
  }

  @override
  Future<void> pause() async {
    pauseCount += 1;
  }

  @override
  Future<void> setLanguage(String language) async {
    if (failWith == TtsFailure.languageUnavailable) {
      throw const TtsException(TtsFailure.languageUnavailable);
    }
    languages.add(language);
  }

  @override
  Future<void> setSpeechRate(double rate) async {
    rates.add(rate);
  }

  @override
  Future<void> setPitch(double pitch) async {
    pitches.add(pitch);
  }

  @override
  Future<void> dispose() async {
    disposeCount += 1;
  }
}
