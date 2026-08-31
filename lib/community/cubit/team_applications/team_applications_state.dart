part of 'team_applications_cubit.dart';

@freezed
abstract class TeamApplicationsState with _$TeamApplicationsState {
  const factory TeamApplicationsState({
    @Default(TeamApplicationsStatus.initial) TeamApplicationsStatus status,
    @Default(<TeamApplication>[]) List<TeamApplication> applications,
    @Default(<String>{}) Set<String> pendingIds,
    @Default(<String>{}) Set<String> pendingRejectIds,
  }) = _TeamApplicationsState;
}
