import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/app_drawer_button.dart';
import '../widgets/translator_language_bar.dart';
import '../widgets/translator_panels.dart';

class TranslatorPage extends StatelessWidget {
  const TranslatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurface.withValues(alpha: 0.6);

    return Scaffold(
      appBar: AppBar(
        leading: const AppDrawerButton(),
        title: const Text('Traductor'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.md,
          AppSpacing.lg,
          AppSpacing.xxl,
        ),
        children: [
          const TranslatorLanguageBar(),
          const SizedBox(height: AppSpacing.lg),
          const TranslatorInput(),
          const SizedBox(height: AppSpacing.md),
          const TranslatorResult(),
          const SizedBox(height: AppSpacing.md),
          Text(
            'La primera vez se descarga el idioma. Después puedes traducir sin conexión.',
            style: theme.textTheme.bodySmall?.copyWith(color: muted),
          ),
        ],
      ),
    );
  }
}
