// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: cast_nullable_to_non_nullable, implicit_dynamic_parameter, lines_longer_than_80_chars, prefer_const_constructors, require_trailing_commas

part of 'text_caption_block.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TextCaptionBlock _$TextCaptionBlockFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_TextCaptionBlock', json, ($checkedConvert) {
      final val = _TextCaptionBlock(
        text: $checkedConvert('text', (v) => v as String),
        color: $checkedConvert(
          'color',
          (v) => $enumDecode(_$TextCaptionColorEnumMap, v),
        ),
        type: $checkedConvert(
          'type',
          (v) => v as String? ?? TextCaptionBlock.identifier,
        ),
      );
      return val;
    });

Map<String, dynamic> _$TextCaptionBlockToJson(_TextCaptionBlock instance) =>
    <String, dynamic>{
      'text': instance.text,
      'color': _$TextCaptionColorEnumMap[instance.color]!,
      'type': instance.type,
    };

const _$TextCaptionColorEnumMap = {
  TextCaptionColor.normal: 'normal',
  TextCaptionColor.light: 'light',
};
