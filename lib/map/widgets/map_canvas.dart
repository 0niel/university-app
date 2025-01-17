import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/map/map.dart';

class MapCanvas extends CustomPainter {
  final List<RoomModel> rooms;

  MapCanvas({required this.rooms});

  @override
  void paint(Canvas canvas, Size size) {
    if (rooms.isEmpty) {
      return;
    }

    Rect? bounds;
    for (final room in rooms) {
      final roomBounds = room.path.getBounds();
      bounds = bounds == null ? roomBounds : bounds.expandToInclude(roomBounds);
    }

    final scaleX = size.width / bounds!.width;
    final scaleY = size.height / bounds.height;
    final scale = scaleX < scaleY ? scaleX : scaleY;

    final offsetX = (size.width - bounds.width * scale) / 2 - bounds.left * scale;
    final offsetY = (size.height - bounds.height * scale) / 2 - bounds.top * scale;

    final transform = Matrix4.identity()
      ..translate(offsetX, offsetY)
      ..scale(scale, scale);

    final Paint paint = Paint()..style = PaintingStyle.fill;

    canvas.save();
    canvas.transform(transform.storage);

    for (final room in rooms) {
      paint.color = room.isSelected ? Colors.greenAccent : Colors.grey.shade300;
      canvas.drawPath(room.path, paint);

      final borderPaint = Paint()
        ..color = Colors.black
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0 / scale;
      canvas.drawPath(room.path, borderPaint);
    }

    final debugBorderPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0 / scale;
    canvas.drawRect(Rect.fromLTWH(bounds.left, bounds.top, bounds.width, bounds.height), debugBorderPaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant MapCanvas oldDelegate) {
    return oldDelegate.rooms != rooms;
  }
}
