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
    this.pressedOpacity = 0.85,
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
  final double pressedOpacity;
  final bool haptics;
  final HitTestBehavior behavior;
  final String? semanticsLabel;
  final bool? semanticsButton;
  final bool? semanticsSelected;
  final bool? semanticsToggled;

  @override
  Widget build(BuildContext context) {
    final reduceMotion =
        (MediaQuery.maybeDisableAnimationsOf(context) ?? false) ||
            (MediaQuery.maybeAccessibleNavigationOf(context) ?? false);
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
      builder: (context, {required pressed}) => AnimatedOpacity(
        opacity: pressed ? pressedOpacity : 1,
        duration: reduceMotion
            ? Duration.zero
            : Duration(milliseconds: pressed ? 80 : 160),
        curve: Curves.easeOut,
        child: child,
      ),
    );
  }
}
