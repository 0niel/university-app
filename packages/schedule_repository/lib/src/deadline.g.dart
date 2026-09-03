// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deadline.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Deadline _$DeadlineFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_Deadline', json, ($checkedConvert) {
      final val = _Deadline(
        id: $checkedConvert(
          'id',
          (v) => const _NonEmptyStringConverter().fromJson(v),
        ),
        title: $checkedConvert(
          'title',
          (v) => const _NonEmptyStringConverter().fromJson(v),
        ),
        dueAt: $checkedConvert(
          'dueAt',
          (v) => const _LocalDateTimeConverter().fromJson(v as String),
        ),
        source: $checkedConvert(
          'source',
          (v) => $enumDecode(
            _$DeadlineSourceEnumMap,
            v,
            unknownValue: DeadlineSource.me,
          ),
        ),
        subjectName: $checkedConvert('subjectName', (v) => v as String? ?? ''),
        progress: $checkedConvert(
          'progress',
          (v) => v == null ? 0 : const _DeadlineProgressConverter().fromJson(v),
        ),
        isDone: $checkedConvert('isDone', (v) => v as bool? ?? false),
        isMine: $checkedConvert('isMine', (v) => v as bool? ?? false),
        priority: $checkedConvert(
          'priority',
          (v) =>
              $enumDecodeNullable(
                _$DeadlinePriorityEnumMap,
                v,
                unknownValue: DeadlinePriority.medium,
              ) ??
              DeadlinePriority.medium,
        ),
        remind: $checkedConvert('remind', (v) => v as bool? ?? true),
        remindMinutes: $checkedConvert(
          'remindMinutes',
          (v) => (v as num?)?.toInt() ?? 60,
        ),
      );
      return val;
    });

Map<String, dynamic> _$DeadlineToJson(_Deadline instance) => <String, dynamic>{
  'id': const _NonEmptyStringConverter().toJson(instance.id),
  'title': const _NonEmptyStringConverter().toJson(instance.title),
  'dueAt': const _LocalDateTimeConverter().toJson(instance.dueAt),
  'source': _$DeadlineSourceEnumMap[instance.source]!,
  'subjectName': instance.subjectName,
  'progress': const _DeadlineProgressConverter().toJson(instance.progress),
  'isDone': instance.isDone,
  'isMine': instance.isMine,
  'priority': _$DeadlinePriorityEnumMap[instance.priority]!,
  'remind': instance.remind,
  'remindMinutes': instance.remindMinutes,
};

const _$DeadlineSourceEnumMap = {
  DeadlineSource.me: 'me',
  DeadlineSource.group: 'group',
  DeadlineSource.prof: 'prof',
};

const _$DeadlinePriorityEnumMap = {
  DeadlinePriority.low: 'low',
  DeadlinePriority.medium: 'medium',
  DeadlinePriority.urgent: 'urgent',
};
