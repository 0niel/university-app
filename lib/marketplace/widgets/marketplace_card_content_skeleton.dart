part of 'marketplace_card_skeleton.dart';

class _MarketplaceCardContentSkeleton extends StatelessWidget {
  const _MarketplaceCardContentSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NinjaSkeleton.bar(height: 13, widthFactor: .9),
        SizedBox(height: 3),
        NinjaSkeleton.bar(height: 13, widthFactor: .6),
        SizedBox(height: AppSpacing.xsm),
        NinjaSkeleton(width: 70, height: 15),
        SizedBox(height: AppSpacing.xs),
        NinjaSkeleton.bar(height: 11.5, widthFactor: .7),
        SizedBox(height: AppSpacing.sectionGap),
        SizedBox(
          width: double.infinity,
          child: NinjaSkeleton(height: 36, radius: AppRadius.full),
        ),
      ],
    );
  }
}
