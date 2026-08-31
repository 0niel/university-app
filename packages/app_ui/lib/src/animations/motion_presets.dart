import 'dart:async';

import 'package:app_ui/src/animations/ninja_motion.dart';
import 'package:flutter/widgets.dart';

extension AppMotionPresets on Widget {
  Widget animatePageEntrance({Key? key, Duration delay = Duration.zero}) {
    return _MotionEntrance(
      key: key,
      delay: delay,
      duration: const Duration(milliseconds: 220),
      slideYFraction: 0.035,
      child: this,
    );
  }

  Widget animateSectionEntrance({
    Key? key,
    int index = 0,
    Duration baseDelay = const Duration(milliseconds: 24),
  }) {
    return _MotionEntrance(
      key: key,
      delay: Duration(milliseconds: index * baseDelay.inMilliseconds),
      duration: const Duration(milliseconds: 180),
      slideYFraction: 0.025,
      child: this,
    );
  }

  Widget animateListItem({
    Key? key,
    int index = 0,
    Duration step = const Duration(milliseconds: 12),
    Duration maxDelay = const Duration(milliseconds: 96),
  }) {
    final rawDelay = Duration(milliseconds: index * step.inMilliseconds);
    return _MotionEntrance(
      key: key,
      delay: rawDelay > maxDelay ? maxDelay : rawDelay,
      duration: const Duration(milliseconds: 170),
      slideYFraction: 0.02,
      child: this,
    );
  }

  Widget animateEmptyState({Key? key, Duration delay = Duration.zero}) {
    return _MotionEntrance(
      key: key,
      delay: delay,
      duration: const Duration(milliseconds: 190),
      scaleBegin: 0.985,
      child: this,
    );
  }

  Widget animateEmphasis({Key? key, Duration delay = Duration.zero}) {
    return _MotionEntrance(
      key: key,
      delay: delay,
      duration: const Duration(milliseconds: 150),
      scaleBegin: 0.99,
      child: this,
    );
  }
}

class _MotionEntrance extends StatefulWidget {
  const _MotionEntrance({
    required this.child,
    required this.duration,
    super.key,
    this.delay = Duration.zero,
    this.slideYFraction = 0,
    this.scaleBegin = 1,
  });

  final Widget child;
  final Duration delay;
  final Duration duration;
  final double slideYFraction;
  final double scaleBegin;

  @override
  State<_MotionEntrance> createState() => _MotionEntranceState();
}

class _MotionEntranceState extends State<_MotionEntrance>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  CurvedAnimation? _animation;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_controller != null) return;
    if (MediaQuery.disableAnimationsOf(context)) return;
    final total = widget.delay + widget.duration;
    final controller = AnimationController(vsync: this, duration: total);
    unawaited(controller.forward());
    _controller = controller;
    _animation = CurvedAnimation(
      parent: controller,
      curve: Interval(
        total.inMicroseconds == 0
            ? 0
            : widget.delay.inMicroseconds / total.inMicroseconds,
        1,
        curve: NinjaMotion.enter,
      ),
    );
  }

  @override
  void dispose() {
    _animation?.dispose();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final animation = _animation;
    if (animation == null) return widget.child;
    return AnimatedBuilder(
      animation: animation,
      child: widget.child,
      builder: (context, child) {
        final t = animation.value;
        Widget result = Opacity(
          opacity: t,
          alwaysIncludeSemantics: true,
          child: child,
        );
        if (widget.slideYFraction != 0) {
          result = FractionalTranslation(
            translation: Offset(0, widget.slideYFraction * (1 - t)),
            child: result,
          );
        }
        if (widget.scaleBegin != 1) {
          result = Transform.scale(
            scale: widget.scaleBegin + (1 - widget.scaleBegin) * t,
            child: result,
          );
        }
        return result;
      },
    );
  }
}
