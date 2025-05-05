// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'splash_video_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SplashVideoResponse _$SplashVideoResponseFromJson(Map<String, dynamic> json) =>
    SplashVideoResponse(
      videoUrl: json['videoUrl'] as String,
      lastUpdated: json['lastUpdated'] as String,
      endDate: json['endDate'] as String,
      isEnabled: json['isEnabled'] as bool,
    );

Map<String, dynamic> _$SplashVideoResponseToJson(
        SplashVideoResponse instance) =>
    <String, dynamic>{
      'videoUrl': instance.videoUrl,
      'lastUpdated': instance.lastUpdated,
      'endDate': instance.endDate,
      'isEnabled': instance.isEnabled,
    };
