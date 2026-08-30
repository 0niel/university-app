part of 'study_group_cubit.dart';

@freezed
abstract class StudyGroupState with _$StudyGroupState {
  const factory StudyGroupState({
    @Default(StudyGroupStatus.initial) StudyGroupStatus status,
    @Default(MyStudyGroup.empty) MyStudyGroup data,
    @Default(<String>{}) Set<String> pendingRequestIds,
    @Default(<String>{}) Set<String> pendingMemberIds,
  }) = _StudyGroupState;

  const StudyGroupState._();

  bool get isOwner => data.isOwner;

  StudyGroup? get group => data.group;

  List<StudyGroupMember> get members => data.members;

  List<StudyGroupJoinRequest> get pendingRequests => data.pendingRequests;

  bool get isBusy => status == .initial || status == .loading;
}
