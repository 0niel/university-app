part of 'mentorship_cubit.dart';

@freezed
abstract class MentorshipState with _$MentorshipState {
  const factory MentorshipState({
    @Default(MentorshipStatus.initial) MentorshipStatus status,
    @Default(MentorRequestsStatus.notNeeded)
    MentorRequestsStatus requestsStatus,
    @Default(<Mentor>[]) List<Mentor> mentors,
    @Default(<MentorRequest>[]) List<MentorRequest> requests,
    @Default(<String>{}) Set<String> pendingMentorIds,
    @Default(<String>{}) Set<String> pendingRequestIds,
    @Default(false) bool isSavingProfile,
  }) = _MentorshipState;

  const MentorshipState._();

  Mentor? get myProfile => mentors.firstWhereOrNull((mentor) => mentor.isMe);

  bool get isMentor => myProfile != null;
}
