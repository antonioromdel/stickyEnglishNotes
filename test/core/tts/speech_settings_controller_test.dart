import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stickeenglishnotes/core/theme/theme_controller.dart';
import 'package:stickeenglishnotes/core/tts/speech_settings.dart';
import 'package:stickeenglishnotes/core/tts/speech_settings_controller.dart';

void main() {
  test('persiste la velocidad y la voz de inglés', () async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final container = ProviderContainer.test(
      overrides: [
        sharedPreferencesProvider.overrideWith((ref) => preferences),
      ],
    );
    addTearDown(container.dispose);

    expect(container.read(speechSettingsProvider).rate, SpeechRate.normal);
    expect(
      container.read(speechSettingsProvider).learningVoice,
      SpeechVoice.englishGb,
    );

    await container.read(speechSettingsProvider.notifier).setRate(SpeechRate.fast);
    await container.read(speechSettingsProvider.notifier).setLearningVoice(
          SpeechVoice.englishUs,
        );

    final restored = ProviderContainer.test(
      overrides: [
        sharedPreferencesProvider.overrideWith((ref) => preferences),
      ],
    );
    addTearDown(restored.dispose);

    expect(restored.read(speechSettingsProvider).rate, SpeechRate.fast);
    expect(restored.read(speechSettingsProvider).learningVoice, SpeechVoice.englishUs);
  });
}
