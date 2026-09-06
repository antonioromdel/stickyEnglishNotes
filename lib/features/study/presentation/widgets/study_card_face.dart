import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/tts/speech_settings.dart';
import '../../../../core/widgets/audio_button.dart';
import '../../../../core/widgets/flashcard_face_text.dart';
import '../../../../core/widgets/paper_card.dart';

class StudyCardFace extends StatelessWidget {
  const StudyCardFace({
    super.key,
    required this.text,
    required this.caption,
    required this.voice,
    required this.utteranceId,
    this.example,
    this.adaptToLines = false,
  });

  final String text;
  final String caption;
  final SpeechVoice voice;
  final String utteranceId;
  final String? example;
  final bool adaptToLines;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PaperCard(
      expand: true,
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FlashcardFaceText(
                      text: text,
                      adaptToLines: adaptToLines,
                    ),
                    if (example != null && example!.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        example!,
                        style: theme.textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                    ],
                    const SizedBox(height: AppSpacing.lg),
                    AudioButton(
                      text: text,
                      voice: voice,
                      utteranceId: utteranceId,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Text(caption, style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}
