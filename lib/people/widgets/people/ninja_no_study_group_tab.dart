part of '../people_widgets.dart';

class NinjaNoStudyGroupTab extends StatelessWidget {
  const NinjaNoStudyGroupTab({
    required this.invites,
    required this.pendingInviteIds,
    required this.onCreate,
    required this.onJoinByCode,
    required this.onDiscover,
    required this.onRespondInvite,
    super.key,
  });

  final List<StudyGroupInvite> invites;
  final Set<String> pendingInviteIds;
  final Future<void> Function() onCreate;
  final Future<void> Function() onJoinByCode;
  final Future<void> Function() onDiscover;
  final Future<void> Function(String inviteId, {required bool accept})
  onRespondInvite;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    const inset = EdgeInsets.symmetric(
      horizontal: AppSpacing.screen,
    );
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const .only(top: 20, bottom: 96),
      children: [
        Padding(
          padding: inset,
          child: NinjaEmptyState(
            title: l10n.studyGroupNoGroupTitle,
            message: l10n.studyGroupNoGroupSubtitle,
            icon: AppLineIconWidget(
              AppLineIcon.people,
              color: context.colors.muted,
            ),
            actionLabel: l10n.studyGroupCreateCta,
            onAction: () => unawaited(onCreate()),
          ).animateEmptyState(),
        ),
        const SizedBox(height: 12),
        NinjaChipRow(
          children: [
            NinjaChip(
              label: l10n.studyGroupJoinByCodeCta,
              onTap: () => unawaited(onJoinByCode()),
            ),
            NinjaChip(
              label: l10n.studyGroupDiscoverCta,
              onTap: () => unawaited(onDiscover()),
            ),
          ],
        ),
        if (invites.isNotEmpty) ...[
          NinjaPeopleSectionHeader(l10n.studyGroupInvitesSection),
          for (final invite in invites)
            Padding(
              padding: const .fromLTRB(
                AppSpacing.screen,
                0,
                AppSpacing.screen,
                10,
              ),
              child: StudyGroupInviteCard(
                invite: invite,
                pending: pendingInviteIds.contains(invite.id),
                onJoin: () => unawaited(
                  onRespondInvite(invite.id, accept: true),
                ),
                onDismiss: () => unawaited(
                  onRespondInvite(invite.id, accept: false),
                ),
              ),
            ),
        ],
      ],
    );
  }
}
