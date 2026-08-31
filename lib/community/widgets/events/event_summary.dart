part of '../event_row.dart';

class _EventSummary extends StatelessWidget {
  const _EventSummary({required this.event, required this.category});

  final CampusEvent event;
  final EventCategory category;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          event.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: NinjaText.headline.copyWith(color: colors.ink),
        ),
        const SizedBox(height: 3),
        Text(
          [
            DateFormat.Hm().format(event.startsAt),
            if (event.place.isNotEmpty) event.place,
          ].join(' · '),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: NinjaText.subtext.copyWith(color: colors.muted),
        ),
        const SizedBox(height: 6),
        _EventStats(event: event, category: category),
      ],
    );
  }
}
