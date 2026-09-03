// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_space.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GroupSpace _$GroupSpaceFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_GroupSpace', json, ($checkedConvert) {
      final val = _GroupSpace(
        group: $checkedConvert('group', (v) => v as String?),
        groupId: $checkedConvert('groupId', (v) => v as String?),
        joinCode: $checkedConvert('joinCode', (v) => v as String?),
        emoji: $checkedConvert('emoji', (v) => v as String? ?? '🎓'),
        hasGroup: $checkedConvert(
          'hasGroup',
          (v) => v as bool? ?? false,
          readValue: _readHasGroup,
        ),
        isOwner: $checkedConvert('isOwner', (v) => v as bool? ?? false),
        memberCount: $checkedConvert(
          'memberCount',
          (v) => (v as num?)?.toInt() ?? 0,
        ),
        myBirthdaySet: $checkedConvert(
          'myBirthdaySet',
          (v) => v as bool? ?? false,
        ),
        memberNames: $checkedConvert(
          'memberNames',
          (v) => v == null ? const <String>[] : stringListFromJson(v),
        ),
        members: $checkedConvert(
          'members',
          (v) => v == null ? const <GroupSpaceMember>[] : _membersFromJson(v),
        ),
        links: $checkedConvert(
          'links',
          (v) => v == null ? const <GroupLink>[] : _linksFromJson(v),
        ),
        announcement: $checkedConvert(
          'announcement',
          (v) => _announcementFromJson(v),
        ),
        notes: $checkedConvert(
          'notes',
          (v) => v == null ? const <GroupNote>[] : _notesFromJson(v),
        ),
        birthdays: $checkedConvert(
          'birthdays',
          (v) => v == null ? const <GroupBirthday>[] : _birthdaysFromJson(v),
        ),
      );
      return val;
    });

Map<String, dynamic> _$GroupSpaceToJson(_GroupSpace instance) =>
    <String, dynamic>{
      'group': instance.group,
      'groupId': instance.groupId,
      'joinCode': instance.joinCode,
      'emoji': instance.emoji,
      'hasGroup': instance.hasGroup,
      'isOwner': instance.isOwner,
      'memberCount': instance.memberCount,
      'myBirthdaySet': instance.myBirthdaySet,
      'memberNames': stringListToJson(instance.memberNames),
      'members': _membersToJson(instance.members),
      'links': _linksToJson(instance.links),
      'announcement': _announcementToJson(instance.announcement),
      'notes': _notesToJson(instance.notes),
      'birthdays': _birthdaysToJson(instance.birthdays),
    };
