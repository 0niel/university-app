import 'package:freezed_annotation/freezed_annotation.dart';

part 'group_member.freezed.dart';
part 'group_member.g.dart';

/// A member of the current user's academic group.
@freezed
abstract class GroupMember with _$GroupMember {
  const factory GroupMember({
    required String userId,
    @JsonKey(defaultValue: 'Студент') required String fullName,
    String? handle,
    @Default(false) bool isMe,
    @Default(false) bool isFriend,
    String? friendshipStatus,
  }) = _GroupMember;

  factory GroupMember.fromJson(Map<String, Object?> json) =>
      _$GroupMemberFromJson(json);
}
