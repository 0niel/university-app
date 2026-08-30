import 'dart:developer' as developer;
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_drawing/path_drawing.dart';
import 'package:rtu_mirea_app/map/models/models.dart';
import 'package:xml/xml.dart' as xml;

typedef SvgAssetLoader = Future<String> Function(String assetPath);

Future<String> _loadSvgAsset(String assetPath) =>
    rootBundle.loadString(assetPath);

class SvgRoomParser {
  const SvgRoomParser({this.onLoadSvg = _loadSvgAsset});

  final SvgAssetLoader onLoadSvg;

  Future<(List<RoomModel>, ui.Rect)> parseSvg(String assetPath) async {
    final svgString = await onLoadSvg(assetPath);
    final document = xml.XmlDocument.parse(svgString);
    final svgRoot = document.findElements('svg').firstOrNull;
    if (svgRoot == null) {
      throw const FormatException('SVG document has no root element');
    }

    final parsedViewBox = _parseViewBox(svgRoot.getAttribute('viewBox'));
    final rooms = <RoomModel>[];
    final objectElements = svgRoot.descendants
        .whereType<xml.XmlElement>()
        .where((element) => element.getAttribute('data-object') != null);

    var globalMinX = double.infinity;
    var globalMinY = double.infinity;
    var globalMaxX = -double.infinity;
    var globalMaxY = -double.infinity;
    var hasGeometry = false;

    for (final element in objectElements) {
      final roomId = element.getAttribute('data-object') ?? 'unknown';
      final combinedPath = Path()..fillType = .nonZero;
      _appendShapes(
        element,
        parentTransform: Matrix4.identity(),
        destination: combinedPath,
      );

      final bounds = combinedPath.getBounds();
      if (!bounds.isEmpty) {
        hasGeometry = true;
        globalMinX = math.min(globalMinX, bounds.left);
        globalMinY = math.min(globalMinY, bounds.top);
        globalMaxX = math.max(globalMaxX, bounds.right);
        globalMaxY = math.max(globalMaxY, bounds.bottom);
      }

      rooms.add(RoomModel(roomId: roomId, path: combinedPath));
    }

    if (rooms.isEmpty || !hasGeometry) return (rooms, parsedViewBox);

    final realBox = ui.Rect.fromLTWH(
      globalMinX,
      globalMinY,
      globalMaxX - globalMinX,
      globalMaxY - globalMinY,
    );
    final unionRect = _rectUnion(parsedViewBox, realBox);
    final shiftOffset = Offset(-unionRect.left, -unionRect.top);
    final shiftedRooms = [
      for (final room in rooms)
        room.copyWith(path: room.path.shift(shiftOffset)),
    ];

    return (
      shiftedRooms,
      ui.Rect.fromLTWH(0, 0, unionRect.width, unionRect.height),
    );
  }

  static ui.Rect _parseViewBox(String? value) {
    final normalized = value?.trim();
    final parts = normalized == null || normalized.isEmpty
        ? null
        : normalized.split(RegExp(r'[\s,]+'));
    return switch (parts) {
      [final x, final y, final width, final height] => ui.Rect.fromLTWH(
        double.tryParse(x) ?? 0,
        double.tryParse(y) ?? 0,
        double.tryParse(width) ?? 1000,
        double.tryParse(height) ?? 1000,
      ),
      _ => const ui.Rect.fromLTWH(0, 0, 1000, 1000),
    };
  }

  static void _appendShapes(
    xml.XmlElement element, {
    required Matrix4 parentTransform,
    required Path destination,
  }) {
    final elementTransform = _parseTransform(element.getAttribute('transform'));
    final accumulatedTransform = elementTransform == null
        ? parentTransform
        : parentTransform.multiplied(elementTransform);
    final shape = _parseShapeToPath(element);
    if (shape != null) {
      destination.addPath(shape.transform(accumulatedTransform.storage), .zero);
    }

    for (final child in element.childElements) {
      if (child.getAttribute('data-object') != null) {
        continue;
      }
      _appendShapes(
        child,
        parentTransform: accumulatedTransform,
        destination: destination,
      );
    }
  }

  static Path? _parseShapeToPath(xml.XmlElement element) {
    final tag = element.name.local.toLowerCase();
    return switch (tag) {
      'path' => _parsePath(element),
      'rect' => _parseRect(element),
      'circle' => _parseCircle(element),
      'ellipse' => _parseEllipse(element),
      'polygon' || 'polyline' => _parsePoly(element, close: tag == 'polygon'),
      _ => null,
    };
  }

  static Path? _parsePath(xml.XmlElement element) {
    final data = element.getAttribute('d');
    return data == null || data.isEmpty ? null : parseSvgPathData(data);
  }

  static Path? _parseRect(xml.XmlElement element) {
    final width = _attributeDouble(element, 'width');
    final height = _attributeDouble(element, 'height');
    if (width <= 0 || height <= 0) return null;

    final x = _attributeDouble(element, 'x');
    final y = _attributeDouble(element, 'y');
    return Path()..addRect(Rect.fromLTWH(x, y, width, height));
  }

  static Path? _parseCircle(xml.XmlElement element) {
    final radius = _attributeDouble(element, 'r');
    if (radius <= 0) return null;

    final center = Offset(
      _attributeDouble(element, 'cx'),
      _attributeDouble(element, 'cy'),
    );
    return Path()..addOval(Rect.fromCircle(center: center, radius: radius));
  }

  static Path? _parseEllipse(xml.XmlElement element) {
    final radiusX = _attributeDouble(element, 'rx');
    final radiusY = _attributeDouble(element, 'ry');
    if (radiusX <= 0 || radiusY <= 0) return null;

    final center = Offset(
      _attributeDouble(element, 'cx'),
      _attributeDouble(element, 'cy'),
    );
    return Path()..addOval(
      Rect.fromCenter(
        center: center,
        width: radiusX * 2,
        height: radiusY * 2,
      ),
    );
  }

  static Path? _parsePoly(xml.XmlElement element, {required bool close}) {
    final value = element.getAttribute('points');
    if (value == null || value.isEmpty) return null;

    final points = _parsePoints(value);
    if (points case [final first, final second, ...final rest]) {
      final path = Path()
        ..moveTo(first.dx, first.dy)
        ..lineTo(second.dx, second.dy);
      for (final point in rest) {
        path.lineTo(point.dx, point.dy);
      }
      if (close) path.close();
      return path;
    }
    return null;
  }

  static double _attributeDouble(xml.XmlElement element, String name) =>
      double.tryParse(element.getAttribute(name) ?? '') ?? 0;

  static Matrix4? _parseTransform(String? value) {
    if (value == null) return null;

    var matrix = Matrix4.identity();
    final matches = RegExp(r'(\w+)\(([^)]+)\)').allMatches(value);
    for (final match in matches) {
      final transformType = match.group(1);
      final parameters = match.group(2);
      if (transformType == null || parameters == null) continue;

      final values = parameters
          .split(RegExp(r'[,\s]+'))
          .map((parameter) => double.tryParse(parameter) ?? 0)
          .toList();
      final current = Matrix4.identity();
      _applyTransform(current, transformType, values);
      matrix = matrix.multiplied(current);
    }
    return matrix;
  }

  static void _applyTransform(
    Matrix4 matrix,
    String type,
    List<double> values,
  ) {
    switch ((type, values)) {
      case ('translate', [final x]):
        matrix.translateByDouble(x, 0, 0, 1);
      case ('translate', [final x, final y]):
        matrix.translateByDouble(x, y, 0, 1);
      case ('scale', [final value]):
        matrix.scaleByDouble(value, value, value, 1);
      case ('scale', [final x, final y]):
        matrix.scaleByDouble(x, y, 1, 1);
      case ('rotate', [final angle]):
        matrix.rotateZ(_degreesToRadians(angle));
      case ('rotate', [final angle, final x, final y]):
        matrix
          ..translateByDouble(x, y, 0, 1)
          ..rotateZ(_degreesToRadians(angle))
          ..translateByDouble(-x, -y, 0, 1);
      case ('matrix', [final a, final b, final c, final d, final e, final f]):
        _setSvgMatrix(matrix, a: a, b: b, c: c, d: d, e: e, f: f);
      case ('skewX', [final angle]):
        _setSvgMatrix(
          matrix,
          a: 1,
          b: 0,
          c: math.tan(_degreesToRadians(angle)),
          d: 1,
          e: 0,
          f: 0,
        );
      case ('skewY', [final angle]):
        _setSvgMatrix(
          matrix,
          a: 1,
          b: math.tan(_degreesToRadians(angle)),
          c: 0,
          d: 1,
          e: 0,
          f: 0,
        );
      case (
        'translate' || 'scale' || 'rotate' || 'matrix' || 'skewX' || 'skewY',
        _,
      ):
        break;
      default:
        developer.log('Unknown transformation type: $type');
    }
  }

  static void _setSvgMatrix(
    Matrix4 matrix, {
    required double a,
    required double b,
    required double c,
    required double d,
    required double e,
    required double f,
  }) {
    matrix.setValues(a, b, 0, 0, c, d, 0, 0, 0, 0, 1, 0, e, f, 0, 1);
  }

  static ui.Rect _rectUnion(ui.Rect first, ui.Rect second) => ui.Rect.fromLTRB(
    math.min(first.left, second.left),
    math.min(first.top, second.top),
    math.max(first.right, second.right),
    math.max(first.bottom, second.bottom),
  );

  static List<Offset> _parsePoints(String value) {
    final values = value.trim().split(RegExp(r'[\s,]+'));
    return [
      for (final pair in values.slices(2))
        if (pair case [final x, final y])
          Offset(double.tryParse(x) ?? 0, double.tryParse(y) ?? 0),
    ];
  }

  static double _degreesToRadians(double degrees) => degrees * math.pi / 180;
}
