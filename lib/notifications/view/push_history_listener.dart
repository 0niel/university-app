import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gamification_repository/gamification_repository.dart';
import 'package:local_notifications_repository/local_notifications_repository.dart';
import 'package:rtu_mirea_app/app/bloc/app_bloc.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/navigation/deep_links.dart';
import 'package:rtu_mirea_app/notifications/cubit/notifications_cubit.dart';
import 'package:rtu_mirea_app/notifications/model/app_notification.dart';
import 'package:rtu_mirea_app/notifications/view/inbox_notification_tracker.dart';

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
  StreamSubscription<NotificationsState>? _inboxSubscription;
  Timer? _refreshTimer;
  late final NotificationsCubit _notifications;
  late final AppBloc _app;
  late final String? _userId;
  final _displayed = <String>{};
  final _inboxTracker = InboxNotificationTracker();

  @override
  void initState() {
    super.initState();
    _notifications = context.read<NotificationsCubit>();
    _userId = _notifications.state.userId;
    _app = context.read<AppBloc>();
    if (_isDesktop) {
      _inboxTracker.observe(_notifications.state);
      _inboxSubscription = _notifications.stream.listen(_onInboxState);
    }
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
      _subscription = stream.listen(
        (message) => _record(message, foreground: true),
        onError: (Object _) {},
      );
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

  bool get _isDesktop =>
      !kIsWeb &&
      (defaultTargetPlatform == .macOS ||
          defaultTargetPlatform == .windows ||
          defaultTargetPlatform == .linux);

  void _onInboxState(NotificationsState state) {
    if (!_canRecord) return;
    final items = _inboxTracker.observe(state);
    if (items.isNotEmpty) unawaited(_showInbox(items));
  }

  Future<void> _showInbox(List<AppNotification> items) async {
    try {
      final preferences = context.read<GamificationRepository?>();
      if (preferences != null) {
        final settings = await preferences.getSettings();
        if (!settings.notificationsEnabled || !_canRecord) return;
      }
      for (final item in items) {
        if (!_canRecord) return;
        if (_rememberDisplayed(item.id)) {
          await _showForeground(
            item.id,
            item.title,
            item.subtitle,
            item.route,
          );
        }
      }
    } on Object catch (error, stackTrace) {
      log(
        'Inbox notification display failed',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  bool _rememberDisplayed(String identity) {
    if (!_displayed.add(identity)) return false;
    if (_displayed.length > 100) _displayed.remove(_displayed.first);
    return true;
  }

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

  void _record(RemoteMessage message, {bool foreground = false}) {
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
    final discoursePostId = int.tryParse(
      data['discourse_post_id']?.toString() ?? '',
    );
    final route =
        DeepLinks.normalizeLocation(data['route']?.toString()) ??
        (discoursePostId != null && discoursePostId > 0
            ? '/services/discourse-post-overview/$discoursePostId'
            : null) ??
        switch (data['type']) {
          'friend_request' ||
          'friend_accepted' => '/services/people?tab=friends',
          _ => null,
        };
    final title =
        notification?.title ??
        data['title']?.toString() ??
        context.l10n.notifPushDefaultTitle;
    final body = notification?.body ?? data['body']?.toString();
    final historyId = validNotificationId
        ? 'inbox:${notificationId.toLowerCase()}'
        : messageId == null
        ? null
        : 'push:$messageId';
    final identity = historyId ?? '${message.sentTime}:$title:$body';
    if (!foreground) _rememberDisplayed(identity);
    _notifications.recordPush(
      id: historyId,
      title: title,
      body: body,
      route: route,
      kind: AppNotificationKind.parse(data['kind']?.toString()),
      at: message.sentTime,
    );
    if (!foreground && historyId != null) {
      _notifications.markRead(historyId);
    }
    _refresh();
    if (foreground &&
        (notification != null ||
            data['title'] != null ||
            data['body'] != null)) {
      if (_rememberDisplayed(identity)) {
        unawaited(_showForeground(identity, title, body, route));
      }
    }
  }

  Future<void> _showForeground(
    String identity,
    String title,
    String? body,
    String? route,
  ) async {
    if (kIsWeb || defaultTargetPlatform == .fuchsia) {
      return;
    }
    try {
      final repository = context.read<LocalNotificationsRepository?>();
      if (repository == null) return;
      await repository.initialize();
      if (!await repository.hasPermission() || !_canRecord) return;
      final lifecycle = WidgetsBinding.instance.lifecycleState;
      if (lifecycle != null && lifecycle != AppLifecycleState.resumed) return;
      await repository.showPush(
        id:
            identity.codeUnits.fold<int>(
              0,
              (hash, unit) => (hash * 31 + unit) & 0x3fffffff,
            ) +
            0x40000000,
        title: title,
        body: body,
        payload: jsonEncode({
          'type': 'push',
          'user_id': _userId,
          'notification_id': identity,
          'route': route,
        }),
      );
    } on Object catch (error, stackTrace) {
      _displayed.remove(identity);
      log(
        'Foreground notification display failed',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _refreshTimer?.cancel();
    unawaited(_subscription?.cancel());
    unawaited(_interactionSubscription?.cancel());
    unawaited(_inboxSubscription?.cancel());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
