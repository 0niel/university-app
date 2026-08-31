import 'package:campus_repository/src/models/json_converters.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'free_room.freezed.dart';
part 'free_room.g.dart';

@freezed
abstract class FreeRoom with _$FreeRoom {
  const factory FreeRoom({
    @JsonKey(defaultValue: '') required String room,
    String? campus,
    @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
    DateTime? freeUntil,
  }) = _FreeRoom;

  const FreeRoom._();

  factory FreeRoom.fromJson(Map<String, Object?> json) =>
      _$FreeRoomFromJson(json);

  String get building {
    final match = RegExp(r'^([А-ЯЁA-Z]+)[\s-]').firstMatch(room);
    return match?.group(1) ?? (campus ?? '');
  }
}
