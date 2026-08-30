part of '../people_widgets.dart';

class _LiveAvatars extends StatelessWidget {
  const _LiveAvatars({required this.live});

  final List<Friend> live;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.textScalerOf(context).scale(1) >= 1.5) {
      return const SizedBox.shrink();
    }
    final shown = live.take(3).toList(growable: false);
    return SizedBox(
      height: 28,
      child: Row(
        mainAxisSize: .min,
        children: [
          for (final (index, friend) in shown.indexed)
            Align(
              widthFactor: index == 0 ? 1 : 0.62,
              child: Container(
                padding: const .all(2),
                decoration: BoxDecoration(
                  color: context.ninja.surface,
                  shape: .circle,
                ),
                child: NinjaAvatar(
                  initials: ninjaInitials(friend.fullName),
                  size: 28,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
