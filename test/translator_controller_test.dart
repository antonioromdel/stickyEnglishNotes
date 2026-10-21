import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:stickeenglishnotes/features/translator/application/mlkit_translator_engine.dart';
import 'package:stickeenglishnotes/features/translator/application/translator_controller.dart';
import 'package:stickeenglishnotes/features/translator/application/translator_engine.dart';

import 'helpers/fake_translator.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('traduce cuando el texto deja de cambiar', () async {
    final engine = FakeTranslatorEngine(
      (text, source, target) async => 'hello',
    );
    final container = _container(engine);
    addTearDown(container.dispose);

    container.read(translatorControllerProvider.notifier).setInput('hola');
    await Future<void>.delayed(Duration.zero);

    final view = container.read(translatorControllerProvider);
    expect(engine.texts, ['hola']);
    expect(view.output, 'hello');
    expect(view.loading, isFalse);
    expect(view.error, isNull);
  });

  test('un texto vacío borra la traducción', () async {
    final engine = FakeTranslatorEngine(
      (text, source, target) async => 'hello',
    );
    final container = _container(engine);
    addTearDown(container.dispose);
    final notifier = container.read(translatorControllerProvider.notifier);

    notifier.setInput('hola');
    await Future<void>.delayed(Duration.zero);
    notifier.setInput('   ');
    await Future<void>.delayed(Duration.zero);

    final view = container.read(translatorControllerProvider);
    expect(view.output, isEmpty);
    expect(view.loading, isFalse);
    expect(engine.texts, ['hola']);
  });

  test('solo traduce la última petición', () async {
    final engine = FakeTranslatorEngine(
      (text, source, target) async => text.toUpperCase(),
    );
    final container = _container(engine);
    addTearDown(container.dispose);
    final notifier = container.read(translatorControllerProvider.notifier);

    notifier.setInput('uno');
    notifier.setInput('dos');
    await Future<void>.delayed(Duration.zero);

    expect(engine.texts, ['dos']);
    expect(container.read(translatorControllerProvider).output, 'DOS');
  });

  test('intercambia los idiomas y evita que coincidan', () {
    final container = _container(const EchoTranslatorEngine());
    addTearDown(container.dispose);
    final notifier = container.read(translatorControllerProvider.notifier);

    notifier.swapLanguages();
    var view = container.read(translatorControllerProvider);
    expect(view.source, TranslateLanguage.english);
    expect(view.target, TranslateLanguage.spanish);

    notifier.setSource(TranslateLanguage.spanish);
    view = container.read(translatorControllerProvider);
    expect(view.source, TranslateLanguage.spanish);
    expect(view.target, TranslateLanguage.english);
  });

  test('muestra un error si la traducción falla', () async {
    final engine = FakeTranslatorEngine(
      (text, source, target) async => throw StateError('sin modelo'),
    );
    final container = _container(engine);
    addTearDown(container.dispose);

    container.read(translatorControllerProvider.notifier).setInput('hola');
    await Future<void>.delayed(Duration.zero);

    final view = container.read(translatorControllerProvider);
    expect(view.loading, isFalse);
    expect(view.error, contains('conexión'));
  });
}

ProviderContainer _container(TranslatorEngine engine) {
  return ProviderContainer(
    overrides: [
      translatorEngineProvider.overrideWith((ref) => engine),
      translatorDebounceProvider.overrideWith((ref) => Duration.zero),
    ],
  );
}
