part of '../people_widgets.dart';

class NinjaFriendsTab extends StatelessWidget {
  const NinjaFriendsTab({
    required this.friends,
    required this.requests,
    required this.pendingResponseIds,
    required this.onRespond,
    required this.onAdd,
    super.key,
    this.now,
  });

  final List<Friend> friends;
  final List<FriendRequest> requests;
  final Set<String> pendingResponseIds;
  final Future<void> Function({
    required String friendshipId,
    required bool accept,
  })
  onRespond;
  final Future<void> Function() onAdd;
  final DateTime? now;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final currentTime = now ?? DateTime.now();
    final live = friends
        .where((friend) {
          final updatedAt = friend.locationUpdatedAt;
          return friend.hasLocation &&
              updatedAt != null &&
              currentTime.difference(updatedAt.toLocal()).inMinutes < 30;
        })
        .toList(growable: false);

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const .only(top: 10, bottom: 96),
      children: [
        Padding(
          padding: const .symmetric(
            horizontal: AppSpacing.screen,
          ),
          child: PeopleMapBanner(live: live),
        ),
        if (requests.isNotEmpty) ...[
          NinjaPeopleSectionHeader(l10n.peopleRequestsLabel(requests.length)),
          Padding(
            padding: const .symmetric(
              horizontal: AppSpacing.screen,
            ),
            child: Column(
              spacing: 10,
              crossAxisAlignment: .stretch,
              children: [
                for (final request in requests)
                  FriendRequestRow(
                    request: request,
                    pending: pendingResponseIds.contains(
                      request.friendshipId,
                    ),
                    onRespond: onRespond,
                  ),
              ],
            ),
          ),
        ],
        if (live.isNotEmpty) ...[
          NinjaPeopleSectionHeader(l10n.peopleLiveNow),
          SizedBox(
            height: 96,
            child: ListView.separated(
              scrollDirection: .horizontal,
              padding: const .symmetric(
                horizontal: AppSpacing.screen,
              ),
              itemCount: live.length,
              separatorBuilder: (_, _) => const SizedBox(width: 16),
              itemBuilder: (context, index) => _liveFriend(
                colors,
                live[index],
              ),
            ),
          ),
        ],
        if (friends.isEmpty)
          Padding(
            padding: const .fromLTRB(
              AppSpacing.screen,
              28,
              AppSpacing.screen,
              0,
            ),
            child: NinjaEmptyState(
              title: l10n.peopleEmptyFriendsTitle,
              message: l10n.peopleEmptyFriendsSub,
              icon: AppLineIconWidget(
                AppLineIcon.people,
                color: colors.muted,
              ),
              actionLabel: l10n.peopleFindFriends,
              onAction: () => unawaited(onAdd()),
            ).animateEmptyState(),
          )
        else ...[
          NinjaPeopleSectionHeader(l10n.peopleAllFriends),
          for (final (index, friend) in friends.indexed)
            Padding(
              padding: const .fromLTRB(
                AppSpacing.screen,
                0,
                AppSpacing.screen,
                10,
              ),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: .circular(AppRadius.card),
                ),
                child: Padding(
                  padding: const .symmetric(
                    horizontal: 14,
                    vertical: 13,
                  ),
                  child: PeopleFriendRow(friend: friend, now: currentTime),
                ),
              ),
            ).animateListItem(index: index),
        ],
      ],
    );
  }

  Widget _liveFriend(AppColors colors, Friend friend) {
    final firstName = friend.fullName
        .split(' ')
        .where((part) => part.isNotEmpty)
        .firstOrNull;
    return Column(
      children: [
        Stack(
          children: [
            NinjaAvatar(initials: ninjaInitials(friend.fullName), size: 56),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const .all(2),
                decoration: BoxDecoration(
                  color: colors.canvas,
                  shape: .circle,
                ),
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: colors.accent,
                    shape: .circle,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          firstName ?? friend.fullName,
          maxLines: 1,
          overflow: .ellipsis,
          style: AppText.caption.copyWith(
            fontWeight: .w600,
            color: colors.ink,
          ),
        ),
        if (friend.mood.isNotEmpty)
          Text(friend.mood, style: const TextStyle(fontSize: 11)),
      ],
    );
  }
}
