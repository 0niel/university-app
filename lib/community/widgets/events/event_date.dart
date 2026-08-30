part of '../event_row.dart';

class _EventDate extends StatelessWidget {
  const _EventDate({required this.event, required this.color});

  final CampusEvent event;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final locale = Localizations.localeOf(context).languageCode;
    return SizedBox(
      width: 38,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${event.startsAt.day}',
            style: NinjaText.tabular(
              NinjaText.title.copyWith(color: colors.ink),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            DateFormat('MMM', locale).format(event.startsAt),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: NinjaText.helper.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
