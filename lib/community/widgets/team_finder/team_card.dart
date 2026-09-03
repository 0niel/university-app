import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/community/view/team_finder_labels.dart';
import 'package:rtu_mirea_app/community/widgets/team_avatar_stack.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class TeamCard extends StatelessWidget {
  const TeamCard({
    required this.team,
    required this.now,
    required this.onApply,
    required this.onWithdraw,
    required this.onLeave,
    required this.onApplications,
    required this.onDelete,
    required this.onEdit,
    required this.onCloseToggle,
    super.key,
    this.isBusy = false,
  });

  final Team team;
  final DateTime now;
  final VoidCallback onApply;
  final VoidCallback onWithdraw;
  final VoidCallback onLeave;
  final VoidCallback onApplications;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final VoidCallback onCloseToggle;
  final bool isBusy;

  bool get _isExpired => team.deadlineAt?.isBefore(now) ?? false;
  bool get _isClosed => team.status == TeamStatus.closed;

  bool get _isUrgent {
    final deadline = team.deadlineAt;
    if (deadline == null || _isExpired) return false;
    return deadline.difference(now) < const Duration(days: 3);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return AppCard(
      margin: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        0,
        AppSpacing.screen,
        10,
      ),
      child: Column(
        spacing: 9,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _metadata(context),
          Text(team.title, style: AppText.title.copyWith(color: colors.ink)),
          if (team.description.isNotEmpty)
            Text(
              team.description,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: AppText.subtext.copyWith(color: colors.muted, height: 1.4),
            ),
          if (team.neededRoles.isNotEmpty)
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final role in team.neededRoles)
                  AppHashTag(label: teamRoleLabel(context.l10n, role)),
              ],
            ),
          Row(
            children: [
              TeamAvatarStack(
                names: team.memberNames,
                emptySlots: (team.capacity - team.memberCount).clamp(0, 4),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  context.l10n.teamFinderMembersOf(
                    team.memberCount,
                    team.capacity,
                  ),
                  style: AppText.captionSmall.copyWith(color: colors.muted),
                ),
              ),
            ],
          ),
          ..._actions(context),
        ],
      ),
    );
  }

  Widget _metadata(BuildContext context) {
    final l10n = context.l10n;
    final deadline = team.deadlineAt;
    return Wrap(
      spacing: 8,
      runSpacing: 6,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        AppTag(label: teamKindLabel(l10n, team.kind)),
        if (_isClosed) AppBadge(label: l10n.teamFinderClosedStatus),
        if (team.isBoosted)
          AppBadge(
            label: l10n.teamFinderTagTop,
            tone: AppBadgeTone.ink,
            icon: AppLineIcon.star,
          ),
        if (deadline != null)
          Text(
            _isExpired
                ? l10n.teamFinderExpired
                : l10n.teamFinderDeadlineUntil(
                    formatTeamDate(context, deadline),
                  ),
            style: AppText.captionSmall.copyWith(
              color: _isUrgent ? context.colors.danger : context.colors.muted,
            ),
          ),
        Text(
          teamRelativeTime(l10n, team.createdAt),
          style: AppText.captionSmall.copyWith(color: context.colors.muted),
        ),
      ],
    );
  }

  List<Widget> _actions(BuildContext context) {
    final l10n = context.l10n;
    if (team.isMine) {
      return [
        if (team.applicationsCount == 0)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: SizedBox(
              width: double.infinity,
              child: Text(
                l10n.teamFinderNoApplications,
                textAlign: TextAlign.center,
                style: AppText.subtext.copyWith(color: context.colors.muted),
              ),
            ),
          )
        else
          AppButton.secondary(
            label: l10n.teamFinderApplicationsCount(team.applicationsCount),
            expanded: true,
            onPressed: isBusy ? null : onApplications,
          ),
        Row(
          spacing: 8,
          children: [
            Expanded(
              child: AppButton.secondary(
                label: l10n.teamFinderEditTeam,
                icon: const AppLineIconWidget(AppLineIcon.pencil),
                onPressed: isBusy ? null : onEdit,
              ),
            ),
            Expanded(
              child: AppButton.secondary(
                label: _isClosed
                    ? l10n.teamFinderReopenTeam
                    : l10n.teamFinderCloseTeam,
                icon: AppLineIconWidget(
                  _isClosed ? AppLineIcon.refresh : AppLineIcon.lock,
                ),
                onPressed: isBusy ? null : onCloseToggle,
              ),
            ),
          ],
        ),
        AppButton.destructiveOutline(
          label: l10n.teamFinderDeleteTeam,
          icon: const AppLineIconWidget(AppLineIcon.trash),
          expanded: true,
          onPressed: isBusy ? null : onDelete,
        ),
      ];
    }
    if (team.isMember) {
      return [
        AppButton.destructiveOutline(
          label: l10n.teamFinderLeaveTeam,
          expanded: true,
          onPressed: isBusy ? null : onLeave,
        ),
      ];
    }
    if (team.hasApplied) {
      return [
        AppButton.destructiveOutline(
          label: l10n.teamFinderWithdrawApplication,
          expanded: true,
          onPressed: isBusy ? null : onWithdraw,
        ),
      ];
    }
    return [
      AppButton.primary(
        label: _isExpired
            ? l10n.teamFinderExpired
            : team.isFull
            ? l10n.teamFinderFull
            : l10n.teamFinderApply,
        expanded: true,
        onPressed: isBusy || team.isFull || _isExpired ? null : onApply,
      ),
    ];
  }
}
