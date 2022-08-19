// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_UpdateInfoModel _$$_UpdateInfoModelFromJson(Map<String, dynamic> json) =>
    _$_UpdateInfoModel(
      title: json['title'] as String,
      description: json['description'] as String?,
      text: json['text'] as String,
      appVersion: json['appVersion'] as String,
      buildNumber: json['buildNumber'] as int,
    );

Map<String, dynamic> _$$_UpdateInfoModelToJson(_$_UpdateInfoModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'text': instance.text,
      'appVersion': instance.appVersion,
      'buildNumber': instance.buildNumber,
    };
