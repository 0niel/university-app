part of '../featured_event_card.dart';

class _EventMetadata extends StatelessWidget {
  const _EventMetadata({required this.event});

  final CampusEvent event;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final locale = Localizations.localeOf(context).languageCode;
    return Text(
      [
        DateFormat('d MMMM · HH:mm', locale).format(event.startsAt),
        if (event.place.isNotEmpty) event.place,
      ].join(' · '),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: NinjaText.subtext.copyWith(color: colors.onAccentSoftMuted),
    );
  }
}
