enum IndoorEdgeKind {
  corridor,
  stairs,
  elevator,
  ramp,
  escalator,
  door,
  outdoor,
}

class IndoorNavigationNode {
  const IndoorNavigationNode({
    required this.id,
    required this.floorId,
    required this.x,
    required this.y,
    this.roomId,
    this.label,
    this.kind,
    this.wheelchairAccessible = false,
    this.closed = false,
  });

  factory IndoorNavigationNode.fromJson(Map<String, dynamic> json) =>
      IndoorNavigationNode(
        id: _requiredString(json, 'id'),
        floorId: _requiredString(json, 'floor_id'),
        x: _requiredNumber(json, 'x'),
        y: _requiredNumber(json, 'y'),
        roomId: _optionalString(json, 'room_id'),
        label: _optionalString(json, 'label'),
        kind: _optionalString(json, 'kind'),
        wheelchairAccessible: _boolean(json, 'wheelchair_accessible'),
        closed: _boolean(json, 'closed'),
      );

  final String id;
  final String floorId;
  final double x;
  final double y;
  final String? roomId;
  final String? label;
  final String? kind;
  final bool wheelchairAccessible;
  final bool closed;

  String get displayLabel => label ?? roomId ?? id;
}

class IndoorNavigationEdge {
  const IndoorNavigationEdge({
    required this.id,
    required this.fromNodeId,
    required this.toNodeId,
    this.distanceMeters,
    this.traversalCost,
    this.durationSeconds,
    this.bidirectional = false,
    this.kind = IndoorEdgeKind.corridor,
    this.wheelchairAccessible = false,
    this.closed = false,
  });

  factory IndoorNavigationEdge.fromJson(Map<String, dynamic> json) {
    final kind = _optionalString(json, 'kind') ?? 'corridor';
    final parsedKind = IndoorEdgeKind.values.where((item) => item.name == kind);
    if (parsedKind.isEmpty) {
      throw FormatException('Unknown navigation edge kind: $kind');
    }
    return IndoorNavigationEdge(
      id: _requiredString(json, 'id'),
      fromNodeId: _requiredString(json, 'from_node_id'),
      toNodeId: _requiredString(json, 'to_node_id'),
      distanceMeters: json['distance_meters'] == null
          ? null
          : _requiredNumber(json, 'distance_meters'),
      traversalCost: json['traversal_cost'] == null
          ? null
          : _requiredNumber(json, 'traversal_cost'),
      durationSeconds: json['duration_seconds'] == null
          ? null
          : _requiredNumber(json, 'duration_seconds'),
      bidirectional: _boolean(json, 'bidirectional'),
      kind: parsedKind.single,
      wheelchairAccessible: _boolean(json, 'wheelchair_accessible'),
      closed: _boolean(json, 'closed'),
    );
  }

  final String id;
  final String fromNodeId;
  final String toNodeId;
  final double? distanceMeters;
  final double? traversalCost;
  final double? durationSeconds;
  final bool bidirectional;
  final IndoorEdgeKind kind;
  final bool wheelchairAccessible;
  final bool closed;

  bool get hasSteps =>
      kind == IndoorEdgeKind.stairs || kind == IndoorEdgeKind.escalator;

  bool get distanceKnown => distanceMeters != null;
  bool get hasKnownDistance => distanceKnown;
  double get routingCost => traversalCost ?? distanceMeters ?? double.infinity;

  double? get estimatedDurationSeconds {
    if (durationSeconds != null) return durationSeconds;
    final distance = distanceMeters;
    if (distance == null || distance == 0) return distance;
    return switch (kind) {
      IndoorEdgeKind.stairs => distance / 0.6,
      IndoorEdgeKind.escalator => distance / 0.5,
      IndoorEdgeKind.elevator => 20 + distance / 1.5,
      IndoorEdgeKind.ramp => distance,
      IndoorEdgeKind.door => distance / 1.2 + 3,
      IndoorEdgeKind.corridor || IndoorEdgeKind.outdoor => distance / 1.2,
    };
  }
}

class IndoorNavigationGraph {
  factory IndoorNavigationGraph({
    required Iterable<IndoorNavigationNode> nodes,
    required Iterable<IndoorNavigationEdge> edges,
  }) {
    final immutableNodes = List<IndoorNavigationNode>.unmodifiable(nodes);
    final immutableEdges = List<IndoorNavigationEdge>.unmodifiable(edges);
    final nodesById = <String, IndoorNavigationNode>{};
    for (final node in immutableNodes) {
      if (node.id.trim().isEmpty || node.floorId.trim().isEmpty) {
        throw const FormatException('Navigation nodes need an id and floor_id');
      }
      if (!node.x.isFinite || !node.y.isFinite) {
        throw FormatException('Node ${node.id} has invalid coordinates');
      }
      if (nodesById.containsKey(node.id)) {
        throw FormatException('Duplicate navigation node: ${node.id}');
      }
      nodesById[node.id] = node;
    }
    final edgeIds = <String>{};
    for (final edge in immutableEdges) {
      if (edge.id.trim().isEmpty || !edgeIds.add(edge.id)) {
        throw FormatException('Empty or duplicate navigation edge: ${edge.id}');
      }
      final from = nodesById[edge.fromNodeId];
      final to = nodesById[edge.toNodeId];
      if (from == null || to == null) {
        throw FormatException('Edge ${edge.id} references an unknown node');
      }
      final distance = edge.distanceMeters;
      if (distance != null && (!distance.isFinite || distance < 0)) {
        throw FormatException(
          'Edge ${edge.id} needs a nonnegative finite distance',
        );
      }
      final cost = edge.traversalCost;
      if ((cost != null && (!cost.isFinite || cost <= 0)) ||
          (distance == null && cost == null)) {
        throw FormatException(
          'Edge ${edge.id} needs a positive traversal cost '
          'when distance is unknown',
        );
      }
      final duration = edge.estimatedDurationSeconds;
      if (duration != null && (!duration.isFinite || duration < 0)) {
        throw FormatException(
          'Edge ${edge.id} needs a nonnegative finite duration',
        );
      }
      if (from.floorId != to.floorId &&
          (edge.kind == IndoorEdgeKind.corridor ||
              edge.kind == IndoorEdgeKind.door)) {
        throw FormatException('Edge ${edge.id} has no floor transition type');
      }
    }
    return IndoorNavigationGraph._(
      nodes: immutableNodes,
      edges: immutableEdges,
      nodesById: Map.unmodifiable(nodesById),
    );
  }

  factory IndoorNavigationGraph.fromJson(Map<String, dynamic> json) =>
      IndoorNavigationGraph(
        nodes: _objects(json, 'nodes').map(IndoorNavigationNode.fromJson),
        edges: _objects(json, 'edges').map(IndoorNavigationEdge.fromJson),
      );

  const IndoorNavigationGraph._({
    required this.nodes,
    required this.edges,
    required this.nodesById,
  });

  final List<IndoorNavigationNode> nodes;
  final List<IndoorNavigationEdge> edges;
  final Map<String, IndoorNavigationNode> nodesById;

  bool get hasCompleteDistance => edges.every((edge) => edge.distanceKnown);
  bool get hasCompleteDuration =>
      edges.every((edge) => edge.estimatedDurationSeconds != null);

  Iterable<IndoorNavigationNode> nodesForRoom(String roomId) =>
      nodes.where((node) => node.roomId == roomId);
}

String _requiredString(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is! String || value.trim().isEmpty) {
    throw FormatException('Expected a nonempty string for $key');
  }
  return value;
}

String? _optionalString(Map<String, dynamic> json, String key) {
  if (json[key] == null) return null;
  return _requiredString(json, key);
}

double _requiredNumber(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is! num || !value.isFinite) {
    throw FormatException('Expected a finite number for $key');
  }
  return value.toDouble();
}

bool _boolean(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value == null) return false;
  if (value is! bool) throw FormatException('Expected a boolean for $key');
  return value;
}

Iterable<Map<String, dynamic>> _objects(
  Map<String, dynamic> json,
  String key,
) sync* {
  final value = json[key];
  if (value is! List) throw FormatException('Expected an array for $key');
  for (final item in value) {
    if (item is! Map<String, dynamic>) {
      throw FormatException('Expected objects in $key');
    }
    yield item;
  }
}
