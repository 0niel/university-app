// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Account _$AccountFromJson(Map<String, dynamic> json) => Account(
      serverURL: Uri.parse(json['serverURL'] as String),
      username: json['username'] as String,
      password: json['password'] as String?,
      userAgent: json['userAgent'] as String?,
    );

Map<String, dynamic> _$AccountToJson(Account instance) => <String, dynamic>{
      'serverURL': instance.serverURL.toString(),
      'username': instance.username,
      'password': instance.password,
      'userAgent': instance.userAgent,
    };
