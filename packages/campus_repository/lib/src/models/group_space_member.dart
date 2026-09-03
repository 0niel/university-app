import 'package:freezed_annotation/freezed_annotation.dart';

part 'group_space_member.freezed.dart';
part 'group_space_member.g.dart';

@freezed
abstract class GroupSpaceMember with _$GroupSpaceMember {
  const factory GroupSpaceMember({
    @JsonKey(defaultValue: '') required String userId,
    @JsonKey(defaultValue: '') required String fullName,
    String? handle,
    @Default('member') String role,
    @Default(false) bool isOwner,
    @Default(false) bool isMe,
  }) = _GroupSpaceMember;

  factory GroupSpaceMember.fromJson(Map<String, Object?> json) =>
      _$GroupSpaceMemberFromJson(json);
}
