import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/app/app.dart';
import 'package:rtu_mirea_app/watch/watch.dart';

class RootAppWrapper extends StatelessWidget {
  const RootAppWrapper({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FirebaseInteractedMessageListener(
      child: WatchConnectivityWrapper(child: child),
    );
  }
}
