import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';

class ScheduleViewTransition extends StatelessWidget {
  const ScheduleViewTransition({
    required this.child,
    this.fill = false,
    super.key,
  });

  final Widget child;
  final bool fill;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context) ||
        MediaQuery.accessibleNavigationOf(context)) {
      return child;
    }
    return AnimatedSwitcher(
      duration: NinjaMotion.of(context, const Duration(milliseconds: 420)),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      layoutBuilder: (current, _) => Stack(
        fit: fill ? StackFit.expand : StackFit.loose,
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none,
        children: [
          ?current,
        ],
      ),
      transitionBuilder: (content, animation) {
        const fullScale = 1.0;
        final scale = Tween(begin: .985, end: fullScale);
        return ScaleTransition(
          alignment: Alignment.topCenter,
          scale: scale.animate(animation),
          child: content,
        );
      },
      child: child,
    );
  }
}
