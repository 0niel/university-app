import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/app/bloc/app_bloc.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/navigation/deep_links.dart';
import 'package:rtu_mirea_app/notifications/cubit/notifications_cubit.dart';
import 'package:rtu_mirea_app/notifications/model/app_notification.dart';

class PushHistoryListener extends StatefulWidget {
  const PushHistoryListener({
    required this.child,
    this.messages,
    super.key,
  });

  final Widget child;
  final Stream<RemoteMessage>? messages;

  @override
  State<PushHistoryListener> createState() => _PushHistoryListenerState();
}

class _PushHistoryListenerState extends State<PushHistoryListener>
    with WidgetsBindingObserver {
  StreamSubscription<RemoteMessage>? _subscription;
  StreamSubscription<AppState>? _interactionSubscription;
  Timer? _refreshTimer;
  late final NotificationsCubit _notifications;
  late final AppBloc _app;
  late final String? _userId;

  @override
  void initState() {
    super.initState();
    _notifications = context.read<NotificationsCubit>();
    _userId = _notifications.state.userId;
    _app = context.read<AppBloc>();
    WidgetsBinding.instance.addObserver(this);
    _interactionSubscription = _app.stream.listen(
      (_) => _recordPendingInteractions(),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _recordPendingInteractions();
      _startRefresh();
    });
    try {
      final stream = widget.messages ?? FirebaseMessaging.onMessage;
      _subscription = stream.listen(_record, onError: (Object _) {});
    } on Object catch (_) {
      _subscription = null;
    }
  }

  bool get _canRecord =>
      mounted &&
      !_notifications.isClosed &&
      _userId != null &&
      _userId == _app.state.user.id &&
      _userId == _notifications.state.userId;

  void _recordPendingInteractions() {
    if (!_canRecord) return;
    _app.takePendingPushMessages(_userId).forEach(_record);
  }

  void _refresh() {
    if (_canRecord) unawaited(_notifications.refresh());
  }

  void _startRefresh() {
    _refreshTimer?.cancel();
    if (!_canRecord || !_notifications.hasInbox) return;
    final lifecycle = WidgetsBinding.instance.lifecycleState;
    if (lifecycle != null && lifecycle != AppLifecycleState.resumed) return;
    _refresh();
    _refreshTimer = Timer.periodic(
      const Duration(minutes: 1),
      (_) => _refresh(),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _startRefresh();
    } else {
      _refreshTimer?.cancel();
    }
  }

  void _record(RemoteMessage message) {
    if (!_canRecord) return;
    final notification = message.notification;
    final data = message.data;
    final messageId = message.messageId;
    final notificationId = data['notification_id']?.toString();
    final validNotificationId =
        notificationId != null &&
        RegExp(
          '^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}'
          r'-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
        ).hasMatch(notificationId);
    final route =
        DeepLinks.normalizeLocation(data['route']?.toString()) ??
        switch (data['type']) {
          'friend_request' ||
          'friend_accepted' => '/services/people?tab=friends',
          _ => null,
        };
    _notifications.recordPush(
      id: validNotificationId
          ? 'inbox:${notificationId.toLowerCase()}'
          : messageId == null
          ? null
          : 'push:$messageId',
      title:
          notification?.title ??
          data['title']?.toString() ??
          context.l10n.notifPushDefaultTitle,
      body: notification?.body ?? data['body']?.toString(),
      route: route,
      kind: AppNotificationKind.parse(data['kind']?.toString()),
      at: message.sentTime,
    );
    _refresh();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _refreshTimer?.cancel();
    unawaited(_subscription?.cancel());
    unawaited(_interactionSubscription?.cancel());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
