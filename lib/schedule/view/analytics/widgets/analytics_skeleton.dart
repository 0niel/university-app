part of '../analytics_page.dart';

class _AnalyticsSkeleton extends StatelessWidget {
  const _AnalyticsSkeleton({super.key});

  @override
  Widget build(BuildContext context) => const Column(
    crossAxisAlignment: .stretch,
    children: [
      Row(
        children: [
          Expanded(
            child: AppSkeleton(height: 96, radius: AppRadius.card),
          ),
          SizedBox(width: AppSpacing.gap),
          Expanded(
            child: AppSkeleton(height: 96, radius: AppRadius.card),
          ),
        ],
      ),
      SizedBox(height: AppSpacing.gap),
      AppSkeleton(height: 232, radius: AppRadius.card),
      SizedBox(height: AppSpacing.gap),
      AppSkeleton(height: 148, radius: AppRadius.card),
      SizedBox(height: AppSpacing.gap),
      AppSkeleton(height: 76, radius: AppRadius.card),
      SizedBox(height: AppSpacing.gap),
      AppSkeleton(height: 76, radius: AppRadius.card),
    ],
  );
}
