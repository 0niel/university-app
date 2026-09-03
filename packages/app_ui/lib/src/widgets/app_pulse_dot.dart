import 'dart:async';

import 'package:app_ui/src/colors/colors.dart';
import 'package:flutter/widgets.dart';

class AppPulseDot extends StatefulWidget {
  const AppPulseDot({super.key, this.size = 12, this.color});

  final double size;
  final Color? color;

  @override
  State<AppPulseDot> createState() => _AppPulseDotState();
}

class _AppPulseDotState extends State<AppPulseDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reduceMotion =
        (MediaQuery.maybeDisableAnimationsOf(context) ?? false) ||
            (MediaQuery.maybeAccessibleNavigationOf(context) ?? false);
    if (reduceMotion || !TickerMode.valuesOf(context).enabled) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      unawaited(_controller.repeat());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? context.colors.accent;
    final reduceMotion =
        (MediaQuery.maybeDisableAnimationsOf(context) ?? false) ||
            (MediaQuery.maybeAccessibleNavigationOf(context) ?? false);

    final dot = DecoratedBox(
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: SizedBox.square(dimension: widget.size),
    );

    if (reduceMotion) return dot;

    return SizedBox.square(
      dimension: widget.size,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final t = _controller.value;
              final wave = t < .5 ? t * 2 : (1 - t) * 2;
              return Opacity(
                opacity: (.6 - .6 * wave).clamp(0, 1).toDouble(),
                child: Transform.scale(scale: 1 + .4 * wave, child: child),
              );
            },
            child: dot,
          ),
          dot,
        ],
      ),
    );
  }
}
