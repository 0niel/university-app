import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:friends_repository/src/models/group_member.dart';

part 'group_roster.freezed.dart';
part 'group_roster.g.dart';

/// The current user's academic group and its members.
@freezed
abstract class GroupRoster with _$GroupRoster {
  @JsonSerializable(explicitToJson: true)
  const factory GroupRoster({
    String? group,
    @Default(<GroupMember>[]) List<GroupMember> members,
  }) = _GroupRoster;

  factory GroupRoster.fromJson(Map<String, Object?> json) =>
      _$GroupRosterFromJson(json);

  static const empty = GroupRoster();
}
