// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mini_app_screen.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MiniAppScreen _$MiniAppScreenFromJson(Map<String, dynamic> json) =>
    _MiniAppScreen(
      id: json['id'] as String?,
      path: json['path'] as String? ?? '/',
      title: json['title'] as String?,
      json: json['json'] as Map<String, dynamic>? ?? const <String, dynamic>{},
    );

Map<String, dynamic> _$MiniAppScreenToJson(_MiniAppScreen instance) =>
    <String, dynamic>{
      'path': instance.path,
      'title': ?instance.title,
      'json': instance.json,
    };
