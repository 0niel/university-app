import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/common/utils/ninja_initials.dart';
import 'package:rtu_mirea_app/community/view/team_finder_labels.dart';
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
  final bool isBusy;

  bool get _isExpired => team.deadlineAt?.isBefore(now) ?? false;

  bool get _isBurning {
    final deadline = team.deadlineAt;
    if (deadline == null || _isExpired) return false;
    return deadline.difference(now) < const Duration(hours: 48);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        NinjaMetrics.screenPadding,
        0,
        NinjaMetrics.screenPadding,
        10,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(NinjaRadius.card),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            spacing: 9,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _metadata(context),
              Text(
                team.title,
                style: NinjaText.title.copyWith(color: colors.ink),
              ),
              Text(
                teamKindLabel(context.l10n, team.kind),
                style: NinjaText.helper.copyWith(color: colors.mutedDark),
              ),
              if (team.description.isNotEmpty)
                Text(
                  team.description,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: NinjaText.subtext.copyWith(
                    color: colors.mutedDark,
                    height: 1.4,
                  ),
                ),
              if (team.neededRoles.isNotEmpty)
                Text(
                  team.neededRoles
                      .map(
                        (role) => context.l10n.teamFinderLookingForRole(
                          teamRoleLabel(context.l10n, role),
                        ),
                      )
                      .join(' · '),
                  style: NinjaText.helper.copyWith(
                    color: colors.brandInk,
                    height: 1.35,
                  ),
                ),
              Row(
                children: [
                  NinjaAvatar(
                    initials: ninjaInitials(
                      team.memberNames.firstOrNull ?? team.title,
                    ),
                    size: 34,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      context.l10n.teamFinderMembersOf(
                        team.memberCount,
                        team.capacity,
                      ),
                      style: NinjaText.helper.copyWith(
                        color: colors.mutedDark,
                      ),
                    ),
                  ),
                ],
              ),
              ..._actions(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _metadata(BuildContext context) {
    final deadline = team.deadlineAt;
    return Wrap(
      spacing: 8,
      runSpacing: 6,
      crossAxisAlignment: .center,
      children: [
        if (_isBurning)
          NinjaBadge(
            context.l10n.teamFinderTagBurning,
            tone: .warnTint,
          )
        else if (team.isBoosted)
          NinjaBadge(context.l10n.teamFinderTagTop, tone: .ink),
        if (deadline != null)
          Text(
            _isExpired
                ? context.l10n.teamFinderExpired
                : context.l10n.teamFinderDeadlineUntil(
                    formatTeamDate(context, deadline),
                  ),
            style: NinjaText.helper.copyWith(
              color: _isBurning ? context.ninja.scarlet : context.ninja.muted,
            ),
          ),
        Text(
          teamRelativeTime(context.l10n, team.createdAt),
          style: NinjaText.helper.copyWith(
            color: context.ninja.muted,
          ),
        ),
      ],
    );
  }

  List<Widget> _actions(BuildContext context) {
    if (team.isMine) {
      return [
        if (team.applicationsCount == 0)
          Padding(
            padding: const .symmetric(vertical: 12),
            child: SizedBox(
              width: double.infinity,
              child: Text(
                context.l10n.teamFinderNoApplications,
                textAlign: .center,
                style: NinjaText.subtext.copyWith(
                  color: context.ninja.muted,
                ),
              ),
            ),
          )
        else
          NinjaButton.secondary(
            label: context.l10n.teamFinderApplicationsCount(
              team.applicationsCount,
            ),
            expanded: true,
            onPressed: isBusy ? null : onApplications,
          ),
        NinjaButton.destructive(
          label: context.l10n.teamFinderDeleteTeam,
          expanded: true,
          onPressed: isBusy ? null : onDelete,
        ),
      ];
    }
    if (team.isMember) {
      return [
        NinjaButton.destructive(
          label: context.l10n.teamFinderLeaveTeam,
          expanded: true,
          onPressed: isBusy ? null : onLeave,
        ),
      ];
    }
    if (team.hasApplied) {
      return [
        NinjaButton.destructive(
          label: context.l10n.teamFinderWithdrawApplication,
          expanded: true,
          onPressed: isBusy ? null : onWithdraw,
        ),
      ];
    }
    return [
      NinjaButton.primary(
        label: _isExpired
            ? context.l10n.teamFinderExpired
            : team.isFull
            ? context.l10n.teamFinderFull
            : context.l10n.teamFinderApply,
        expanded: true,
        onPressed: isBusy || team.isFull || _isExpired ? null : onApply,
      ),
    ];
  }
}
