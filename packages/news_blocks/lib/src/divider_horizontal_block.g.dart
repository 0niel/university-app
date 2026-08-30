// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: cast_nullable_to_non_nullable, implicit_dynamic_parameter, lines_longer_than_80_chars, prefer_const_constructors, require_trailing_commas

part of 'divider_horizontal_block.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DividerHorizontalBlock _$DividerHorizontalBlockFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_DividerHorizontalBlock', json, ($checkedConvert) {
  final val = _DividerHorizontalBlock(
    type: $checkedConvert(
      'type',
      (v) => v as String? ?? DividerHorizontalBlock.identifier,
    ),
  );
  return val;
});

Map<String, dynamic> _$DividerHorizontalBlockToJson(
  _DividerHorizontalBlock instance,
) => <String, dynamic>{'type': instance.type};
