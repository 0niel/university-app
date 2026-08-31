part of 'study_group_page.dart';

class NinjaStudyGroupContent extends StatelessWidget {
  const NinjaStudyGroupContent({
    required this.state,
    required this.group,
    required this.onInvite,
    required this.onRemoveMember,
    required this.onAcceptRequest,
    required this.onDeclineRequest,
    required this.onLeaveOrDelete,
    super.key,
  });
  final StudyGroupState state;
  final StudyGroup group;
  final VoidCallback onInvite;
  final ValueChanged<StudyGroupMember> onRemoveMember;
  final ValueChanged<StudyGroupJoinRequest> onAcceptRequest;
  final ValueChanged<StudyGroupJoinRequest> onDeclineRequest;
  final VoidCallback onLeaveOrDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isOwner = state.isOwner;
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const .only(top: 12, bottom: 32),
      children: [
        Padding(
          padding: const .symmetric(horizontal: NinjaMetrics.screenPadding),
          child: NinjaStudyGroupHeroCard(group: group),
        ),
        Padding(
          padding: const .fromLTRB(
            NinjaMetrics.screenPadding,
            12,
            NinjaMetrics.screenPadding,
            0,
          ),
          child: NinjaButton.primary(
            label: l10n.studyGroupInviteAction,
            expanded: true,
            size: .large,
            onPressed: state.isBusy ? null : onInvite,
          ),
        ),
        if (isOwner && state.pendingRequests.isNotEmpty) ...[
          Padding(
            padding: const .fromLTRB(
              NinjaMetrics.screenPadding,
              28,
              NinjaMetrics.screenPadding,
              10,
            ),
            child: NinjaStudyGroupSectionHeader(
              l10n.studyGroupRequestsSection(state.pendingRequests.length),
            ),
          ),
          Padding(
            padding: const .symmetric(
              horizontal: NinjaMetrics.screenPadding,
            ),
            child: Column(
              children: [
                for (final request in state.pendingRequests)
                  NinjaStudyGroupRequestCard(
                    request: request,
                    pending: state.pendingRequestIds.contains(request.id),
                    onAccept: () => onAcceptRequest(request),
                    onDecline: () => onDeclineRequest(request),
                  ),
              ],
            ),
          ),
        ],
        Padding(
          padding: const .fromLTRB(
            NinjaMetrics.screenPadding,
            28,
            NinjaMetrics.screenPadding,
            10,
          ),
          child: NinjaStudyGroupSectionHeader(l10n.studyGroupMembersSection),
        ),
        Padding(
          padding: const .symmetric(horizontal: NinjaMetrics.screenPadding),
          child: Column(
            children: [
              for (final (index, member) in state.members.indexed)
                Padding(
                  padding: const .only(bottom: 10),
                  child: NinjaStudyGroupMemberRow(
                    member: member,
                    canRemove: isOwner && !member.isMe && !member.isOwner,
                    pending: state.pendingMemberIds.contains(member.userId),
                    onRemove: () => onRemoveMember(member),
                  ).animateListItem(index: index),
                ),
            ],
          ),
        ),
        Padding(
          padding: const .fromLTRB(
            NinjaMetrics.screenPadding,
            28,
            NinjaMetrics.screenPadding,
            0,
          ),
          child: NinjaButton.destructiveOutline(
            label: isOwner ? l10n.studyGroupDelete : l10n.studyGroupLeave,
            expanded: true,
            size: .large,
            onPressed: state.isBusy ? null : onLeaveOrDelete,
          ),
        ),
      ],
    );
  }
}
