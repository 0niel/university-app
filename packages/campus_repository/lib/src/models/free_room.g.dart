// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'free_room.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FreeRoom _$FreeRoomFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_FreeRoom', json, ($checkedConvert) {
      final val = _FreeRoom(
        room: $checkedConvert('room', (v) => v as String? ?? ''),
        campus: $checkedConvert('campus', (v) => v as String?),
        freeUntil: $checkedConvert('freeUntil', (v) => dateTimeFromJson(v)),
      );
      return val;
    });

Map<String, dynamic> _$FreeRoomToJson(_FreeRoom instance) => <String, dynamic>{
  'room': instance.room,
  'campus': instance.campus,
  'freeUntil': dateTimeToJson(instance.freeUntil),
};
