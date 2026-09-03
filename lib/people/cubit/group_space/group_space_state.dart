part of 'group_space_cubit.dart';

@freezed
abstract class GroupSpaceState with _$GroupSpaceState {
  const factory GroupSpaceState({
    @Default(GroupSpaceStatus.initial) GroupSpaceStatus status,
    @Default(GroupSpace.empty) GroupSpace space,
    @Default(false) bool isRefreshing,
    @Default(<String>{}) Set<String> pendingLikeIds,
    @Default(<String>{}) Set<String> pendingLinkDeleteIds,
    @Default(<CollabNote>[]) List<CollabNote> notesPreview,
    @Default(<String, List<GroupPostComment>>{})
    Map<String, List<GroupPostComment>> comments,
    @Default(<String>{}) Set<String> loadingCommentPostIds,
    @Default(false) bool isSubmittingComment,
    @Default(<String>{}) Set<String> pendingCommentDeleteIds,
    @Default(1) int onlineCount,
    GroupSpaceMutationFailure? mutationFailure,
  }) = _GroupSpaceState;
}
