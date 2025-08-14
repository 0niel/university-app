// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: cast_nullable_to_non_nullable, implicit_dynamic_parameter, lines_longer_than_80_chars, prefer_const_constructors, require_trailing_commas

part of 'article_introduction_block.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArticleIntroductionBlock _$ArticleIntroductionBlockFromJson(Map<String, dynamic> json) => $checkedCreate(
      'ArticleIntroductionBlock',
      json,
      ($checkedConvert) {
        final val = ArticleIntroductionBlock(
          categoryId: $checkedConvert('category_id', (v) => v as String),
          author: $checkedConvert('author', (v) => v as String),
          publishedAt: $checkedConvert('published_at', (v) => DateTime.parse(v as String)),
          title: $checkedConvert('title', (v) => v as String),
          imageUrl: $checkedConvert('image_url', (v) => v as String?),
          type: $checkedConvert('type', (v) => v as String? ?? ArticleIntroductionBlock.identifier),
        );
        return val;
      },
      fieldKeyMap: const {'categoryId': 'category_id', 'publishedAt': 'published_at', 'imageUrl': 'image_url'},
    );

Map<String, dynamic> _$ArticleIntroductionBlockToJson(ArticleIntroductionBlock instance) => <String, dynamic>{
      'category_id': instance.categoryId,
      'author': instance.author,
      'published_at': instance.publishedAt.toIso8601String(),
      if (instance.imageUrl case final value?) 'image_url': value,
      'title': instance.title,
      'type': instance.type,
    };
