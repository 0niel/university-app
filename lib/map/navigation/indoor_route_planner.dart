import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:rtu_mirea_app/map/navigation/indoor_navigation_graph.dart';

enum IndoorRouteMetric { distance, duration }

enum IndoorRouteStatus {
  found,
  unknownStart,
  unknownDestination,
  closedEndpoint,
  inaccessibleEndpoint,
  unreachable,
}

enum IndoorManeuver {
  depart,
  straight,
  turnLeft,
  turnRight,
  turnBack,
  stairs,
  elevator,
  ramp,
  escalator,
  floorTransition,
  arrive,
}

class IndoorRouteOptions {
  const IndoorRouteOptions({
    this.stepFree = false,
    this.wheelchair = false,
    this.metric = IndoorRouteMetric.distance,
    this.closedEdgeIds = const {},
    this.closedNodeIds = const {},
  });

  final bool stepFree;
  final bool wheelchair;
  final IndoorRouteMetric metric;
  final Set<String> closedEdgeIds;
  final Set<String> closedNodeIds;
}

class IndoorRouteLeg {
  const IndoorRouteLeg({
    required this.from,
    required this.to,
    required this.edge,
  });

  final IndoorNavigationNode from;
  final IndoorNavigationNode to;
  final IndoorNavigationEdge edge;

  double? get distanceMeters => edge.distanceMeters;
  double? get durationSeconds => edge.estimatedDurationSeconds;
  bool get changesFloor => from.floorId != to.floorId;
}

class IndoorRouteInstruction {
  const IndoorRouteInstruction({
    required this.maneuver,
    required this.atNode,
    this.toNode,
    this.distanceMeters = 0,
  });

  final IndoorManeuver maneuver;
  final IndoorNavigationNode atNode;
  final IndoorNavigationNode? toNode;
  final double? distanceMeters;

  String get floorId => atNode.floorId;
  String? get destinationFloorId => toNode?.floorId;
}

class IndoorRouteFloorSegment {
  IndoorRouteFloorSegment._(this.floorId, Iterable<IndoorNavigationNode> nodes)
    : nodes = List.unmodifiable(nodes);

  final String floorId;
  final List<IndoorNavigationNode> nodes;
}

class IndoorRoute {
  IndoorRoute._({
    required Iterable<IndoorNavigationNode> nodes,
    required Iterable<IndoorRouteLeg> legs,
    required Iterable<IndoorRouteInstruction> instructions,
    required this.distanceMeters,
    required this.durationSeconds,
  }) : nodes = List.unmodifiable(nodes),
       legs = List.unmodifiable(legs),
       instructions = List.unmodifiable(instructions);

  final List<IndoorNavigationNode> nodes;
  final List<IndoorRouteLeg> legs;
  final List<IndoorRouteInstruction> instructions;
  final double? distanceMeters;
  final double? durationSeconds;
  late final List<IndoorRouteFloorSegment> floorSegments =
      _splitFloorSegments();

  List<String> get floorIds =>
      nodes.map((node) => node.floorId).toSet().toList();

  Iterable<IndoorRouteFloorSegment> segmentsForFloor(String floorId) =>
      floorSegments.where((segment) => segment.floorId == floorId);

  bool get hasCompleteDistance => distanceMeters != null;
  bool get hasCompleteDuration => durationSeconds != null;
  bool get hasEstimatedDuration =>
      hasCompleteDuration &&
      legs.any((leg) => leg.edge.durationSeconds == null);

  List<IndoorRouteFloorSegment> _splitFloorSegments() {
    final segments = <IndoorRouteFloorSegment>[];
    var current = <IndoorNavigationNode>[];
    for (final node in nodes) {
      if (current.isNotEmpty && current.last.floorId != node.floorId) {
        segments.add(IndoorRouteFloorSegment._(current.first.floorId, current));
        current = [];
      }
      current.add(node);
    }
    if (current.isNotEmpty) {
      segments.add(IndoorRouteFloorSegment._(current.first.floorId, current));
    }
    return List.unmodifiable(segments);
  }
}

class IndoorRouteResult {
  const IndoorRouteResult._(this.status, [this.route]);

  final IndoorRouteStatus status;
  final IndoorRoute? route;

  bool get hasRoute => status == IndoorRouteStatus.found;
}

class IndoorRoutePlanner {
  IndoorRoutePlanner(this.graph) {
    for (final edge in graph.edges) {
      final from = graph.nodesById[edge.fromNodeId]!;
      final to = graph.nodesById[edge.toNodeId]!;
      (_adjacency[from.id] ??= []).add(
        IndoorRouteLeg(from: from, to: to, edge: edge),
      );
      if (edge.bidirectional) {
        (_adjacency[to.id] ??= []).add(
          IndoorRouteLeg(from: to, to: from, edge: edge),
        );
      }
    }
  }

  final IndoorNavigationGraph graph;
  final _adjacency = <String, List<IndoorRouteLeg>>{};

  IndoorRouteResult findRoute({
    required String startNodeId,
    required String destinationNodeId,
    IndoorRouteOptions options = const IndoorRouteOptions(),
  }) => findRouteBetween(
    startNodeIds: [startNodeId],
    destinationNodeIds: [destinationNodeId],
    options: options,
  );

  IndoorRouteResult findRouteBetween({
    required Iterable<String> startNodeIds,
    required Iterable<String> destinationNodeIds,
    IndoorRouteOptions options = const IndoorRouteOptions(),
  }) {
    final starts = startNodeIds
        .toSet()
        .map((id) => graph.nodesById[id])
        .nonNulls
        .toList();
    final destinations = destinationNodeIds
        .toSet()
        .map((id) => graph.nodesById[id])
        .nonNulls
        .toList();
    if (starts.isEmpty) {
      return const IndoorRouteResult._(IndoorRouteStatus.unknownStart);
    }
    if (destinations.isEmpty) {
      return const IndoorRouteResult._(IndoorRouteStatus.unknownDestination);
    }
    final openStarts = starts
        .where((node) => !_nodeClosed(node, options))
        .toList();
    final openDestinations = destinations
        .where((node) => !_nodeClosed(node, options))
        .toList();
    if (openStarts.isEmpty || openDestinations.isEmpty) {
      return const IndoorRouteResult._(IndoorRouteStatus.closedEndpoint);
    }
    final availableStarts = openStarts
        .where((node) => !options.wheelchair || node.wheelchairAccessible)
        .toList();
    final availableDestinationIds = openDestinations
        .where((node) => !options.wheelchair || node.wheelchairAccessible)
        .map((node) => node.id)
        .toSet();
    if (availableStarts.isEmpty || availableDestinationIds.isEmpty) {
      return const IndoorRouteResult._(IndoorRouteStatus.inaccessibleEndpoint);
    }
    final costs = <String, double>{
      for (final start in availableStarts) start.id: 0,
    };
    final previous = <String, IndoorRouteLeg>{};
    var sequence = 0;
    final queue = HeapPriorityQueue<_QueueEntry>((a, b) {
      final comparison = a.cost.compareTo(b.cost);
      return comparison == 0 ? a.sequence.compareTo(b.sequence) : comparison;
    });
    for (final start in availableStarts) {
      queue.add(_QueueEntry(start.id, 0, sequence++));
    }

    while (queue.isNotEmpty) {
      final current = queue.removeFirst();
      if (current.cost != costs[current.nodeId]) continue;
      if (availableDestinationIds.contains(current.nodeId)) {
        return _buildRoute(graph.nodesById[current.nodeId]!, previous);
      }
      for (final leg in _adjacency[current.nodeId] ?? <IndoorRouteLeg>[]) {
        if (!_allowed(leg, options)) continue;
        final weight = options.metric == IndoorRouteMetric.distance
            ? leg.edge.routingCost
            : leg.durationSeconds ?? leg.edge.routingCost;
        final cost = current.cost + weight;
        if (!cost.isFinite || cost >= (costs[leg.to.id] ?? double.infinity)) {
          continue;
        }
        costs[leg.to.id] = cost;
        previous[leg.to.id] = leg;
        queue.add(_QueueEntry(leg.to.id, cost, sequence++));
      }
    }
    return const IndoorRouteResult._(IndoorRouteStatus.unreachable);
  }

  bool _allowed(IndoorRouteLeg leg, IndoorRouteOptions options) {
    if (leg.edge.closed ||
        options.closedEdgeIds.contains(leg.edge.id) ||
        _nodeClosed(leg.to, options)) {
      return false;
    }
    if ((options.stepFree || options.wheelchair) && leg.edge.hasSteps) {
      return false;
    }
    if (options.wheelchair &&
        (!leg.edge.wheelchairAccessible || !leg.to.wheelchairAccessible)) {
      return false;
    }
    return true;
  }

  bool _nodeClosed(IndoorNavigationNode node, IndoorRouteOptions options) =>
      node.closed || options.closedNodeIds.contains(node.id);

  IndoorRouteResult _buildRoute(
    IndoorNavigationNode destination,
    Map<String, IndoorRouteLeg> previous,
  ) {
    final reversed = <IndoorRouteLeg>[];
    var start = destination;
    while (true) {
      final leg = previous[start.id];
      if (leg == null) break;
      reversed.add(leg);
      start = leg.from;
    }
    final legs = reversed.reversed.toList();
    final distanceMeters = legs.every((leg) => leg.distanceMeters != null)
        ? legs.fold<double>(0, (sum, leg) => sum + leg.distanceMeters!)
        : null;
    final durationSeconds = legs.every((leg) => leg.durationSeconds != null)
        ? legs.fold<double>(0, (sum, leg) => sum + leg.durationSeconds!)
        : null;
    if ((distanceMeters != null && !distanceMeters.isFinite) ||
        (durationSeconds != null && !durationSeconds.isFinite)) {
      return const IndoorRouteResult._(IndoorRouteStatus.unreachable);
    }
    final nodes = [start, ...legs.map((leg) => leg.to)];
    final instructions = <IndoorRouteInstruction>[];
    if (legs.isNotEmpty) {
      instructions.add(
        IndoorRouteInstruction(maneuver: IndoorManeuver.depart, atNode: start),
      );
    }
    IndoorRouteLeg? previousBearing;
    for (final leg in legs) {
      final maneuver = _maneuver(previousBearing, leg);
      final previousInstruction = instructions.lastOrNull;
      if (maneuver == IndoorManeuver.straight &&
          previousInstruction != null &&
          _isWalkingManeuver(previousInstruction.maneuver) &&
          previousInstruction.toNode?.id == leg.from.id &&
          previousInstruction.atNode.floorId == leg.to.floorId) {
        instructions[instructions.length - 1] = IndoorRouteInstruction(
          maneuver: previousInstruction.maneuver,
          atNode: previousInstruction.atNode,
          toNode: leg.to,
          distanceMeters:
              previousInstruction.distanceMeters == null ||
                  leg.distanceMeters == null
              ? null
              : previousInstruction.distanceMeters! + leg.distanceMeters!,
        );
      } else {
        instructions.add(
          IndoorRouteInstruction(
            maneuver: maneuver,
            atNode: leg.from,
            toNode: leg.to,
            distanceMeters: leg.distanceMeters,
          ),
        );
      }
      if (leg.changesFloor) {
        previousBearing = null;
      } else if (leg.from.x != leg.to.x || leg.from.y != leg.to.y) {
        previousBearing = leg;
      }
    }
    instructions.add(
      IndoorRouteInstruction(
        maneuver: IndoorManeuver.arrive,
        atNode: destination,
      ),
    );
    return IndoorRouteResult._(
      IndoorRouteStatus.found,
      IndoorRoute._(
        nodes: nodes,
        legs: legs,
        instructions: instructions,
        distanceMeters: distanceMeters,
        durationSeconds: durationSeconds,
      ),
    );
  }

  IndoorManeuver _maneuver(IndoorRouteLeg? previous, IndoorRouteLeg current) {
    if (current.changesFloor || current.edge.hasSteps) {
      return switch (current.edge.kind) {
        IndoorEdgeKind.stairs => IndoorManeuver.stairs,
        IndoorEdgeKind.elevator => IndoorManeuver.elevator,
        IndoorEdgeKind.ramp => IndoorManeuver.ramp,
        IndoorEdgeKind.escalator => IndoorManeuver.escalator,
        _ => IndoorManeuver.floorTransition,
      };
    }
    if (previous == null || previous.changesFloor) {
      return IndoorManeuver.straight;
    }
    final beforeX = previous.to.x - previous.from.x;
    final beforeY = previous.to.y - previous.from.y;
    final afterX = current.to.x - current.from.x;
    final afterY = current.to.y - current.from.y;
    if ((beforeX == 0 && beforeY == 0) || (afterX == 0 && afterY == 0)) {
      return IndoorManeuver.straight;
    }
    var angle = math.atan2(afterY, afterX) - math.atan2(beforeY, beforeX);
    if (angle > math.pi) angle -= 2 * math.pi;
    if (angle < -math.pi) angle += 2 * math.pi;
    if (angle.abs() >= math.pi * 5 / 6) return IndoorManeuver.turnBack;
    if (angle.abs() < math.pi / 6) return IndoorManeuver.straight;
    return angle > 0 ? IndoorManeuver.turnRight : IndoorManeuver.turnLeft;
  }

  bool _isWalkingManeuver(IndoorManeuver maneuver) => switch (maneuver) {
    IndoorManeuver.straight ||
    IndoorManeuver.turnLeft ||
    IndoorManeuver.turnRight ||
    IndoorManeuver.turnBack => true,
    _ => false,
  };
}

class _QueueEntry {
  const _QueueEntry(this.nodeId, this.cost, this.sequence);

  final String nodeId;
  final double cost;
  final int sequence;
}
