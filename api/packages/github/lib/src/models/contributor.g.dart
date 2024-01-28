// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contributor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Contributor _$ContributorFromJson(Map<String, dynamic> json) => Contributor(
      login: json['login'] as String,
      avatarUrl: json['avatar_url'] as String,
      htmlUrl: json['html_url'] as String,
      contributions: json['contributions'] as int,
    );

Map<String, dynamic> _$ContributorToJson(Contributor instance) => <String, dynamic>{
      'login': instance.login,
      'avatar_url': instance.avatarUrl,
      'html_url': instance.htmlUrl,
      'contributions': instance.contributions,
    };
