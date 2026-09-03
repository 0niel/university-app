part of 'friend_marker.dart';

class MyLocationMarker extends StatelessWidget {
  const MyLocationMarker({required this.isGhost, super.key});

  final bool isGhost;

  static const dotSize = 14.0;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tone = isGhost ? colors.muted2 : colors.accent;
    const ringSize = dotSize + friendMarkerRingWidth * 2;
    return _MarkerPop(
      child: Column(
        mainAxisSize: .min,
        children: [
          SizedBox.square(
            dimension: ringSize + 16,
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: .none,
              children: [
                if (!isGhost &&
                    !MediaQuery.disableAnimationsOf(context) &&
                    !MediaQuery.accessibleNavigationOf(context))
                  AppPulseDot(size: ringSize, color: tone),
                Container(
                  width: ringSize,
                  height: ringSize,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: colors.surface,
                    shape: .circle,
                  ),
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: tone, shape: .circle),
                    child: const SizedBox.square(dimension: dotSize),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 3),
          _NamePill(label: context.l10n.friendsYou, color: tone),
        ],
      ),
    );
  }
}
