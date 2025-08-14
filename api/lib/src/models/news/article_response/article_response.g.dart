// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArticleResponse _$ArticleResponseFromJson(Map<String, dynamic> json) => ArticleResponse(
      title: json['title'] as String,
      content: const NewsBlocksConverter().fromJson(json['content'] as List),
      totalCount: (json['totalCount'] as num).toInt(),
      url: Uri.parse(json['url'] as String),
      isPreview: json['isPreview'] as bool,
    );

Map<String, dynamic> _$ArticleResponseToJson(ArticleResponse instance) => <String, dynamic>{
      'title': instance.title,
      'content': const NewsBlocksConverter().toJson(instance.content),
      'totalCount': instance.totalCount,
      'url': instance.url.toString(),
      'isPreview': instance.isPreview,
    };
