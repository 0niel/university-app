part of '../schedule_details_page.dart';

class _MaterialCardSkeleton extends StatelessWidget {
  const _MaterialCardSkeleton();
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const .all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: .circular(AppRadius.card),
      ),
      child: const Row(
        children: [
          AppSkeleton.avatar(size: 46),
          SizedBox(width: AppSpacing.sectionGap),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                AppSkeleton.bar(widthFactor: 0.65),
                SizedBox(height: AppSpacing.xsm),
                Row(
                  spacing: AppSpacing.xsm,
                  children: [
                    AppSkeleton(width: AppSpacing.lg, height: AppSpacing.lg),
                    AppSkeleton(width: 110, height: AppSpacing.gap),
                  ],
                ),
                SizedBox(height: AppSpacing.sm),
                AppSkeleton(width: 90, height: AppSpacing.gap),
              ],
            ),
          ),
          SizedBox(width: AppSpacing.gap),
          AppSkeleton(width: 34, height: 34),
        ],
      ),
    );
  }
}
