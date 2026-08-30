part of 'add_schedule_page.dart';

class _AddScheduleResultRow extends StatelessWidget {
  const _AddScheduleResultRow({required this.result, required this.added});

  final _AddScheduleResult result;
  final bool added;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        NinjaMetrics.screenPadding,
        0,
        NinjaMetrics.screenPadding,
        10,
      ),
      child: Container(
        constraints: const BoxConstraints(minHeight: 64),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(NinjaRadius.card),
        ),
        child: Row(
          children: [
            ScheduleEntityAvatar(target: result.target, name: result.name),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    result.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: NinjaText.headline.copyWith(color: colors.ink),
                  ),
                  if (result.subtitle case final subtitle?
                      when subtitle.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: NinjaText.subtext.copyWith(color: colors.muted),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 10),
            if (added)
              NinjaBadge(l10n.addScheduleAdded)
            else
              NinjaButton.primary(
                label: l10n.addScheduleAddAction,
                size: NinjaButtonSize.medium,
                onPressed: () => result.onSubscribe(context.read()),
              ),
          ],
        ),
      ),
    );
  }
}
