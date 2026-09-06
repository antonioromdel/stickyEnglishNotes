import 'package:flutter_test/flutter_test.dart';
import 'package:stickeenglishnotes/core/tts/text_to_speech_service.dart';

void main() {
  test('convierte la velocidad de la app a la del motor', () {
    expect(FlutterTextToSpeechService.engineRate(1.0), 0.5);
    expect(FlutterTextToSpeechService.engineRate(0.75), closeTo(0.375, 0.0001));
    expect(FlutterTextToSpeechService.engineRate(1.25), closeTo(0.625, 0.0001));
  });
}
