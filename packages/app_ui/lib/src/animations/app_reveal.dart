import 'dart:async';

import 'package:app_ui/src/animations/ninja_motion.dart';
import 'package:flutter/widgets.dart';

class AppReveal extends StatefulWidget {
  const AppReveal({
    required this.child,
    super.key,
    this.index = 0,
    this.identity,
    this.duration = NinjaMotion.base,
  }) : assert(index >= 0, 'The reveal index must be non-negative');

  final Widget child;
  final int index;
  final Object? identity;
  final Duration duration;

  @override
  State<AppReveal> createState() => _AppRevealState();
}

class _AppRevealState extends State<AppReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  Curve _curve = NinjaMotion.enter;
  bool _didStart = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (NinjaMotion.of(context, widget.duration) == Duration.zero) {
      _controller.value = 1;
      _didStart = true;
    } else if (!_didStart) {
      _play();
      _didStart = true;
    }
  }

  @override
  void didUpdateWidget(AppReveal oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.identity != oldWidget.identity) _play();
  }

  void _play() {
    final duration = NinjaMotion.of(context, widget.duration);
    if (duration == Duration.zero) {
      _controller.value = 1;
      return;
    }
    final delay = Duration(
      milliseconds: (widget.index.clamp(0, 8) * 18).clamp(0, 140),
    );
    final total = duration + delay;
    _controller.duration = total;
    _curve = Interval(
      delay.inMicroseconds / total.inMicroseconds,
      1,
      curve: NinjaMotion.enter,
    );
    unawaited(_controller.forward(from: 0));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _controller,
    child: widget.child,
    builder: (context, child) {
      final remaining = 1 - _curve.transform(_controller.value);
      return Transform.translate(
        offset: Offset(0, remaining * 8),
        child: Transform.scale(scale: 1 - remaining * .01, child: child),
      );
    },
  );
}
