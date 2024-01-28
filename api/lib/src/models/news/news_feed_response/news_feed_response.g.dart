// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_feed_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewsFeedResponse _$NewsFeedResponseFromJson(Map<String, dynamic> json) => NewsFeedResponse(
      news: (json['news'] as List<dynamic>).map((e) => NewsItemResponse.fromJson(e as Map<String, dynamic>)).toList(),
    );

Map<String, dynamic> _$NewsFeedResponseToJson(NewsFeedResponse instance) => <String, dynamic>{
      'news': instance.news,
    };
