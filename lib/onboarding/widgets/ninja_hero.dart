part of '../view/onboarding_page.dart';

class _NinjaHero extends StatefulWidget {
  const _NinjaHero({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  State<_NinjaHero> createState() => _NinjaHeroState();
}

class _NinjaHeroState extends State<_NinjaHero>
    with SingleTickerProviderStateMixin {
  late final AnimationController _bobController;
  late final CurvedAnimation _bob;
  var _motionEnabled = false;

  @override
  void initState() {
    super.initState();
    _bobController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _bob = CurvedAnimation(parent: _bobController, curve: Curves.easeInOut);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final shouldAnimate =
        !MediaQuery.disableAnimationsOf(context) &&
        !MediaQuery.accessibleNavigationOf(context);
    if (_motionEnabled == shouldAnimate) return;
    _motionEnabled = shouldAnimate;
    if (shouldAnimate) {
      unawaited(_bobController.repeat(reverse: true));
    } else {
      _bobController
        ..stop()
        ..value = 0;
    }
  }

  @override
  void dispose() {
    _bob.dispose();
    _bobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: widget.size,
      child: AnimatedBuilder(
        animation: _bob,
        child: AppNinjaMark(size: widget.size, color: widget.color),
        builder: (context, child) => Transform.translate(
          offset: Offset(0, -6 * _bob.value),
          child: child,
        ),
      ),
    );
  }
}
