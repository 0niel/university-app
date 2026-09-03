part of 'search_results_skeleton.dart';

class _ResultRowSkeleton extends StatelessWidget {
  const _ResultRowSkeleton();

  @override
  Widget build(BuildContext context) {
    final scale = MediaQuery.textScalerOf(context).scale(1);
    final height = 78 + (scale - 1).clamp(0, 1).toDouble() * 40;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: SizedBox(
        height: height,
        child: const Padding(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: Row(
            children: [
              NinjaSkeleton(width: 42, height: 42, radius: AppRadius.md),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NinjaSkeleton.bar(height: 14, widthFactor: .62),
                    SizedBox(height: AppSpacing.sm),
                    NinjaSkeleton.bar(height: 10, widthFactor: .34),
                  ],
                ),
              ),
              SizedBox(width: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}
