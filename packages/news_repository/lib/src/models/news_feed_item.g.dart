// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_feed_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NewsFeedItem _$NewsFeedItemFromJson(Map<String, dynamic> json) =>
    _NewsFeedItem(
      id: json['id'] as String,
      title: json['title'] as String,
      publishedAt: DateTime.parse(json['publishedAt'] as String),
      sourceName: json['sourceName'] as String? ?? '',
      sourceType: json['sourceType'] as String? ?? 'social',
      sourceId: json['sourceId'] as String?,
      originalUrl: json['originalUrl'] as String?,
      newsBlocks:
          (json['newsBlocks'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          const <Map<String, dynamic>>[],
      totalCount: (json['totalCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$NewsFeedItemToJson(_NewsFeedItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'publishedAt': instance.publishedAt.toIso8601String(),
      'sourceName': instance.sourceName,
      'sourceType': instance.sourceType,
      'sourceId': instance.sourceId,
      'originalUrl': instance.originalUrl,
      'newsBlocks': instance.newsBlocks,
      'totalCount': instance.totalCount,
    };

_NewsSourceItem _$NewsSourceItemFromJson(Map<String, dynamic> json) =>
    _NewsSourceItem(
      sourceType: json['sourceType'] as String,
      sourceId: json['sourceId'] as String,
      sourceName: json['sourceName'] as String? ?? '',
      sourceUrl: json['sourceUrl'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      subscribers: json['subscribers'] as String?,
    );

Map<String, dynamic> _$NewsSourceItemToJson(_NewsSourceItem instance) =>
    <String, dynamic>{
      'sourceType': instance.sourceType,
      'sourceId': instance.sourceId,
      'sourceName': instance.sourceName,
      'sourceUrl': instance.sourceUrl,
      'avatarUrl': instance.avatarUrl,
      'subscribers': instance.subscribers,
    };
