import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stickeenglishnotes/core/theme/app_theme.dart';
import 'package:stickeenglishnotes/core/theme/theme_controller.dart';
import 'package:stickeenglishnotes/core/tts/speech_settings.dart';
import 'package:stickeenglishnotes/core/tts/text_to_speech_service.dart';
import 'package:stickeenglishnotes/core/tts/tts_controller.dart';
import 'package:stickeenglishnotes/core/widgets/audio_button.dart';

import '../../helpers/fake_tts.dart';

void main() {
  Future<void> pumpButton(
    WidgetTester tester, {
    required FakeTextToSpeechService tts,
    String text = 'Although',
  }) async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWith((ref) => preferences),
          textToSpeechServiceProvider.overrideWith((ref) => tts),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          home: Scaffold(
            body: AudioButton(
              text: text,
              voice: SpeechVoice.englishGb,
              utteranceId: 'card-front',
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('no muestra el botón si el texto está vacío', (tester) async {
    await pumpButton(tester, tts: FakeTextToSpeechService(), text: '  ');

    expect(find.byKey(const Key('audio-button-card-front')), findsNothing);
  });

  testWidgets('reproduce al pulsar y muestra error amigable', (tester) async {
    final tts = FakeTextToSpeechService()..failWith = TtsFailure.unavailable;
    await pumpButton(tester, tts: tts);

    await tester.tap(find.byKey(const Key('audio-button-card-front')));
    await tester.pump();
    await tester.pump();

    expect(find.text('No se pudo reproducir el audio.'), findsOneWidget);
    expect(find.textContaining('PlatformException'), findsNothing);
  });

  testWidgets('cambia el icono mientras reproduce si el motor se queda hablando', (
    tester,
  ) async {
    final tts = FakeTextToSpeechService();
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWith((ref) => preferences),
          textToSpeechServiceProvider.overrideWith((ref) => tts),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          home: Scaffold(
            body: Consumer(
              builder: (context, ref, _) {
                return Column(
                  children: [
                    AudioButton(
                      text: 'hello',
                      voice: SpeechVoice.englishGb,
                      utteranceId: 'card-front',
                    ),
                    TextButton(
                      onPressed: () {
                        ref
                            .read(ttsControllerProvider.notifier)
                            .debugSetSpeaking('card-front');
                      },
                      child: const Text('simular'),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.volume_up_rounded), findsOneWidget);

    await tester.tap(find.text('simular'));
    await tester.pump();

    expect(find.byIcon(Icons.stop_rounded), findsOneWidget);
  });
}
