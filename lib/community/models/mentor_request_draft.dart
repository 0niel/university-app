import 'package:campus_repository/campus_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'mentor_request_draft.freezed.dart';

@freezed
abstract class MentorRequestDraft with _$MentorRequestDraft {
  const factory MentorRequestDraft({
    required String mentorUserId,
    @Default('') String topic,
    @Default(MentorWhenSlot.week) MentorWhenSlot whenSlot,
    @Default('') String message,
  }) = _MentorRequestDraft;
}
