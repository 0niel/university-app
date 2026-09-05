import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gamification_repository/gamification_repository.dart';
import 'package:go_router/go_router.dart';
import 'package:local_notifications_repository/local_notifications_repository.dart';
import 'package:rtu_mirea_app/app/bloc/app_bloc.dart';
import 'package:rtu_mirea_app/navigation/deep_links.dart';
import 'package:rtu_mirea_app/schedule/cubit/cubit.dart';

class LocalNotificationListener extends StatefulWidget {
  const LocalNotificationListener({
    required this.router,
    required this.child,
    super.key,
  });
  final GoRouter router;
  final Widget child;

  @override
  State<LocalNotificationListener> createState() =>
      _LocalNotificationListenerState();
}

class _LocalNotificationListenerState extends State<LocalNotificationListener>
    with WidgetsBindingObserver {
  StreamSubscription<String>? _subscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) unawaited(_recordActiveDay());
    });
    if (kIsWeb || defaultTargetPlatform == TargetPlatform.fuchsia) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) unawaited(_initialize());
    });
  }

  Future<void> _initialize() async {
    final repository = context.read<LocalNotificationsRepository>();
    _subscription = repository.interactions.listen(_open);
    try {
      await repository.initialize();
      final payload = repository.takePendingInteraction();
      if (payload != null) _open(payload);
    } on Object catch (error, stackTrace) {
      log(
        'Local notification initialization failed',
        error: error,
        stackTrace: stackTrace,
        name: 'LocalNotificationListener',
      );
    }
  }

  void _open(String payload) {
    if (!mounted) return;
    if (payload == 'custom-schedules') {
      widget.router.go('/schedule');
      return;
    }
    try {
      final data = jsonDecode(payload);
      if (data is! Map<String, dynamic> || data['type'] != 'push') return;
      final state = context.read<AppBloc>().state;
      if (!state.status.isLoggedIn || data['user_id'] != state.user.id) return;
      final route = DeepLinks.normalizeLocation(data['route'] as String?);
      if (route != null) widget.router.go(route);
    } on Object catch (_) {
      return;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && mounted) {
      unawaited(_recordActiveDay());
      context.read<CustomScheduleCubit?>()?.refreshReminders();
    }
  }

  Future<void> _recordActiveDay() async {
    try {
      await context.read<GamificationRepository?>()?.recordActiveDay();
    } on Object catch (error, stackTrace) {
      log(
        'Active day update failed',
        error: error,
        stackTrace: stackTrace,
        name: 'LocalNotificationListener',
      );
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_subscription?.cancel());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
