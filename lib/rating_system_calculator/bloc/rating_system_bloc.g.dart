// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rating_system_bloc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RatingSystemState _$RatingSystemStateFromJson(Map<String, dynamic> json) => RatingSystemState(
      subjects: json['subjects'] == null ? const [] : const SubjectsConverter().fromJson(json['subjects'] as List),
    );

Map<String, dynamic> _$RatingSystemStateToJson(RatingSystemState instance) => <String, dynamic>{
      'subjects': const SubjectsConverter().toJson(instance.subjects),
    };
