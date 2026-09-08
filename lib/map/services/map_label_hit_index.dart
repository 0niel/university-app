import 'dart:ui';

class MapLabelHitIndex {
  Map<String, Rect> _bounds = const {};

  Map<String, Rect> get bounds => _bounds;

  void clear() => _bounds = const {};

  void replace(Map<String, Rect> boundsById) {
    _bounds = Map.unmodifiable(boundsById);
  }

  String? hitTest(Offset scenePoint) {
    if (!scenePoint.dx.isFinite || !scenePoint.dy.isFinite) return null;
    for (final entry in _bounds.entries) {
      if (entry.value.contains(scenePoint)) return entry.key;
    }
    return null;
  }
}
