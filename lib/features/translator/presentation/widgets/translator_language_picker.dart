import 'package:flutter/material.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';

import '../../../../core/constants/app_spacing.dart';
import '../translator_languages.dart';

Future<TranslateLanguage?> showTranslatorLanguagePicker(
  BuildContext context, {
  required TranslateLanguage selected,
}) {
  return showModalBottomSheet<TranslateLanguage>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) {
      final height = MediaQuery.sizeOf(context).height * 0.72;
      return SizedBox(
        height: height,
        child: _LanguagePicker(selected: selected),
      );
    },
  );
}

class _LanguagePicker extends StatefulWidget {
  const _LanguagePicker({required this.selected});

  final TranslateLanguage selected;

  @override
  State<_LanguagePicker> createState() => _LanguagePickerState();
}

class _LanguagePickerState extends State<_LanguagePicker> {
  final _search = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final languages = _filtered();
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      child: Column(
        children: [
          Text('Idioma', style: theme.textTheme.titleMedium),
          const SizedBox(height: AppSpacing.md),
          TextField(
            key: const Key('translator-language-search'),
            controller: _search,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Buscar idioma',
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (value) => setState(() => _query = value),
          ),
          const SizedBox(height: AppSpacing.sm),
          Expanded(
            child: languages.isEmpty
                ? Center(
                    child: Text(
                      'Ningún idioma coincide',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.6,
                        ),
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: languages.length,
                    itemBuilder: (context, index) {
                      final language = languages[index];
                      final label = translatorLanguageLabel(language);
                      return ListTile(
                        key: Key('translator-language-$label'),
                        title: Text(label),
                        trailing: language == widget.selected
                            ? Icon(
                                Icons.check,
                                color: theme.colorScheme.primary,
                              )
                            : null,
                        onTap: () => Navigator.of(context).pop(language),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  List<TranslateLanguage> _filtered() {
    final query = _query.trim().toLowerCase();
    final languages = sortedTranslatorLanguages();
    if (query.isEmpty) return languages;
    return languages
        .where(
          (language) =>
              translatorLanguageLabel(language).toLowerCase().contains(query),
        )
        .toList();
  }
}
