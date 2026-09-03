import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:rtu_mirea_app/notifications/model/app_notification.dart';

class NotificationsState extends Equatable {
  const NotificationsState({
    this.pushes = const [],
    this.readIds = const {},
    this.userId,
  });

  factory NotificationsState.fromJson(Map<String, dynamic> json) {
    final pushes = json['pushes'];
    final readIds = json['readIds'];
    return NotificationsState(
      userId: json['userId'] as String?,
      pushes: [
        if (pushes is List)
          for (final item in pushes)
            if (item is Map)
              AppNotification.fromJson(Map<String, dynamic>.from(item)),
      ],
      readIds: {
        if (readIds is List)
          for (final id in readIds) id.toString(),
      },
    );
  }

  final List<AppNotification> pushes;
  final Set<String> readIds;
  final String? userId;

  bool isRead(String id) => readIds.contains(id);

  bool hasUnread(Iterable<String> ids) =>
      ids.any((id) => !readIds.contains(id));

  int unreadCount(Iterable<String> ids) =>
      ids.where((id) => !readIds.contains(id)).length;

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'pushes': pushes.map((push) => push.toJson()).toList(),
    'readIds': readIds.toList(),
  };

  NotificationsState copyWith({
    List<AppNotification>? pushes,
    Set<String>? readIds,
  }) {
    return NotificationsState(
      userId: userId,
      pushes: pushes ?? this.pushes,
      readIds: readIds ?? this.readIds,
    );
  }

  @override
  List<Object?> get props => [pushes, readIds, userId];
}

class NotificationsCubit extends HydratedCubit<NotificationsState> {
  NotificationsCubit({String? userId}) : super(const NotificationsState()) {
    selectUser(userId);
  }

  static const int maxPushes = 50;
  static const int maxReadIds = 400;

  void recordPush({
    required String title,
    String? body,
    String? route,
    AppNotificationKind kind = AppNotificationKind.accent,
    DateTime? at,
    String? id,
  }) {
    if (state.userId == null) return;
    final createdAt = at ?? DateTime.now();
    final push = AppNotification(
      id: id ?? 'push:${createdAt.microsecondsSinceEpoch}',
      kind: kind,
      title: title,
      subtitle: body,
      route: route,
      createdAt: createdAt,
    );
    final pushes = [push, ...state.pushes.where((item) => item.id != push.id)];
    emit(state.copyWith(pushes: pushes.take(maxPushes).toList()));
  }

  void markRead(String id) {
    if (state.readIds.contains(id)) return;
    emit(state.copyWith(readIds: _trim({...state.readIds, id})));
  }

  void markAllRead(Iterable<String> ids) {
    final next = {...state.readIds, ...ids};
    if (next.length == state.readIds.length) return;
    emit(state.copyWith(readIds: _trim(next)));
  }

  void selectUser(String? userId) {
    final normalized = userId == null || userId.isEmpty ? null : userId;
    if (state.userId == normalized && normalized != null) return;
    emit(NotificationsState(userId: normalized));
  }

  void reset() => emit(NotificationsState(userId: state.userId));

  Set<String> _trim(Set<String> ids) => ids.length <= maxReadIds
      ? ids
      : ids.skip(ids.length - maxReadIds).toSet();

  @override
  NotificationsState? fromJson(Map<String, dynamic> json) {
    try {
      return NotificationsState.fromJson(json);
    } on Object catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic> toJson(NotificationsState state) => state.toJson();
}
