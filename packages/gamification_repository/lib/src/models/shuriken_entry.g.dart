// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shuriken_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ShurikenEntry _$ShurikenEntryFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_ShurikenEntry', json, ($checkedConvert) {
      final val = _ShurikenEntry(
        title: $checkedConvert('title', (v) => v as String? ?? ''),
        amount: $checkedConvert('amount', (v) => (v as num?)?.toInt() ?? 0),
        emoji: $checkedConvert('emoji', (v) => v as String? ?? '✨'),
        createdAt: $checkedConvert('createdAt', (v) => dateTimeFromJson(v)),
      );
      return val;
    });

Map<String, dynamic> _$ShurikenEntryToJson(_ShurikenEntry instance) =>
    <String, dynamic>{
      'title': instance.title,
      'amount': instance.amount,
      'emoji': instance.emoji,
      'createdAt': dateTimeToJson(instance.createdAt),
    };
