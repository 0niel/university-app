// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: cast_nullable_to_non_nullable, implicit_dynamic_parameter, lines_longer_than_80_chars, prefer_const_constructors, require_trailing_commas

part of 'post_grid_tile_block.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostGridTileBlock _$PostGridTileBlockFromJson(Map<String, dynamic> json) => $checkedCreate(
      'PostGridTileBlock',
      json,
      ($checkedConvert) {
        final val = PostGridTileBlock(
          id: $checkedConvert('id', (v) => v as String),
          categoryId: $checkedConvert('category_id', (v) => v as String),
          author: $checkedConvert('author', (v) => v as String),
          publishedAt: $checkedConvert('published_at', (v) => DateTime.parse(v as String)),
          imageUrl: $checkedConvert('image_url', (v) => v as String),
          title: $checkedConvert('title', (v) => v as String),
          description: $checkedConvert('description', (v) => v as String?),
          action: $checkedConvert('action', (v) => const BlockActionConverter().fromJson(v as Map<String, dynamic>?)),
          type: $checkedConvert('type', (v) => v as String? ?? PostGridTileBlock.identifier),
          isPremium: $checkedConvert('is_premium', (v) => v as bool? ?? false),
        );
        return val;
      },
      fieldKeyMap: const {
        'categoryId': 'category_id',
        'publishedAt': 'published_at',
        'imageUrl': 'image_url',
        'isPremium': 'is_premium'
      },
    );

Map<String, dynamic> _$PostGridTileBlockToJson(PostGridTileBlock instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'category_id': instance.categoryId,
    'author': instance.author,
    'published_at': instance.publishedAt.toIso8601String(),
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('image_url', instance.imageUrl);
  val['title'] = instance.title;
  writeNotNull('description', instance.description);
  writeNotNull('action', const BlockActionConverter().toJson(instance.action));
  val['is_premium'] = instance.isPremium;
  val['type'] = instance.type;
  return val;
}
