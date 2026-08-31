part of 'friend_marker.dart';

class _PulseRing extends StatefulWidget {
  const _PulseRing({required this.color});

  final Color color;

  @override
  State<_PulseRing> createState() => _PulseRingState();
}

class _PulseRingState extends State<_PulseRing>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  var _reduceMotion = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reduceMotion =
        MediaQuery.disableAnimationsOf(context) ||
        MediaQuery.accessibleNavigationOf(context);
    if (_reduceMotion == reduceMotion) return;
    _reduceMotion = reduceMotion;
    if (reduceMotion) {
      _controller
        ?..stop()
        ..value = 0;
      return;
    }
    final controller = _controller ??= AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );
    unawaited(controller.repeat());
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    if (_reduceMotion || controller == null) {
      return const SizedBox.square(dimension: 50);
    }
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: controller,
        builder: (_, _) {
          final value = controller.value;
          return Transform.scale(
            scale: 1 + 0.95 * value,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: widget.color.withValues(alpha: (1 - value) * 0.45),
                shape: .circle,
              ),
            ),
          );
        },
      ),
    );
  }
}
