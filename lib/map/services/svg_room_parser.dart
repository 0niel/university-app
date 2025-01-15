import 'dart:ui' as ui;
import 'package:flutter/services.dart' show rootBundle;
import 'package:rtu_mirea_app/map/models/models.dart';
import 'package:xml/xml.dart' as xml;
import 'package:path_drawing/path_drawing.dart';

class SvgRoomsParser {
  static Future<(List<RoomModel>, ui.Rect)> parseSvg(String assetPath) async {
    final svgString = await rootBundle.loadString(assetPath);

    final document = xml.XmlDocument.parse(svgString);
    final svgRoot = document.findElements('svg').first;

    final viewBoxAttr = svgRoot.getAttribute('viewBox');
    ui.Rect viewBoxRect = const ui.Rect.fromLTWH(0, 0, 1000, 1000);
    if (viewBoxAttr != null) {
      final parts = viewBoxAttr.split(RegExp(r'\s+'));
      if (parts.length == 4) {
        final x = double.tryParse(parts[0]) ?? 0;
        final y = double.tryParse(parts[1]) ?? 0;
        final w = double.tryParse(parts[2]) ?? 1000;
        final h = double.tryParse(parts[3]) ?? 1000;
        viewBoxRect = ui.Rect.fromLTWH(x, y, w, h);
      }
    }

    final rooms = <RoomModel>[];

    final pathElements = svgRoot.findAllElements('path').where((el) {
      return el.getAttribute('data-object') != null;
    });

    for (final el in pathElements) {
      final dataRoom = el.getAttribute('data-object')!;
      final d = el.getAttribute('d') ?? '';
      if (d.isEmpty) continue;

      final path = parseSvgPathData(d);
      rooms.add(RoomModel(roomId: dataRoom, path: path));
    }

    return (rooms, viewBoxRect);
  }
}
