import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'room_model.freezed.dart';

@freezed
abstract class RoomModel with _$RoomModel {
  const factory RoomModel({
    required String roomId,
    required Path path,
    @Default('') String name,
    @Default(false) bool isSelected,
  }) = _RoomModel;
}
