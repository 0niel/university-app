// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_space.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GroupSpace _$GroupSpaceFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_GroupSpace', json, ($checkedConvert) {
      final val = _GroupSpace(
        group: $checkedConvert('group', (v) => v as String?),
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
        memberNames: $checkedConvert(
          'memberNames',
          (v) => v == null ? const <String>[] : stringListFromJson(v),
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
      'emoji': instance.emoji,
      'hasGroup': instance.hasGroup,
      'isOwner': instance.isOwner,
      'memberCount': instance.memberCount,
      'memberNames': stringListToJson(instance.memberNames),
      'links': _linksToJson(instance.links),
      'announcement': _announcementToJson(instance.announcement),
      'notes': _notesToJson(instance.notes),
      'birthdays': _birthdaysToJson(instance.birthdays),
    };
