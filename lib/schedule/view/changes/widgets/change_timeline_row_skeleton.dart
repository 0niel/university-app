part of '../changes_page.dart';

class _ChangeTimelineRowSkeleton extends StatelessWidget {
  const _ChangeTimelineRowSkeleton({this.last = false});

  final bool last;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: .only(bottom: last ? AppSpacing.xs : AppSpacing.gap),
      child: const AppCard(
        child: Row(
          crossAxisAlignment: .start,
          spacing: AppSpacing.md,
          children: [
            AppSkeleton.avatar(),
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                spacing: AppSpacing.xsm,
                children: [
                  AppSkeleton.bar(
                    height: AppSpacing.sectionGap,
                    widthFactor: 0.7,
                  ),
                  AppSkeleton.bar(height: 11, widthFactor: 0.5),
                  SizedBox(height: AppSpacing.xxs),
                  AppSkeleton(
                    width: 72,
                    height: AppSpacing.fieldGap,
                    radius: AppRadius.full,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
