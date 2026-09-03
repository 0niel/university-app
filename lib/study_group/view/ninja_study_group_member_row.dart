part of 'study_group_page.dart';

class NinjaStudyGroupMemberRow extends StatelessWidget {
  const NinjaStudyGroupMemberRow({
    required this.member,
    required this.canRemove,
    required this.onRemove,
    required this.onTransfer,
    this.pending = false,
    super.key,
  });
  final StudyGroupMember member;
  final bool canRemove;
  final VoidCallback onRemove;
  final VoidCallback onTransfer;
  final bool pending;

  Future<void> _openTools(BuildContext context) async {
    final l10n = context.l10n;
    final action = await showAppSheet<_MemberToolsAction>(
      context,
      title: member.fullName,
      child: Column(
        mainAxisSize: .min,
        children: [
          AppListRow(
            isFirst: true,
            leading: const AppLineIconWidget(.swap, size: 18),
            title: l10n.studyGroupTransferOwnership,
            onTap: () => Navigator.of(context).pop(_MemberToolsAction.transfer),
          ),
          AppListRow(
            destructive: true,
            leading: AppLineIconWidget(
              .close,
              size: 18,
              color: context.colors.danger,
            ),
            title: l10n.studyGroupRemove,
            onTap: () => Navigator.of(context).pop(_MemberToolsAction.remove),
          ),
        ],
      ),
    );
    switch (action) {
      case _MemberToolsAction.transfer:
        onTransfer();
      case _MemberToolsAction.remove:
        onRemove();
      case null:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final handle = member.handle;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: .circular(AppRadius.card),
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
                    style: AppText.headline.copyWith(color: colors.ink),
                  ),
                  if (handle != null) ...[
                    const SizedBox(height: 3),
                    Text(
                      '@$handle',
                      maxLines: 1,
                      overflow: .ellipsis,
                      style: AppText.subtext.copyWith(color: colors.muted),
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
                    .more,
                    size: 18,
                    color: colors.muted,
                  ),
                  tooltip: l10n.studyGroupMemberTools,
                  onPressed: pending
                      ? null
                      : () => unawaited(_openTools(context)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

enum _MemberToolsAction { transfer, remove }
