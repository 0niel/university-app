import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/community/cubit/team_finder/team_finder.dart';
import 'package:rtu_mirea_app/community/view/team_finder_labels.dart';
import 'package:rtu_mirea_app/community/widgets/ninja_filter_bar.dart';
import 'package:rtu_mirea_app/community/widgets/team_finder/team_card.dart';
import 'package:rtu_mirea_app/community/widgets/team_finder/team_list_skeleton.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class TeamFinderBody extends StatelessWidget {
  const TeamFinderBody({
    required this.onApply,
    required this.onWithdraw,
    required this.onLeave,
    required this.onApplications,
    required this.onDelete,
    super.key,
    this.onCreate,
  });

  final VoidCallback? onCreate;
  final ValueChanged<Team> onApply;
  final ValueChanged<Team> onWithdraw;
  final ValueChanged<Team> onLeave;
  final ValueChanged<Team> onApplications;
  final ValueChanged<Team> onDelete;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<TeamFinderCubit>().state;
    return Column(
      children: [
        Padding(
          padding: const .symmetric(vertical: 10),
          child: NinjaFilterBar(
            value: state.filterKey,
            onChanged: context.read<TeamFinderCubit>().filterChanged,
            items: [
              ('all', context.l10n.teamFinderFilterAll),
              for (final kind in UniversityConfig.current.teamKindKeys)
                (kind, teamKindLabel(context.l10n, kind)),
              ('mine', context.l10n.teamFinderFilterMine),
            ],
          ),
        ),
        Expanded(
          child: NinjaStateSwitcher(child: _content(context, state)),
        ),
      ],
    );
  }

  Widget _content(BuildContext context, TeamFinderState state) {
    if (state.status == .loading && state.teams.isEmpty) {
      return const TeamListSkeleton(key: ValueKey('teams-loading'));
    }
    return RefreshIndicator(
      key: ValueKey('teams-${_variantKey(state)}'),
      color: context.ninja.ink,
      onRefresh: context.read<TeamFinderCubit>().load,
      child: _list(context, state),
    );
  }

  String _variantKey(TeamFinderState state) {
    if (state.status == .failure && state.teams.isEmpty) return 'failure';
    if (state.visibleTeams.isEmpty) return 'empty-${state.filterKey}';
    return 'list-${state.filterKey}';
  }

  Widget _list(BuildContext context, TeamFinderState state) {
    if (state.status == .failure && state.teams.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          Padding(
            padding: const .fromLTRB(
              NinjaMetrics.screenPadding,
              40,
              NinjaMetrics.screenPadding,
              0,
            ),
            child: NinjaErrorState(
              title: context.l10n.teamFinderLoadError,
              message: context.l10n.teamFinderLoadErrorSubtitle,
              retryLabel: context.l10n.retry,
              onRetry: () => unawaited(context.read<TeamFinderCubit>().load()),
            ),
          ),
        ],
      );
    }
    final teams = state.visibleTeams;
    if (teams.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          Padding(
            padding: const .fromLTRB(
              NinjaMetrics.screenPadding,
              64,
              NinjaMetrics.screenPadding,
              0,
            ),
            child: NinjaEmptyState.screen(
              icon: const AppLineIconWidget(AppLineIcon.people, size: 24),
              title: context.l10n.teamFinderEmptyTitle,
              message: context.l10n.teamFinderEmptySubtitle,
              actionLabel: context.l10n.teamFinderCreateCta,
              onAction: onCreate,
            ).animateEmptyState(),
          ),
        ],
      );
    }
    final now = DateTime.now();
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const .fromLTRB(0, 8, 0, 100),
      itemCount: teams.length,
      itemBuilder: (context, index) {
        final team = teams[index];
        final busy =
            state.pendingApplyIds.contains(team.id) ||
            state.pendingDeleteIds.contains(team.id) ||
            state.pendingLeaveIds.contains(team.id);
        return TeamCard(
          team: team,
          now: now,
          isBusy: busy,
          onApply: () => onApply(team),
          onWithdraw: () => onWithdraw(team),
          onLeave: () => onLeave(team),
          onApplications: () => onApplications(team),
          onDelete: () => onDelete(team),
        ).animateListItem(key: ValueKey(team.id), index: index);
      },
    );
  }
}
