import 'package:flutter/widgets.dart';

class RoomModel {
  final String roomId;
  final String name;
  final bool isSelected;
  Path path;

  RoomModel({
    required this.roomId,
    required this.path,
    this.name = '',
    this.isSelected = false,
  });

  RoomModel copyWith({
    String? roomId,
    String? name,
    Path? path,
    bool? isSelected,
  }) {
    return RoomModel(
      roomId: roomId ?? this.roomId,
      name: name ?? this.name,
      path: path ?? this.path,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
