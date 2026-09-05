import 'package:rtu_mirea_app/navigation/deep_links.dart';
import 'package:rtu_mirea_app/notifications/model/app_notification.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationInboxSnapshot {
  const NotificationInboxSnapshot({
    required this.items,
    this.readIds = const {},
  });

  factory NotificationInboxSnapshot.fromJson(
    Object? response, {
    Object? scheduleReadIds = const <String>[],
  }) {
    if (response is! List) {
      throw const FormatException('Invalid notification inbox');
    }
    final items = <AppNotification>[];
    final readIds = <String>{};
    if (scheduleReadIds is! List) {
      throw const FormatException('Invalid schedule read state');
    }
    for (final changeId in scheduleReadIds) {
      if (changeId is! String ||
          !isScheduleChangeNotificationId('change:$changeId')) {
        throw const FormatException('Invalid schedule read identity');
      }
      readIds.add('change:$changeId');
    }
    for (final row in response) {
      if (row is! Map || row['id'] is! String || row['title'] is! String) {
        throw const FormatException('Invalid notification');
      }
      final id = 'inbox:${(row['id'] as String).toLowerCase()}';
      final createdAt = DateTime.tryParse(row['createdAt']?.toString() ?? '');
      if (!isInboxNotificationId(id) || createdAt == null) {
        throw const FormatException('Invalid notification identity');
      }
      items.add(
        AppNotification(
          id: id,
          title: row['title'] as String,
          subtitle: row['body']?.toString(),
          route: DeepLinks.normalizeLocation(row['route']?.toString()),
          kind: AppNotificationKind.parse(row['kind']?.toString()),
          createdAt: createdAt,
        ),
      );
      if (row['readAt'] != null) readIds.add(id);
    }
    return NotificationInboxSnapshot(items: items, readIds: readIds);
  }

  final List<AppNotification> items;
  final Set<String> readIds;
}

final _inboxIdPattern = RegExp(
  r'^inbox:[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$',
);

bool isInboxNotificationId(String id) => _inboxIdPattern.hasMatch(id);

final _scheduleChangeIdPattern = RegExp(r'^change:[1-9][0-9]{0,18}$');

bool isScheduleChangeNotificationId(String id) {
  if (!_scheduleChangeIdPattern.hasMatch(id)) return false;
  final value = id.substring('change:'.length);
  return value.length < 19 || value.compareTo('9223372036854775807') <= 0;
}

bool isCloudNotificationId(String id) =>
    isInboxNotificationId(id) || isScheduleChangeNotificationId(id);

abstract interface class NotificationInboxRepository {
  Future<NotificationInboxSnapshot> load(String userId);
  Future<void> markRead(String userId, Set<String> ids);
}

class SupabaseNotificationInboxRepository
    implements NotificationInboxRepository {
  const SupabaseNotificationInboxRepository(this._client);

  final SupabaseClient _client;

  void _checkUser(String userId) {
    if (_client.auth.currentUser?.id != userId) {
      throw StateError('Notification account changed');
    }
  }

  @override
  Future<NotificationInboxSnapshot> load(String userId) async {
    _checkUser(userId);
    final response = await _client.rpc<Object?>('get_notification_inbox');
    _checkUser(userId);
    final scheduleReadIds = await _client.rpc<Object?>(
      'get_schedule_notification_read_ids',
      params: {'p_expected_user_id': userId},
    );
    _checkUser(userId);
    return NotificationInboxSnapshot.fromJson(
      response,
      scheduleReadIds: scheduleReadIds,
    );
  }

  @override
  Future<void> markRead(String userId, Set<String> ids) async {
    _checkUser(userId);
    final inboxIds = ids.where(isInboxNotificationId).toList();
    if (inboxIds.isNotEmpty) {
      await _client.rpc<void>(
        'mark_notification_inbox_read',
        params: {
          'p_ids': inboxIds.map((id) => id.substring('inbox:'.length)).toList(),
        },
      );
      _checkUser(userId);
    }
    final changeIds = ids.where(isScheduleChangeNotificationId).toList();
    for (var offset = 0; offset < changeIds.length; offset += 200) {
      _checkUser(userId);
      await _client.rpc<void>(
        'mark_schedule_notifications_read',
        params: {
          'p_expected_user_id': userId,
          'p_ids': changeIds
              .skip(offset)
              .take(200)
              .map((id) => id.substring('change:'.length))
              .toList(),
        },
      );
      _checkUser(userId);
    }
  }
}
