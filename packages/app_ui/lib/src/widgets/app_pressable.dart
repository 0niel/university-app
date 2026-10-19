import 'package:app_ui/src/widgets/app_press_state.dart';
import 'package:flutter/material.dart';

class AppPressable extends StatelessWidget {
  const AppPressable({
    required this.child,
    super.key,
    this.onTap,
    this.onLongPress,
    this.enabled = true,
    this.pressedScale = 0.97,
    this.haptics = false,
    this.behavior = HitTestBehavior.opaque,
    this.semanticsLabel,
    this.semanticsButton,
    this.semanticsSelected,
    this.semanticsToggled,
  });

  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  final bool enabled;
  final double pressedScale;
  final bool haptics;
  final HitTestBehavior behavior;
  final String? semanticsLabel;
  final bool? semanticsButton;
  final bool? semanticsSelected;
  final bool? semanticsToggled;

  @override
  Widget build(BuildContext context) {
    return AppPressState(
      onTap: onTap,
      onLongPress: onLongPress,
      enabled: enabled,
      pressedScale: pressedScale,
      haptics: haptics,
      behavior: behavior,
      semanticsLabel: semanticsLabel,
      semanticsButton: semanticsButton,
      semanticsSelected: semanticsSelected,
      semanticsToggled: semanticsToggled,
      builder: (context, {required pressed}) => child,
    );
  }
}
