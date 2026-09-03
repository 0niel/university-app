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

  Stream<String> get interactions => _client.interactions;

  String? takePendingInteraction() => _client.takePendingInteraction();

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

  Future<void> syncLessonReminders({
    required String scheduleId,
    required List<LessonReminder> reminders,
  }) async {
    try {
      await initialize();
      final now = DateTime.now();
      final ordered =
          reminders.where((reminder) => reminder.when.isAfter(now)).toList()
            ..sort((a, b) => a.when.compareTo(b.when));
      if (ordered.isNotEmpty && !await hasPermission()) {
        throw StateError('Notification permission is not granted');
      }
      final pending = await _client.pending();
      final foreignCount = pending
          .where((item) => item.payload != scheduleId)
          .length;
      final capacity = (maxScheduledReminders - foreignCount).clamp(
        0,
        maxScheduledReminders,
      );
      final unique = <int, LessonReminder>{};
      for (final reminder in ordered) {
        unique.putIfAbsent(reminder.id, () => reminder);
      }
      final selected = unique.values.take(capacity).toList();
      final ids = selected.map((reminder) => reminder.id).toSet();
      if (pending.any(
        (reminder) =>
            reminder.payload != scheduleId && ids.contains(reminder.id),
      )) {
        throw StateError('Notification identifier belongs to another schedule');
      }
      final pendingIds = pending.map((reminder) => reminder.id).toSet();
      final stale = pending
          .where(
            (reminder) =>
                reminder.payload == scheduleId && !ids.contains(reminder.id),
          )
          .map((reminder) => reminder.id)
          .toList();
      var removed = 0;
      Future<void> removeStale() async {
        final id = stale[removed];
        await _client.cancel(id);
        pendingIds.remove(id);
        removed++;
      }

      for (final reminder in selected) {
        if (!pendingIds.contains(reminder.id) && pendingIds.length >= 64) {
          await removeStale();
        }
        await _client.schedule(
          id: reminder.id,
          title: reminder.title,
          body: reminder.body,
          when: reminder.when,
          payload: scheduleId,
        );
        pendingIds.add(reminder.id);
        while (pendingIds.length > maxScheduledReminders &&
            removed < stale.length) {
          await removeStale();
        }
      }
      while (removed < stale.length) {
        await removeStale();
      }
    } on Object catch (error, stackTrace) {
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
