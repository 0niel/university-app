part of 'friend_marker.dart';

class _MoodBadge extends StatelessWidget {
  const _MoodBadge(this.mood);

  final String mood;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return Container(
      padding: const .all(3),
      decoration: BoxDecoration(color: colors.surface, shape: .circle),
      child: Text(mood, style: const TextStyle(fontSize: 12, height: 1)),
    );
  }
}
