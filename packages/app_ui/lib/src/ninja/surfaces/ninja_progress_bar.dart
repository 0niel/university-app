import 'dart:async';

import 'package:app_ui/src/colors/colors.dart';
import 'package:flutter/widgets.dart';

enum NinjaProgressTone { lime, scarlet, ink, lecture, warn }

class NinjaProgressBar extends StatefulWidget {
  const NinjaProgressBar({
    super.key,
    this.value = 0,
    this.tone = NinjaProgressTone.lime,
    this.height = 6,
    this.color,
    this.trackColor,
    this.indeterminate = false,
  });

  final double value;
  final NinjaProgressTone tone;
  final double height;
  final Color? color;
  final Color? trackColor;
  final bool indeterminate;

  @override
  State<NinjaProgressBar> createState() => _NinjaProgressBarState();
}

class _NinjaProgressBarState extends State<NinjaProgressBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncAnimation();
  }

  @override
  void didUpdateWidget(covariant NinjaProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncAnimation();
  }

  void _syncAnimation() {
    final reduceMotion = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    if (!widget.indeterminate || reduceMotion) {
      _controller.stop();
      return;
    }
    if (!_controller.isAnimating) {
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
    final colors = context.colors;
    final fill = widget.color ??
        switch (widget.tone) {
          NinjaProgressTone.lime => colors.accent,
          NinjaProgressTone.scarlet => colors.danger,
          NinjaProgressTone.ink => colors.ink,
          NinjaProgressTone.lecture => colors.lecture,
          NinjaProgressTone.warn => colors.warn,
        };
    final track = widget.trackColor ?? colors.surface2;
    final radius = BorderRadius.circular(widget.height / 2);
    final reduceMotion = MediaQuery.maybeDisableAnimationsOf(context) ?? false;

    return ClipRRect(
      borderRadius: radius,
      child: SizedBox(
        height: widget.height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(child: ColoredBox(color: track)),
            if (widget.indeterminate)
              reduceMotion
                  ? FractionallySizedBox(
                      alignment: AlignmentDirectional.centerStart,
                      widthFactor: 0.4,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: fill,
                          borderRadius: radius,
                        ),
                      ),
                    )
                  : AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        final t = Curves.easeInOut.transform(
                          _controller.value,
                        );
                        return FractionalTranslation(
                          translation: Offset(-1 + 1.4 * t, 0),
                          child: child,
                        );
                      },
                      child: FractionallySizedBox(
                        alignment: AlignmentDirectional.centerStart,
                        widthFactor: 0.4,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: fill,
                            borderRadius: radius,
                          ),
                        ),
                      ),
                    )
            else
              FractionallySizedBox(
                alignment: AlignmentDirectional.centerStart,
                widthFactor: widget.value.clamp(0.0, 1.0),
                child: DecoratedBox(
                  decoration: BoxDecoration(color: fill, borderRadius: radius),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

typedef AppProgressBar = NinjaProgressBar;
