// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: cast_nullable_to_non_nullable, implicit_dynamic_parameter, lines_longer_than_80_chars, prefer_const_constructors, require_trailing_commas

part of 'text_paragraph_block.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TextParagraphBlock _$TextParagraphBlockFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_TextParagraphBlock', json, ($checkedConvert) {
      final val = _TextParagraphBlock(
        text: $checkedConvert('text', (v) => v as String),
        type: $checkedConvert(
          'type',
          (v) => v as String? ?? TextParagraphBlock.identifier,
        ),
      );
      return val;
    });

Map<String, dynamic> _$TextParagraphBlockToJson(_TextParagraphBlock instance) =>
    <String, dynamic>{'text': instance.text, 'type': instance.type};
