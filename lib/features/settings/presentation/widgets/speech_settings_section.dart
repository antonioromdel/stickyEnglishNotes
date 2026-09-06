import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/tts/speech_settings.dart';
import '../../../../core/tts/speech_settings_controller.dart';
import '../../../../core/widgets/paper_card.dart';

class SpeechSettingsSection extends ConsumerWidget {
  const SpeechSettingsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(speechSettingsProvider);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Pronunciación', style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.md),
        PaperCard(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Velocidad', style: theme.textTheme.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  for (final rate in SpeechRate.values)
                    ChoiceChip(
                      key: Key('speech-rate-${rate.label}'),
                      label: Text(rate.label),
                      selected: settings.rate == rate,
                      onSelected: (_) {
                        ref.read(speechSettingsProvider.notifier).setRate(rate);
                      },
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
              Text('Inglés detectado', style: theme.textTheme.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  for (final voice in SpeechVoice.englishVoices)
                    ChoiceChip(
                      key: Key('speech-voice-${voice.locale}'),
                      label: Text(voice.label),
                      selected: settings.learningVoice == voice,
                      selectedColor: scheme.primaryContainer,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadii.sm),
                      ),
                      onSelected: (_) {
                        ref
                            .read(speechSettingsProvider.notifier)
                            .setLearningVoice(voice);
                      },
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
