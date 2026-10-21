import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../application/translator_controller.dart';

class TranslatorInput extends ConsumerStatefulWidget {
  const TranslatorInput({super.key});

  @override
  ConsumerState<TranslatorInput> createState() => _TranslatorInputState();
}

class _TranslatorInputState extends ConsumerState<TranslatorInput> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasText = _controller.text.isNotEmpty;

    return TextField(
      key: const Key('translator-input'),
      controller: _controller,
      minLines: 4,
      maxLines: 8,
      textCapitalization: TextCapitalization.sentences,
      onChanged: (value) {
        setState(() {});
        ref.read(translatorControllerProvider.notifier).setInput(value);
      },
      decoration: InputDecoration(
        hintText: 'Escribe para traducir',
        alignLabelWithHint: true,
        suffixIcon: hasText
            ? IconButton(
                key: const Key('translator-clear'),
                tooltip: 'Borrar',
                onPressed: _clear,
                icon: const Icon(Icons.close),
              )
            : null,
      ),
    );
  }

  void _clear() {
    _controller.clear();
    setState(() {});
    ref.read(translatorControllerProvider.notifier).clear();
  }
}

class TranslatorResult extends ConsumerWidget {
  const TranslatorResult({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final view = ref.watch(translatorControllerProvider);
    final theme = Theme.of(context);
    final hasOutput = view.output.trim().isNotEmpty;
    final muted = theme.colorScheme.onSurface.withValues(alpha: 0.6);

    return Material(
      color: theme.colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(AppRadii.card),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.sm,
          AppSpacing.sm,
          AppSpacing.lg,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Traducción',
                  style: theme.textTheme.labelLarge?.copyWith(color: muted),
                ),
                const Spacer(),
                if (view.loading)
                  const Padding(
                    padding: EdgeInsets.only(right: AppSpacing.sm),
                    child: SizedBox(
                      key: Key('translator-loading'),
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                if (hasOutput)
                  IconButton(
                    key: const Key('translator-copy'),
                    tooltip: 'Copiar',
                    onPressed: () => _copy(context, view.output),
                    icon: const Icon(Icons.copy_outlined),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.sm),
              child: view.error == null
                  ? SelectableText(
                      key: const Key('translator-output'),
                      hasOutput ? view.output : 'La traducción aparecerá aquí',
                      style: hasOutput
                          ? theme.textTheme.titleLarge
                          : theme.textTheme.bodyLarge?.copyWith(color: muted),
                    )
                  : Text(
                      view.error!,
                      key: const Key('translator-error'),
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.error,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _copy(BuildContext context, String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Traducción copiada')));
  }
}
