part of 'team_finder_cubit.dart';

@freezed
abstract class TeamFinderState with _$TeamFinderState {
  const factory TeamFinderState({
    @Default(TeamFinderStatus.initial) TeamFinderStatus status,
    @Default(<Team>[]) List<Team> teams,
    @Default('all') String filterKey,
    @Default(<String>{}) Set<String> pendingApplyIds,
    @Default(<String>{}) Set<String> pendingDeleteIds,
    @Default(<String>{}) Set<String> pendingLeaveIds,
    @Default(<String>{}) Set<String> pendingUpdateIds,
    @Default(false) bool isCreating,
  }) = _TeamFinderState;

  const TeamFinderState._();

  List<Team> get visibleTeams => switch (filterKey) {
    'all' =>
      teams
          .where((team) => team.status == TeamStatus.open)
          .toList(growable: false),
    'mine' =>
      teams
          .where((team) => team.isMine || team.isMember || team.hasApplied)
          .toList(growable: false),
    _ =>
      teams
          .where(
            (team) => team.status == TeamStatus.open && team.kind == filterKey,
          )
          .toList(growable: false),
  };
}
