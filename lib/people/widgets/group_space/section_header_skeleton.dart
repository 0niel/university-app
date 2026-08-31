part of 'ninja_group_space_skeleton.dart';

class _SectionHeaderSkeleton extends StatelessWidget {
  const _SectionHeaderSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: .fromLTRB(0, 28, 0, 8),
      child: Row(
        children: [
          Expanded(child: NinjaSkeleton.bar(height: 19, widthFactor: 0.42)),
          SizedBox(width: 10),
          NinjaSkeleton(width: 84, height: 36, radius: NinjaRadius.pill),
        ],
      ),
    );
  }
}
