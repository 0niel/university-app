import 'dart:ui';

class MapBoundarySegment {
  const MapBoundarySegment(this.from, this.to);

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
