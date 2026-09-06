import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../theme/theme_controller.dart';
import 'speech_settings.dart';

const _rateKey = 'speech_rate';
const _learningLocaleKey = 'speech_learning_locale';

class SpeechSettingsController extends Notifier<SpeechSettings> {
  @override
  SpeechSettings build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    return SpeechSettings(
      learningVoice: SpeechVoice.englishByLocale(prefs.getString(_learningLocaleKey)),
      explanationVoice: SpeechVoice.spanish,
      rate: SpeechRate.byName(prefs.getString(_rateKey)),
    );
  }

  Future<void> setRate(SpeechRate rate) async {
    state = state.copyWith(rate: rate);
    await ref.read(sharedPreferencesProvider).setString(_rateKey, rate.name);
  }

  Future<void> setLearningVoice(SpeechVoice voice) async {
    state = state.copyWith(learningVoice: voice);
    await ref.read(sharedPreferencesProvider).setString(
          _learningLocaleKey,
          voice.locale,
        );
  }
}

final speechSettingsProvider =
    NotifierProvider<SpeechSettingsController, SpeechSettings>(
  SpeechSettingsController.new,
);
