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
    @Default(false) bool isCreating,
  }) = _TeamFinderState;

  const TeamFinderState._();

  List<Team> get visibleTeams => switch (filterKey) {
    'all' => teams,
    'mine' =>
      teams
          .where((team) => team.isMine || team.isMember || team.hasApplied)
          .toList(growable: false),
    _ => teams.where((team) => team.kind == filterKey).toList(growable: false),
  };
}
