import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:study_groups_repository/src/models/study_group.dart';
import 'package:study_groups_repository/src/models/study_group_invite.dart';
import 'package:study_groups_repository/src/models/study_group_join_request.dart';
import 'package:study_groups_repository/src/models/study_group_member.dart';

part 'my_study_group.freezed.dart';
part 'my_study_group.g.dart';

@freezed
abstract class MyStudyGroup with _$MyStudyGroup {
  const factory MyStudyGroup({
    @Default(false) bool hasGroup,
    @Default(false) bool isOwner,
    @JsonKey(fromJson: _groupFromJson, toJson: _groupToJson) StudyGroup? group,
    @JsonKey(fromJson: _membersFromJson, toJson: _membersToJson)
    @Default(<StudyGroupMember>[])
    List<StudyGroupMember> members,
    @JsonKey(fromJson: _invitesFromJson, toJson: _invitesToJson)
    @Default(<StudyGroupInvite>[])
    List<StudyGroupInvite> incomingInvites,
    @JsonKey(fromJson: _requestsFromJson, toJson: _requestsToJson)
    @Default(<StudyGroupJoinRequest>[])
    List<StudyGroupJoinRequest> pendingRequests,
  }) = _MyStudyGroup;

  const MyStudyGroup._();

  factory MyStudyGroup.fromJson(Map<String, Object?> json) =>
      _$MyStudyGroupFromJson(json);

  static const empty = MyStudyGroup();
}

StudyGroup? _groupFromJson(Object? value) => switch (value) {
  null => null,
  final Map<Object?, Object?> map => .fromJson(map.cast()),
  _ => throw const FormatException('group must be a JSON object or null'),
};

Map<String, Object?>? _groupToJson(StudyGroup? value) => value?.toJson();

List<T> _listFromJson<T>(
  Object? value,
  T Function(Map<String, Object?>) fromJson,
) => switch (value) {
  final List<Object?> rows => rows.map((row) {
    if (row is! Map<Object?, Object?>) {
      throw const FormatException('list entry must be a JSON object');
    }
    return fromJson(row.cast());
  }).toList(),
  _ => throw const FormatException('value must be a JSON array'),
};

List<StudyGroupMember> _membersFromJson(Object? value) =>
    _listFromJson(value, StudyGroupMember.fromJson);

List<Map<String, Object?>> _membersToJson(List<StudyGroupMember> value) =>
    value.map((member) => member.toJson()).toList();

List<StudyGroupInvite> _invitesFromJson(Object? value) =>
    _listFromJson(value, StudyGroupInvite.fromJson);

List<Map<String, Object?>> _invitesToJson(List<StudyGroupInvite> value) =>
    value.map((invite) => invite.toJson()).toList();

List<StudyGroupJoinRequest> _requestsFromJson(Object? value) =>
    _listFromJson(value, StudyGroupJoinRequest.fromJson);

List<Map<String, Object?>> _requestsToJson(
  List<StudyGroupJoinRequest> value,
) => value.map((request) => request.toJson()).toList();
