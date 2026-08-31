part of 'home_title_block.dart';

class _TitleSkeleton extends StatelessWidget {
  const _TitleSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: .min,
      crossAxisAlignment: .start,
      children: [
        NinjaSkeleton(width: 180, height: 28, radius: 12),
        SizedBox(height: 9),
        NinjaSkeleton(width: 150, height: 11, radius: 5),
      ],
    );
  }
}
