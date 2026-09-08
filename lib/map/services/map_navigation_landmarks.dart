import 'package:rtu_mirea_app/map/data/map_data_models.dart';
import 'package:rtu_mirea_app/map/navigation/indoor_navigation_graph.dart';

class MapNavigationLandmark {
  MapNavigationLandmark._({
    required this.place,
    required Iterable<String> nodeIds,
    required Iterable<String> outgoingFloorIds,
    required this.closed,
  }) : nodeIds = Set.unmodifiable(nodeIds),
       outgoingFloorIds = Set.unmodifiable(outgoingFloorIds);

  final MapPlaceData place;
  final Set<String> nodeIds;
  final Set<String> outgoingFloorIds;
  final bool closed;
}

List<MapNavigationLandmark> mapNavigationLandmarks(
  IndoorNavigationGraph graph, {
  Iterable<MapPlaceData> places = const [],
}) {
  final kindsByNode = <String, Set<String>>{};
  final outgoing = <(String, String), Set<String>>{};
  for (final node in graph.nodes) {
    final kind = _connectorKind(node.kind);
    if (kind != null) kindsByNode[node.id] = {kind};
  }
  for (final edge in graph.edges) {
    final kind = _connectorKind(edge.kind.name);
    if (kind == null) continue;
    final from = graph.nodesById[edge.fromNodeId]!;
    final to = graph.nodesById[edge.toNodeId]!;
    kindsByNode.putIfAbsent(from.id, () => {}).add(kind);
    kindsByNode.putIfAbsent(to.id, () => {}).add(kind);
    if (from.floorId == to.floorId || edge.closed || from.closed || to.closed) {
      continue;
    }
    outgoing.putIfAbsent((from.id, kind), () => {}).add(to.floorId);
    if (edge.bidirectional) {
      outgoing.putIfAbsent((to.id, kind), () => {}).add(from.floorId);
    }
  }

  final representedNodes = <(String, String, String)>{};
  final representedPoints = <(String, String, double, double)>{};
  for (final place in places) {
    final kind = _connectorKind(place.kind);
    if (kind == null) continue;
    representedNodes.add((place.id, place.floorId, kind));
    for (final alias in [...place.legacyIds, ?place.sourceDatabaseId]) {
      representedNodes.add((alias, place.floorId, kind));
    }
    representedPoints.add((place.floorId, kind, place.x, place.y));
  }
  final groups =
      <(String, String, double, double), List<IndoorNavigationNode>>{};
  for (final entry in kindsByNode.entries) {
    final node = graph.nodesById[entry.key]!;
    for (final kind in entry.value) {
      final key = (node.floorId, kind, node.x, node.y);
      if (representedPoints.contains(key) ||
          (node.roomId != null &&
              representedNodes.contains((node.roomId, node.floorId, kind)))) {
        continue;
      }
      groups.putIfAbsent(key, () => []).add(node);
    }
  }
  final result = <MapNavigationLandmark>[];
  for (final entry in groups.entries) {
    final nodes = entry.value..sort((a, b) => a.id.compareTo(b.id));
    final first = nodes.first;
    final kind = entry.key.$2;
    final label = switch (kind) {
      'stairs' => 'Лестница',
      'elevator' => 'Лифт',
      'escalator' => 'Эскалатор',
      'ramp' => 'Пандус',
      _ => throw StateError('Unknown connector kind: $kind'),
    };
    result.add(
      MapNavigationLandmark._(
        place: MapPlaceData.fromJson({
          'id': 'navigation:$kind:${first.id}',
          'floor_id': first.floorId,
          'label': label,
          'kind': kind,
          'x': first.x,
          'y': first.y,
        }),
        nodeIds: nodes.map((node) => node.id),
        outgoingFloorIds: {
          for (final node in nodes) ...?outgoing[(node.id, kind)],
        },
        closed: nodes.every((node) => node.closed),
      ),
    );
  }
  result.sort((a, b) => a.place.id.compareTo(b.place.id));
  return List.unmodifiable(result);
}

String? _connectorKind(String? kind) => switch (kind) {
  'stairs' || 'staircase' => 'stairs',
  'elevator' || 'lift' => 'elevator',
  'escalator' => 'escalator',
  'ramp' => 'ramp',
  _ => null,
};
