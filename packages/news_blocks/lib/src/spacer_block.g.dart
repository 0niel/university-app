// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: cast_nullable_to_non_nullable, implicit_dynamic_parameter, lines_longer_than_80_chars, prefer_const_constructors, require_trailing_commas

part of 'spacer_block.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SpacerBlock _$SpacerBlockFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_SpacerBlock', json, ($checkedConvert) {
      final val = _SpacerBlock(
        spacing: $checkedConvert(
          'spacing',
          (v) => $enumDecode(_$SpacingEnumMap, v),
        ),
        type: $checkedConvert(
          'type',
          (v) => v as String? ?? SpacerBlock.identifier,
        ),
      );
      return val;
    });

Map<String, dynamic> _$SpacerBlockToJson(_SpacerBlock instance) =>
    <String, dynamic>{
      'spacing': _$SpacingEnumMap[instance.spacing]!,
      'type': instance.type,
    };

const _$SpacingEnumMap = {
  Spacing.extraSmall: 'extraSmall',
  Spacing.small: 'small',
  Spacing.medium: 'medium',
  Spacing.large: 'large',
  Spacing.veryLarge: 'veryLarge',
  Spacing.extraLarge: 'extraLarge',
};
