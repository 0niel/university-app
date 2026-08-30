import 'package:freezed_annotation/freezed_annotation.dart';

part 'study_group_invite.freezed.dart';
part 'study_group_invite.g.dart';

@freezed
abstract class StudyGroupInvite with _$StudyGroupInvite {
  const factory StudyGroupInvite({
    required String id,
    required String groupId,
    required String groupName,
    @Default('🎓') String groupEmoji,
    @Default(0) int memberCount,
    @Default('') String invitedByName,
  }) = _StudyGroupInvite;

  factory StudyGroupInvite.fromJson(Map<String, Object?> json) =>
      _$StudyGroupInviteFromJson(json);
}
