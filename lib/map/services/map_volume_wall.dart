import 'dart:ui';

class MapVolumeWall {
  const MapVolumeWall(this.start, this.end);

  final Offset start;
  final Offset end;
  Rect get bounds => Rect.fromPoints(start, end).inflate(.001);
}
