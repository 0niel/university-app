part of 'home_dashboard_header.dart';

class _IdentitySkeleton extends StatelessWidget {
  const _IdentitySkeleton();

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: .min,
      crossAxisAlignment: .start,
      children: [
        NinjaSkeleton(width: 128, height: 14, radius: 7),
        SizedBox(height: 6),
        NinjaSkeleton(width: 96, height: 10, radius: 5),
      ],
    );
  }
}
