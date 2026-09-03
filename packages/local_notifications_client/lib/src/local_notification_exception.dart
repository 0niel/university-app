import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

part 'local_notification_exception.freezed.dart';

/// {@template local_notification_exception}
/// Base failure for every [LocalNotificationsClient] operation.
/// {@endtemplate}
abstract class LocalNotificationException
    with EquatableMixin
    implements Exception {
  /// {@macro local_notification_exception}
  const LocalNotificationException(this.error);

  /// The underlying error.
  final Object error;

  @override
  List<Object?> get props => [error];
}

/// {@template schedule_reminder_failure}
/// Thrown when scheduling a reminder fails.
/// {@endtemplate}
class ScheduleReminderFailure extends LocalNotificationException {
  /// {@macro schedule_reminder_failure}
  const ScheduleReminderFailure(super.error);
}

/// {@template pending_reminders_failure}
/// Thrown when the list of pending reminders cannot be read.
/// {@endtemplate}
class PendingRemindersFailure extends LocalNotificationException {
  /// {@macro pending_reminders_failure}
  const PendingRemindersFailure(super.error);
}

/// {@template pending_reminder}
/// A reminder that is scheduled but has not fired yet.
/// {@endtemplate}
@freezed
abstract class PendingReminder with _$PendingReminder {
  /// {@macro pending_reminder}
  const factory PendingReminder({required int id, String? payload}) =
      _PendingReminder;
}

/// {@template local_notifications_client}
/// Wraps `flutter_local_notifications` to schedule, list and cancel local
/// device notifications. Times are interpreted in the device's local timezone.
/// {@endtemplate}
class LocalNotificationsClient {
  /// {@macro local_notifications_client}
  LocalNotificationsClient({FlutterLocalNotificationsPlugin? plugin})
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;
  static final _interactions = StreamController<String>.broadcast(sync: true);
  static String? _pendingPayload;
  static bool _launchCaptured = false;

  Stream<String> get interactions => _interactions.stream;

  String? takePendingInteraction() {
    final payload = _pendingPayload;
    _pendingPayload = null;
    return payload;
  }

  static void _onInteraction(NotificationResponse response) {
    final payload = response.payload;
    if (payload == null || payload.isEmpty) return;
    if (_interactions.hasListener) {
      _interactions.add(payload);
    } else {
      _pendingPayload = payload;
    }
  }

  /// Android notification channel id for lesson reminders.
  static const channelId = 'lesson_reminders';

  /// Android notification channel name.
  static const channelName = 'Напоминания о парах';

  /// Initializes the timezone database, the plugin and the Android channel.
  /// Safe to call once at startup.
  Future<void> init() async {
    tz_data.initializeTimeZones();
    try {
      // flutter_timezone exposes the IANA timezone identifier.
      final localZone = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(localZone.identifier));
    } on Object {
      // Falls back to UTC if the device timezone can't be resolved.
    }

    const android = AndroidInitializationSettings('ic_stat_ic_notification');
    const darwin = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    await _plugin.initialize(
      settings: const InitializationSettings(android: android, iOS: darwin),
      onDidReceiveNotificationResponse: _onInteraction,
    );
    if (!_launchCaptured) {
      final launch = await _plugin.getNotificationAppLaunchDetails();
      _launchCaptured = true;
      if (launch?.didNotificationLaunchApp == true &&
          launch?.notificationResponse != null) {
        _onInteraction(launch!.notificationResponse!);
      }
    }

    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(
          const AndroidNotificationChannel(
            channelId,
            channelName,
            description: 'Напоминания перед началом пары',
            importance: Importance.max,
          ),
        );
  }

  /// Requests the OS notification permission. Returns `true` if granted.
  Future<bool> requestPermission() async {
    final android =
        _plugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();
    if (android != null) {
      return await android.requestNotificationsPermission() ?? false;
    }
    final ios =
        _plugin
            .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin
            >();
    if (ios != null) {
      return await ios.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          ) ??
          false;
    }
    return true;
  }

  /// Returns the reminders that are scheduled but haven't fired yet.
  Future<List<PendingReminder>> pending() async {
    try {
      final requests = await _plugin.pendingNotificationRequests();
      return [
        for (final r in requests) PendingReminder(id: r.id, payload: r.payload),
      ];
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(PendingRemindersFailure(error), stackTrace);
    }
  }

  /// Schedules a single reminder to fire at [when] (device-local time).
  ///
  /// Uses inexact scheduling so no `SCHEDULE_EXACT_ALARM` permission is needed;
  /// a few minutes of drift is acceptable for a "15 minutes before" reminder.
  Future<void> schedule({
    required int id,
    required String title,
    required String body,
    required DateTime when,
    String? payload,
  }) async {
    try {
      await _plugin.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: tz.TZDateTime.from(when, tz.local),
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            channelId,
            channelName,
            channelDescription: 'Напоминания перед началом пары',
            importance: Importance.max,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        payload: payload,
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(ScheduleReminderFailure(error), stackTrace);
    }
  }

  /// Cancels the reminder with [id].
  Future<void> cancel(int id) => _plugin.cancel(id: id);

  /// Cancels every scheduled reminder.
  Future<void> cancelAll() => _plugin.cancelAll();
}
