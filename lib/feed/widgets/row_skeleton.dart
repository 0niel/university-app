part of 'category_feed_loader_item.dart';

class _RowSkeleton extends StatelessWidget {
  const _RowSkeleton({this.isLast = false});

  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final scale = MediaQuery.textScalerOf(context).scale(1);
    final height = 104 + (scale - 1).clamp(0, 1).toDouble() * 98;
    return _Bounded(
      isLast: isLast,
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
                child: Row(
                  children: [
                    NinjaSkeletonMedia(
                      width: 72,
                      height: 72,
                      radius: AppRadius.md,
                    ),
                    SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          NinjaSkeleton.bar(height: 14, widthFactor: .92),
                          SizedBox(height: AppSpacing.sm),
                          NinjaSkeleton.bar(height: 14, widthFactor: .72),
                          SizedBox(height: AppSpacing.md),
                          NinjaSkeleton.bar(height: 10, widthFactor: .44),
                        ],
                      ),
                    ),
                    SizedBox(width: AppSpacing.xs),
                    NinjaSkeleton(width: 16, height: 16),
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
