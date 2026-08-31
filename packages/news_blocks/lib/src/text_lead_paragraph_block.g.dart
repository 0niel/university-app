// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: cast_nullable_to_non_nullable, implicit_dynamic_parameter, lines_longer_than_80_chars, prefer_const_constructors, require_trailing_commas

part of 'text_lead_paragraph_block.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TextLeadParagraphBlock _$TextLeadParagraphBlockFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_TextLeadParagraphBlock', json, ($checkedConvert) {
  final val = _TextLeadParagraphBlock(
    text: $checkedConvert('text', (v) => v as String),
    type: $checkedConvert(
      'type',
      (v) => v as String? ?? TextLeadParagraphBlock.identifier,
    ),
  );
  return val;
});

Map<String, dynamic> _$TextLeadParagraphBlockToJson(
  _TextLeadParagraphBlock instance,
) => <String, dynamic>{'text': instance.text, 'type': instance.type};
