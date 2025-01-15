import 'dart:collection';
import 'package:flutter/services.dart' show rootBundle;
import 'package:xml/xml.dart' as xml;
import 'package:path_drawing/path_drawing.dart';
import 'package:flutter/material.dart';
import '../models/room_model.dart';

class SvgLoader {
  static final Map<String, List<RoomModel>> _cache = HashMap();

  static Future<List<RoomModel>> loadFloorPlan({
    required String floorId,
    required String svgPath,
  }) async {
    if (_cache.containsKey(floorId)) {
      return _cache[floorId]!;
    }

    try {
      final svgString = await rootBundle.loadString(svgPath);

      final document = xml.XmlDocument.parse(svgString);

      final pathElements =
          document.findAllElements('path').where((element) => element.getAttribute('data-room') != null);

      final rooms = <RoomModel>[];

      for (var element in pathElements) {
        final dataRoom = element.getAttribute('data-room')!;
        final dAttribute = element.getAttribute('d') ?? '';

        if (dAttribute.isEmpty) continue;

        final Path path = parseSvgPathData(dAttribute);

        rooms.add(
          RoomModel(
            roomId: dataRoom,
            path: path,
          ),
        );
      }

      _cache[floorId] = rooms;
      return rooms;
    } catch (e) {
      return [];
    }
  }

  static void clearCache() {
    _cache.clear();
  }
}
