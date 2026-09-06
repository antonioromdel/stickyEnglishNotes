import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/paper_card.dart';
import '../../application/notification_settings_controller.dart';
import '../../domain/notification_reminder_settings.dart';

class NotificationSettingsSection extends ConsumerStatefulWidget {
  const NotificationSettingsSection({super.key});

  @override
  ConsumerState<NotificationSettingsSection> createState() =>
      _NotificationSettingsSectionState();
}

class _NotificationSettingsSectionState
    extends ConsumerState<NotificationSettingsSection>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _syncAfterResume();
    }
  }

  Future<void> _syncAfterResume() async {
    final denied =
        await ref.read(notificationSettingsProvider.notifier).syncWithSystem();
    if (!denied || !mounted) return;
    _showDeniedMessage();
  }

  void _showDeniedMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Sin permiso no podemos enviarte recordatorios.',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(notificationSettingsProvider);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Recordatorios', style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.md),
        PaperCard(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: AppSpacing.xs),
                    child: Icon(Icons.notifications_outlined),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Notificaciones', style: theme.textTheme.titleMedium),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'Un aviso en el teléfono para estudiar un rato',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    key: const Key('notifications-enabled-switch'),
                    value: settings.enabled,
                    onChanged: _setEnabled,
                  ),
                ],
              ),
              if (settings.enabled) ...[
                const SizedBox(height: AppSpacing.lg),
                Text('Días', style: theme.textTheme.titleSmall),
                const SizedBox(height: AppSpacing.sm),
                _WeekdaySelector(
                  selected: settings.weekdays,
                  onToggle: (weekday) {
                    ref
                        .read(notificationSettingsProvider.notifier)
                        .toggleWeekday(weekday);
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                InkWell(
                  key: const Key('notification-time'),
                  onTap: () => _pickTime(settings),
                  borderRadius: BorderRadius.circular(AppRadii.sm),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                    child: Row(
                      children: [
                        const Icon(Icons.schedule_outlined),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Text('Hora', style: theme.textTheme.titleMedium),
                        ),
                        Text(
                          settings.timeLabel,
                          style: theme.textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _setEnabled(bool enabled) async {
    final controller = ref.read(notificationSettingsProvider.notifier);
    final accepted = await controller.setEnabled(enabled);
    if (!mounted) return;
    if (accepted || !enabled || controller.isAwaitingPermission) return;
    _showDeniedMessage();
  }

  Future<void> _pickTime(NotificationReminderSettings settings) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: settings.hour, minute: settings.minute),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (picked == null) return;

    await ref.read(notificationSettingsProvider.notifier).setTime(
          hour: picked.hour,
          minute: picked.minute,
        );
  }
}

class _WeekdaySelector extends StatelessWidget {
  const _WeekdaySelector({
    required this.selected,
    required this.onToggle,
  });

  final Set<int> selected;
  final ValueChanged<int> onToggle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        for (final weekday in NotificationReminderSettings.weekdayOrder)
          _DayChip(
            weekday: weekday,
            label: NotificationReminderSettings.weekdayLabels[weekday]!,
            selected: selected.contains(weekday),
            selectedColor: scheme.primary,
            selectedForeground: scheme.onPrimary,
            idleColor: scheme.surfaceContainer,
            idleForeground: scheme.onSurface,
            onTap: () => onToggle(weekday),
          ),
      ],
    );
  }
}

class _DayChip extends StatelessWidget {
  const _DayChip({
    required this.weekday,
    required this.label,
    required this.selected,
    required this.selectedColor,
    required this.selectedForeground,
    required this.idleColor,
    required this.idleForeground,
    required this.onTap,
  });

  final int weekday;
  final String label;
  final bool selected;
  final Color selectedColor;
  final Color selectedForeground;
  final Color idleColor;
  final Color idleForeground;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? selectedColor : idleColor,
      borderRadius: BorderRadius.circular(AppRadii.sm),
      child: InkWell(
        key: Key('notification-day-$weekday'),
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadii.sm),
        child: SizedBox(
          width: 40,
          height: 40,
          child: Center(
            child: Text(
              label,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: selected ? selectedForeground : idleForeground,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
