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
      layoutBuilder: (current, previous) => Stack(
        fit: fill ? StackFit.expand : StackFit.loose,
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none,
        children: [
          for (final old in previous)
            if (fill)
              Positioned.fill(
                child: IgnorePointer(child: ExcludeSemantics(child: old)),
              )
            else
              Positioned(
                left: 0,
                right: 0,
                child: IgnorePointer(child: ExcludeSemantics(child: old)),
              ),
          ?current,
        ],
      ),
      transitionBuilder: (child, animation) => AnimatedBuilder(
        animation: animation,
        child: child,
        builder: (context, child) => animation.isCompleted
            ? child!
            : fill
            ? FadeTransition(
                opacity: animation,
                child: ScaleTransition(
                  alignment: Alignment.topCenter,
                  scale: Tween<double>(begin: .96, end: 1).animate(animation),
                  child: child,
                ),
              )
            : FadeTransition(
                opacity: animation,
                child: SizeTransition(
                  sizeFactor: animation,
                  alignment: Alignment.topCenter,
                  child: ScaleTransition(
                    alignment: Alignment.topCenter,
                    scale: Tween<double>(begin: .96, end: 1).animate(animation),
                    child: child,
                  ),
                ),
              ),
      ),
      child: child,
    );
  }
}
