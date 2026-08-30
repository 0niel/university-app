part of '../people_widgets.dart';

class NinjaPeopleGroupMemberCard extends StatelessWidget {
  const NinjaPeopleGroupMemberCard({
    required this.member,
    required this.pending,
    required this.onAdd,
    super.key,
  });

  final StudyGroupMember member;
  final bool pending;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;
    final status = switch (member) {
      _ when member.isOwner => NinjaBadge(l10n.studyGroupOwnerTag, tone: .ink),
      _ when member.isMe => NinjaBadge(l10n.peopleTagYou, tone: .ink),
      _ when member.isFriend => NinjaBadge(l10n.peopleTagFriend),
      _ when pending || member.friendshipStatus == 'pending' => NinjaBadge(
        l10n.peopleTagRequest,
        tone: .ink,
      ),
      _ => NinjaButton.secondary(
        label: l10n.peopleAddToFriends,
        size: NinjaButtonSize.small,
        onPressed: onAdd,
      ),
    };
    final handle = member.handle;
    return LayoutBuilder(
      builder: (context, constraints) {
        final stackStatus = MediaQuery.textScalerOf(context).scale(1) >= 1.5;
        final identity = Row(
          spacing: 12,
          children: [
            NinjaAvatar(initials: ninjaInitials(member.fullName)),
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    member.fullName,
                    overflow: .ellipsis,
                    style: NinjaText.body.copyWith(color: colors.ink),
                  ),
                  if (handle != null && handle.isNotEmpty)
                    Text(
                      '@$handle',
                      style: NinjaText.helper.copyWith(
                        color: colors.muted,
                      ),
                    ),
                ],
              ),
            ),
          ],
        );
        if (stackStatus || constraints.maxWidth < 280) {
          return Column(
            spacing: 8,
            crossAxisAlignment: .stretch,
            children: [
              identity,
              Align(alignment: .centerRight, child: status),
            ],
          );
        }
        return Row(
          spacing: 8,
          children: [
            Expanded(child: identity),
            status,
          ],
        );
      },
    );
  }
}
