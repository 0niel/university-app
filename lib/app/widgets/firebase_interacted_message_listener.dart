import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rtu_mirea_app/app/app.dart';

class FirebaseInteractedMessageListener extends StatefulWidget {
  const FirebaseInteractedMessageListener({
    required this.child,
    required this.router,
    super.key,
  });

  final Widget child;
  final GoRouter router;

  @override
  State<FirebaseInteractedMessageListener> createState() =>
      _FirebaseInteractedMessageListenerState();
}

class _FirebaseInteractedMessageListenerState
    extends State<FirebaseInteractedMessageListener> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _openPending(context.read<AppBloc>().state);
    });
  }

  void _openPending(AppState state) {
    if (!mounted ||
        !context.read<AppBloc>().consumeNotificationNavigation(
          state.notificationNavigationId,
        )) {
      return;
    }
    if (state.discoursePostIdToOpen case final int postId) {
      widget.router.go('/services/discourse-post-overview/$postId');
    } else if (state.routeToOpen case final String route) {
      widget.router.go(route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppBloc, AppState>(
      listenWhen: (previous, current) =>
          previous.notificationNavigationId != current.notificationNavigationId,
      listener: (_, state) => _openPending(state),
      child: widget.child,
    );
  }
}
