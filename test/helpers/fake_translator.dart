import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:stickeenglishnotes/features/translator/application/translator_engine.dart';

/// Motor de traducción para tests. No descarga modelos.
class EchoTranslatorEngine extends TranslatorEngine {
  const EchoTranslatorEngine();

  @override
  Future<String> translate({
    required String text,
    required TranslateLanguage source,
    required TranslateLanguage target,
  }) async {
    return text.trim();
  }

  @override
  Future<void> close() async {}
}

class FakeTranslatorEngine extends TranslatorEngine {
  FakeTranslatorEngine(this._translate);

  final Future<String> Function(
    String text,
    TranslateLanguage source,
    TranslateLanguage target,
  )
  _translate;

  final texts = <String>[];

  @override
  Future<String> translate({
    required String text,
    required TranslateLanguage source,
    required TranslateLanguage target,
  }) {
    texts.add(text);
    return _translate(text, source, target);
  }

  @override
  Future<void> close() async {}
}
