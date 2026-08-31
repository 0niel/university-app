// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: cast_nullable_to_non_nullable, implicit_dynamic_parameter, lines_longer_than_80_chars, prefer_const_constructors, require_trailing_commas

part of 'newsletter_block.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NewsletterBlock _$NewsletterBlockFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_NewsletterBlock', json, ($checkedConvert) {
      final val = _NewsletterBlock(
        type: $checkedConvert(
          'type',
          (v) => v as String? ?? NewsletterBlock.identifier,
        ),
      );
      return val;
    });

Map<String, dynamic> _$NewsletterBlockToJson(_NewsletterBlock instance) =>
    <String, dynamic>{'type': instance.type};
