// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scores_bloc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScoresState _$ScoresStateFromJson(Map<String, dynamic> json) => ScoresState(
      scores: (json['scores'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as List<dynamic>).map((e) => Score.fromJson(e as Map<String, dynamic>)).toList()),
      ),
      selectedSemester: json['selectedSemester'] as String?,
      status: $enumDecodeNullable(_$ScoresStatusEnumMap, json['status']) ?? ScoresStatus.initial,
    );

Map<String, dynamic> _$ScoresStateToJson(ScoresState instance) => <String, dynamic>{
      'scores': instance.scores,
      'selectedSemester': instance.selectedSemester,
      'status': _$ScoresStatusEnumMap[instance.status]!,
    };

const _$ScoresStatusEnumMap = {
  ScoresStatus.initial: 'initial',
  ScoresStatus.loading: 'loading',
  ScoresStatus.loaded: 'loaded',
  ScoresStatus.error: 'error',
};
