import 'package:rtu_mirea_app/notifications/cubit/notifications_cubit.dart';
import 'package:rtu_mirea_app/notifications/data/notification_inbox_repository.dart';
import 'package:rtu_mirea_app/notifications/model/app_notification.dart';

class InboxNotificationTracker {
  String? _userId;
  bool _waiting = false;
  bool _hasBaseline = false;
  DateTime? _newest;
  final _seen = <String>{};

  List<AppNotification> observe(NotificationsState state) {
    if (_userId != state.userId) {
      _userId = state.userId;
      _waiting = false;
      _hasBaseline = false;
      _newest = null;
      _seen.clear();
    }
    if (_userId == null) return const [];
    if (state.isLoading) {
      _waiting = true;
      return const [];
    }
    if (!_waiting) return const [];
    _waiting = false;
    if (state.loadFailed) return const [];
    final items =
        state.pushes.where((item) => isInboxNotificationId(item.id)).toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final fresh = [
      if (_hasBaseline)
        for (final item in items)
          if (!_seen.contains(item.id) &&
              !state.isRead(item.id) &&
              (_newest == null || !item.createdAt.isBefore(_newest!)))
            item,
    ];
    _hasBaseline = true;
    _seen.addAll(items.map((item) => item.id));
    if (_seen.length > 400) {
      _seen.removeAll(_seen.take(_seen.length - 400).toList());
    }
    if (items.isNotEmpty &&
        (_newest == null || items.first.createdAt.isAfter(_newest!))) {
      _newest = items.first.createdAt;
    }
    return fresh.take(3).toList();
  }
}
