// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Article _$ArticleFromJson(Map<String, dynamic> json) => Article(
      title: json['title'] as String,
      htmlContent: json['htmlContent'] as String,
      publishedAt: DateTime.parse(json['publishedAt'] as String),
      imageUrls: (json['imageUrls'] as List<dynamic>).map((e) => e as String).toList(),
      categories: (json['categories'] as List<dynamic>).map((e) => e as String).toList(),
      url: json['url'] as String?,
    );

Map<String, dynamic> _$ArticleToJson(Article instance) => <String, dynamic>{
      'title': instance.title,
      'htmlContent': instance.htmlContent,
      'publishedAt': instance.publishedAt.toIso8601String(),
      'imageUrls': instance.imageUrls,
      'categories': instance.categories,
      'url': instance.url,
    };
