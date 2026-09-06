import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/app_radii.dart';
import '../tts/speech_settings.dart';
import '../tts/tts_controller.dart';

class AudioButton extends ConsumerWidget {
  const AudioButton({
    super.key,
    required this.text,
    required this.voice,
    required this.utteranceId,
    this.color,
  });

  final String text;
  final SpeechVoice voice;
  final String utteranceId;
  final Color? color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (text.trim().isEmpty) return const SizedBox.shrink();

    final playback = ref.watch(ttsControllerProvider);
    final speaking = playback.isSpeakingId(utteranceId);
    final scheme = Theme.of(context).colorScheme;
    final iconColor = color ?? scheme.primary;

    return Tooltip(
      message: speaking ? 'Detener' : 'Escuchar pronunciación',
      child: Material(
        color: iconColor.withValues(alpha: speaking ? 0.16 : 0.08),
        shape: const CircleBorder(),
        child: InkWell(
          key: Key('audio-button-$utteranceId'),
          customBorder: const CircleBorder(),
          onTap: () => _toggle(context, ref, speaking),
          child: SizedBox(
            width: 44,
            height: 44,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              child: Icon(
                speaking ? Icons.stop_rounded : Icons.volume_up_rounded,
                key: ValueKey(speaking),
                color: iconColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _toggle(
    BuildContext context,
    WidgetRef ref,
    bool speaking,
  ) async {
    await ref.read(ttsControllerProvider.notifier).toggle(
          text: text,
          voice: voice,
          utteranceId: utteranceId,
        );
    if (!context.mounted) return;

    final next = ref.read(ttsControllerProvider);
    final message = next.errorMessage;
    if (next.status != TtsPlaybackStatus.error || message == null) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.md),
        ),
      ),
    );
    ref.read(ttsControllerProvider.notifier).clearError();
  }
}
