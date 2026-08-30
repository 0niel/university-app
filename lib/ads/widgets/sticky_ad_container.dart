import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

@visibleForTesting
class StickyAdContainer extends StatelessWidget {
  const StickyAdContainer({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(color: context.ninja.canvas),
    child: child,
  );
}
