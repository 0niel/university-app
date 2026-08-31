import 'package:freezed_annotation/freezed_annotation.dart';

part 'study_group_member.freezed.dart';
part 'study_group_member.g.dart';

@freezed
abstract class StudyGroupMember with _$StudyGroupMember {
  const factory StudyGroupMember({
    required String userId,
    required String fullName,
    String? handle,
    @Default('member') String role,
    @Default(false) bool isOwner,
    @Default(false) bool isMe,
    @Default(false) bool isFriend,
    String? friendshipStatus,
  }) = _StudyGroupMember;

  factory StudyGroupMember.fromJson(Map<String, Object?> json) =>
      _$StudyGroupMemberFromJson(json);
}
