// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_persona.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AccountPersona _$AccountPersonaFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_AccountPersona', json, ($checkedConvert) {
      final val = _AccountPersona(
        role: $checkedConvert(
          'role',
          (v) =>
              $enumDecodeNullable(_$AccountRoleEnumMap, v) ??
              AccountRole.student,
        ),
        teacherId: $checkedConvert('teacherId', (v) => v as String?),
        teacherName: $checkedConvert('teacherName', (v) => v as String?),
        teacherAvailable: $checkedConvert(
          'teacherAvailable',
          (v) => v as bool? ?? false,
        ),
        revision: $checkedConvert('revision', (v) => (v as num?)?.toInt() ?? 0),
      );
      return val;
    });

Map<String, dynamic> _$AccountPersonaToJson(_AccountPersona instance) =>
    <String, dynamic>{
      'role': _$AccountRoleEnumMap[instance.role]!,
      'teacherId': instance.teacherId,
      'teacherName': instance.teacherName,
      'teacherAvailable': instance.teacherAvailable,
      'revision': instance.revision,
    };

const _$AccountRoleEnumMap = {
  AccountRole.student: 'student',
  AccountRole.teacher: 'teacher',
};
