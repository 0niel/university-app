part of 'friend_marker.dart';

class _AvatarBubble extends StatelessWidget {
  const _AvatarBubble({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return Container(
      padding: const .all(4),
      decoration: BoxDecoration(color: colors.surface, shape: .circle),
      child: NinjaAvatar(initials: ninjaInitials(name), size: 42, tone: .ink),
    );
  }
}
