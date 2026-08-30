part of 'schedule_skeleton.dart';

class _ScheduleChromeSkeleton extends StatelessWidget {
  const _ScheduleChromeSkeleton();

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final scale = MediaQuery.textScalerOf(
      context,
    ).scale(1).clamp(1, 2).toDouble();

    return Padding(
      padding: const .fromLTRB(
        NinjaMetrics.screenPadding,
        6,
        NinjaMetrics.screenPadding,
        4,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: 56 + (scale - 1) * 26),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: .min,
                crossAxisAlignment: .start,
                children: [
                  Text(
                    context.l10n.scheduleAppBarTitle,
                    maxLines: 1,
                    overflow: .ellipsis,
                    style: NinjaText.headline.copyWith(color: colors.ink),
                  ),
                  const SizedBox(height: 6),
                  const NinjaSkeleton(width: 104, height: 9, radius: 5),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const NinjaSkeleton.avatar(),
            const SizedBox(width: 8),
            const NinjaSkeleton.avatar(),
          ],
        ),
      ),
    );
  }
}
