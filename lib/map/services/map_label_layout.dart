import 'dart:math' as math;
import 'dart:ui';

class MapLabelCandidate {
  const MapLabelCandidate({
    required this.id,
    required this.anchor,
    required this.size,
    required this.priority,
  });

  final String id;
  final Offset anchor;
  final Size size;
  final int priority;

  Rect get bounds => Rect.fromCenter(
    center: anchor,
    width: size.width,
    height: size.height,
  );
}

List<MapLabelCandidate> placeMapLabels(
  Iterable<MapLabelCandidate> candidates, {
  double gap = 4,
}) {
  if (!gap.isFinite || gap < 0) {
    throw ArgumentError.value(gap, 'gap', 'Must be finite and nonnegative');
  }
  final ordered = candidates.where(_validCandidate).toList()
    ..sort(_compareCandidates);
  final result = <MapLabelCandidate>[];
  final accepted = <Rect>[];
  final oversized = <Rect>[];
  final grid = <(int, int), List<Rect>>{};
  final placedIds = <String>{};
  const cellSize = 64.0;
  const maximumCells = 256;

  for (final candidate in ordered) {
    if (placedIds.contains(candidate.id)) continue;
    final bounds = candidate.bounds.inflate(gap);
    if (!_validBounds(bounds)) continue;
    final useGlobalIndex =
        bounds.width > cellSize * maximumCells ||
        bounds.height > cellSize * maximumCells ||
        bounds.left.abs() > 1e12 ||
        bounds.top.abs() > 1e12 ||
        bounds.right.abs() > 1e12 ||
        bounds.bottom.abs() > 1e12;
    final minX = useGlobalIndex ? 0 : (bounds.left / cellSize).floor();
    final maxX = useGlobalIndex ? 0 : (bounds.right / cellSize).floor();
    final minY = useGlobalIndex ? 0 : (bounds.top / cellSize).floor();
    final maxY = useGlobalIndex ? 0 : (bounds.bottom / cellSize).floor();
    final columns = maxX - minX + 1;
    final rows = maxY - minY + 1;
    final isOversized =
        useGlobalIndex ||
        columns > maximumCells ||
        rows > maximumCells ||
        columns * rows > maximumCells;
    var overlaps = false;
    if (isOversized) {
      overlaps = accepted.any(bounds.overlaps);
    } else {
      overlaps = oversized.any(bounds.overlaps);
      for (var x = minX; x <= maxX && !overlaps; x++) {
        for (var y = minY; y <= maxY && !overlaps; y++) {
          overlaps = grid[(x, y)]?.any(bounds.overlaps) ?? false;
        }
      }
    }
    if (overlaps) continue;
    placedIds.add(candidate.id);
    result.add(candidate);
    accepted.add(bounds);
    if (isOversized) {
      oversized.add(bounds);
    } else {
      for (var x = minX; x <= maxX; x++) {
        for (var y = minY; y <= maxY; y++) {
          (grid[(x, y)] ??= []).add(bounds);
        }
      }
    }
  }
  return result;
}

Offset? mapInteriorLabelAnchor(Path path) {
  final bounds = path.getBounds();
  if (!_validBounds(bounds)) return null;

  final metrics = path.computeMetrics(forceClosed: true).take(32).toList();
  final segments = <_BoundarySegment>[];
  final contourCenters = <Offset>[];
  final samples = math.max(4, 128 ~/ math.max(1, metrics.length));
  for (final metric in metrics) {
    if (!metric.length.isFinite || metric.length <= 0) continue;
    Offset? previous;
    Rect? contourBounds;
    for (var i = 0; i <= samples; i++) {
      final point = metric.getTangentForOffset(metric.length * i / samples);
      if (point == null || !_validOffset(point.position)) continue;
      final position = point.position;
      final pointBounds = Rect.fromLTRB(
        position.dx,
        position.dy,
        position.dx,
        position.dy,
      );
      contourBounds =
          contourBounds?.expandToInclude(pointBounds) ?? pointBounds;
      if (previous != null && previous != position) {
        segments.add(_BoundarySegment(previous, position));
      }
      previous = position;
    }
    if (contourBounds != null) contourCenters.add(contourBounds.center);
  }

  if (segments.isEmpty) return null;

  final tolerance = math.max(bounds.width, bounds.height) * 1e-7;
  Offset? best;
  var bestClearance = tolerance * tolerance;
  void consider(Offset point) {
    if (!path.contains(point)) return;
    final edgeDistance = math.min(
      math.min(point.dx - bounds.left, bounds.right - point.dx),
      math.min(point.dy - bounds.top, bounds.bottom - point.dy),
    );
    var clearance = edgeDistance * edgeDistance;
    for (final segment in segments) {
      clearance = math.min(clearance, segment.squaredDistanceTo(point));
      if (clearance <= bestClearance) return;
    }
    if (clearance > bestClearance) {
      best = point;
      bestClearance = clearance;
    }
  }

  consider(bounds.center);
  if (best != null) return best;

  contourCenters.forEach(consider);
  const divisions = 17;
  for (var y = 0; y < divisions; y++) {
    for (var x = 0; x < divisions; x++) {
      consider(
        Offset(
          bounds.left + bounds.width * (x + .5) / divisions,
          bounds.top + bounds.height * (y + .5) / divisions,
        ),
      );
    }
  }
  if (best != null) return best;

  final inset = math.min(bounds.width, bounds.height) / 2048;
  for (final segment in segments) {
    final delta = segment.to - segment.from;
    final length = delta.distance;
    if (!length.isFinite || length == 0) continue;
    final middle = segment.from + delta / 2;
    final normal = Offset(-delta.dy / length, delta.dx / length) * inset;
    consider(middle + normal);
    consider(middle - normal);
  }
  return best;
}

bool _validCandidate(MapLabelCandidate candidate) =>
    _validOffset(candidate.anchor) &&
    candidate.size.width.isFinite &&
    candidate.size.height.isFinite &&
    candidate.size.width > 0 &&
    candidate.size.height > 0;

bool _validOffset(Offset point) => point.dx.isFinite && point.dy.isFinite;

bool _validBounds(Rect bounds) =>
    bounds.left.isFinite &&
    bounds.top.isFinite &&
    bounds.right.isFinite &&
    bounds.bottom.isFinite &&
    bounds.width.isFinite &&
    bounds.height.isFinite &&
    !bounds.isEmpty;

int _compareCandidates(MapLabelCandidate first, MapLabelCandidate second) {
  final priority = second.priority.compareTo(first.priority);
  if (priority != 0) return priority;
  final id = first.id.compareTo(second.id);
  if (id != 0) return id;
  final x = first.anchor.dx.compareTo(second.anchor.dx);
  if (x != 0) return x;
  final y = first.anchor.dy.compareTo(second.anchor.dy);
  if (y != 0) return y;
  final width = first.size.width.compareTo(second.size.width);
  return width == 0 ? first.size.height.compareTo(second.size.height) : width;
}

class _BoundarySegment {
  const _BoundarySegment(this.from, this.to);

  final Offset from;
  final Offset to;

  double squaredDistanceTo(Offset point) {
    final delta = to - from;
    final lengthSquared = delta.distanceSquared;
    if (lengthSquared == 0) return (point - from).distanceSquared;
    final relative = point - from;
    final ratio =
        ((relative.dx * delta.dx + relative.dy * delta.dy) / lengthSquared)
            .clamp(0.0, 1.0);
    return (point - (from + delta * ratio)).distanceSquared;
  }
}
