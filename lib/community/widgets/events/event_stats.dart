part of '../event_row.dart';

class _EventStats extends StatelessWidget {
  const _EventStats({required this.event, required this.category});

  final CampusEvent event;
  final EventCategory category;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return Row(
      children: [
        Flexible(
          child: Text(
            eventCategoryLabel(context.l10n, category),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: NinjaText.helper.copyWith(color: colors.brandInk),
          ),
        ),
        const SizedBox(width: 10),
        Semantics(
          label: context.l10n.eventsGoingShort,
          child: Text(
            '${event.goingCount}',
            style: NinjaText.tabular(
              NinjaText.helper.copyWith(color: colors.muted),
            ),
          ),
        ),
      ],
    );
  }
}
