part of 'marketplace_card_skeleton.dart';

class _MarketplaceCardContentSkeleton extends StatelessWidget {
  const _MarketplaceCardContentSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NinjaSkeleton(width: 86, height: 24),
        SizedBox(height: 7),
        NinjaSkeleton.bar(height: 17),
        SizedBox(height: 7),
        NinjaSkeleton.bar(height: 17, widthFactor: 0.72),
        SizedBox(height: 10),
        NinjaSkeleton.bar(height: 11, widthFactor: 0.52),
      ],
    );
  }
}
