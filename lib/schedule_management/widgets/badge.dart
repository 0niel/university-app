part of 'primary_schedule_card.dart';

class _Badge extends StatelessWidget {
  const _Badge({required this.target, required this.name});

  final ScheduleTarget? target;
  final String name;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final foreground = colors.onAccentSoft;
    final Widget content = target == .group
        ? Text(
            scheduleGroupBadge(name),
            style: NinjaText.tabular(
              NinjaText.headline.copyWith(color: foreground),
            ),
          )
        : AppLineIconWidget(
            scheduleTargetIcon(target ?? .group),
            size: 21,
            color: foreground,
          );

    return Container(
      width: NinjaMetrics.minTouchTarget,
      height: NinjaMetrics.minTouchTarget,
      decoration: BoxDecoration(
        color: foreground.withValues(alpha: .12),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: content,
    );
  }
}
