import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:friends_repository/friends_repository.dart';
import 'package:rtu_mirea_app/people/cubit/people_status.dart';
import 'package:study_groups_repository/study_groups_repository.dart';

part 'people_state.freezed.dart';

@freezed
abstract class PeopleState with _$PeopleState {
  const factory PeopleState({
    @Default(PeopleStatus.initial) PeopleStatus status,
    @Default(PeopleTab.friends) PeopleTab tab,
    @Default(<Friend>[]) List<Friend> friends,
    @Default(<FriendRequest>[]) List<FriendRequest> requests,
    @Default(MyStudyGroup.empty) MyStudyGroup studyGroup,
    @Default(<PeopleSource>{}) Set<PeopleSource> failedSources,
    @Default(<String>{}) Set<String> pendingFriendIds,
    @Default(<String>{}) Set<String> pendingResponseIds,
    @Default(<String>{}) Set<String> pendingInviteIds,
    @Default(false) bool isJoiningGroup,
  }) = _PeopleState;

  const PeopleState._();

  bool get hasCachedData =>
      friends.isNotEmpty || requests.isNotEmpty || studyGroup != .empty;

  bool get isMutating =>
      pendingFriendIds.isNotEmpty ||
      pendingResponseIds.isNotEmpty ||
      pendingInviteIds.isNotEmpty ||
      isJoiningGroup;
}
