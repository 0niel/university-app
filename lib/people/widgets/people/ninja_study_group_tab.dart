part of '../people_widgets.dart';

class NinjaStudyGroupTab extends StatelessWidget {
  const NinjaStudyGroupTab({
    required this.study,
    required this.pendingFriendIds,
    required this.pendingInviteIds,
    required this.onAddToFriends,
    required this.onCreate,
    required this.onJoinByCode,
    required this.onDiscover,
    required this.onManage,
    required this.onRespondInvite,
    super.key,
  });

  final MyStudyGroup study;
  final Set<String> pendingFriendIds;
  final Set<String> pendingInviteIds;
  final Future<void> Function(String userId) onAddToFriends;
  final Future<void> Function() onCreate;
  final Future<void> Function() onJoinByCode;
  final Future<void> Function() onDiscover;
  final Future<void> Function() onManage;
  final Future<void> Function(String inviteId, {required bool accept})
  onRespondInvite;

  @override
  Widget build(BuildContext context) {
    final group = study.group;
    if (!study.hasGroup || group == null) {
      return NinjaNoStudyGroupTab(
        invites: study.incomingInvites,
        pendingInviteIds: pendingInviteIds,
        onCreate: onCreate,
        onJoinByCode: onJoinByCode,
        onDiscover: onDiscover,
        onRespondInvite: onRespondInvite,
      );
    }

    final colors = context.colors;
    final l10n = context.l10n;
    final members = study.members;
    final friendsInGroup = members.where((member) => member.isFriend).length;
    const inset = EdgeInsets.symmetric(
      horizontal: AppSpacing.screen,
    );
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const .only(top: 10, bottom: 96),
      children: [
        Padding(
          padding: inset,
          child: Container(
            padding: const .all(16),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: .circular(AppRadius.card),
            ),
            child: Row(
              spacing: 14,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  alignment: .center,
                  decoration: BoxDecoration(
                    color: colors.surface2,
                    borderRadius: .circular(AppRadius.tile),
                  ),
                  child: Text(
                    group.emoji,
                    style: const TextStyle(fontSize: 21),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      Text(
                        group.name,
                        maxLines: 2,
                        overflow: .ellipsis,
                        style: AppText.title.copyWith(color: colors.ink),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        [
                          l10n.studyGroupMembersCount(group.memberCount),
                          if (friendsInGroup > 0)
                            l10n.peopleGroupInFriends(friendsInGroup),
                        ].join(' · '),
                        maxLines: 2,
                        overflow: .ellipsis,
                        style: AppText.caption.copyWith(color: colors.muted),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: inset,
          child: StudyGroupActionCard(
            icon: AppLineIcon.settings,
            title: l10n.studyGroupManage,
            subtitle: study.isOwner
                ? l10n.studyGroupOwnerTag
                : l10n.studyGroupMembersSection,
            onTap: () => unawaited(onManage()),
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: inset,
          child: StudyGroupActionCard(
            icon: AppLineIcon.people,
            title: l10n.peopleGroupSpaceTitle,
            subtitle: l10n.peopleGroupSpaceSub,
            onTap: () => context.go('/services/people/group-space'),
          ),
        ),
        NinjaPeopleSectionHeader(l10n.peopleGroupList),
        for (final (index, member) in members.indexed)
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
                padding: const .symmetric(horizontal: 14, vertical: 13),
                child: NinjaPeopleGroupMemberCard(
                  member: member,
                  pending: pendingFriendIds.contains(member.userId),
                  onAdd: () => unawaited(onAddToFriends(member.userId)),
                ),
              ),
            ),
          ).animateListItem(index: index),
        const SizedBox(height: 8),
        Padding(
          padding: inset,
          child: PeoplePrivacyNote(text: l10n.peoplePrivacyNote),
        ),
      ],
    );
  }
}
