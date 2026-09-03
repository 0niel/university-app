part of 'schedule_management_page.dart';

class _HubSkeleton extends StatelessWidget {
  const _HubSkeleton();

  static const _rowCount = 3;

  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    return NinjaSkeletonGroup(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.only(
          top: AppSpacing.xl,
          bottom: ninjaBottomInset(context) + AppSpacing.lg,
        ),
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.screen,
            ),
            child: NinjaSkeleton(width: 90, height: 11),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screen,
            ),
            child: NinjaSkeleton(
              height: textScale >= 1.5 ? 172 : 140,
              radius: AppRadius.card,
            ),
          ),
          const SizedBox(height: 18),
          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.screen,
            ),
            child: NinjaSkeleton(width: 110, height: 11),
          ),
          const SizedBox(height: 10),
          ...List<Widget>.generate(_rowCount, (_) => const _HubRowSkeleton()),
        ],
      ),
    );
  }
}
