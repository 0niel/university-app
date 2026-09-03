part of 'teacher_profile_page.dart';

class _ReviewCardSkeleton extends StatelessWidget {
  const _ReviewCardSkeleton();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const .all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: .circular(AppRadius.card),
      ),
      child: const Column(
        crossAxisAlignment: .start,
        spacing: AppSpacing.gap,
        children: [
          Row(
            spacing: AppSpacing.gap,
            children: [
              AppSkeleton(width: 32, height: 32, radius: AppRadius.sheet / 2),
              Expanded(child: AppSkeleton(width: 120, height: 12)),
              AppSkeleton(width: 60, height: 14),
            ],
          ),
          AppSkeleton.bar(height: 11, widthFactor: 0.9),
        ],
      ),
    );
  }
}
