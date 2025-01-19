import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:xml/xml.dart' as xml;
import 'package:path_drawing/path_drawing.dart';
import 'dart:math' as math;
import 'dart:developer' as developer;
import 'package:rtu_mirea_app/map/models/models.dart';
import 'package:flutter/material.dart';

class SvgRoomsParser {
  static Future<(List<RoomModel>, ui.Rect)> parseSvg(String assetPath) async {
    final svgString = await rootBundle.loadString(assetPath);
    final document = xml.XmlDocument.parse(svgString);
    final svgRoot = document.findElements('svg').first;

    ui.Rect parsedViewBox = const ui.Rect.fromLTWH(0, 0, 1000, 1000);
    final viewBoxAttr = svgRoot.getAttribute('viewBox');
    if (viewBoxAttr != null) {
      final parts = viewBoxAttr.split(RegExp(r'[\s,]+'));
      if (parts.length == 4) {
        final x = double.tryParse(parts[0]) ?? 0;
        final y = double.tryParse(parts[1]) ?? 0;
        final w = double.tryParse(parts[2]) ?? 1000;
        final h = double.tryParse(parts[3]) ?? 1000;
        parsedViewBox = ui.Rect.fromLTWH(x, y, w, h);
      }
    }

    final rooms = <RoomModel>[];
    final objectElements = svgRoot.descendants.where((node) {
      return (node is xml.XmlElement) && (node.getAttribute('data-object') != null);
    });

    double globalMinX = double.infinity;
    double globalMinY = double.infinity;
    double globalMaxX = -double.infinity;
    double globalMaxY = -double.infinity;

    for (final node in objectElements) {
      final element = node as xml.XmlElement;
      final dataRoom = element.getAttribute('data-object') ?? 'unknown';

      Path combinedPath = Path()..fillType = PathFillType.nonZero;

      final gTransformAttr = element.getAttribute('transform');
      final gTransform = _parseTransform(gTransformAttr);

      final shapeElements = element.descendants.whereType<xml.XmlElement>();
      for (final shapeEl in shapeElements) {
        Path? shapePath = _parseShapeToPath(shapeEl);
        if (shapePath == null) continue;

        final shapeTransformAttr = shapeEl.getAttribute('transform');
        final shapeMatrix = _parseTransform(shapeTransformAttr);

        if (shapeMatrix != null) {
          shapePath = shapePath.transform(shapeMatrix.storage);
        }

        combinedPath.addPath(shapePath, Offset.zero);
      }

      if (gTransform != null) {
        combinedPath = combinedPath.transform(gTransform.storage);
      }

      final bounds = combinedPath.getBounds();
      if (!bounds.isEmpty) {
        globalMinX = math.min(globalMinX, bounds.left);
        globalMinY = math.min(globalMinY, bounds.top);
        globalMaxX = math.max(globalMaxX, bounds.right);
        globalMaxY = math.max(globalMaxY, bounds.bottom);
      }

      rooms.add(RoomModel(roomId: dataRoom, path: combinedPath));
    }

    if (rooms.isEmpty) {
      return (<RoomModel>[], parsedViewBox);
    }

    final realBox = ui.Rect.fromLTWH(globalMinX, globalMinY, globalMaxX - globalMinX, globalMaxY - globalMinY);
    final unionRect = _rectUnion(parsedViewBox, realBox);

    final shiftOffset = Offset(-unionRect.left, -unionRect.top);
    for (final room in rooms) {
      room.path = room.path.shift(shiftOffset);
    }

    final normalizedRect = ui.Rect.fromLTWH(0, 0, unionRect.width, unionRect.height);
    return (rooms, normalizedRect);
  }

  static Path? _parseShapeToPath(xml.XmlElement shapeEl) {
    final tag = shapeEl.name.local.toLowerCase();

    if (tag == 'path') {
      final d = shapeEl.getAttribute('d');
      if (d != null && d.isNotEmpty) {
        return parseSvgPathData(d);
      }
    } else if (tag == 'rect') {
      final x = double.tryParse(shapeEl.getAttribute('x') ?? '0') ?? 0;
      final y = double.tryParse(shapeEl.getAttribute('y') ?? '0') ?? 0;
      final w = double.tryParse(shapeEl.getAttribute('width') ?? '0') ?? 0;
      final h = double.tryParse(shapeEl.getAttribute('height') ?? '0') ?? 0;
      if (w > 0 && h > 0) {
        return Path()..addRect(Rect.fromLTWH(x, y, w, h));
      }
    } else if (tag == 'circle') {
      final cx = double.tryParse(shapeEl.getAttribute('cx') ?? '0') ?? 0;
      final cy = double.tryParse(shapeEl.getAttribute('cy') ?? '0') ?? 0;
      final r = double.tryParse(shapeEl.getAttribute('r') ?? '0') ?? 0;
      if (r > 0) {
        return Path()..addOval(Rect.fromCircle(center: Offset(cx, cy), radius: r));
      }
    } else if (tag == 'ellipse') {
      final cx = double.tryParse(shapeEl.getAttribute('cx') ?? '0') ?? 0;
      final cy = double.tryParse(shapeEl.getAttribute('cy') ?? '0') ?? 0;
      final rx = double.tryParse(shapeEl.getAttribute('rx') ?? '0') ?? 0;
      final ry = double.tryParse(shapeEl.getAttribute('ry') ?? '0') ?? 0;
      if (rx > 0 && ry > 0) {
        return Path()..addOval(Rect.fromCenter(center: Offset(cx, cy), width: rx * 2, height: ry * 2));
      }
    } else if (tag == 'polygon' || tag == 'polyline') {
      final pointsAttr = shapeEl.getAttribute('points');
      if (pointsAttr != null && pointsAttr.isNotEmpty) {
        final points = _parsePoints(pointsAttr);
        if (points.length >= 2) {
          final path = Path()..moveTo(points.first.dx, points.first.dy);
          for (var point in points.skip(1)) {
            path.lineTo(point.dx, point.dy);
          }
          if (tag == 'polygon') {
            path.close();
          }
          return path;
        }
      }
    }

    return null;
  }

  static Matrix4? _parseTransform(String? transformAttr) {
    if (transformAttr == null) return null;

    final regex = RegExp(r'(\w+)\(([^)]+)\)');
    final matches = regex.allMatches(transformAttr);

    Matrix4 matrix = Matrix4.identity();

    for (final match in matches) {
      final String transformType = match.group(1)!;
      final String params = match.group(2)!;
      final List<double> values = params.split(RegExp(r'[,\s]+')).map((v) => double.tryParse(v) ?? 0).toList();

      Matrix4 current = Matrix4.identity();

      switch (transformType) {
        case 'translate':
          if (values.length == 1) {
            current.translate(values[0]);
          } else if (values.length == 2) {
            current.translate(values[0], values[1]);
          }
          break;
        case 'scale':
          if (values.length == 1) {
            current.scale(values[0]);
          } else if (values.length == 2) {
            current.scale(values[0], values[1]);
          }
          break;
        case 'rotate':
          if (values.length == 1) {
            current.rotateZ(_degreesToRadians(values[0]));
          } else if (values.length == 3) {
            final double angle = _degreesToRadians(values[0]);
            final double cx = values[1];
            final double cy = values[2];
            current
              ..translate(cx, cy)
              ..rotateZ(angle)
              ..translate(-cx, -cy);
          }
          break;
        case 'matrix':
          if (values.length == 6) {
            final a = values[0];
            final b = values[1];
            final c = values[2];
            final d = values[3];
            final e = values[4];
            final f = values[5];
            current.setValues(
              a,
              c,
              0,
              e,
              b,
              d,
              0,
              f,
              0,
              0,
              1,
              0,
              0,
              0,
              0,
              1,
            );
          }
          break;

        default:
          developer.log('Unknown transformation type: $transformType');
      }

      matrix = matrix.multiplied(current);
    }

    return matrix;
  }

  static ui.Rect _rectUnion(ui.Rect r1, ui.Rect r2) {
    final left = math.min(r1.left, r2.left);
    final top = math.min(r1.top, r2.top);
    final right = math.max(r1.right, r2.right);
    final bottom = math.max(r1.bottom, r2.bottom);
    return ui.Rect.fromLTRB(left, top, right, bottom);
  }

  static List<Offset> _parsePoints(String pointsStr) {
    final points = <Offset>[];
    final pairs = pointsStr.trim().split(RegExp(r'[\s,]+'));
    for (int i = 0; i < pairs.length - 1; i += 2) {
      final x = double.tryParse(pairs[i]) ?? 0;
      final y = double.tryParse(pairs[i + 1]) ?? 0;
      points.add(Offset(x, y));
    }
    return points;
  }

  static double _degreesToRadians(double degrees) => degrees * math.pi / 180;
}
