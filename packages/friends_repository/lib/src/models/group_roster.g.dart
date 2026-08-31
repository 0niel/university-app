// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_roster.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GroupRoster _$GroupRosterFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_GroupRoster', json, ($checkedConvert) {
      final val = _GroupRoster(
        group: $checkedConvert('group', (v) => v as String?),
        members: $checkedConvert(
          'members',
          (v) =>
              (v as List<dynamic>?)
                  ?.map((e) => GroupMember.fromJson(e as Map<String, dynamic>))
                  .toList() ??
              const <GroupMember>[],
        ),
      );
      return val;
    });

Map<String, dynamic> _$GroupRosterToJson(_GroupRoster instance) =>
    <String, dynamic>{
      'group': instance.group,
      'members': instance.members.map((e) => e.toJson()).toList(),
    };
