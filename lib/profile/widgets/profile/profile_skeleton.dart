part of 'profile_widgets.dart';

class ProfileSkeleton extends StatelessWidget {
  const ProfileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const NinjaSkeletonGroup(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.screen),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: AppSpacing.xlg),
            Row(
              children: [
                NinjaSkeleton.avatar(size: 72),
                SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      NinjaSkeleton.bar(height: 22),
                      SizedBox(height: AppSpacing.sm),
                      NinjaSkeleton.bar(),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.screen),
            NinjaSkeleton(height: 84, radius: AppRadius.lg),
            SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: NinjaSkeleton(height: 64, radius: AppRadius.field),
                ),
                SizedBox(width: AppSpacing.xsm),
                Expanded(
                  child: NinjaSkeleton(height: 64, radius: AppRadius.field),
                ),
                SizedBox(width: AppSpacing.xsm),
                Expanded(
                  child: NinjaSkeleton(height: 64, radius: AppRadius.field),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.sheetBottom),
            NinjaSkeleton.bar(height: 22, widthFactor: 0.4),
            SizedBox(height: AppSpacing.sectionGap),
            NinjaSkeleton(height: 180, radius: AppRadius.card),
            SizedBox(height: AppSpacing.sheetBottom),
            NinjaSkeleton.bar(height: 22, widthFactor: 0.4),
            SizedBox(height: AppSpacing.sectionGap),
            Row(
              children: [
                Expanded(
                  child: NinjaSkeleton(height: 112, radius: AppRadius.row),
                ),
                SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: NinjaSkeleton(height: 112, radius: AppRadius.row),
                ),
                SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: NinjaSkeleton(height: 112, radius: AppRadius.row),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
