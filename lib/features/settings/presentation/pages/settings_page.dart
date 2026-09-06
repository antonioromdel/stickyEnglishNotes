import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_info.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/theme_controller.dart';
import '../widgets/notification_settings_section.dart';
import '../widgets/speech_settings_section.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeControllerProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Ajustes')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        children: [
          const NotificationSettingsSection(),
          const SizedBox(height: AppSpacing.xxxl),
          const SpeechSettingsSection(),
          const SizedBox(height: AppSpacing.xxxl),
          Text('Apariencia', style: theme.textTheme.titleMedium),
          const SizedBox(height: AppSpacing.md),
          ...[
            (
              mode: ThemeMode.system,
              label: 'Sistema',
              icon: Icons.brightness_auto,
            ),
            (
              mode: ThemeMode.light,
              label: 'Claro',
              icon: Icons.light_mode_outlined,
            ),
            (
              mode: ThemeMode.dark,
              label: 'Oscuro',
              icon: Icons.dark_mode_outlined,
            ),
          ].map((option) {
            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(option.icon),
              title: Text(option.label),
              trailing: themeMode == option.mode
                  ? Icon(Icons.check, color: theme.colorScheme.primary)
                  : null,
              onTap: () {
                ref.read(themeControllerProvider.notifier).setMode(option.mode);
              },
            );
          }),
          const SizedBox(height: AppSpacing.xxxl),
          Text(AppInfo.name, style: theme.textTheme.bodySmall),
          Text('Modo offline', style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}
