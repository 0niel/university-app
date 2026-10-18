import 'package:rtu_mirea_app/map/data/map_data_models.dart';
import 'package:rtu_mirea_app/map/navigation/navigation.dart';

enum MapRouteEndpoint { start, destination }

class MapRouteDestinations {
  MapRouteDestinations({required this.campus, required this.planner}) {
    for (final node in planner.graph.nodes) {
      if (campus.floorForId(node.floorId) == null) continue;
      final place = campus.placeForId(node.roomId ?? '');
      if (place?.raw['navigation_needs_review'] == true) continue;
      if (place == null &&
          (node.roomId != null ||
              (node.label?.trim().isEmpty ?? true) ||
              _technicalKinds.contains(node.kind))) {
        continue;
      }
      final key = place == null ? 'node:${node.id}' : 'place:${place.id}';
      _keysByNode[node.id] = key;
      (_nodesByKey[key] ??= []).add(node);
    }
  }

  final CampusMapData campus;
  final IndoorRoutePlanner planner;
  final _nodesByKey = <String, List<IndoorNavigationNode>>{};
  final _keysByNode = <String, String>{};
  late final Map<MapRouteEndpoint, List<IndoorNavigationNode>>
  _defaultCandidates = {
    for (final endpoint in MapRouteEndpoint.values)
      endpoint: _candidates(endpoint: endpoint),
  };
  late final Map<MapRouteEndpoint, Set<String?>> _defaultKeys = {
    for (final entry in _defaultCandidates.entries)
      entry.key: entry.value.map((node) => _keysByNode[node.id]).toSet(),
  };

  bool supportsRoom(
    String? roomId, {
    required MapRouteEndpoint endpoint,
    IndoorNavigationNode? opposite,
    IndoorRouteOptions options = const IndoorRouteOptions(),
  }) {
    final place = roomId == null ? null : campus.placeForId(roomId);
    if (place == null) return false;
    final key = 'place:${place.id}';
    if (opposite == null && options == const IndoorRouteOptions()) {
      return _defaultKeys[endpoint]!.contains(key);
    }
    return candidates(
      endpoint: endpoint,
      opposite: opposite,
      options: options,
    ).any((node) => _keysByNode[node.id] == key);
  }

  Set<String> nodeIdsFor(IndoorNavigationNode node) => Set.unmodifiable(
    _nodesByKey[_keysByNode[node.id]]?.map((entry) => entry.id) ??
        const <String>[],
  );

  IndoorNavigationNode? nodeForRoom(
    String? roomId, {
    IndoorRouteOptions options = const IndoorRouteOptions(),
  }) {
    if (roomId == null) return null;
    final place = campus.placeForId(roomId);
    if (place == null) return null;
    final nodes = _nodesByKey['place:${place.id}'];
    if (nodes == null) return null;
    for (final node in nodes) {
      if (_available(node, options)) return node;
    }
    return null;
  }

  List<IndoorNavigationNode> candidates({
    required MapRouteEndpoint endpoint,
    IndoorNavigationNode? opposite,
    IndoorRouteOptions options = const IndoorRouteOptions(),
  }) => opposite == null && options == const IndoorRouteOptions()
      ? _defaultCandidates[endpoint]!
      : _candidates(endpoint: endpoint, opposite: opposite, options: options);

  List<IndoorNavigationNode> _candidates({
    required MapRouteEndpoint endpoint,
    IndoorNavigationNode? opposite,
    IndoorRouteOptions options = const IndoorRouteOptions(),
  }) {
    final available = {
      for (final entry in _nodesByKey.entries)
        entry.key: entry.value
            .where((node) => _available(node, options))
            .toList(),
    }..removeWhere((_, nodes) => nodes.isEmpty);
    final direction = endpoint == MapRouteEndpoint.start
        ? IndoorRouteDirection.reverse
        : IndoorRouteDirection.forward;
    if (opposite == null) {
      final connected = planner.connectedEndpointNodeIds(
        endpoints: {
          for (final entry in available.entries)
            entry.key: entry.value.map((node) => node.id),
        },
        direction: direction,
        options: options,
      );
      return List.unmodifiable([
        for (final entry in available.entries)
          if (connected[entry.key]?.isNotEmpty ?? false)
            entry.value.firstWhere(
              (node) => connected[entry.key]!.contains(node.id),
            ),
      ]);
    }
    final reachable = planner.reachableNodeIds(
      nodeIds: nodeIdsFor(opposite),
      direction: direction,
      options: options,
    );
    return List.unmodifiable([
      for (final nodes in available.values)
        if (nodes.any((node) => reachable.contains(node.id)))
          nodes.firstWhere((node) => reachable.contains(node.id)),
    ]);
  }

  bool _available(IndoorNavigationNode node, IndoorRouteOptions options) =>
      !node.closed &&
      !options.closedNodeIds.contains(node.id) &&
      (!options.wheelchair || node.wheelchairAccessible);
}

const _technicalKinds = {
  'door',
  'stairs',
  'elevator',
  'escalator',
  'corridor',
  'junction',
  'portal',
};
