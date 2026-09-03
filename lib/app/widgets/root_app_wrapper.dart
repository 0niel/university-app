import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rtu_mirea_app/app/app.dart';
import 'package:rtu_mirea_app/app/widgets/local_notification_listener.dart';
import 'package:rtu_mirea_app/notifications/notifications.dart';
import 'package:rtu_mirea_app/watch/watch.dart';

class RootAppWrapper extends StatelessWidget {
  const RootAppWrapper({
    required this.child,
    required this.router,
    super.key,
  });

  final Widget child;
  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    return FirebaseInteractedMessageListener(
      router: router,
      child: LocalNotificationListener(
        router: router,
        child: PushHistoryListener(
          child: WatchConnectivityWrapper(child: child),
        ),
      ),
    );
  }
}
