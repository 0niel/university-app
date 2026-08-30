import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:rtu_mirea_app/map/models/models.dart';

class RoomsHighlightPainter extends CustomPainter {
  const RoomsHighlightPainter(
    this.rooms, {
    required this.highlightColor,
    this.selectedRoomId,
  });

  final List<RoomModel> rooms;
  final String? selectedRoomId;
  final Color highlightColor;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = highlightColor.withValues(alpha: 0.28)
      ..style = PaintingStyle.fill;
    for (final room in rooms) {
      if (room.roomId == selectedRoomId) {
        canvas.drawPath(room.path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(RoomsHighlightPainter oldDelegate) =>
      oldDelegate.selectedRoomId != selectedRoomId ||
      !listEquals(oldDelegate.rooms, rooms) ||
      oldDelegate.highlightColor != highlightColor;
}
