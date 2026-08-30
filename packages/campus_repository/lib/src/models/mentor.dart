import 'package:campus_repository/src/models/json_converters.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'mentor.freezed.dart';
part 'mentor.g.dart';

@freezed
abstract class Mentor with _$Mentor {
  const factory Mentor({
    required String userId,
    required String fullName,
    @JsonKey(fromJson: stringListFromJson, toJson: stringListToJson)
    @Default(<String>[])
    List<String> topics,
    @Default('') String bio,
    @Default(0) int sessions,
    @Default('') String level,
    @JsonKey(fromJson: stringListFromJson, toJson: stringListToJson)
    @Default(<String>[])
    List<String> formats,
    @Default(0) int price,
    @Default(false) bool isMe,
    int? course,
    String? group,
    String? handle,
  }) = _Mentor;

  factory Mentor.fromJson(Map<String, Object?> json) => _$MentorFromJson(json);
}

enum MentorWhenSlot {
  @JsonValue('tonight')
  tonight('tonight'),
  @JsonValue('tomorrow')
  tomorrow('tomorrow'),
  @JsonValue('week')
  week('week');

  const MentorWhenSlot(this.wireValue);

  final String wireValue;
}

enum MentorRequestStatus {
  pending,
  accepted,
  declined,
  cancelled,
  @JsonValue('completion_pending')
  completionPending,
  completed,
}

enum MentorRequestAction {
  accept('accept'),
  decline('decline'),
  cancel('cancel'),
  confirmComplete('confirm_complete');

  const MentorRequestAction(this.wireValue);

  final String wireValue;
}

@freezed
abstract class MentorRequest with _$MentorRequest {
  const factory MentorRequest({
    required String id,
    required String mentorUserId,
    required String requesterId,
    @Default('') String topic,
    @Default(MentorWhenSlot.week) MentorWhenSlot whenSlot,
    @Default('') String message,
    @Default(0) int price,
    @Default('') String requesterName,
    @Default('') String mentorName,
    String? requesterHandle,
    String? mentorHandle,
    @Default(true) bool isIncoming,
    @Default(MentorRequestStatus.pending) MentorRequestStatus status,
    @Default(false) bool mentorConfirmed,
    @Default(false) bool requesterConfirmed,
    @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
    DateTime? createdAt,
  }) = _MentorRequest;

  const MentorRequest._();

  factory MentorRequest.fromJson(Map<String, Object?> json) =>
      _$MentorRequestFromJson(json);

  String get counterpartName => isIncoming ? requesterName : mentorName;

  String? get counterpartHandle => isIncoming ? requesterHandle : mentorHandle;

  bool get hasConfirmed => isIncoming ? mentorConfirmed : requesterConfirmed;
}
