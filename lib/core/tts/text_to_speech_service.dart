import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

enum TtsFailure { emptyText, unavailable, languageUnavailable, playback }

class TtsException implements Exception {
  const TtsException(this.failure, {this.debugMessage});

  final TtsFailure failure;
  final String? debugMessage;

  String get userMessage {
    return switch (failure) {
      TtsFailure.emptyText => 'No hay texto para pronunciar.',
      TtsFailure.languageUnavailable =>
        'Este idioma no está disponible en el dispositivo.',
      TtsFailure.unavailable || TtsFailure.playback =>
        'No se pudo reproducir el audio.',
    };
  }

  @override
  String toString() => debugMessage ?? 'TtsException($failure)';
}

/// Contrato del motor TTS. La UI no usa [FlutterTts] directamente.
abstract class TextToSpeechService {
  Future<void> speak(String text);
  Future<void> stop();
  Future<void> pause();
  Future<void> setLanguage(String language);
  Future<void> setSpeechRate(double rate);
  Future<void> setPitch(double pitch);
  Future<void> dispose();
}

class FlutterTextToSpeechService implements TextToSpeechService {
  FlutterTextToSpeechService({FlutterTts? engine}) : _engine = engine ?? FlutterTts();

  final FlutterTts _engine;
  bool _ready = false;

  Future<void> _ensureReady() async {
    if (_ready) return;
    try {
      await _engine.awaitSpeakCompletion(true);
      _ready = true;
    } on Object catch (error, stackTrace) {
      debugPrint('No se pudo iniciar el TTS: $error\n$stackTrace');
      throw const TtsException(TtsFailure.unavailable);
    }
  }

  @override
  Future<void> speak(String text) async {
    await _ensureReady();
    final trimmed = text.trim();
    if (trimmed.isEmpty) {
      throw const TtsException(TtsFailure.emptyText);
    }

    try {
      final result = await _engine.speak(trimmed);
      if (result != 1) {
        throw const TtsException(TtsFailure.playback);
      }
    } on TtsException {
      rethrow;
    } on Object catch (error, stackTrace) {
      debugPrint('Error al pronunciar: $error\n$stackTrace');
      throw TtsException(TtsFailure.playback, debugMessage: error.toString());
    }
  }

  @override
  Future<void> stop() async {
    await _ensureReady();
    try {
      await _engine.stop();
    } on Object catch (error, stackTrace) {
      debugPrint('No se pudo detener el TTS: $error\n$stackTrace');
    }
  }

  @override
  Future<void> pause() async {
    await _ensureReady();
    try {
      await _engine.pause();
    } on Object catch (error, stackTrace) {
      debugPrint('No se pudo pausar el TTS: $error\n$stackTrace');
    }
  }

  @override
  Future<void> setLanguage(String language) async {
    await _ensureReady();
    try {
      final available = await _engine.isLanguageAvailable(language);
      if (!_isAvailable(available)) {
        throw const TtsException(TtsFailure.languageUnavailable);
      }
      await _engine.setLanguage(language);
    } on TtsException {
      rethrow;
    } on Object catch (error, stackTrace) {
      debugPrint('Idioma TTS no disponible ($language): $error\n$stackTrace');
      throw const TtsException(TtsFailure.languageUnavailable);
    }
  }

  @override
  Future<void> setSpeechRate(double rate) async {
    await _ensureReady();
    await _engine.setSpeechRate(_engineRate(rate));
  }

  @override
  Future<void> setPitch(double pitch) async {
    await _ensureReady();
    await _engine.setPitch(pitch.clamp(0.5, 2.0));
  }

  @override
  Future<void> dispose() async {
    if (!_ready) return;
    try {
      await _engine.stop();
    } on Object catch (error, stackTrace) {
      debugPrint('No se pudo cerrar el TTS: $error\n$stackTrace');
    }
  }

  /// iOS usa 0.5 como velocidad normal. Android acepta 0.0–1.0.
  static double engineRate(double multiplier) {
    return (0.5 * multiplier).clamp(0.1, 1.0);
  }

  double _engineRate(double multiplier) => engineRate(multiplier);

  static bool _isAvailable(dynamic value) {
    return value == true || value == 1;
  }
}
