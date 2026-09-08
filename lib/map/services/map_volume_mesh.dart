import 'dart:math' as math;
import 'dart:ui';

import 'package:rtu_mirea_app/map/widgets/map_structure_layer.dart';

class MapVolumeWall {
  const MapVolumeWall(this.start, this.end);

  final Offset start;
  final Offset end;
  Rect get bounds => Rect.fromPoints(start, end).inflate(.001);
}

class MapVolumeMesh {
  const MapVolumeMesh._(this.walls, this.truncated);

  factory MapVolumeMesh.fromLayers(
    MapStructureLayers layers, {
    required Size floorSize,
    int maximumEdges = 20000,
  }) {
    if (!floorSize.width.isFinite ||
        !floorSize.height.isFinite ||
        floorSize.width <= 0 ||
        floorSize.height <= 0) {
      return const MapVolumeMesh._([], false);
    }
    final limit = maximumEdges.clamp(0, 20000);
    final tolerance = math.max(.01, floorSize.shortestSide / 16000);
    final openings = <MapVolumeWall>[];
    for (final shape in layers.openingShapes) {
      if (!shape.stroke || shape.strokeOpacity <= 0) continue;
      for (final wall in _flatten(
        shape.path,
        tolerance,
        2000 - openings.length,
      )) {
        openings.addAll(
          (shape.clips.isEmpty
                  ? [wall]
                  : _clipWall(wall, shape.clips, tolerance))
              .take(2000 - openings.length),
        );
        if (openings.length >= 2000) break;
      }
      if (openings.length >= 2000) break;
    }
    final openingGrid = <(int, int), List<MapVolumeWall>>{};
    final largeOpenings = <MapVolumeWall>[];
    final cellSize = math.max<double>(1, floorSize.longestSide / 64);
    for (final opening in openings) {
      final bounds = opening.bounds.inflate(tolerance * 2);
      final cells = _gridCells(bounds, cellSize);
      if (cells == null) {
        largeOpenings.add(opening);
        continue;
      }
      for (final cell in cells) {
        openingGrid.putIfAbsent(cell, () => []).add(opening);
      }
    }
    final walls = <MapVolumeWall>[];
    var truncated = false;
    for (final shape in layers.foundationShapes) {
      if (!shape.stroke || shape.strokeOpacity <= 0) continue;
      final edges = _flatten(shape.path, tolerance, limit - walls.length);
      for (final edge in edges) {
        final bounds = edge.bounds.inflate(tolerance * 2);
        final cells = _gridCells(bounds, cellSize);
        final nearbyOpenings = <MapVolumeWall>{...largeOpenings};
        if (cells == null) {
          nearbyOpenings.addAll(openings);
        } else {
          for (final cell in cells) {
            nearbyOpenings.addAll(openingGrid[cell] ?? const []);
          }
        }
        for (final wall in _subtractOpenings(edge, nearbyOpenings, tolerance)) {
          if (shape.clips.isEmpty) {
            walls.add(wall);
          } else {
            walls.addAll(
              _clipWall(
                wall,
                shape.clips,
                tolerance,
              ).take(limit - walls.length),
            );
          }
          if (walls.length >= limit) break;
        }
        if (walls.length >= limit) break;
      }
      if (walls.length >= limit) {
        truncated = true;
        break;
      }
    }
    return MapVolumeMesh._(List.unmodifiable(walls.take(limit)), truncated);
  }

  final List<MapVolumeWall> walls;
  final bool truncated;
}

List<MapVolumeWall> _flatten(Path path, double tolerance, int limit) {
  if (limit <= 0) return const [];
  final edges = <MapVolumeWall>[];
  for (final metric in path.computeMetrics()) {
    if (!metric.length.isFinite || metric.length <= tolerance) continue;
    void flatten(double from, double to, Offset start, Offset end, int depth) {
      if (edges.length >= limit) return;
      final middle = (from + to) / 2;
      final mid = metric.getTangentForOffset(middle)?.position;
      if (mid == null || !mid.isFinite) return;
      final quarter = metric.getTangentForOffset((from + middle) / 2)?.position;
      final third = metric.getTangentForOffset((middle + to) / 2)?.position;
      final deviation = math.max(
        (mid - Offset.lerp(start, end, .5)!).distance,
        math.max(
          quarter == null
              ? 0
              : (quarter - Offset.lerp(start, end, .25)!).distance,
          third == null ? 0 : (third - Offset.lerp(start, end, .75)!).distance,
        ),
      );
      if (depth < 14 && deviation > tolerance) {
        flatten(from, middle, start, mid, depth + 1);
        flatten(middle, to, mid, end, depth + 1);
      } else if ((end - start).distance > tolerance / 10) {
        edges.add(MapVolumeWall(start, end));
      }
    }

    final start = metric.getTangentForOffset(0)?.position;
    final end = metric.getTangentForOffset(metric.length)?.position;
    if (start == null || end == null || !start.isFinite || !end.isFinite) {
      continue;
    }
    flatten(0, metric.length, start, end, 0);
    if (edges.length >= limit) break;
  }
  return edges;
}

Iterable<MapVolumeWall> _subtractOpenings(
  MapVolumeWall wall,
  Iterable<MapVolumeWall> openings,
  double tolerance,
) sync* {
  final delta = wall.end - wall.start;
  final length = delta.distance;
  if (length <= tolerance) return;
  final direction = delta / length;
  double along(Offset point) =>
      (point.dx - wall.start.dx) * direction.dx +
      (point.dy - wall.start.dy) * direction.dy;
  double across(Offset point) =>
      ((point.dx - wall.start.dx) * direction.dy -
              (point.dy - wall.start.dy) * direction.dx)
          .abs();
  final gaps = <(double, double)>[];
  for (final opening in openings) {
    if (across(opening.start) > tolerance * 2 ||
        across(opening.end) > tolerance * 2) {
      continue;
    }
    final a = along(opening.start);
    final b = along(opening.end);
    final left = math.max<double>(0, math.min(a, b));
    final right = math.min(length, math.max(a, b));
    if (right > left) gaps.add((left, right));
  }
  gaps.sort((a, b) => a.$1.compareTo(b.$1));
  var from = 0.0;
  for (final gap in gaps) {
    if (gap.$1 > from + tolerance) {
      yield MapVolumeWall(
        wall.start + direction * from,
        wall.start + direction * gap.$1,
      );
    }
    from = math.max(from, gap.$2);
  }
  if (from < length - tolerance) {
    yield MapVolumeWall(wall.start + direction * from, wall.end);
  }
}

Iterable<MapVolumeWall> _clipWall(
  MapVolumeWall wall,
  List<Path> clips,
  double tolerance,
) sync* {
  final direction = wall.end - wall.start;
  final length = direction.distance;
  final normal = Offset(-direction.dy, direction.dx) * (tolerance / length);
  var visible = Path()
    ..moveTo((wall.start + normal).dx, (wall.start + normal).dy)
    ..lineTo((wall.end + normal).dx, (wall.end + normal).dy)
    ..lineTo((wall.end - normal).dx, (wall.end - normal).dy)
    ..lineTo((wall.start - normal).dx, (wall.start - normal).dy)
    ..close();
  for (final clip in clips) {
    visible = Path.combine(PathOperation.intersect, visible, clip);
  }
  final unit = direction / length;
  for (final contour in visible.computeMetrics()) {
    var min = double.infinity;
    var max = double.negativeInfinity;
    for (var step = 0; step <= 16; step++) {
      final point = contour
          .getTangentForOffset(contour.length * step / 16)
          ?.position;
      if (point == null) continue;
      final offset = point - wall.start;
      final distance = offset.dx * unit.dx + offset.dy * unit.dy;
      min = math.min(min, distance);
      max = math.max(max, distance);
    }
    if (min.isFinite && max - min > tolerance) {
      yield MapVolumeWall(wall.start + unit * min, wall.start + unit * max);
    }
  }
}

List<(int, int)>? _gridCells(Rect bounds, double size) {
  if (!bounds.isFinite || !size.isFinite || size <= 0) return null;
  final left = (bounds.left / size).floor();
  final right = (bounds.right / size).floor();
  final top = (bounds.top / size).floor();
  final bottom = (bounds.bottom / size).floor();
  if ((right - left + 1) * (bottom - top + 1) > 256) return null;
  return [
    for (var x = left; x <= right; x++)
      for (var y = top; y <= bottom; y++) (x, y),
  ];
}
