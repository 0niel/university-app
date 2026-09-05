part of 'ninja_friends_panel.dart';

class _NinjaFriendCard extends StatelessWidget {
  const _NinjaFriendCard({
    required this.friend,
    required this.onTap,
    super.key,
    this.distance,
  });

  final Friend friend;
  final String? distance;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final presence = friendPresence(friend, DateTime.now());
    final live = presence == FriendPresence.live;

    final String statusText;
    if (friend.isGhost) {
      statusText = l10n.friendsStatusHidden;
    } else if (live) {
      statusText = l10n.friendsStatusLive;
    } else if (presence == FriendPresence.recent) {
      statusText = l10n.friendsStatusRecent;
    } else {
      statusText = l10n.friendsStatusGeoOff;
    }
    final meta = [?friend.group, statusText].join(' · ');

    return Padding(
      padding: const .fromLTRB(
        AppSpacing.screen,
        0,
        AppSpacing.screen,
        10,
      ),
      child: AppPressable(
        onTap: onTap,
        semanticsLabel: [friend.fullName, meta, ?distance].join(', '),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: .circular(AppRadius.card),
          ),
          child: Padding(
            padding: const .all(AppSpacing.lg),
            child: Row(
              children: [
                AppAvatar(
                  name: friend.fullName,
                  size: FriendsLayout.avatar,
                  online: live,
                ),
                const SizedBox(width: AppSpacing.sectionGap),
                Expanded(
                  child: Column(
                    crossAxisAlignment: .start,
                    spacing: 3,
                    children: [
                      Row(
                        spacing: 6,
                        children: [
                          Flexible(
                            child: Text(
                              friend.fullName,
                              maxLines: 1,
                              overflow: .ellipsis,
                              style: AppText.headline.copyWith(
                                color: colors.ink,
                              ),
                            ),
                          ),
                          if (friend.mood.isNotEmpty)
                            Text(
                              friend.mood,
                              style: const TextStyle(fontSize: 13, height: 1),
                            ),
                        ],
                      ),
                      Text(
                        meta,
                        maxLines: 1,
                        overflow: .ellipsis,
                        style: AppText.caption.copyWith(color: colors.muted),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.gap),
                Column(
                  crossAxisAlignment: .end,
                  spacing: 5,
                  children: [
                    if (distance case final distanceText?)
                      Container(
                        padding: const .symmetric(
                          horizontal: AppSpacing.gap,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: colors.surface2,
                          borderRadius: .circular(AppRadius.full),
                        ),
                        child: Text(
                          distanceText,
                          style: AppText.captionSmall
                              .copyWith(
                                color: colors.muted,
                              )
                              .copyWith(
                                fontFeatures: const [
                                  FontFeature.tabularFigures(),
                                ],
                              ),
                        ),
                      ),
                    if (friend.battery case final battery?)
                      Row(
                        mainAxisSize: .min,
                        spacing: 3,
                        children: [
                          AppLineIconWidget(
                            AppLineIcon.battery,
                            size: 13,
                            color: colors.muted,
                          ),
                          Text(
                            '$battery%',
                            style: AppText.caption
                                .copyWith(color: colors.muted)
                                .copyWith(
                                  fontFeatures: const [
                                    FontFeature.tabularFigures(),
                                  ],
                                ),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
