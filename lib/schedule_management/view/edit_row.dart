part of 'edit_schedules_page.dart';

class _EditRow extends StatelessWidget {
  const _EditRow({
    required this.target,
    required this.entry,
    required this.index,
    required this.onRemove,
    super.key,
  });

  final ScheduleTarget target;
  final _EditEntry entry;
  final int index;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final status = ScheduleLiveStatus.of(entry.schedule);

    return Padding(
      key: ValueKey('${entry.id}_row'),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        0,
        AppSpacing.screen,
        10,
      ),
      child: Container(
        constraints: const BoxConstraints(minHeight: 60),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
        child: Row(
          children: [
            AppPressable(
              pressedScale: 0.9,
              onTap: onRemove,
              semanticsLabel: '${l10n.delete}: ${entry.name}',
              child: SizedBox.square(
                dimension: AppControlSize.touchTarget,
                child: Center(
                  child: Container(
                    width: 32,
                    height: 32,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colors.dangerTint,
                    ),
                    child: AppLineIconWidget(
                      AppLineIcon.minus,
                      size: 17,
                      color: colors.exam,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 4),
            ScheduleEntityAvatar(target: target, name: entry.name, size: 40),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    entry.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.headline.copyWith(color: colors.ink),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l10n.scheduleHubLessonsToday(status.todayCount),
                    style: AppText.subtext.copyWith(color: colors.muted),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            ReorderableDragStartListener(
              index: index,
              child: SizedBox.square(
                dimension: AppControlSize.touchTarget,
                child: Center(
                  child: AppLineIconWidget(
                    AppLineIcon.more,
                    color: colors.muted2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
