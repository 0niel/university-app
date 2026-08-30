part of 'contributors_content.dart';

class _ContributorCardSkeleton extends StatelessWidget {
  const _ContributorCardSkeleton({required this.colors});

  final NinjaColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(NinjaRadius.card),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          NinjaSkeleton.avatar(size: 64),
          SizedBox(height: 14),
          NinjaSkeleton.bar(widthFactor: 0.7),
          SizedBox(height: 6),
          NinjaSkeleton.bar(height: 11, widthFactor: 0.5),
        ],
      ),
    );
  }
}
