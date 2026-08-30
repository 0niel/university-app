part of 'ninja_path_skeleton.dart';

class _LeaderboardRowSkeleton extends StatelessWidget {
  const _LeaderboardRowSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: .symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          SizedBox(
            width: 30,
            child: NinjaSkeleton(width: 16, height: 12, radius: 6),
          ),
          NinjaSkeleton.avatar(size: 32),
          SizedBox(width: 12),
          Expanded(child: NinjaSkeleton.bar(height: 13, widthFactor: 0.6)),
          SizedBox(width: 10),
          NinjaSkeleton(width: 40, height: 12, radius: 6),
        ],
      ),
    );
  }
}
