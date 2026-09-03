part of 'friend_marker.dart';

class _AvatarBubble extends StatelessWidget {
  const _AvatarBubble({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const .all(friendMarkerRingWidth),
      decoration: BoxDecoration(
        color: context.colors.surface,
        shape: .circle,
      ),
      child: AppAvatar(name: name, size: friendMarkerAvatarSize),
    );
  }
}
