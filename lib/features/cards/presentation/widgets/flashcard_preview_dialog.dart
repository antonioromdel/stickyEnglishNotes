import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_collection_palette.dart';
import '../../../../core/theme/app_semantic_colors.dart';
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
  List<Flashcard> cards = const [],
  void Function(Flashcard card)? onEdit,
  Future<void> Function(Flashcard card)? onDelete,
}) {
  return showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Cerrar tarjeta',
    barrierColor: Colors.black.withValues(alpha: 0.45),
    transitionDuration: const Duration(milliseconds: 220),
    pageBuilder: (context, animation, secondaryAnimation) {
      return FlashcardPreviewDialog(
        card: card,
        cards: cards,
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

List<Flashcard> previewFeed(Flashcard selected, List<Flashcard> cards) {
  if (cards.isEmpty) return [selected];
  final index = cards.indexWhere((card) => card.id == selected.id);
  if (index >= 0) return cards;
  return [selected, ...cards];
}

class FlashcardPreviewDialog extends ConsumerStatefulWidget {
  const FlashcardPreviewDialog({
    super.key,
    required this.card,
    this.cards = const [],
    this.onEdit,
    this.onDelete,
  });

  final Flashcard card;
  final List<Flashcard> cards;
  final void Function(Flashcard card)? onEdit;
  final Future<void> Function(Flashcard card)? onDelete;

  @override
  ConsumerState<FlashcardPreviewDialog> createState() =>
      _FlashcardPreviewDialogState();
}

class _FlashcardPreviewDialogState
    extends ConsumerState<FlashcardPreviewDialog> {
  late final List<Flashcard> _cards;
  late final PageController _pageController;
  late int _pageIndex;

  @override
  void initState() {
    super.initState();
    _cards = previewFeed(widget.card, widget.cards);
    _pageIndex = _cards.indexWhere((card) => card.id == widget.card.id);
    if (_pageIndex < 0) _pageIndex = 0;
    _pageController = PageController(initialPage: _pageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    ref.read(ttsControllerProvider.notifier).stop();
    setState(() => _pageIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final swatch = AppCollectionPalette.forId(
      _cards[_pageIndex].id,
      theme.brightness,
    );
    final canBrowse = _cards.length > 1;

    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          PageView.builder(
            key: const Key('preview-feed'),
            controller: _pageController,
            scrollDirection: Axis.vertical,
            itemCount: _cards.length,
            onPageChanged: _onPageChanged,
            physics: const PageScrollPhysics(parent: BouncingScrollPhysics()),
            itemBuilder: (context, index) {
              final card = _cards[index];
              return _PreviewPage(
                card: card,
                swatch: AppCollectionPalette.forId(card.id, theme.brightness),
                onEdit: widget.onEdit,
                onDelete: widget.onDelete,
              );
            },
          ),
          Positioned(
            top: AppSpacing.sm,
            right: AppSpacing.sm,
            child: SafeArea(
              child: IconButton.filled(
                key: const Key('preview-close-button'),
                tooltip: 'Cerrar',
                style: IconButton.styleFrom(
                  backgroundColor: swatch.onBackground.withValues(alpha: 0.16),
                  foregroundColor: swatch.onBackground,
                ),
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(Icons.close_rounded),
              ),
            ),
          ),
          if (canBrowse)
            Positioned(
              left: AppSpacing.lg,
              right: AppSpacing.lg,
              bottom: AppSpacing.md,
              child: SafeArea(
                child: Text(
                  'Desliza arriba o abajo',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.semantic.onHero.withValues(alpha: 0.9),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _PreviewPage extends ConsumerStatefulWidget {
  const _PreviewPage({
    required this.card,
    required this.swatch,
    this.onEdit,
    this.onDelete,
  });

  final Flashcard card;
  final CollectionSwatch swatch;
  final void Function(Flashcard card)? onEdit;
  final Future<void> Function(Flashcard card)? onDelete;

  @override
  ConsumerState<_PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends ConsumerState<_PreviewPage> {
  bool _isFlipped = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final buttonShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadii.lg),
    );
    final editStyle = FilledButton.styleFrom(
      minimumSize: const Size(0, 48),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      backgroundColor: scheme.primary,
      foregroundColor: scheme.onPrimary,
      shape: buttonShape,
    );
    final deleteStyle = FilledButton.styleFrom(
      minimumSize: const Size(0, 48),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      backgroundColor: scheme.error,
      foregroundColor: scheme.onError,
      shape: buttonShape,
    );
    final showActions = widget.onEdit != null || widget.onDelete != null;

    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cardHeight = math.min(280.0, constraints.maxHeight * 0.5);

          return Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.xl,
              AppSpacing.xxl,
              AppSpacing.xl,
              AppSpacing.xxl,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 360),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: cardHeight,
                      child: FlipCard(
                        isFlipped: _isFlipped,
                        onTap: () {
                          ref.read(ttsControllerProvider.notifier).stop();
                          setState(() => _isFlipped = !_isFlipped);
                        },
                        front: _PreviewFace(
                          key: Key('preview-front-${widget.card.id}'),
                          swatch: widget.swatch,
                          text: widget.card.front,
                          caption: 'Toca para voltear',
                          voice: ref
                              .watch(speechSettingsProvider)
                              .voiceFor(widget.card.front),
                          utteranceId: 'preview-front-${widget.card.id}',
                        ),
                        back: _PreviewFace(
                          key: Key('preview-back-${widget.card.id}'),
                          swatch: widget.swatch,
                          text: widget.card.back,
                          caption: widget.card.example ?? 'Toca para volver',
                          adaptToLines: true,
                          voice: ref
                              .watch(speechSettingsProvider)
                              .voiceFor(widget.card.back),
                          utteranceId: 'preview-back-${widget.card.id}',
                        ),
                      ),
                    ),
                    if (showActions) ...[
                      const SizedBox(height: AppSpacing.lg),
                      Row(
                        children: [
                          if (widget.onEdit != null)
                            Expanded(
                              child: FilledButton.icon(
                                key: Key('preview-edit-${widget.card.id}'),
                                onPressed: () {
                                  Navigator.of(context).maybePop();
                                  widget.onEdit!(widget.card);
                                },
                                style: editStyle,
                                icon: const Icon(Icons.edit_outlined),
                                label: const Text('Editar'),
                              ),
                            ),
                          if (widget.onEdit != null && widget.onDelete != null)
                            const SizedBox(width: AppSpacing.sm),
                          if (widget.onDelete != null)
                            Expanded(
                              child: FilledButton.icon(
                                key: Key('preview-delete-${widget.card.id}'),
                                onPressed: () =>
                                    widget.onDelete?.call(widget.card),
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
          );
        },
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
                  physics: const ClampingScrollPhysics(),
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
