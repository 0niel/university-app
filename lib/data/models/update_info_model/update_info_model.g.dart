// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UpdateInfoModelImpl _$$UpdateInfoModelImplFromJson(Map<String, dynamic> json) => _$UpdateInfoModelImpl(
      title: json['title'] as String,
      description: json['description'] as String?,
      text: json['text'] as String,
      appVersion: json['appVersion'] as String,
      buildNumber: json['buildNumber'] as int,
    );

Map<String, dynamic> _$$UpdateInfoModelImplToJson(_$UpdateInfoModelImpl instance) => <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'text': instance.text,
      'appVersion': instance.appVersion,
      'buildNumber': instance.buildNumber,
    };
