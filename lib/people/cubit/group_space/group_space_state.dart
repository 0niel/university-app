part of 'group_space_cubit.dart';

@freezed
abstract class GroupSpaceState with _$GroupSpaceState {
  const factory GroupSpaceState({
    @Default(GroupSpaceStatus.initial) GroupSpaceStatus status,
    @Default(GroupSpace.empty) GroupSpace space,
    @Default(false) bool isRefreshing,
    @Default(<String>{}) Set<String> pendingLikeIds,
    @Default(<String>{}) Set<String> pendingLinkDeleteIds,
    GroupSpaceMutationFailure? mutationFailure,
  }) = _GroupSpaceState;
}
