import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/community/cubit/team_finder/team_finder.dart';
import 'package:rtu_mirea_app/community/view/team_finder_labels.dart';
import 'package:rtu_mirea_app/community/widgets/team_finder/team_card.dart';
import 'package:rtu_mirea_app/community/widgets/team_finder/team_list_skeleton.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class TeamFinderBody extends StatefulWidget {
  const TeamFinderBody({
    required this.onApply,
    required this.onWithdraw,
    required this.onLeave,
    required this.onApplications,
    required this.onDelete,
    required this.onEdit,
    required this.onCloseToggle,
    super.key,
    this.onCreate,
  });

  final VoidCallback? onCreate;
  final ValueChanged<Team> onApply;
  final ValueChanged<Team> onWithdraw;
  final ValueChanged<Team> onLeave;
  final ValueChanged<Team> onApplications;
  final ValueChanged<Team> onDelete;
  final ValueChanged<Team> onEdit;
  final ValueChanged<Team> onCloseToggle;

  @override
  State<TeamFinderBody> createState() => _TeamFinderBodyState();
}

class _TeamFinderBodyState extends State<TeamFinderBody> {
  final _search = TextEditingController();
  final Set<String> _roleFilter = {};
  var _query = '';

  @override
  void initState() {
    super.initState();
    _search.addListener(_onQueryChanged);
  }

  @override
  void dispose() {
    _search
      ..removeListener(_onQueryChanged)
      ..dispose();
    super.dispose();
  }

  void _onQueryChanged() {
    final query = _search.text.trim().toLowerCase();
    if (query != _query) setState(() => _query = query);
  }

  List<Team> _refine(List<Team> teams) {
    var result = teams;
    if (_roleFilter.isNotEmpty) {
      result = result
          .where((team) => team.neededRoles.any(_roleFilter.contains))
          .toList(growable: false);
    }
    if (_query.isNotEmpty) {
      result = result
          .where(
            (team) =>
                '${team.title} ${team.description} '
                        '${team.neededRoles.join(' ')}'
                    .toLowerCase()
                    .contains(_query),
          )
          .toList(growable: false);
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<TeamFinderCubit>().state;
    final config = UniversityConfig.current;
    final l10n = context.l10n;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screen,
            AppSpacing.sm,
            AppSpacing.screen,
            0,
          ),
          child: AppSearchField(
            controller: _search,
            hintText: l10n.teamFinderSearchHint,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        AppChipRow<String>(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
          value: state.filterKey,
          onChanged: context.read<TeamFinderCubit>().filterChanged,
          items: [
            AppChipRowItem(value: 'all', label: l10n.teamFinderFilterAll),
            for (final kind in config.teamKindKeys)
              AppChipRowItem(
                value: kind,
                label: teamKindFilterLabel(l10n, kind),
              ),
            AppChipRowItem(value: 'mine', label: l10n.teamFinderFilterMine),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
          child: Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final role in config.teamRoleKeys)
                AppChip.filter(
                  label: teamRoleLabel(l10n, role),
                  selected: _roleFilter.contains(role),
                  onTap: () => setState(() {
                    if (!_roleFilter.remove(role)) _roleFilter.add(role);
                  }),
                ),
            ],
          ),
        ),
        Expanded(child: NinjaStateSwitcher(child: _content(context, state))),
      ],
    );
  }

  Widget _content(BuildContext context, TeamFinderState state) {
    if (state.status == .loading && state.teams.isEmpty) {
      return const TeamListSkeleton(key: ValueKey('teams-loading'));
    }
    return RefreshIndicator(
      key: ValueKey('teams-${_variantKey(state)}'),
      color: context.colors.ink,
      onRefresh: context.read<TeamFinderCubit>().load,
      child: _list(context, state),
    );
  }

  String _variantKey(TeamFinderState state) {
    if (state.status == .failure && state.teams.isEmpty) return 'failure';
    final teams = _refine(state.visibleTeams);
    if (teams.isEmpty) {
      return state.visibleTeams.isEmpty
          ? 'empty-${state.filterKey}'
          : 'search-empty-${state.filterKey}-$_query-${_roleFilter.length}';
    }
    return 'list-${state.filterKey}-$_query-${_roleFilter.length}';
  }

  Widget _list(BuildContext context, TeamFinderState state) {
    final l10n = context.l10n;
    if (state.status == .failure && state.teams.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screen,
              40,
              AppSpacing.screen,
              0,
            ),
            child: AppErrorState(
              title: l10n.teamFinderLoadError,
              message: l10n.teamFinderLoadErrorSubtitle,
              primaryLabel: l10n.retry,
              onPrimary: () =>
                  unawaited(context.read<TeamFinderCubit>().load()),
            ),
          ),
        ],
      );
    }
    final base = state.visibleTeams;
    final teams = _refine(base);
    if (teams.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          if (base.isEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screen,
                64,
                AppSpacing.screen,
                0,
              ),
              child: AppEmptyState(
                lineIcon: AppLineIcon.people,
                title: l10n.teamFinderEmptyTitle,
                subtitle: l10n.teamFinderEmptySubtitle,
                actionLabel: l10n.teamFinderCreateCta,
                onAction: widget.onCreate,
              ).animateEmptyState(),
            )
          else
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screen,
                64,
                AppSpacing.screen,
                0,
              ),
              child: AppEmptyState.compact(
                title: l10n.teamFinderSearchEmptyTitle,
                subtitle: l10n.teamFinderSearchEmptySubtitle,
              ),
            ),
        ],
      );
    }
    final now = DateTime.now();
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(
        0,
        8,
        0,
        ninjaBottomInset(context) + AppSpacing.lg,
      ),
      itemCount: teams.length,
      itemBuilder: (context, index) {
        final team = teams[index];
        final busy =
            state.pendingApplyIds.contains(team.id) ||
            state.pendingDeleteIds.contains(team.id) ||
            state.pendingLeaveIds.contains(team.id) ||
            state.pendingUpdateIds.contains(team.id);
        return TeamCard(
          team: team,
          now: now,
          isBusy: busy,
          onApply: () => widget.onApply(team),
          onWithdraw: () => widget.onWithdraw(team),
          onLeave: () => widget.onLeave(team),
          onApplications: () => widget.onApplications(team),
          onDelete: () => widget.onDelete(team),
          onEdit: () => widget.onEdit(team),
          onCloseToggle: () => widget.onCloseToggle(team),
        ).animateListItem(key: ValueKey(team.id), index: index);
      },
    );
  }
}
