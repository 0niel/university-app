part of 'schedule_management_page.dart';

class _HubRowSkeleton extends StatelessWidget {
  const _HubRowSkeleton();

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
        constraints: const BoxConstraints(minHeight: 52),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
        child: const Row(
          children: [
            NinjaSkeleton.avatar(),
            SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  NinjaSkeleton.bar(widthFactor: 0.5),
                  SizedBox(height: 7),
                  NinjaSkeleton.bar(height: 11, widthFactor: 0.35),
                ],
              ),
            ),
            SizedBox(width: 10),
            NinjaSkeleton(
              width: 16,
              height: 16,
              radius: AppRadius.skeletonThin,
            ),
          ],
        ),
      ),
    );
  }
}
