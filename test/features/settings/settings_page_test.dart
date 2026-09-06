import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stickeenglishnotes/core/theme/app_theme.dart';
import 'package:stickeenglishnotes/core/theme/theme_controller.dart';
import 'package:stickeenglishnotes/features/settings/application/notification_settings_controller.dart';
import 'package:stickeenglishnotes/features/settings/presentation/pages/settings_page.dart';

import '../../helpers/fake_notifications.dart';

void main() {
  testWidgets('pide permiso al activar y muestra días y hora', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final permissions = FakeNotificationPermissionClient();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWith((ref) => preferences),
          studyReminderSchedulerProvider.overrideWith(
            (ref) => FakeStudyReminderScheduler(),
          ),
          notificationPermissionClientProvider.overrideWith((ref) => permissions),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          home: const SettingsPage(),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Notificaciones'), findsOneWidget);
    expect(find.text('Pronunciación'), findsOneWidget);
    expect(find.text('1.0x'), findsOneWidget);
    expect(find.text('L'), findsNothing);

    await tester.tap(find.byKey(const Key('notifications-enabled-switch')));
    await tester.pumpAndSettle();

    expect(permissions.requestCount, 1);
    expect(permissions.granted, isTrue);
    expect(find.text('L'), findsOneWidget);
    expect(find.text('09:00'), findsOneWidget);
  });

  testWidgets('si se niega el permiso el interruptor sigue apagado', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final permissions = FakeNotificationPermissionClient(
      requestShouldGrant: false,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWith((ref) => preferences),
          studyReminderSchedulerProvider.overrideWith(
            (ref) => FakeStudyReminderScheduler(),
          ),
          notificationPermissionClientProvider.overrideWith((ref) => permissions),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          home: const SettingsPage(),
        ),
      ),
    );
    await tester.pump();

    await tester.tap(find.byKey(const Key('notifications-enabled-switch')));
    await tester.pumpAndSettle();
    await _resumeApp(tester);

    expect(find.text('Sin permiso no podemos enviarte recordatorios.'), findsOneWidget);
    expect(find.text('L'), findsNothing);
    expect(
      tester.widget<Switch>(
        find.byKey(const Key('notifications-enabled-switch')),
      ).value,
      isFalse,
    );
  });

  testWidgets(
    'al volver a la app muestra días y hora si el permiso se aceptó',
    (tester) async {
      SharedPreferences.setMockInitialValues({});
      final preferences = await SharedPreferences.getInstance();
      final permissions = FakeNotificationPermissionClient(
        requestShouldGrant: false,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWith((ref) => preferences),
            studyReminderSchedulerProvider.overrideWith(
              (ref) => FakeStudyReminderScheduler(),
            ),
            notificationPermissionClientProvider.overrideWith(
              (ref) => permissions,
            ),
          ],
          child: MaterialApp(
            theme: AppTheme.light,
            home: const SettingsPage(),
          ),
        ),
      );
      await tester.pump();

      await tester.tap(find.byKey(const Key('notifications-enabled-switch')));
      await tester.pumpAndSettle();

      expect(find.text('L'), findsNothing);
      expect(
        tester.widget<Switch>(
          find.byKey(const Key('notifications-enabled-switch')),
        ).value,
        isFalse,
      );

      permissions.granted = true;
      await _resumeApp(tester);

      expect(find.text('L'), findsOneWidget);
      expect(find.text('09:00'), findsOneWidget);
      expect(
        tester.widget<Switch>(
          find.byKey(const Key('notifications-enabled-switch')),
        ).value,
        isTrue,
      );
    },
  );
}

Future<void> _resumeApp(WidgetTester tester) async {
  tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
  tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
  await tester.pump();
  tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
  await tester.pumpAndSettle();
}
