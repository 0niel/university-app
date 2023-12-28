// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sponsor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Sponsor _$SponsorFromJson(Map<String, dynamic> json) => Sponsor(
      username: json['username'] as String,
      email: json['email'] as String,
      about: json['about'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      url: json['url'] as String?,
    );

Map<String, dynamic> _$SponsorToJson(Sponsor instance) => <String, dynamic>{
      'username': instance.username,
      'avatarUrl': instance.avatarUrl,
      'about': instance.about,
      'url': instance.url,
      'email': instance.email,
    };
