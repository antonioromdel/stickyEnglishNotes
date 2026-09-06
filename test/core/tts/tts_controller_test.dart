import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stickeenglishnotes/core/theme/theme_controller.dart';
import 'package:stickeenglishnotes/core/tts/speech_settings.dart';
import 'package:stickeenglishnotes/core/tts/speech_settings_controller.dart';
import 'package:stickeenglishnotes/core/tts/text_to_speech_service.dart';
import 'package:stickeenglishnotes/core/tts/tts_controller.dart';

import '../../helpers/fake_tts.dart';

void main() {
  late FakeTextToSpeechService tts;
  late ProviderContainer container;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    tts = FakeTextToSpeechService();
    container = ProviderContainer.test(
      overrides: [
        sharedPreferencesProvider.overrideWith((ref) => preferences),
        textToSpeechServiceProvider.overrideWith((ref) => tts),
      ],
    );
  });

  tearDown(() => container.dispose());

  test('ignora el texto vacío y no llama al motor', () async {
    await container.read(ttsControllerProvider.notifier).speak(
          text: '   ',
          voice: SpeechVoice.englishGb,
          utteranceId: 'front-1',
        );

    expect(container.read(ttsControllerProvider).status, TtsPlaybackStatus.idle);
    expect(tts.spoken, isEmpty);
  });

  test('pronuncia con el idioma y la velocidad configurados', () async {
    await container.read(speechSettingsProvider.notifier).setRate(SpeechRate.slow);
    await container.read(speechSettingsProvider.notifier).setLearningVoice(
          SpeechVoice.englishUs,
        );

    await container.read(ttsControllerProvider.notifier).speak(
          text: 'Although',
          voice: container.read(speechSettingsProvider).voiceFor('Although'),
          utteranceId: 'front-1',
        );

    expect(tts.spoken, ['Although']);
    expect(tts.languages, ['en-US']);
    expect(tts.rates, [0.75]);
    expect(container.read(ttsControllerProvider).status, TtsPlaybackStatus.idle);
  });

  test('stop deja el estado en stopped', () async {
    await container.read(ttsControllerProvider.notifier).speak(
          text: 'hello',
          voice: SpeechVoice.englishGb,
          utteranceId: 'front-1',
        );
    await container.read(ttsControllerProvider.notifier).stop();

    expect(tts.stopCount, greaterThan(0));
    expect(container.read(ttsControllerProvider).status, TtsPlaybackStatus.stopped);
  });

  test('toggle detiene la misma reproducción', () async {
    final controller = container.read(ttsControllerProvider.notifier);
    await controller.speak(
      text: 'hello',
      voice: SpeechVoice.englishGb,
      utteranceId: 'front-1',
    );
    container.read(ttsControllerProvider.notifier).debugSetSpeaking('front-1');

    await controller.toggle(
      text: 'hello',
      voice: SpeechVoice.englishGb,
      utteranceId: 'front-1',
    );

    expect(container.read(ttsControllerProvider).status, TtsPlaybackStatus.stopped);
  });

  test('un error del motor no se propaga y muestra un mensaje usable', () async {
    tts.failWith = TtsFailure.languageUnavailable;

    await container.read(ttsControllerProvider.notifier).speak(
          text: 'hello',
          voice: SpeechVoice.englishGb,
          utteranceId: 'front-1',
        );

    final state = container.read(ttsControllerProvider);
    expect(state.status, TtsPlaybackStatus.error);
    expect(state.errorMessage, isNotNull);
    expect(state.errorMessage, isNot(contains('PlatformException')));
  });

  test('un texto en español usa la voz es-ES', () async {
    await container.read(ttsControllerProvider.notifier).speak(
          text: 'Aunque',
          voice: SpeechVoice.spanish,
          utteranceId: 'back-1',
        );

    expect(tts.languages, ['es-ES']);
    expect(tts.spoken, ['Aunque']);
  });
}
