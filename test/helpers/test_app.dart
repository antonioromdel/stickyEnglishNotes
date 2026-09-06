import 'package:drift/drift.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stickeenglishnotes/app.dart';
import 'package:stickeenglishnotes/core/theme/theme_controller.dart';
import 'package:stickeenglishnotes/core/tts/tts_controller.dart';
import 'package:stickeenglishnotes/data/database/app_database.dart';
import 'package:stickeenglishnotes/data/providers.dart';
import 'package:stickeenglishnotes/features/errors/application/errors_providers.dart';
import 'package:stickeenglishnotes/features/groups/application/groups_providers.dart';
import 'package:stickeenglishnotes/features/settings/application/notification_settings_controller.dart';

import 'fake_notifications.dart';
import 'fake_tts.dart';
import 'package:stickeenglishnotes/features/home/application/home_providers.dart';
import 'package:stickeenglishnotes/features/statistics/application/statistics_providers.dart';
import 'package:stickeenglishnotes/features/statistics/domain/study_stats.dart';

import 'test_data.dart';

void configureTestDrift() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
}

Future<Widget> createTestApp() async {
  SharedPreferences.setMockInitialValues({});
  final preferences = await SharedPreferences.getInstance();

  return ProviderScope(
    overrides: [
      sharedPreferencesProvider.overrideWith((ref) => preferences),
      appDatabaseProvider.overrideWith((ref) {
        final database = AppDatabase.memory();
        ref.onDispose(database.close);
        return database;
      }),
      dueFlashcardsCountProvider.overrideWith((ref) => Stream.value(0)),
      homePreviewCardProvider.overrideWith((ref) => Stream.value(null)),
      studyStreakProvider.overrideWith((ref) => Stream.value(0)),
      cardGroupsProvider.overrideWith(
        (ref) => Stream.value([testGroup()]),
      ),
      studyStatsProvider.overrideWith(
        (ref) => Stream.value(StudyStats.empty()),
      ),
      frequentCardErrorsProvider.overrideWith((ref) => Stream.value([])),
      studyReminderSchedulerProvider.overrideWith(
        (ref) => FakeStudyReminderScheduler(),
      ),
      notificationPermissionClientProvider.overrideWith(
        (ref) => FakeNotificationPermissionClient(),
      ),
      textToSpeechServiceProvider.overrideWith((ref) => FakeTextToSpeechService()),
    ],
    child: const StickyEnglishNotesApp(),
  );
}

Future<void> pumpTestApp(WidgetTester tester) async {
  await tester.pumpWidget(await createTestApp());
  await tester.pump();
  await tester.pump();
}

Future<void> disposeTestApp(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump();
}
