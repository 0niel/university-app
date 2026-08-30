import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class NinjaLogoBadge extends StatefulWidget {
  const NinjaLogoBadge({super.key, this.size = 64, this.spin = true});

  final double size;

  final bool spin;

  @override
  State<NinjaLogoBadge> createState() => _NinjaLogoBadgeState();
}

class _NinjaLogoBadgeState extends State<NinjaLogoBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  var _motionEnabled = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final shouldAnimate =
        widget.spin &&
        !MediaQuery.disableAnimationsOf(context) &&
        !MediaQuery.accessibleNavigationOf(context);
    if (_motionEnabled == shouldAnimate) return;
    _motionEnabled = shouldAnimate;
    if (shouldAnimate) {
      unawaited(_controller.repeat());
    } else {
      _controller
        ..stop()
        ..value = 0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final markSize = widget.size * 0.48;

    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: .circular(NinjaRadius.card),
      ),
      alignment: Alignment.center,
      child: RotationTransition(
        turns: _controller,
        child: AppNinjaMark(size: markSize, color: colors.brand),
      ),
    );
  }
}
