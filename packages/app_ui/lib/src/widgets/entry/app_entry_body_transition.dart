import 'dart:async';

import 'package:app_ui/src/animations/ninja_motion.dart';
import 'package:flutter/widgets.dart';

class AppEntryBodyTransition extends StatefulWidget {
  const AppEntryBodyTransition({
    required this.child,
    this.identity,
    super.key,
  });

  final Widget child;
  final Object? identity;

  @override
  State<AppEntryBodyTransition> createState() => _AppEntryBodyTransitionState();
}

class _AppEntryBodyTransitionState extends State<AppEntryBodyTransition>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(vsync: this);
  late final _progress = CurvedAnimation(
    parent: _controller,
    curve: NinjaMotion.enter,
  );
  late final Animation<double> _scale = Tween(
    begin: .985,
    end: _controller.upperBound,
  ).animate(_progress);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_controller.duration != NinjaMotion.of(context)) {
      _animate();
    }
  }

  @override
  void didUpdateWidget(covariant AppEntryBodyTransition oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.identity != oldWidget.identity) _animate();
  }

  void _animate() {
    final duration = NinjaMotion.of(context);
    _controller.duration = duration;
    if (duration == Duration.zero) {
      _controller.value = 1;
    } else {
      unawaited(_controller.forward(from: 0));
    }
  }

  @override
  void dispose() {
    _progress.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ScaleTransition(
    scale: _scale,
    alignment: Alignment.topCenter,
    child: widget.child,
  );
}
