import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/theme/theme_controller.dart';
import 'features/settings/application/notification_settings_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferences = await SharedPreferences.getInstance();
  final container = ProviderContainer(
    overrides: [
      sharedPreferencesProvider.overrideWith((ref) => preferences),
    ],
  );

  try {
    await container.read(studyReminderServiceProvider).initialize();
  } on Object catch (error, stackTrace) {
    debugPrint('No se pudieron preparar los recordatorios: $error\n$stackTrace');
  }

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const StickyEnglishNotesApp(),
    ),
  );
}
