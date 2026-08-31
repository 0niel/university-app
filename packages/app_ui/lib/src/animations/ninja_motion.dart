import 'package:flutter/widgets.dart';

abstract final class NinjaMotion {
  static const Duration press = Duration(milliseconds: 90);
  static const Duration fast = Duration(milliseconds: 160);
  static const Duration base = Duration(milliseconds: 220);
  static const Duration slow = Duration(milliseconds: 320);
  static const Curve enter = Curves.easeOutCubic;
  static const Curve exit = Curves.easeInCubic;
  static const Curve emphasized = Curves.easeInOutCubic;

  static Duration of(BuildContext context, [Duration duration = base]) {
    final media = MediaQuery.maybeOf(context);
    return (media?.disableAnimations ?? false) ||
            (media?.accessibleNavigation ?? false)
        ? Duration.zero
        : duration;
  }
}
