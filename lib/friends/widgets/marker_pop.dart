part of 'friend_marker.dart';

class _MarkerPop extends StatelessWidget {
  const _MarkerPop({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final reduceMotion =
        MediaQuery.disableAnimationsOf(context) ||
        MediaQuery.accessibleNavigationOf(context);
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: reduceMotion
          ? Duration.zero
          : const Duration(milliseconds: 340),
      curve: Curves.easeOutBack,
      builder: (_, animationValue, animatedChild) => Opacity(
        opacity: animationValue.clamp(0.0, 1.0),
        child: Transform.scale(
          scale: 0.55 + 0.45 * animationValue,
          alignment: Alignment.bottomCenter,
          child: animatedChild,
        ),
      ),
      child: child,
    );
  }
}
