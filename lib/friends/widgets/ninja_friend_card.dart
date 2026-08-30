part of 'ninja_friends_panel.dart';

class _NinjaFriendCard extends StatelessWidget {
  const _NinjaFriendCard({
    required this.friend,
    required this.onTap,
    this.distance,
  });

  final Friend friend;
  final String? distance;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;
    final locationUpdatedAt = friend.locationUpdatedAt;
    final live =
        friend.hasLocation &&
        locationUpdatedAt != null &&
        DateTime.now().difference(locationUpdatedAt).inMinutes < 5;

    final String statusText;
    if (friend.isGhost) {
      statusText = l10n.friendsStatusHidden;
    } else if (live) {
      statusText = l10n.friendsStatusLive;
    } else if (friend.hasLocation) {
      statusText = l10n.friendsStatusRecent;
    } else {
      statusText = l10n.friendsStatusGeoOff;
    }
    final meta = [?friend.group, statusText].join(' · ');

    return Padding(
      padding: const .fromLTRB(
        NinjaMetrics.screenPadding,
        0,
        NinjaMetrics.screenPadding,
        10,
      ),
      child: AppPressable(
        onTap: onTap,
        semanticsLabel: [friend.fullName, meta, ?distance].join(', '),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: .circular(NinjaRadius.card),
          ),
          child: Padding(
            padding: const .all(16),
            child: Row(
              children: [
                NinjaAvatar(
                  initials: ninjaInitials(friend.fullName),
                  online: live,
                ),
                const SizedBox(width: 14),
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
                              style: NinjaText.headline.copyWith(
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
                        style: NinjaText.helper.copyWith(color: colors.muted),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: .end,
                  spacing: 5,
                  children: [
                    if (distance case final distanceText?)
                      Container(
                        padding: const .symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: colors.surfaceAlt,
                          borderRadius: .circular(NinjaRadius.pill),
                        ),
                        child: Text(
                          distanceText,
                          style: NinjaText.tabular(
                            NinjaText.microLabel.copyWith(
                              color: colors.mutedDark,
                            ),
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
                            style: NinjaText.tabular(
                              NinjaText.helper.copyWith(color: colors.muted),
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
