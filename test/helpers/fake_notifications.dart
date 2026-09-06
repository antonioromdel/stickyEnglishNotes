import 'package:stickeenglishnotes/features/settings/application/notification_permission_client.dart';
import 'package:stickeenglishnotes/features/settings/application/study_reminder_scheduler.dart';
import 'package:stickeenglishnotes/features/settings/domain/notification_reminder_settings.dart';

class FakeStudyReminderScheduler implements StudyReminderScheduler {
  NotificationReminderSettings? lastScheduled;
  int initializeCount = 0;
  int cancelCount = 0;
  int scheduleCount = 0;

  @override
  Future<void> initialize() async {
    initializeCount += 1;
  }

  @override
  Future<void> schedule(NotificationReminderSettings settings) async {
    scheduleCount += 1;
    lastScheduled = settings;
  }

  @override
  Future<void> cancelAll() async {
    cancelCount += 1;
    lastScheduled = null;
  }
}

class FakeNotificationPermissionClient implements NotificationPermissionClient {
  FakeNotificationPermissionClient({
    this.granted = false,
    this.requestShouldGrant = true,
  });

  bool granted;
  bool requestShouldGrant;
  int requestCount = 0;
  int revokeCount = 0;

  @override
  Future<bool> isGranted() async => granted;

  @override
  Future<bool> request() async {
    requestCount += 1;
    if (requestShouldGrant) {
      granted = true;
    }
    return granted;
  }

  @override
  Future<void> revoke() async {
    revokeCount += 1;
    granted = false;
  }
}
