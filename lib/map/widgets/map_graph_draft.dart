import 'dart:ui';

import 'package:collection/collection.dart';

import 'package:rtu_mirea_app/map/data/map_data_models.dart';
import 'package:rtu_mirea_app/map/navigation/navigation.dart';

class MapGraphDraft {
  MapGraphDraft(this.campus)
    : _nodes = mapJsonRows(campus.graph['nodes']).map(Map.of).toList(),
      _edges = mapJsonRows(campus.graph['edges']).map(Map.of).toList();

  final CampusMapData campus;
  final List<Map<String, Object?>> _nodes;
  List<Map<String, Object?>> _edges;
  final _history = <void Function()>[];
  final _unmeasuredEdges = <String>{};
  List<IndoorNavigationNode>? _nodeCache;
  List<IndoorNavigationEdge>? _edgeCache;
  Map<String, IndoorNavigationNode>? _nodeIndex;

  bool get canUndo => _history.isNotEmpty;
  bool get needsDistanceReview => _unmeasuredEdges.isNotEmpty;
  List<IndoorNavigationNode> get nodes => _nodeCache ??= List.unmodifiable(
    _nodes.map(
      (row) => IndoorNavigationNode.fromJson(Map.of(row)),
    ),
  );
  List<IndoorNavigationEdge> get edges => _edgeCache ??= List.unmodifiable(
    _edges.map(
      (row) => IndoorNavigationEdge.fromJson(Map.of(row)),
    ),
  );
  IndoorNavigationNode? nodeForId(String? id) =>
      (_nodeIndex ??= {for (final node in nodes) node.id: node})[id];

  Map<String, Object?> get patch => {
    'nodes': _nodes.map(Map<String, Object?>.of).toList(),
    'edges': _edges.map(Map<String, Object?>.of).toList(),
  };

  void _remember(void Function() restore) {
    final unmeasured = Set.of(_unmeasuredEdges);
    _history.add(() {
      restore();
      _unmeasuredEdges
        ..clear()
        ..addAll(unmeasured);
    });
    if (_history.length > 40) _history.removeAt(0);
  }

  void _invalidate({bool invalidateNodes = true, bool invalidateEdges = true}) {
    if (invalidateNodes) {
      _nodeCache = null;
      _nodeIndex = null;
    }
    if (invalidateEdges) _edgeCache = null;
  }

  void undo() {
    if (!canUndo) return;
    _history.removeLast()();
    _invalidate();
  }

  void saveNode(Map<String, Object?> row) {
    final node = IndoorNavigationNode.fromJson(Map.of(row));
    final floor = campus.floorForId(node.floorId);
    if (floor == null ||
        node.x < 0 ||
        node.y < 0 ||
        node.x > floor.width ||
        node.y > floor.height) {
      throw const FormatException(
        'Точка должна находиться внутри плана этажа.',
      );
    }
    if (node.roomId != null &&
        !campus.rooms.any(
          (room) => room.id == node.roomId && room.floorId == node.floorId,
        )) {
      throw const FormatException('Выберите помещение на этом этаже.');
    }
    final index = _nodes.indexWhere((item) => item['id'] == node.id);
    final previous = index < 0 ? null : _nodes.elementAtOrNull(index);
    _remember(() {
      if (previous == null) {
        _nodes.removeWhere((item) => item['id'] == node.id);
      } else {
        _nodes[index] = previous;
      }
    });
    if (index < 0) {
      _nodes.add(Map.of(row));
    } else {
      _nodes[index] = {...?previous, ...row};
    }
    _invalidate(invalidateEdges: false);
  }

  void moveNode(String id, Offset point) {
    final row = _nodes.firstWhereOrNull((item) => item['id'] == id);
    if (row == null) throw ArgumentError.value(id, 'id', 'Unknown node');
    saveNode({...row, 'x': point.dx, 'y': point.dy});
    _unmeasuredEdges.addAll(
      _edges
          .where(
            (edge) => edge['from_node_id'] == id || edge['to_node_id'] == id,
          )
          .map((edge) => edge['id']! as String),
    );
  }

  void removeNode(String id) {
    final index = _nodes.indexWhere((item) => item['id'] == id);
    if (index < 0) return;
    final previous = _nodes.elementAtOrNull(index);
    if (previous == null) return;
    final links = [
      for (var i = 0; i < _edges.length; i++)
        if (_edges[i]['from_node_id'] == id || _edges[i]['to_node_id'] == id)
          (i, _edges[i]),
    ];
    _remember(() {
      _nodes.insert(index, previous);
      for (final (position, edge) in links) {
        _edges.insert(position, edge);
      }
    });
    _nodes.removeWhere((item) => item['id'] == id);
    _edges.removeWhere(
      (item) => item['from_node_id'] == id || item['to_node_id'] == id,
    );
    _unmeasuredEdges.retainAll(_edges.map((edge) => edge['id']! as String));
    _invalidate();
  }

  void saveEdge(Map<String, Object?> row) {
    final edge = IndoorNavigationEdge.fromJson(Map.of(row));
    if (edge.fromNodeId == edge.toNodeId) {
      throw const FormatException('Выберите две разные точки.');
    }
    final from = nodeForId(edge.fromNodeId);
    final to = nodeForId(edge.toNodeId);
    if (from == null || to == null) {
      throw const FormatException('Обе точки должны существовать на плане.');
    }
    if (from.floorId != to.floorId &&
        !const {
          IndoorEdgeKind.stairs,
          IndoorEdgeKind.elevator,
          IndoorEdgeKind.ramp,
          IndoorEdgeKind.escalator,
          IndoorEdgeKind.outdoor,
        }.contains(edge.kind)) {
      throw const FormatException(
        'Выберите подходящий тип перехода между этажами.',
      );
    }
    if (edge.hasSteps && edge.wheelchairAccessible) {
      throw const FormatException(
        'Ступени не подходят для маршрута без лестниц.',
      );
    }
    final next = _edges.where((item) => item['id'] != edge.id).toList()
      ..add(row);
    final validated = IndoorNavigationGraph.fromJson({
      'nodes': _nodes,
      'edges': next,
    });
    final index = _edges.indexWhere((item) => item['id'] == edge.id);
    final previous = index < 0 ? null : _edges.elementAtOrNull(index);
    _remember(() {
      _edges.removeWhere((item) => item['id'] == edge.id);
      if (previous != null) _edges.insert(index, previous);
    });
    _edges = next;
    _edgeCache = validated.edges;
    _unmeasuredEdges.remove(edge.id);
  }

  void removeEdge(String id) {
    final index = _edges.indexWhere((item) => item['id'] == id);
    if (index < 0) return;
    final previous = _edges.elementAtOrNull(index);
    if (previous == null) return;
    _remember(() => _edges.insert(index, previous));
    _edges.removeAt(index);
    _unmeasuredEdges.remove(id);
    _invalidate(invalidateNodes: false);
  }

  IndoorNavigationGraph validate() {
    if (needsDistanceReview) {
      throw const FormatException(
        'После переноса точки откройте её проходы и проверьте длины.',
      );
    }
    return IndoorNavigationGraph.fromJson(Map.of(patch));
  }
}
