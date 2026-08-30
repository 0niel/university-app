// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'squad_challenge.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SquadChallenge _$SquadChallengeFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_SquadChallenge', json, ($checkedConvert) {
      final val = _SquadChallenge(
        id: $checkedConvert('id', (v) => v as String),
        title: $checkedConvert('title', (v) => v as String),
        description: $checkedConvert('description', (v) => v as String),
        rewardShurikens: $checkedConvert(
          'rewardShurikens',
          (v) => (v as num).toInt(),
        ),
        target: $checkedConvert('target', (v) => (v as num).toInt()),
        progress: $checkedConvert('progress', (v) => (v as num).toInt()),
        endsAt: $checkedConvert('endsAt', (v) => DateTime.parse(v as String)),
      );
      return val;
    });

Map<String, dynamic> _$SquadChallengeToJson(_SquadChallenge instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'rewardShurikens': instance.rewardShurikens,
      'target': instance.target,
      'progress': instance.progress,
      'endsAt': instance.endsAt.toIso8601String(),
    };
