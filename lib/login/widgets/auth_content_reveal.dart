import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';

class AuthContentReveal extends StatefulWidget {
  const AuthContentReveal({required this.child, this.identity, super.key});

  final Widget child;
  final Object? identity;

  @override
  State<AuthContentReveal> createState() => _AuthContentRevealState();
}

class _AuthContentRevealState extends State<AuthContentReveal>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(vsync: this);
  late final _progress = CurvedAnimation(
    parent: _controller,
    curve: NinjaMotion.enter,
  );
  late final Animatable<double> _scaleTween = Tween(begin: .985, end: 1);
  late final Animation<double> _scale = _scaleTween.animate(_progress);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_controller.duration != NinjaMotion.of(context, NinjaMotion.slow)) {
      _reveal();
    }
  }

  @override
  void didUpdateWidget(covariant AuthContentReveal oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.identity != widget.identity) _reveal();
  }

  void _reveal() {
    final duration = NinjaMotion.of(context, NinjaMotion.slow);
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
