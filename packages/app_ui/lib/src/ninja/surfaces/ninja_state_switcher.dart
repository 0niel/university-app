import 'package:app_ui/src/animations/ninja_motion.dart';
import 'package:flutter/widgets.dart';

class NinjaStateSwitcher extends StatelessWidget {
  const NinjaStateSwitcher({
    required this.child,
    super.key,
    this.duration = NinjaMotion.base,
    this.alignment = Alignment.topCenter,
    this.slideOffset = 0.015,
  });

  final Widget child;
  final Duration duration;
  final AlignmentGeometry alignment;
  final double slideOffset;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: NinjaMotion.of(context, duration),
      switchInCurve: NinjaMotion.enter,
      switchOutCurve: NinjaMotion.exit,
      transitionBuilder: (transitionChild, animation) => FadeTransition(
        opacity: animation,
        child: slideOffset == 0
            ? transitionChild
            : SlideTransition(
                position: Tween(
                  begin: Offset(0, slideOffset),
                  end: Offset.zero,
                ).animate(animation),
                child: transitionChild,
              ),
      ),
      layoutBuilder: (currentChild, previousChildren) => Stack(
        alignment: alignment,
        children: [
          for (final previous in previousChildren)
            ExcludeSemantics(child: IgnorePointer(child: previous)),
          if (currentChild != null) currentChild,
        ],
      ),
      child: child,
    );
  }
}

typedef AppStateSwitcher = NinjaStateSwitcher;
