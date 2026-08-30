// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_note_save_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GroupNoteSaveResult _$GroupNoteSaveResultFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_GroupNoteSaveResult', json, ($checkedConvert) {
      final val = _GroupNoteSaveResult(
        revision: $checkedConvert('revision', (v) => (v as num).toInt()),
        updatedAt: $checkedConvert(
          'updatedAt',
          (v) => requiredDateTimeFromJson(v),
        ),
      );
      return val;
    });

Map<String, dynamic> _$GroupNoteSaveResultToJson(
  _GroupNoteSaveResult instance,
) => <String, dynamic>{
  'revision': instance.revision,
  'updatedAt': requiredDateTimeToJson(instance.updatedAt),
};
