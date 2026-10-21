import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';

import '../../../../core/constants/app_radii.dart';
import '../../application/translator_controller.dart';
import '../translator_languages.dart';
import 'translator_language_picker.dart';

class TranslatorLanguageBar extends ConsumerWidget {
  const TranslatorLanguageBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final view = ref.watch(translatorControllerProvider);
    final notifier = ref.read(translatorControllerProvider.notifier);

    return Row(
      children: [
        Expanded(
          child: _LanguageButton(
            buttonKey: const Key('translator-source'),
            label: translatorLanguageLabel(view.source),
            onPressed: () => _pick(
              context,
              selected: view.source,
              onSelected: notifier.setSource,
            ),
          ),
        ),
        IconButton(
          key: const Key('translator-swap'),
          tooltip: 'Intercambiar idiomas',
          onPressed: notifier.swapLanguages,
          icon: const Icon(Icons.swap_horiz),
        ),
        Expanded(
          child: _LanguageButton(
            buttonKey: const Key('translator-target'),
            label: translatorLanguageLabel(view.target),
            onPressed: () => _pick(
              context,
              selected: view.target,
              onSelected: notifier.setTarget,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _pick(
    BuildContext context, {
    required TranslateLanguage selected,
    required ValueChanged<TranslateLanguage> onSelected,
  }) async {
    final language = await showTranslatorLanguagePicker(
      context,
      selected: selected,
    );
    if (language != null) onSelected(language);
  }
}

class _LanguageButton extends StatelessWidget {
  const _LanguageButton({
    required this.buttonKey,
    required this.label,
    required this.onPressed,
  });

  final Key buttonKey;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      key: buttonKey,
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.lg),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
      child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
    );
  }
}
