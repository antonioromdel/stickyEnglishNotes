import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'speech_settings.dart';
import 'speech_settings_controller.dart';
import 'text_to_speech_service.dart';

enum TtsPlaybackStatus { idle, speaking, stopped, error }

class TtsPlaybackState {
  const TtsPlaybackState({
    required this.status,
    this.utteranceId,
    this.errorMessage,
  });

  const TtsPlaybackState.idle()
      : this(status: TtsPlaybackStatus.idle);

  const TtsPlaybackState.speaking(String utteranceId)
      : this(status: TtsPlaybackStatus.speaking, utteranceId: utteranceId);

  const TtsPlaybackState.stopped()
      : this(status: TtsPlaybackStatus.stopped);

  const TtsPlaybackState.error(String message)
      : this(status: TtsPlaybackStatus.error, errorMessage: message);

  final TtsPlaybackStatus status;
  final String? utteranceId;
  final String? errorMessage;

  bool get isSpeaking => status == TtsPlaybackStatus.speaking;

  bool isSpeakingId(String id) => isSpeaking && utteranceId == id;
}

final textToSpeechServiceProvider = Provider<TextToSpeechService>((ref) {
  final service = FlutterTextToSpeechService();
  ref.onDispose(service.dispose);
  return service;
});

class TtsController extends Notifier<TtsPlaybackState> {
  @override
  TtsPlaybackState build() => const TtsPlaybackState.idle();

  TextToSpeechService get _service => ref.read(textToSpeechServiceProvider);

  Future<void> toggle({
    required String text,
    required SpeechVoice voice,
    required String utteranceId,
  }) async {
    if (state.isSpeakingId(utteranceId)) {
      await stop();
      return;
    }
    await speak(text: text, voice: voice, utteranceId: utteranceId);
  }

  Future<void> speak({
    required String text,
    required SpeechVoice voice,
    required String utteranceId,
  }) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) {
      state = const TtsPlaybackState.idle();
      return;
    }

    await _service.stop();
    state = TtsPlaybackState.speaking(utteranceId);

    try {
      final settings = ref.read(speechSettingsProvider);
      await _service.setSpeechRate(settings.rate.multiplier);
      await _service.setLanguage(voice.locale);
      await _service.speak(trimmed);
      if (!ref.mounted) return;
      if (state.utteranceId == utteranceId) {
        state = const TtsPlaybackState.idle();
      }
    } on TtsException catch (error, stackTrace) {
      debugPrint('TTS: ${error.userMessage}\n$stackTrace');
      if (!ref.mounted) return;
      state = TtsPlaybackState.error(error.userMessage);
    } on Object catch (error, stackTrace) {
      debugPrint('TTS inesperado: $error\n$stackTrace');
      if (!ref.mounted) return;
      state = const TtsPlaybackState.error('No se pudo reproducir el audio.');
    }
  }

  Future<void> stop() async {
    try {
      await _service.stop();
    } on Object catch (error, stackTrace) {
      debugPrint('No se pudo detener el TTS: $error\n$stackTrace');
    }
    if (!ref.mounted) return;
    state = const TtsPlaybackState.stopped();
  }

  void clearError() {
    if (state.status == TtsPlaybackStatus.error) {
      state = const TtsPlaybackState.idle();
    }
  }

  @visibleForTesting
  void debugSetSpeaking(String utteranceId) {
    state = TtsPlaybackState.speaking(utteranceId);
  }
}

final ttsControllerProvider =
    NotifierProvider<TtsController, TtsPlaybackState>(TtsController.new);
