part of 'primary_schedule_card.dart';

class _Badge extends StatelessWidget {
  const _Badge({required this.target, required this.name});

  final ScheduleTarget? target;
  final String name;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final foreground = colors.ink;
    final Widget content = target == .group
        ? Text(
            scheduleGroupBadge(name),
            style: AppText.tabular(
              AppText.headline.copyWith(color: foreground),
            ),
          )
        : AppLineIconWidget(
            scheduleTargetIcon(target ?? .group),
            size: 21,
            color: foreground,
          );

    return Container(
      width: AppControlSize.touchTarget,
      height: AppControlSize.touchTarget,
      decoration: BoxDecoration(
        color: foreground.withValues(alpha: .12),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: content,
    );
  }
}
