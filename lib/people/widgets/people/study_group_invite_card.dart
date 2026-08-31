part of '../people_widgets.dart';

class StudyGroupInviteCard extends StatelessWidget {
  const StudyGroupInviteCard({
    required this.invite,
    required this.pending,
    required this.onJoin,
    required this.onDismiss,
    super.key,
  });

  final StudyGroupInvite invite;
  final bool pending;
  final VoidCallback onJoin;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;
    return Container(
      padding: const .all(14),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: .circular(NinjaRadius.card),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final stackActions = MediaQuery.textScalerOf(context).scale(1) >= 1.5;
          final identity = Row(
            spacing: 12,
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: .center,
                decoration: BoxDecoration(
                  color: colors.surfaceAlt,
                  borderRadius: .circular(14),
                ),
                child: Text(
                  invite.groupEmoji,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      invite.groupName,
                      overflow: .ellipsis,
                      style: NinjaText.body.copyWith(color: colors.ink),
                    ),
                    Text(
                      [
                        if (invite.invitedByName.isNotEmpty)
                          invite.invitedByName,
                        l10n.studyGroupMembersCount(invite.memberCount),
                      ].join(' · '),
                      overflow: .ellipsis,
                      style: NinjaText.helper.copyWith(
                        color: colors.muted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
          final actions = Row(
            spacing: 6,
            mainAxisSize: .min,
            children: [
              NinjaButton.primary(
                label: l10n.studyGroupInviteJoin,
                size: NinjaButtonSize.small,
                onPressed: pending ? null : onJoin,
              ),
              NinjaIconButton(
                icon: const AppLineIconWidget(.close, size: 16),
                tooltip: l10n.studyGroupInviteDismiss,
                onPressed: pending ? null : onDismiss,
              ),
            ],
          );
          if (stackActions || constraints.maxWidth < 300) {
            return Column(
              spacing: 10,
              crossAxisAlignment: .stretch,
              children: [
                identity,
                Align(alignment: .centerRight, child: actions),
              ],
            );
          }
          return Row(
            spacing: 8,
            children: [
              Expanded(child: identity),
              actions,
            ],
          );
        },
      ),
    );
  }
}
