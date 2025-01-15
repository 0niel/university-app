import 'package:flutter/widgets.dart';

class RoomModel {
  final String roomId;
  final Path path;

  bool isSelected;

  RoomModel({
    required this.roomId,
    required this.path,
    this.isSelected = false,
  });
}
