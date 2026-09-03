import 'package:campus_repository/src/json_rows.dart';
import 'package:campus_repository/src/models/group_announcement.dart';
import 'package:campus_repository/src/models/group_birthday.dart';
import 'package:campus_repository/src/models/group_link.dart';
import 'package:campus_repository/src/models/group_note.dart';
import 'package:campus_repository/src/models/group_space_member.dart';
import 'package:campus_repository/src/models/json_converters.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'group_space.freezed.dart';
part 'group_space.g.dart';

@Freezed(toJson: true)
abstract class GroupSpace with _$GroupSpace {
  const factory GroupSpace({
    String? group,
    String? groupId,
    String? joinCode,
    @Default('🎓') String emoji,
    @JsonKey(readValue: _readHasGroup) @Default(false) bool hasGroup,
    @Default(false) bool isOwner,
    @Default(0) int memberCount,
    @Default(false) bool myBirthdaySet,
    @JsonKey(fromJson: stringListFromJson, toJson: stringListToJson)
    @Default(<String>[])
    List<String> memberNames,
    @JsonKey(fromJson: _membersFromJson, toJson: _membersToJson)
    @Default(<GroupSpaceMember>[])
    List<GroupSpaceMember> members,
    @JsonKey(fromJson: _linksFromJson, toJson: _linksToJson)
    @Default(<GroupLink>[])
    List<GroupLink> links,
    @JsonKey(fromJson: _announcementFromJson, toJson: _announcementToJson)
    GroupAnnouncement? announcement,
    @JsonKey(fromJson: _notesFromJson, toJson: _notesToJson)
    @Default(<GroupNote>[])
    List<GroupNote> notes,
    @JsonKey(fromJson: _birthdaysFromJson, toJson: _birthdaysToJson)
    @Default(<GroupBirthday>[])
    List<GroupBirthday> birthdays,
  }) = _GroupSpace;

  const GroupSpace._();

  factory GroupSpace.fromJson(Map<String, Object?> json) =>
      _$GroupSpaceFromJson(_validatedGroupSpaceJson(json));

  static const empty = GroupSpace();

  GroupLink? get telegram => links.where((link) => link.isTelegram).firstOrNull;

  List<GroupLink> get plainLinks =>
      links.where((link) => !link.isTelegram).toList();
}

Object _readHasGroup(Map<dynamic, dynamic> json, String key) {
  final value = json[key] as Object?;
  return value ?? (json['group'] != null);
}

void _validateNestedRows(
  Map<String, Object?> json,
  String key, {
  required String context,
}) {
  if (json.containsKey(key)) {
    decodeJsonRows(json[key], context: context);
  }
}

Map<String, Object?> _validatedGroupSpaceJson(Map<String, Object?> json) {
  _validateNestedRows(json, 'links', context: 'GroupSpace links');
  _validateNestedRows(json, 'notes', context: 'GroupSpace notes');
  _validateNestedRows(json, 'birthdays', context: 'GroupSpace birthdays');
  _validateNestedRows(json, 'members', context: 'GroupSpace members');
  if (json.containsKey('announcement')) {
    final announcement = json['announcement'];
    if (announcement != null && announcement is! Map<Object?, Object?>) {
      throw const FormatException(
        'GroupSpace announcement must be a JSON object or null',
      );
    }
  }
  return json;
}

List<GroupSpaceMember> _membersFromJson(Object? value) => value is List<Object?>
    ? decodeJsonRows(
        value,
        context: 'GroupSpace members',
      ).map(GroupSpaceMember.fromJson).toList()
    : const [];

List<Map<String, Object?>> _membersToJson(List<GroupSpaceMember> value) =>
    value.map((member) => member.toJson()).toList();

List<GroupLink> _linksFromJson(Object? value) => value is List<Object?>
    ? decodeJsonRows(
        value,
        context: 'GroupSpace links',
      ).map(GroupLink.fromJson).toList()
    : const [];

List<Map<String, Object?>> _linksToJson(List<GroupLink> value) =>
    value.map((link) => link.toJson()).toList();

GroupAnnouncement? _announcementFromJson(Object? value) =>
    value is Map<Object?, Object?> ? .fromJson(value.cast()) : null;

Map<String, Object?>? _announcementToJson(GroupAnnouncement? value) =>
    value?.toJson();

List<GroupNote> _notesFromJson(Object? value) => value is List<Object?>
    ? decodeJsonRows(
        value,
        context: 'GroupSpace notes',
      ).map(GroupNote.fromJson).toList()
    : const [];

List<Map<String, Object?>> _notesToJson(List<GroupNote> value) =>
    value.map((note) => note.toJson()).toList();

List<GroupBirthday> _birthdaysFromJson(Object? value) => value is List<Object?>
    ? decodeJsonRows(
        value,
        context: 'GroupSpace birthdays',
      ).map(GroupBirthday.fromJson).toList()
    : const [];

List<Map<String, Object?>> _birthdaysToJson(List<GroupBirthday> value) =>
    value.map((birthday) => birthday.toJson()).toList();
