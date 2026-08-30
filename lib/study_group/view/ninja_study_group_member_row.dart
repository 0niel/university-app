part of 'study_group_page.dart';

class NinjaStudyGroupMemberRow extends StatelessWidget {
  const NinjaStudyGroupMemberRow({
    required this.member,
    required this.canRemove,
    required this.onRemove,
    this.pending = false,
    super.key,
  });
  final StudyGroupMember member;
  final bool canRemove;
  final VoidCallback onRemove;
  final bool pending;
  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;
    final handle = member.handle;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: .circular(NinjaRadius.card),
      ),
      child: Padding(
        padding: const .all(16),
        child: Row(
          spacing: 14,
          children: [
            NinjaAvatar(initials: ninjaInitials(member.fullName)),
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    member.fullName,
                    maxLines: 1,
                    overflow: .ellipsis,
                    style: NinjaText.headline.copyWith(color: colors.ink),
                  ),
                  if (handle != null) ...[
                    const SizedBox(height: 3),
                    Text(
                      '@$handle',
                      maxLines: 1,
                      overflow: .ellipsis,
                      style: NinjaText.subtext.copyWith(color: colors.muted),
                    ),
                  ],
                ],
              ),
            ),
            if (member.isOwner)
              NinjaBadge(l10n.studyGroupOwnerTag)
            else if (member.isMe)
              NinjaBadge(l10n.studyGroupYouTag, tone: .ink)
            else if (canRemove)
              AnimatedOpacity(
                opacity: pending ? 0.5 : 1,
                duration: NinjaMotion.of(context, NinjaMotion.fast),
                child: NinjaIconButton(
                  icon: AppLineIconWidget(
                    .close,
                    size: 18,
                    color: colors.scarlet,
                  ),
                  tooltip: l10n.studyGroupRemove,
                  onPressed: pending ? null : onRemove,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
