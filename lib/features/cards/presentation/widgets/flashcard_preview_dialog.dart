import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_collection_palette.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/tts/speech_settings.dart';
import '../../../../core/tts/speech_settings_controller.dart';
import '../../../../core/tts/tts_controller.dart';
import '../../../../core/widgets/audio_button.dart';
import '../../../../core/widgets/flashcard_face_text.dart';
import '../../../../data/database/app_database.dart';
import '../../../study/presentation/widgets/flip_card.dart';

Future<void> showFlashcardPreview({
  required BuildContext context,
  required Flashcard card,
  VoidCallback? onEdit,
  Future<void> Function()? onDelete,
}) {
  final swatch = AppCollectionPalette.forId(
    card.id,
    Theme.of(context).brightness,
  );

  return showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Cerrar tarjeta',
    barrierColor: Colors.black.withValues(alpha: 0.45),
    transitionDuration: const Duration(milliseconds: 220),
    pageBuilder: (context, animation, secondaryAnimation) {
      return FlashcardPreviewDialog(
        card: card,
        swatch: swatch,
        onEdit: onEdit,
        onDelete: onDelete,
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.92, end: 1).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
          ),
          child: child,
        ),
      );
    },
  );
}

class FlashcardPreviewDialog extends ConsumerStatefulWidget {
  const FlashcardPreviewDialog({
    super.key,
    required this.card,
    required this.swatch,
    this.onEdit,
    this.onDelete,
  });

  final Flashcard card;
  final CollectionSwatch swatch;
  final VoidCallback? onEdit;
  final Future<void> Function()? onDelete;

  @override
  ConsumerState<FlashcardPreviewDialog> createState() =>
      _FlashcardPreviewDialogState();
}

class _FlashcardPreviewDialogState
    extends ConsumerState<FlashcardPreviewDialog> {
  bool _isFlipped = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final actionStyle = OutlinedButton.styleFrom(
      minimumSize: const Size(0, 44),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
    final deleteStyle = actionStyle.copyWith(
      foregroundColor: WidgetStatePropertyAll(theme.colorScheme.error),
      backgroundColor: WidgetStatePropertyAll(
        theme.colorScheme.error.withValues(alpha: 0.08),
      ),
      side: WidgetStatePropertyAll(
        BorderSide(color: theme.colorScheme.error.withValues(alpha: 0.36)),
      ),
    );

    return SafeArea(
      child: Material(
        type: MaterialType.transparency,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 360),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton.filled(
                        key: const Key('preview-close-button'),
                        tooltip: 'Cerrar',
                        style: IconButton.styleFrom(
                          backgroundColor: widget.swatch.onBackground
                              .withValues(alpha: 0.16),
                          foregroundColor: widget.swatch.onBackground,
                        ),
                        onPressed: () => Navigator.of(context).maybePop(),
                        icon: const Icon(Icons.close_rounded),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    SizedBox(
                      height: 280,
                      child: FlipCard(
                        isFlipped: _isFlipped,
                        onTap: () {
                          ref.read(ttsControllerProvider.notifier).stop();
                          setState(() => _isFlipped = !_isFlipped);
                        },
                        front: _PreviewFace(
                          key: const Key('preview-front'),
                          swatch: widget.swatch,
                          text: widget.card.front,
                          caption: 'Toca para voltear',
                          voice: ref.watch(speechSettingsProvider).voiceFor(widget.card.front),
                          utteranceId: 'preview-front-${widget.card.id}',
                        ),
                        back: _PreviewFace(
                          key: const Key('preview-back'),
                          swatch: widget.swatch,
                          text: widget.card.back,
                          caption: widget.card.example ?? 'Toca para volver',
                          adaptToLines: true,
                          voice: ref.watch(speechSettingsProvider).voiceFor(widget.card.back),
                          utteranceId: 'preview-back-${widget.card.id}',
                        ),
                      ),
                    ),
                    if (widget.onEdit != null || widget.onDelete != null) ...[
                      const SizedBox(height: AppSpacing.lg),
                      Row(
                        children: [
                          if (widget.onEdit != null)
                            Expanded(
                              child: OutlinedButton.icon(
                                key: const Key('preview-edit-button'),
                                onPressed: () {
                                  Navigator.of(context).maybePop();
                                  widget.onEdit!();
                                },
                                style: actionStyle,
                                icon: const Icon(Icons.edit_outlined),
                                label: const Text('Editar'),
                              ),
                            ),
                          if (widget.onEdit != null && widget.onDelete != null)
                            const SizedBox(width: AppSpacing.sm),
                          if (widget.onDelete != null)
                            Expanded(
                              child: OutlinedButton.icon(
                                key: const Key('preview-delete-button'),
                                onPressed: () {
                                  widget.onDelete?.call();
                                },
                                style: deleteStyle,
                                icon: const Icon(Icons.delete_outline),
                                label: const Text('Eliminar'),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PreviewFace extends StatelessWidget {
  const _PreviewFace({
    super.key,
    required this.swatch,
    required this.text,
    required this.caption,
    required this.voice,
    required this.utteranceId,
    this.adaptToLines = false,
  });

  final CollectionSwatch swatch;
  final String text;
  final String caption;
  final SpeechVoice voice;
  final String utteranceId;
  final bool adaptToLines;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadii.card),
        boxShadow: AppShadows.colored(swatch.background),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          color: swatch.background,
          borderRadius: BorderRadius.circular(AppRadii.card),
        ),
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
                        color: swatch.onBackground,
                        singleLineFontSize: 34,
                        adaptToLines: adaptToLines,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      AudioButton(
                        text: text,
                        voice: voice,
                        utteranceId: utteranceId,
                        color: swatch.onBackground,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Text(
              caption,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: swatch.onBackground.withValues(alpha: 0.78),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
