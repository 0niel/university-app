// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: cast_nullable_to_non_nullable, implicit_dynamic_parameter, lines_longer_than_80_chars, prefer_const_constructors, require_trailing_commas

part of 'slideshow_introduction_block.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SlideshowIntroductionBlock _$SlideshowIntroductionBlockFromJson(
  Map<String, dynamic> json,
) => $checkedCreate(
  '_SlideshowIntroductionBlock',
  json,
  ($checkedConvert) {
    final val = _SlideshowIntroductionBlock(
      title: $checkedConvert('title', (v) => v as String),
      coverImageUrl: $checkedConvert('cover_image_url', (v) => v as String),
      action: $checkedConvert(
        'action',
        (v) =>
            const BlockActionConverter().fromJson(v as Map<String, dynamic>?),
      ),
      type: $checkedConvert(
        'type',
        (v) => v as String? ?? SlideshowIntroductionBlock.identifier,
      ),
    );
    return val;
  },
  fieldKeyMap: const {'coverImageUrl': 'cover_image_url'},
);

Map<String, dynamic> _$SlideshowIntroductionBlockToJson(
  _SlideshowIntroductionBlock instance,
) => <String, dynamic>{
  'title': instance.title,
  'cover_image_url': instance.coverImageUrl,
  'action': ?const BlockActionConverter().toJson(instance.action),
  'type': instance.type,
};
