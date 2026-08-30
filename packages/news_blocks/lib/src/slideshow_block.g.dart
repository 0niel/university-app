// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: cast_nullable_to_non_nullable, implicit_dynamic_parameter, lines_longer_than_80_chars, prefer_const_constructors, require_trailing_commas

part of 'slideshow_block.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SlideshowBlock _$SlideshowBlockFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_SlideshowBlock', json, ($checkedConvert) {
      final val = _SlideshowBlock(
        title: $checkedConvert('title', (v) => v as String),
        slides: $checkedConvert(
          'slides',
          (v) => (v as List<dynamic>)
              .map((e) => SlideBlock.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        type: $checkedConvert(
          'type',
          (v) => v as String? ?? SlideshowBlock.identifier,
        ),
      );
      return val;
    });

Map<String, dynamic> _$SlideshowBlockToJson(_SlideshowBlock instance) =>
    <String, dynamic>{
      'title': instance.title,
      'slides': instance.slides.map((e) => e.toJson()).toList(),
      'type': instance.type,
    };
