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
