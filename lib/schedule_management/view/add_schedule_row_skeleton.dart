part of 'add_schedule_page.dart';

class _AddScheduleRowSkeleton extends StatelessWidget {
  const _AddScheduleRowSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        0,
        AppSpacing.screen,
        10,
      ),
      child: Container(
        constraints: const BoxConstraints(minHeight: 64),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
        child: const Row(
          children: [
            NinjaSkeleton.avatar(),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  NinjaSkeleton.bar(widthFactor: 0.5),
                  SizedBox(height: 7),
                  NinjaSkeleton.bar(height: 11, widthFactor: 0.3),
                ],
              ),
            ),
            SizedBox(width: 10),
            NinjaSkeleton(
              width: 88,
              height: AppControlSize.touchTarget,
              radius: AppRadius.full,
            ),
          ],
        ),
      ),
    );
  }
}
