import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:rtu_mirea_app/notifications/data/notification_inbox_repository.dart';
import 'package:rtu_mirea_app/notifications/model/app_notification.dart';

class NotificationsState extends Equatable {
  const NotificationsState({
    this.pushes = const [],
    this.readIds = const {},
    this.userId,
    this.pendingReadIds = const {},
    this.isLoading = false,
    this.loadFailed = false,
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
      pendingReadIds: {
        if (json['pendingReadIds'] case final List<dynamic> ids)
          for (final id in ids)
            if (id is String && isCloudNotificationId(id)) id,
      },
    );
  }

  final List<AppNotification> pushes;
  final Set<String> readIds;
  final String? userId;
  final Set<String> pendingReadIds;
  final bool isLoading;
  final bool loadFailed;

  bool isRead(String id) => readIds.contains(id);

  bool hasUnread(Iterable<String> ids) =>
      ids.any((id) => !readIds.contains(id));

  int unreadCount(Iterable<String> ids) =>
      ids.where((id) => !readIds.contains(id)).length;

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'pushes': pushes.map((push) => push.toJson()).toList(),
    'readIds': readIds.toList(),
    'pendingReadIds': pendingReadIds.toList(),
  };

  NotificationsState copyWith({
    List<AppNotification>? pushes,
    Set<String>? readIds,
    Set<String>? pendingReadIds,
    bool? isLoading,
    bool? loadFailed,
  }) {
    return NotificationsState(
      userId: userId,
      pushes: pushes ?? this.pushes,
      readIds: readIds ?? this.readIds,
      pendingReadIds: pendingReadIds ?? this.pendingReadIds,
      isLoading: isLoading ?? this.isLoading,
      loadFailed: loadFailed ?? this.loadFailed,
    );
  }

  @override
  List<Object?> get props => [
    pushes,
    readIds,
    userId,
    pendingReadIds,
    isLoading,
    loadFailed,
  ];
}

class NotificationsCubit extends HydratedCubit<NotificationsState> {
  NotificationsCubit({String? userId, this._repository})
    : super(const NotificationsState()) {
    selectUser(userId);
    if (state.userId != null) {
      emit(
        state.copyWith(
          pendingReadIds: {
            ...state.pendingReadIds,
            ...state.readIds.where(isScheduleChangeNotificationId),
          },
        ),
      );
    }
  }

  final NotificationInboxRepository? _repository;

  @override
  String get storagePrefix => 'NotificationsCubit';
  int _revision = 0;
  Future<void>? _refreshTask;
  Future<void>? _readTask;
  bool _refreshAgain = false;

  bool get hasInbox => _repository != null;

  Future<void> refresh() {
    if (isClosed || state.userId == null || _repository == null) {
      return Future<void>.value();
    }
    final revision = _revision;
    return _refreshTask ??= _refreshUntilCurrent(revision, state.userId!)
        .whenComplete(() {
          if (revision == _revision) _refreshTask = null;
        });
  }

  Future<void> _refreshUntilCurrent(int revision, String userId) async {
    do {
      _refreshAgain = false;
      await _refresh(revision, userId);
    } while (_isCurrent(revision, userId) && _refreshAgain);
  }

  bool _isCurrent(int revision, String userId) =>
      !isClosed && revision == _revision && state.userId == userId;

  Future<void> _refresh(int revision, String userId) async {
    emit(state.copyWith(isLoading: true, loadFailed: false));
    try {
      final snapshot = await _repository!.load(userId);
      if (!_isCurrent(revision, userId)) return;
      if (_refreshAgain) return;
      final byId = {
        for (final item in state.pushes)
          if (!isInboxNotificationId(item.id)) item.id: item,
      };
      for (final item in snapshot.items) {
        byId[item.id] = item;
      }
      final items = byId.values.toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      emit(
        state.copyWith(
          pushes: items.take(maxPushes).toList(),
          readIds: _trim({...state.readIds, ...snapshot.readIds}),
          pendingReadIds: state.pendingReadIds.difference(snapshot.readIds),
          isLoading: false,
          loadFailed: false,
        ),
      );
      await _flushRead();
    } on Object {
      if (_isCurrent(revision, userId)) {
        emit(state.copyWith(isLoading: false, loadFailed: true));
      }
    }
  }

  Future<void> _flushRead() {
    if (isClosed ||
        state.userId == null ||
        _repository == null ||
        state.pendingReadIds.isEmpty) {
      return Future<void>.value();
    }
    final revision = _revision;
    return _readTask ??= _sendRead(revision, state.userId!).whenComplete(() {
      if (revision == _revision) _readTask = null;
    });
  }

  Future<void> _sendRead(int revision, String userId) async {
    while (_isCurrent(revision, userId) && state.pendingReadIds.isNotEmpty) {
      final ids = {...state.pendingReadIds};
      try {
        await _repository!.markRead(userId, ids);
      } on Object {
        return;
      }
      if (!_isCurrent(revision, userId)) return;
      emit(
        state.copyWith(pendingReadIds: state.pendingReadIds.difference(ids)),
      );
    }
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
    if (isClosed || state.userId == null) return;
    if (_refreshTask != null && id != null && isInboxNotificationId(id)) {
      _refreshAgain = true;
    }
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
    markAllRead([id]);
  }

  void markAllRead(Iterable<String> ids) {
    if (isClosed) return;
    final next = {...state.readIds, ...ids};
    if (next.length == state.readIds.length) return;
    emit(
      state.copyWith(
        readIds: _trim(next),
        pendingReadIds: _trim({
          ...state.pendingReadIds,
          ...ids.where(isCloudNotificationId),
        }),
      ),
    );
    unawaited(_flushRead());
  }

  void selectUser(String? userId) {
    final normalized = userId == null || userId.isEmpty ? null : userId;
    if (state.userId == normalized && normalized != null) return;
    if (state.userId == null && normalized == null) {
      emit(
        NotificationsState(
          readIds: state.readIds
              .where((id) => id.startsWith('change:'))
              .toSet(),
        ),
      );
      return;
    }
    _revision++;
    _refreshTask = null;
    _readTask = null;
    _refreshAgain = false;
    emit(NotificationsState(userId: normalized));
  }

  void reset() {
    _revision++;
    _refreshTask = null;
    _readTask = null;
    _refreshAgain = false;
    emit(NotificationsState(userId: state.userId));
  }

  Set<String> _trim(Set<String> ids) {
    final otherIds = ids
        .where((id) => !isScheduleChangeNotificationId(id))
        .toList();
    return {
      ...ids.where(isScheduleChangeNotificationId),
      ...otherIds.skip(
        otherIds.length > maxReadIds ? otherIds.length - maxReadIds : 0,
      ),
    };
  }

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
