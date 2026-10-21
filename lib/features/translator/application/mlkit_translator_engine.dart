import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';

import 'translator_engine.dart';

/// Traducción en el dispositivo con los modelos de ML Kit.
///
/// La primera vez descarga el idioma (hace falta conexión). Después
/// traduce sin red y sin coste de API.
class MlKitTranslatorEngine extends TranslatorEngine {
  MlKitTranslatorEngine() : _models = OnDeviceTranslatorModelManager();

  final OnDeviceTranslatorModelManager _models;
  OnDeviceTranslator? _translator;
  TranslateLanguage? _source;
  TranslateLanguage? _target;

  @override
  Future<String> translate({
    required String text,
    required TranslateLanguage source,
    required TranslateLanguage target,
  }) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return '';
    if (source == target) return text;

    await _ensureModel(source);
    await _ensureModel(target);

    if (_translator == null || _source != source || _target != target) {
      await _translator?.close();
      _translator = OnDeviceTranslator(
        sourceLanguage: source,
        targetLanguage: target,
      );
      _source = source;
      _target = target;
    }

    return _translator!.translateText(trimmed);
  }

  Future<void> _ensureModel(TranslateLanguage language) async {
    final code = language.bcpCode;
    if (await _models.isModelDownloaded(code)) return;

    final downloaded = await _models.downloadModel(code, isWifiRequired: false);
    if (!downloaded) {
      throw StateError('No se pudo descargar el modelo de $code.');
    }
  }

  @override
  Future<void> close() async {
    try {
      await _translator?.close();
    } on Object catch (error, stackTrace) {
      debugPrint('No se pudo cerrar el traductor: $error\n$stackTrace');
    } finally {
      _translator = null;
      _source = null;
      _target = null;
    }
  }
}

final translatorEngineProvider = Provider<TranslatorEngine>((ref) {
  final engine = MlKitTranslatorEngine();
  ref.onDispose(engine.close);
  return engine;
});
