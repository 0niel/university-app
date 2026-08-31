part of 'category_feed_loader_item.dart';

class _HeroSkeleton extends StatelessWidget {
  const _HeroSkeleton();

  @override
  Widget build(BuildContext context) {
    final scale = MediaQuery.textScalerOf(context).scale(1);
    final height = 294 + (scale - 1).clamp(0, 1).toDouble() * 206;
    return _Bounded(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: NinjaMetrics.screenPadding,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(NinjaRadius.card),
          child: SizedBox(
            height: height,
            child: ColoredBox(
              color: context.ninja.surface,
              child: const Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NinjaSkeletonMedia(height: 174, radius: AppRadius.md),
                    SizedBox(height: AppSpacing.lg),
                    NinjaSkeleton.bar(height: 20, widthFactor: .82),
                    SizedBox(height: AppSpacing.sm),
                    NinjaSkeleton.bar(height: 20, widthFactor: .58),
                    Spacer(),
                    NinjaSkeleton.bar(widthFactor: .42),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
