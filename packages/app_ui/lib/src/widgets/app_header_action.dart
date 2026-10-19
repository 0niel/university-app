import 'package:app_ui/src/widgets/app_line_icon.dart';
import 'package:flutter/widgets.dart';

class AppHeaderAction {
  const AppHeaderAction({
    this.icon,
    this.child,
    this.onTap,
    this.badge = false,
    this.badgeColor,
    this.semanticsLabel,
  });

  final AppLineIcon? icon;
  final Widget? child;
  final VoidCallback? onTap;
  final bool badge;
  final Color? badgeColor;
  final String? semanticsLabel;
}
