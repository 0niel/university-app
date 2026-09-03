part of 'study_group_page.dart';

class NinjaStudyGroupSkeleton extends StatelessWidget {
  const NinjaStudyGroupSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return NinjaSkeletonGroup(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const .fromLTRB(
          AppSpacing.screen,
          12,
          AppSpacing.screen,
          32,
        ),
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: .circular(AppRadius.card),
            ),
            child: const Padding(
              padding: .all(16),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Row(
                    spacing: 14,
                    children: [
                      SizedBox.square(
                        dimension: 44,
                        child: NinjaSkeleton(
                          height: 44,
                          radius: AppRadius.field,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: .start,
                          spacing: 7,
                          children: [
                            NinjaSkeleton.bar(height: 19, widthFactor: 0.62),
                            NinjaSkeleton.bar(height: 11, widthFactor: 0.34),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  NinjaSkeleton.bar(height: 11, widthFactor: 0.72),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          const NinjaSkeleton(height: 52, radius: AppRadius.full),
          const SizedBox(height: 28),
          const NinjaSkeleton.bar(height: 19, widthFactor: 0.4),
          const SizedBox(height: 10),
          for (var index = 0; index < 4; index++) ...[
            DecoratedBox(
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: .circular(AppRadius.card),
              ),
              child: const Padding(
                padding: .all(16),
                child: NinjaSkeletonRow(),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}
