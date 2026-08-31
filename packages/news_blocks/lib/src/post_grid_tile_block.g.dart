// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: cast_nullable_to_non_nullable, implicit_dynamic_parameter, lines_longer_than_80_chars, prefer_const_constructors, require_trailing_commas

part of 'post_grid_tile_block.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PostGridTileBlock _$PostGridTileBlockFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      '_PostGridTileBlock',
      json,
      ($checkedConvert) {
        final val = _PostGridTileBlock(
          id: $checkedConvert('id', (v) => v as String),
          categoryId: $checkedConvert('category_id', (v) => v as String),
          author: $checkedConvert('author', (v) => v as String),
          publishedAt: $checkedConvert(
            'published_at',
            (v) => DateTime.parse(v as String),
          ),
          title: $checkedConvert('title', (v) => v as String),
          imageUrl: $checkedConvert('image_url', (v) => v as String?),
          description: $checkedConvert('description', (v) => v as String?),
          action: $checkedConvert(
            'action',
            (v) => const BlockActionConverter().fromJson(
              v as Map<String, dynamic>?,
            ),
          ),
          isContentOverlaid: $checkedConvert(
            'is_content_overlaid',
            (v) => v as bool? ?? false,
          ),
          type: $checkedConvert(
            'type',
            (v) => v as String? ?? PostGridTileBlock.identifier,
          ),
        );
        return val;
      },
      fieldKeyMap: const {
        'categoryId': 'category_id',
        'publishedAt': 'published_at',
        'imageUrl': 'image_url',
        'isContentOverlaid': 'is_content_overlaid',
      },
    );

Map<String, dynamic> _$PostGridTileBlockToJson(_PostGridTileBlock instance) =>
    <String, dynamic>{
      'id': instance.id,
      'category_id': instance.categoryId,
      'author': instance.author,
      'published_at': instance.publishedAt.toIso8601String(),
      'title': instance.title,
      'image_url': ?instance.imageUrl,
      'description': ?instance.description,
      'action': ?const BlockActionConverter().toJson(instance.action),
      'is_content_overlaid': instance.isContentOverlaid,
      'type': instance.type,
    };
