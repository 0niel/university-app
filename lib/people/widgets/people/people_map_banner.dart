part of '../people_widgets.dart';

class PeopleMapBanner extends StatelessWidget {
  const PeopleMapBanner({required this.live, super.key});

  final List<Friend> live;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final title = live.isEmpty
        ? l10n.peopleMapTitle
        : l10n.peopleFriendsOnline(live.length);
    return AppPressable(
      onTap: () => context.go('/services/friends-map'),
      semanticsLabel: '$title, ${l10n.peopleMapOpen}',
      semanticsButton: true,
      child: Container(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: .circular(AppRadius.card),
        ),
        padding: const .fromLTRB(16, 14, 12, 14),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              alignment: .center,
              decoration: BoxDecoration(
                color: colors.tint,
                borderRadius: .circular(AppRadius.tile),
              ),
              child: AppLineIconWidget(.map, size: 21, color: colors.accent),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: .ellipsis,
                    style: AppText.body.copyWith(
                      color: colors.ink,
                      fontWeight: .w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l10n.peopleMapOpen,
                    maxLines: 1,
                    overflow: .ellipsis,
                    style: AppText.caption.copyWith(color: colors.muted),
                  ),
                ],
              ),
            ),
            if (live.isNotEmpty) ...[
              const SizedBox(width: 8),
              _LiveAvatars(live: live),
            ],
            const SizedBox(width: 4),
            AppLineIconWidget(.chevronR, size: 16, color: colors.muted2),
          ],
        ),
      ),
    );
  }
}
