// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArticleResponse _$ArticleResponseFromJson(Map<String, dynamic> json) =>
    ArticleResponse(
      title: json['title'] as String,
      content: const NewsBlocksConverter().fromJson(json['content'] as List),
      url: Uri.parse(json['url'] as String),
    );

Map<String, dynamic> _$ArticleResponseToJson(ArticleResponse instance) =>
    <String, dynamic>{
      'title': instance.title,
      'content': const NewsBlocksConverter().toJson(instance.content),
      'url': instance.url.toString(),
    };
