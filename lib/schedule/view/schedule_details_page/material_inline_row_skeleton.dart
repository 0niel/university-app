part of '../schedule_details_page.dart';

class _MaterialInlineRowSkeleton extends StatelessWidget {
  const _MaterialInlineRowSkeleton();

  @override
  Widget build(BuildContext context) => const Padding(
    padding: .symmetric(
      horizontal: AppSpacing.screen,
      vertical: AppSpacing.md,
    ),
    child: Row(
      children: [
        AppSkeleton.avatar(size: 40),
        SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: .start,
            children: [
              AppSkeleton.bar(widthFactor: 0.7),
              SizedBox(height: AppSpacing.xsm),
              AppSkeleton.bar(height: 11, widthFactor: 0.45),
            ],
          ),
        ),
      ],
    ),
  );
}
