part of 'friend_marker.dart';

class MyLocationMarker extends StatelessWidget {
  const MyLocationMarker({required this.isGhost, super.key});

  final bool isGhost;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final tint = isGhost ? colors.muted : colors.brand;

    return _MarkerPop(
      child: Column(
        mainAxisSize: .min,
        children: [
          SizedBox(
            width: 64,
            height: 64,
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: .none,
              children: [
                if (!isGhost) _PulseRing(color: colors.brand),
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: colors.surface,
                    shape: .circle,
                  ),
                  alignment: Alignment.center,
                  child: isGhost
                      ? AppLineIconWidget(.hide, size: 18, color: tint)
                      : Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: tint,
                            shape: .circle,
                          ),
                        ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          _NamePill(label: context.l10n.friendsYou, color: tint),
        ],
      ),
    );
  }
}
