part of 'services_section_skeleton.dart';

class _ServiceTileSkeleton extends StatelessWidget {
  const _ServiceTileSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        NinjaSkeleton(width: 56, height: 56, radius: NinjaRadius.control),
        SizedBox(height: 8),
        NinjaSkeleton(width: 44, height: 10, radius: 5),
      ],
    );
  }
}
