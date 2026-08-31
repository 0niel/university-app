import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class HomeBoardOpener extends StatelessWidget {
  const HomeBoardOpener({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .fromLTRB(
        NinjaMetrics.screenPadding,
        10,
        NinjaMetrics.screenPadding,
        0,
      ),
      child: child,
    );
  }
}
