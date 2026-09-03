part of '../create_event_sheet.dart';

class _EventPreview extends StatelessWidget {
  const _EventPreview({
    required this.title,
    required this.place,
    required this.startsAt,
    required this.category,
    required this.emoji,
    this.endsAt,
  });

  final String title;
  final String place;
  final DateTime startsAt;
  final DateTime? endsAt;
  final EventCategory category;
  final String emoji;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).languageCode;
    final end = endsAt;
    final when = end == null
        ? DateFormat('d MMMM · HH:mm', locale).format(startsAt)
        : '${DateFormat('d MMMM · HH:mm', locale).format(startsAt)}–'
              '${DateFormat.Hm(locale).format(end)}';
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EmojiTile(emoji: emoji, emojiSize: 22),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title.isEmpty ? l10n.eventsCreatePreviewTitle : title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.headline.copyWith(color: colors.ink),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    [
                      eventCategoryLabel(l10n, category),
                      when,
                      if (place.isNotEmpty) place,
                    ].join(' · '),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.subtext.copyWith(color: colors.muted),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
