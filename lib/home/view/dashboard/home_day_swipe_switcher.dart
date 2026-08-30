import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/home/view/dashboard/home_day_step.dart';
import 'package:rtu_mirea_app/home/view/dashboard/home_day_window.dart';

class HomeDaySwipeSwitcher extends StatefulWidget {
  const HomeDaySwipeSwitcher({
    required this.forward,
    required this.onStep,
    required this.child,
    super.key,
    this.shift = 24,
  });

  final bool forward;

  final ValueChanged<HomeDayStep> onStep;

  final Widget child;

  final double shift;

  @override
  State<HomeDaySwipeSwitcher> createState() => _HomeDaySwipeSwitcherState();
}

class _HomeDaySwipeSwitcherState extends State<HomeDaySwipeSwitcher> {
  double _dragOffset = 0;

  void _onDragUpdate(DragUpdateDetails details) {
    _dragOffset += details.delta.dx;
  }

  void _onDragEnd(DragEndDetails details) {
    final step = homeDaySwipeStep(
      dragOffset: _dragOffset,
      velocity: details.velocity.pixelsPerSecond.dx,
      width: MediaQuery.widthOf(context),
    );
    _dragOffset = 0;
    if (step != null) widget.onStep(step);
  }

  @override
  Widget build(BuildContext context) {
    final shift = widget.forward ? widget.shift : -widget.shift;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onHorizontalDragStart: (_) => _dragOffset = 0,
      onHorizontalDragUpdate: _onDragUpdate,
      onHorizontalDragEnd: _onDragEnd,
      child: AnimatedSwitcher(
        duration: NinjaMotion.of(context),
        switchInCurve: NinjaMotion.enter,
        switchOutCurve: NinjaMotion.exit,
        layoutBuilder: (currentChild, previousChildren) => Stack(
          alignment: Alignment.topCenter,
          children: [
            ...previousChildren,
            ?currentChild,
          ],
        ),
        transitionBuilder: (child, animation) {
          final incoming = child.key == widget.child.key;
          final travel = incoming ? shift : -shift;
          return FadeTransition(
            opacity: animation,
            child: AnimatedBuilder(
              animation: animation,
              child: child,
              builder: (context, inner) => Transform.translate(
                offset: Offset(travel * (1 - animation.value), 0),
                child: inner,
              ),
            ),
          );
        },
        child: widget.child,
      ),
    );
  }
}
