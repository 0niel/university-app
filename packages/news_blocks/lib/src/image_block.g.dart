// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: cast_nullable_to_non_nullable, implicit_dynamic_parameter, lines_longer_than_80_chars, prefer_const_constructors, require_trailing_commas

part of 'image_block.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ImageBlock _$ImageBlockFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_ImageBlock', json, ($checkedConvert) {
      final val = _ImageBlock(
        imageUrl: $checkedConvert('image_url', (v) => v as String),
        type: $checkedConvert(
          'type',
          (v) => v as String? ?? ImageBlock.identifier,
        ),
      );
      return val;
    }, fieldKeyMap: const {'imageUrl': 'image_url'});

Map<String, dynamic> _$ImageBlockToJson(_ImageBlock instance) =>
    <String, dynamic>{'image_url': instance.imageUrl, 'type': instance.type};
