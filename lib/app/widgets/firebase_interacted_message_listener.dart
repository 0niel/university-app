import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:rtu_mirea_app/app/app.dart';

class FirebaseInteractedMessageListener extends StatelessWidget {
  const FirebaseInteractedMessageListener({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppBloc, AppState>(
      listenWhen: (previous, current) =>
          previous.notificationNavigationId != current.notificationNavigationId,
      listener: (context, state) {
        Logger().i('FirebaseInteractedMessageListener: $state');
        final router = GoRouter.of(context);
        final routeToOpen = state.routeToOpen;
        if (state.discoursePostIdToOpen case final int postId) {
          router.go('/services/discourse-post-overview/$postId');
        } else if (routeToOpen != null) {
          router.go(routeToOpen);
        }
      },
      child: child,
    );
  }
}
