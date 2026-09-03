part of '../compare_page.dart';

class _GroupPickerResultsSkeleton extends StatelessWidget {
  const _GroupPickerResultsSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .stretch,
      spacing: AppSpacing.lg,
      children: [
        for (var index = 0; index < 4; index++)
          const Row(
            spacing: AppSpacing.md,
            children: [
              AppSkeleton(width: 24, height: 24, radius: AppRadius.iconTile),
              Expanded(child: AppSkeleton.bar(widthFactor: 0.6)),
            ],
          ),
      ],
    );
  }
}
