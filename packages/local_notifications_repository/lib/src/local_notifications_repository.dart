import 'package:local_notifications_client/local_notifications_client.dart';
import 'package:local_notifications_repository/src/lesson_reminder.dart';
import 'package:local_notifications_repository/src/local_notifications_repository_exception.dart';
import 'package:permission_client/permission_client.dart';

class LocalNotificationsRepository {
  LocalNotificationsRepository({
    required LocalNotificationsClient client,
    PermissionClient permissionClient = const PermissionClient(),
  }) : _client = client,
       _permissionClient = permissionClient;

  final LocalNotificationsClient _client;
  final PermissionClient _permissionClient;

  /// Upper bound on simultaneously scheduled reminders, kept below iOS's
  /// 64-pending-notification limit. The soonest reminders win.
  static const maxScheduledReminders = 60;

  Future<void>? _initialization;

  Future<void> initialize() async {
    final initialization = _initialization ??= _client.init();
    try {
      await initialization;
    } on Exception {
      if (identical(_initialization, initialization)) _initialization = null;
      rethrow;
    }
  }

  /// Requests the OS notification permission. Returns `true` if granted.
  Future<bool> ensurePermission() async {
    await initialize();
    final status = await _permissionClient.requestNotifications();
    return status.isGranted;
  }

  /// Reads the current notification permission without opening a prompt.
  Future<bool> hasPermission() async {
    final status = await _permissionClient.notificationsStatus();
    return status.isGranted;
  }

  /// Replaces every pending reminder belonging to [scheduleId] with
  /// [reminders]. Existing reminders for the schedule (matched by payload) are
  /// cancelled first; then the soonest [maxScheduledReminders] are scheduled.
  Future<void> syncLessonReminders({
    required String scheduleId,
    required List<LessonReminder> reminders,
  }) async {
    try {
      await initialize();
      await _cancelScheduledReminders(scheduleId);

      final now = DateTime.now();
      final ordered =
          reminders.where((reminder) => reminder.when.isAfter(now)).toList()
            ..sort((a, b) => a.when.compareTo(b.when));
      for (final reminder in ordered.take(maxScheduledReminders)) {
        await _client.schedule(
          id: reminder.id,
          title: reminder.title,
          body: reminder.body,
          when: reminder.when,
          payload: scheduleId,
        );
      }
    } on Exception catch (error, stackTrace) {
      Error.throwWithStackTrace(SyncRemindersFailure(error), stackTrace);
    }
  }

  /// Cancels every pending reminder belonging to [scheduleId].
  Future<void> cancelSchedule(String scheduleId) async {
    try {
      await initialize();
      await _cancelScheduledReminders(scheduleId);
    } on Exception catch (error, stackTrace) {
      Error.throwWithStackTrace(SyncRemindersFailure(error), stackTrace);
    }
  }

  Future<void> _cancelScheduledReminders(String scheduleId) async {
    final pending = await _client.pending();
    for (final reminder in pending) {
      if (reminder.payload == scheduleId) await _client.cancel(reminder.id);
    }
  }
}
