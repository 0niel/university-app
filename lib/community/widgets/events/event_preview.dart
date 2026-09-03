part of '../create_event_sheet.dart';

class _EventPreview extends StatelessWidget {
  const _EventPreview({
    required this.title,
    required this.place,
    required this.startsAt,
    required this.category,
    required this.emoji,
  });

  final String title;
  final String place;
  final DateTime startsAt;
  final EventCategory category;
  final String emoji;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).languageCode;
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
            Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colors.tint,
                borderRadius: BorderRadius.circular(AppRadius.field),
              ),
              child: Text(emoji, style: const TextStyle(fontSize: 22)),
            ),
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
                      DateFormat('d MMMM · HH:mm', locale).format(startsAt),
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
