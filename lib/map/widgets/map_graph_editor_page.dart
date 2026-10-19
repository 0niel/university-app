import 'dart:async';

import 'dart:math' as math;

import 'package:app_ui/app_ui.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/map/data/map_data_models.dart';
import 'package:rtu_mirea_app/map/data/map_data_repository.dart';
import 'package:rtu_mirea_app/map/navigation/navigation.dart';
import 'package:rtu_mirea_app/map/services/room_key.dart';
import 'package:rtu_mirea_app/map/widgets/map_community_sheet.dart';
import 'package:rtu_mirea_app/map/widgets/map_editor_floor_canvas.dart';
import 'package:rtu_mirea_app/map/widgets/map_graph_draft.dart';

export 'map_editor_floor_canvas.dart';
export 'map_graph_draft.dart';

class MapGraphEditorPage extends StatefulWidget {
  const MapGraphEditorPage({
    required this.campus,
    required this.repository,
    this.initialFloorId,
    super.key,
  });

  final CampusMapData campus;
  final MapDataRepository repository;
  final String? initialFloorId;

  @override
  State<MapGraphEditorPage> createState() => _MapGraphEditorPageState();
}

class _MapGraphEditorPageState extends State<MapGraphEditorPage> {
  late final _draft = MapGraphDraft(widget.campus);
  late MapFloorData? _floor =
      widget.campus.floorForId(
        widget.initialFloorId ?? '',
      ) ??
      widget.campus.floors.firstOrNull;
  String? _selected;
  bool _moving = false;
  bool _connecting = false;
  int _sequence = 0;
  late final _labels = _GraphNodeLabels(widget.campus);

  String _id(String type) =>
      '${type}_${DateTime.now().microsecondsSinceEpoch}_${_sequence++}';

  IndoorNavigationNode? get _selectedNode => _draft.nodeForId(_selected);

  void _message(String message) =>
      ToastManager.showInfo(context, message: message);

  Future<void> _tap(Offset point, double hitRadius) async {
    final floor = _floor;
    if (floor == null) return;
    if (_moving && _selected != null) {
      setState(() {
        _draft.moveNode(_selected!, point);
        _moving = false;
      });
      if (_draft.needsDistanceReview) {
        _message('Точка перенесена. Откройте «Проходы» и проверьте длины.');
      }
      return;
    }
    final nearby =
        _draft.nodes
            .where((node) => node.floorId == floor.floor.id)
            .map((node) => (node, (Offset(node.x, node.y) - point).distance))
            .where((item) => item.$2 <= hitRadius)
            .toList()
          ..sort((a, b) => a.$2.compareTo(b.$2));
    if (nearby.isNotEmpty) {
      if (_connecting) {
        final target = nearby.first.$1;
        if (target.id == _selected) {
          _message('Выберите другую точку прохода.');
          return;
        }
        await _editEdge(toId: target.id);
        return;
      }
      setState(() => _selected = nearby.first.$1.id);
      return;
    }
    if (_connecting) {
      _message('Выберите существующую точку или найдите её через поиск.');
      return;
    }
    await _editNode(point: point);
  }

  Future<void> _editNode({IndoorNavigationNode? node, Offset? point}) async {
    final floor = node == null
        ? _floor
        : widget.campus.floorForId(node.floorId);
    if (floor == null) return;
    final result = await showAppDialog<Map<String, Object?>>(
      context,
      builder: (context) => _NodeDialog(
        id: node?.id ?? _id('node'),
        floor: floor,
        rooms: widget.campus.rooms,
        node: node,
        point: point ?? Offset(node!.x, node.y),
      ),
    );
    if (result == null || !mounted) return;
    try {
      setState(() {
        _draft.saveNode(result);
        _selected = result['id']! as String;
      });
    } on FormatException catch (error) {
      _message(error.message);
    }
  }

  Future<void> _editEdge({IndoorNavigationEdge? edge, String? toId}) async {
    final node = _selectedNode;
    if (node == null) return;
    if (_draft.nodes.length < 2) {
      _message('Сначала добавьте вторую точку прохода на плане.');
      return;
    }
    final result = await showAppDialog<Map<String, Object?>>(
      context,
      builder: (context) => _EdgeDialog(
        campus: widget.campus,
        nodes: _draft.nodes,
        fromId: edge?.fromNodeId ?? node.id,
        id: edge?.id ?? _id('edge'),
        edge: edge,
        toId: toId,
      ),
    );
    if (result == null || !mounted) return;
    try {
      setState(() {
        _draft.saveEdge(result);
        _connecting = false;
      });
    } on FormatException catch (error) {
      _message(error.message);
    }
  }

  Future<void> _findConnection() async {
    final selected = _selectedNode;
    if (selected == null) return;
    final target = await showAppSheet<IndoorNavigationNode>(
      context,
      scrollable: false,
      maxHeightFraction: .94,
      contentPadding: EdgeInsets.zero,
      child: MapGraphNodePicker(
        campus: widget.campus,
        nodes: _draft.nodes,
        fromId: selected.id,
        initialFloorId: _floor?.floor.id ?? selected.floorId,
      ),
    );
    if (target != null && mounted) await _editEdge(toId: target.id);
  }

  Future<void> _connections() async {
    final selected = _selectedNode;
    if (selected == null) return;
    final edge = await showAppSheet<IndoorNavigationEdge>(
      context,
      scrollable: false,
      contentPadding: EdgeInsets.zero,
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: MediaQuery.heightOf(context) * .55,
          child: StatefulBuilder(
            builder: (context, update) {
              final links = _draft.edges
                  .where(
                    (candidate) =>
                        candidate.fromNodeId == selected.id ||
                        candidate.toNodeId == selected.id,
                  )
                  .toList();
              return ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Text(
                    'Проходы · ${_labels.title(selected)}',
                    style: AppText.title,
                  ),
                  if (links.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Text('У этой точки пока нет проходов.'),
                    ),
                  for (final link in links)
                    AppListRow(
                      titleMaxLines: 2,
                      title: _labels.title(
                        _draft.nodeForId(
                          link.fromNodeId == selected.id
                              ? link.toNodeId
                              : link.fromNodeId,
                        )!,
                      ),
                      subtitle:
                          '${_edgeLabel(link.kind)} · '
                          '${_edgeDistanceLabel(link)}'
                          '${link.closed ? ' · закрыт' : ''}',
                      onTap: () => Navigator.pop(context, link),
                      trailing: AppIconButton(
                        tooltip: 'Удалить проход',
                        icon: const Icon(Icons.delete_outline_rounded),
                        onPressed: () {
                          update(
                            () => setState(() => _draft.removeEdge(link.id)),
                          );
                        },
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
    if (edge != null && mounted) await _editEdge(edge: edge);
  }

  Future<void> _review() async {
    if (_draft.needsDistanceReview) {
      _message('После переноса точки откройте её проходы и проверьте длины.');
      return;
    }
    try {
      final graph = _draft.validate();
      final used = graph.edges
          .expand((edge) => [edge.fromNodeId, edge.toNodeId])
          .toSet();
      final isolated = graph.nodes
          .where((node) => !used.contains(node.id))
          .length;
      final warning = isolated == 0
          ? ''
          : '\nБез связей: $isolated. Они пока не участвуют в маршрутах.';
      final sent = await showMapEditorReview(
        context: context,
        campus: widget.campus,
        repository: widget.repository,
        entityType: 'graph',
        entityId: widget.campus.campus.id,
        patch: _draft.patch,
        summary:
            '${graph.nodes.length} точек, ${graph.edges.length} проходов.'
            '$warning'
            '\nПроверьте, что каждый отрезок проходит по реальному '
            'коридору и не пересекает стены.',
      );
      if (sent && mounted) Navigator.pop(context, true);
    } on FormatException {
      _message(
        'Проверьте точки, этажи и длины проходов. Схема содержит ошибку.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final floor = _floor;
    final selected = _selectedNode;
    return Scaffold(
      backgroundColor: context.colors.canvas,
      body: Column(
        children: [
          AppInnerHeader(
            title: 'Редактор маршрутов',
            onBack: () => Navigator.maybePop(context),
            actions: [
              AppHeaderAction(
                semanticsLabel: 'Отменить последнее изменение',
                onTap: _draft.canUndo
                    ? () => setState(() {
                        _draft.undo();
                        _moving = false;
                        _connecting = false;
                      })
                    : null,
                child: const Icon(Icons.undo_rounded),
              ),
            ],
          ),
          Expanded(
            child: floor == null
                ? const Center(child: Text('Планы этажей недоступны.'))
                : Column(
                    children: [
                      MapEditorFloorPicker(
                        floors: widget.campus.floors,
                        selected: floor.floor.id,
                        onSelected: (value) => setState(() {
                          _floor = value;
                          _moving = false;
                          if (!_connecting) _selected = null;
                        }),
                      ),
                      MapEditorHint(
                        label: _connecting
                            ? 'Коснитесь конечной точки или найдите её'
                            : _moving
                            ? 'Коснитесь нового положения'
                            : 'Касание выбирает или добавляет точку',
                        help:
                            'Коснитесь свободного места, чтобы добавить точку, '
                            'или существующей точки, чтобы выбрать её. '
                            'Масштаб меняется двумя пальцами.\n\n'
                            'На каждом повороте коридора добавляйте '
                            'отдельную точку. Вход в помещение отмечайте '
                            'у двери. Соединяйте только '
                            'реальные проходы с проверенной длиной.',
                      ),
                      Expanded(
                        child: MapEditorFloorCanvas(
                          campus: widget.campus,
                          key: ValueKey(floor.floor.id),
                          floor: floor,
                          repository: widget.repository,
                          places: widget.campus.rooms,
                          onTap: (point, scale) =>
                              unawaited(_tap(point, scale)),
                          painter: _GraphPainter(
                            floor: floor,
                            nodes: _draft.nodes,
                            edges: _draft.edges,
                            selected: _selected,
                            labels: _labels,
                            colors: context.colors,
                          ),
                        ),
                      ),
                      SafeArea(
                        top: false,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: MediaQuery.heightOf(context) * .30,
                          ),
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                if (selected != null) ...[
                                  Text(
                                    _labels.title(selected),
                                    style: AppText.label,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        AppButton.text(
                                          size: AppButtonSize.small,
                                          onPressed: () =>
                                              _editNode(node: selected),
                                          label: 'Свойства',
                                        ),
                                        AppButton.text(
                                          size: AppButtonSize.small,
                                          onPressed: () => setState(() {
                                            _moving = !_moving;
                                            _connecting = false;
                                            _floor = widget.campus.floorForId(
                                              selected.floorId,
                                            );
                                          }),
                                          label: _moving
                                              ? 'Отмена переноса'
                                              : 'Перенести',
                                        ),
                                        AppButton.text(
                                          size: AppButtonSize.small,
                                          onPressed: () => setState(() {
                                            _connecting = !_connecting;
                                            _moving = false;
                                          }),
                                          label: _connecting
                                              ? 'Отмена соединения'
                                              : 'Соединить',
                                        ),
                                        AppButton.text(
                                          size: AppButtonSize.small,
                                          onPressed: () =>
                                              unawaited(_connections()),
                                          label: 'Проходы',
                                        ),
                                        AppIconButton(
                                          tooltip: 'Удалить точку и её проходы',
                                          onPressed: () => setState(() {
                                            _draft.removeNode(selected.id);
                                            _selected = null;
                                            _moving = false;
                                            _connecting = false;
                                          }),
                                          icon: const Icon(
                                            Icons.delete_outline_rounded,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                                if (_connecting)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: AppButton.secondary(
                                      label: 'Найти конечную точку',
                                      onPressed: () =>
                                          unawaited(_findConnection()),
                                    ),
                                  ),
                                AppButton.primary(
                                  label: 'Проверить изменения',
                                  expanded: true,
                                  onPressed: _draft.canUndo
                                      ? () => unawaited(_review())
                                      : null,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _MapEditorDialog extends StatelessWidget {
  const _MapEditorDialog({
    required this.title,
    required this.content,
    required this.actions,
  });

  final String title;
  final Widget content;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) => AppDialog(
    title: title,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight:
                (MediaQuery.heightOf(context) -
                    MediaQuery.viewInsetsOf(context).bottom) *
                .42,
          ),
          child: content,
        ),
        const SizedBox(height: AppSpacing.lg),
        Wrap(
          alignment: WrapAlignment.end,
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: actions,
        ),
      ],
    ),
  );
}

class MapEditorHint extends StatelessWidget {
  const MapEditorHint({required this.label, required this.help, super.key});

  final String label;
  final String help;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    child: Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppText.caption,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        AppIconButton(
          icon: const Icon(Icons.help_outline_rounded),
          tooltip: 'Как редактировать карту',
          onPressed: () => showAppDialog<void>(
            context,
            builder: (context) => _MapEditorDialog(
              title: 'Как это работает',
              content: SingleChildScrollView(child: Text(help)),
              actions: [
                AppButton.primary(
                  label: 'Понятно',
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

class MapEditorFloorPicker extends StatelessWidget {
  const MapEditorFloorPicker({
    required this.floors,
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final List<MapFloorData> floors;
  final String selected;
  final ValueChanged<MapFloorData> onSelected;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Row(
      children: [
        for (final floor in floors)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: AppChip(
              label: floor.label.isEmpty
                  ? 'Этаж ${floor.floor.number}'
                  : floor.label,
              selected: floor.floor.id == selected,
              onTap: () => onSelected(floor),
            ),
          ),
      ],
    ),
  );
}

class _GraphPainter extends CustomPainter {
  const _GraphPainter({
    required this.floor,
    required this.nodes,
    required this.edges,
    required this.selected,
    required this.labels,
    required this.colors,
  });

  final MapFloorData floor;
  final List<IndoorNavigationNode> nodes;
  final List<IndoorNavigationEdge> edges;
  final String? selected;
  final _GraphNodeLabels labels;
  final AppColors colors;

  @override
  void paint(Canvas canvas, Size size) {
    final points = {
      for (final node in nodes.where(
        (candidate) => candidate.floorId == floor.floor.id,
      ))
        node.id: Offset(
          node.x / floor.width * size.width,
          node.y / floor.height * size.height,
        ),
    };
    for (final edge in edges) {
      final from = points[edge.fromNodeId];
      final to = points[edge.toNodeId];
      if (from == null || to == null) continue;
      final paint = Paint()
        ..color = edge.closed ? colors.danger : colors.accent
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(from, to, paint);
      if (!edge.bidirectional && (to - from).distance > 8) {
        final middle = (from + to) / 2;
        final direction = (to - from) / (to - from).distance;
        final normal = Offset(-direction.dy, direction.dx);
        canvas
          ..drawLine(middle, middle - direction * 7 + normal * 4, paint)
          ..drawLine(middle, middle - direction * 7 - normal * 4, paint);
      }
    }
    for (final node in nodes) {
      final point = points[node.id];
      if (point == null) continue;
      final radius = node.id == selected ? 8.0 : 5.0;
      canvas
        ..drawCircle(point, radius + 2, Paint()..color = colors.surface)
        ..drawCircle(
          point,
          radius,
          Paint()..color = node.closed ? colors.danger : colors.accent,
        );
      if (node.id == selected || node.roomId != null) {
        TextPainter(
            text: TextSpan(
              text: labels.title(node),
              style: AppText.caption.copyWith(
                fontSize: 10,
                color: colors.ink,
                backgroundColor: colors.surface,
              ),
            ),
            textDirection: TextDirection.ltr,
            maxLines: 1,
            ellipsis: '…',
          )
          ..layout(maxWidth: 120)
          ..paint(canvas, point + const Offset(9, -7));
      }
    }
  }

  @override
  bool shouldRepaint(_GraphPainter oldDelegate) =>
      floor != oldDelegate.floor ||
      !identical(nodes, oldDelegate.nodes) ||
      !identical(edges, oldDelegate.edges) ||
      selected != oldDelegate.selected ||
      colors != oldDelegate.colors;
}

class _NodeDialog extends StatefulWidget {
  const _NodeDialog({
    required this.id,
    required this.floor,
    required this.rooms,
    required this.point,
    this.node,
  });
  final String id;
  final MapFloorData floor;
  final List<MapPlaceData> rooms;
  final Offset point;
  final IndoorNavigationNode? node;

  @override
  State<_NodeDialog> createState() => _NodeDialogState();
}

class _NodeDialogState extends State<_NodeDialog> {
  late final _label = TextEditingController(text: widget.node?.label);
  late String? _roomId = widget.node?.roomId;
  late bool _accessible = widget.node?.wheelchairAccessible ?? false;
  late bool _closed = widget.node?.closed ?? false;
  String? _error;

  Future<void> _chooseRoom() async {
    final room = await _showEditorOptions<String>(
      context,
      title: 'Вход в помещение',
      selected: _roomId ?? '',
      options: {
        '': 'Точка в коридоре',
        for (final option in widget.rooms)
          if (option.floorId == widget.floor.floor.id) option.id: option.label,
      },
    );
    if (room != null && mounted) {
      setState(() => _roomId = room.isEmpty ? null : room);
    }
  }

  @override
  void dispose() {
    _label.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _MapEditorDialog(
    title: widget.node == null ? 'Новая точка прохода' : 'Точка прохода',
    content: SizedBox(
      width: 420,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppInputField(
              controller: _label,
              label: 'Название',
              placeholder: 'Поворот у лестницы',
              maxLength: 160,
              errorText: _error,
            ),
            const SizedBox(height: 16),
            AppSelectField(
              label: 'Вход в помещение',
              value:
                  widget.rooms
                      .where((room) => room.id == _roomId)
                      .firstOrNull
                      ?.label ??
                  'Точка в коридоре',
              onTap: () => unawaited(_chooseRoom()),
            ),
            const SizedBox(height: 8),
            const Text(
              'Для помещения поставьте точку в дверном проёме, '
              'а не в центре комнаты.',
            ),
            AppSwitch(
              label: 'Доступно на коляске',
              value: _accessible,
              onChanged: (value) => setState(() => _accessible = value),
            ),
            AppSwitch(
              label: 'Временно закрыто',
              value: _closed,
              onChanged: (value) => setState(() => _closed = value),
            ),
          ],
        ),
      ),
    ),
    actions: [
      AppButton.text(
        onPressed: () => Navigator.pop(context),
        label: 'Отмена',
      ),
      AppButton.primary(
        label: 'Сохранить в черновик',
        onPressed: () {
          if (_label.text.trim().isEmpty) {
            setState(
              () =>
                  _error = 'Назовите точку, чтобы находить её при соединении.',
            );
            return;
          }
          Navigator.pop(context, <String, Object?>{
            'id': widget.id,
            'floor_id': widget.floor.floor.id,
            'x': widget.point.dx,
            'y': widget.point.dy,
            'label': _label.text.trim(),
            'room_id': _roomId,
            'kind': _roomId == null
                ? (widget.node?.kind ?? 'junction')
                : 'door',
            'wheelchair_accessible': _accessible,
            'closed': _closed,
          });
        },
      ),
    ],
  );
}

class _GraphNodeLabels {
  _GraphNodeLabels(this.campus) {
    for (final floor in campus.floors) {
      _cellSizes[floor.floor.id] = math.max(floor.width, floor.height) / 32;
    }
    for (final room in campus.rooms) {
      _rooms[room.id] = room;
      final size = _cellSizes[room.floorId];
      if (size == null || size <= 0) continue;
      final cell = (
        room.floorId,
        (room.x / size).floor(),
        (room.y / size).floor(),
      );
      (_cells[cell] ??= []).add(room);
    }
  }

  final CampusMapData campus;
  final _rooms = <String, MapPlaceData>{};
  final _cellSizes = <String, double>{};
  final _cells = <(String, int, int), List<MapPlaceData>>{};
  final _titles = <IndoorNavigationNode, String>{};

  String title(IndoorNavigationNode node) => _titles.putIfAbsent(node, () {
    final room = _rooms[node.roomId];
    if (room != null) return room.label;
    final label = node.label?.trim();
    if (label != null && label.isNotEmpty && label != node.id) return label;
    final kind = switch (node.kind) {
      'door' => 'Дверь',
      'stairs' => 'Лестница',
      'elevator' => 'Лифт',
      'ramp' => 'Пандус',
      'escalator' => 'Эскалатор',
      'entrance' => 'Вход',
      _ => 'Точка прохода',
    };
    final size = _cellSizes[node.floorId];
    if (size == null || size <= 0) return kind;
    final x = (node.x / size).floor();
    final y = (node.y / size).floor();
    MapPlaceData? nearest;
    var distance = double.infinity;
    for (var dx = -2; dx <= 2; dx++) {
      for (var dy = -2; dy <= 2; dy++) {
        final cell = (node.floorId, x + dx, y + dy);
        final nearby = _cells[cell] ?? const <MapPlaceData>[];
        for (final candidate in nearby) {
          final current =
              math.pow(candidate.x - node.x, 2) +
              math.pow(candidate.y - node.y, 2);
          if (current < distance) {
            distance = current.toDouble();
            nearest = candidate;
          }
        }
      }
    }
    return nearest == null ? kind : '$kind рядом с ${nearest.label}';
  });

  String subtitle(IndoorNavigationNode node) {
    final floor = campus.floorForId(node.floorId);
    final label = floor == null
        ? 'Этаж неизвестен'
        : floor.label.isEmpty
        ? 'Этаж ${floor.floor.number}'
        : floor.label;
    return '$label · x ${node.x.toStringAsFixed(1)}, '
        'y ${node.y.toStringAsFixed(1)}'
        '${node.closed ? ' · закрыто' : ''}';
  }
}

class MapGraphNodePicker extends StatefulWidget {
  const MapGraphNodePicker({
    required this.campus,
    required this.nodes,
    required this.fromId,
    required this.initialFloorId,
    super.key,
  });

  final CampusMapData campus;
  final List<IndoorNavigationNode> nodes;
  final String fromId;
  final String initialFloorId;

  @override
  State<MapGraphNodePicker> createState() => _MapGraphNodePickerState();
}

class _MapGraphNodePickerState extends State<MapGraphNodePicker> {
  final _search = TextEditingController();
  late String? _floorId = widget.initialFloorId;
  late final _labels = _GraphNodeLabels(widget.campus);
  late final List<({IndoorNavigationNode node, String title, String search})>
  _entries =
      [
        for (final node in widget.nodes)
          if (node.id != widget.fromId)
            (
              node: node,
              title: _labels.title(node),
              search: roomKey(
                '${_labels.title(node)} ${_labels.subtitle(node)} ${node.id}',
              ),
            ),
      ]..sort((a, b) {
        final order = compareNatural(a.title, b.title);
        if (order != 0) return order;
        return compareNatural(
          _labels.subtitle(a.node),
          _labels.subtitle(b.node),
        );
      });
  String _query = '';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final matches = _entries
        .where(
          (entry) =>
              (_floorId == null || entry.node.floorId == _floorId) &&
              (_query.isEmpty || entry.search.contains(_query)),
        )
        .toList(growable: false);
    final media = MediaQuery.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: media.viewInsets.bottom),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: math.max(
            160,
            media.size.height * .82 - media.viewInsets.bottom,
          ),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text('Конечная точка', style: AppText.title),
                          const SizedBox(height: 12),
                          AppSearchField(
                            controller: _search,
                            hintText: 'Аудитория, лестница или точка',
                            onChanged: (value) =>
                                setState(() => _query = roomKey(value)),
                            onClear: () => setState(() => _query = ''),
                          ),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: AppChip(
                              label: 'Все этажи',
                              selected: _floorId == null,
                              onTap: () => setState(() => _floorId = null),
                            ),
                          ),
                          for (final floor in widget.campus.floors)
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: AppChip(
                                label: floor.label.isEmpty
                                    ? 'Этаж ${floor.floor.number}'
                                    : floor.label,
                                selected: _floorId == floor.floor.id,
                                onTap: () =>
                                    setState(() => _floorId = floor.floor.id),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
                      child: Text(
                        'Найдено: ${matches.length}',
                        style: AppText.caption,
                      ),
                    ),
                  ],
                ),
              ),
              if (matches.isEmpty)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Text('Попробуйте другое название или этаж.'),
                  ),
                )
              else
                SliverList.builder(
                  key: ValueKey((_floorId, _query)),
                  itemCount: matches.length,
                  itemBuilder: (context, index) {
                    final entry = matches[index];
                    return AppListRow(
                      key: ValueKey('graph-node-${entry.node.id}'),
                      title: entry.title,
                      titleMaxLines: 2,
                      subtitle: _labels.subtitle(entry.node),
                      leading: Icon(
                        entry.node.roomId == null
                            ? Icons.route_rounded
                            : Icons.meeting_room_outlined,
                      ),
                      onTap: () => Navigator.pop(context, entry.node),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EdgeDialog extends StatefulWidget {
  const _EdgeDialog({
    required this.campus,
    required this.nodes,
    required this.fromId,
    required this.id,
    this.edge,
    this.toId,
  });
  final CampusMapData campus;
  final List<IndoorNavigationNode> nodes;
  final String fromId;
  final String id;
  final IndoorNavigationEdge? edge;
  final String? toId;

  @override
  State<_EdgeDialog> createState() => _EdgeDialogState();
}

class _EdgeDialogState extends State<_EdgeDialog> {
  late final _distance = TextEditingController(
    text: widget.edge?.distanceMeters?.toString(),
  );
  late String? _toId = widget.edge?.toNodeId ?? widget.toId;
  late IndoorEdgeKind _kind = widget.edge?.kind ?? IndoorEdgeKind.corridor;
  late bool _both = widget.edge?.bidirectional ?? true;
  late bool _accessible = widget.edge?.wheelchairAccessible ?? false;
  late bool _closed = widget.edge?.closed ?? false;
  bool _confirmed = false;
  String? _error;
  late final Map<String, IndoorNavigationNode> _byId = {
    for (final node in widget.nodes) node.id: node,
  };
  late final _labels = _GraphNodeLabels(widget.campus);

  @override
  void dispose() {
    _distance.dispose();
    super.dispose();
  }

  IndoorNavigationNode get _from => _byId[widget.fromId]!;
  IndoorNavigationNode? get _to => _byId[_toId];

  Future<void> _chooseKind() async {
    final kind = await _showEditorOptions<IndoorEdgeKind>(
      context,
      title: 'Тип прохода',
      selected: _kind,
      options: {
        for (final option in IndoorEdgeKind.values) option: _edgeLabel(option),
      },
    );
    if (kind == null || !mounted) return;
    setState(() {
      _kind = kind;
      switch (kind) {
        case IndoorEdgeKind.stairs || IndoorEdgeKind.escalator:
          _accessible = false;
        case IndoorEdgeKind.corridor ||
            IndoorEdgeKind.elevator ||
            IndoorEdgeKind.ramp ||
            IndoorEdgeKind.door ||
            IndoorEdgeKind.outdoor:
          break;
      }
    });
  }

  Future<void> _chooseTarget() async {
    final target = await showAppSheet<IndoorNavigationNode>(
      context,
      scrollable: false,
      maxHeightFraction: .94,
      contentPadding: EdgeInsets.zero,
      child: MapGraphNodePicker(
        campus: widget.campus,
        nodes: widget.nodes,
        fromId: widget.fromId,
        initialFloorId: _to?.floorId ?? _from.floorId,
      ),
    );
    if (target == null || !mounted) return;
    setState(() {
      _toId = target.id;
      _confirmed = false;
    });
  }

  void _save() {
    final distanceText = _distance.text.trim().replaceAll(',', '.');
    final distance = double.tryParse(
      distanceText,
    );
    final traversalCost =
        widget.edge?.toNodeId == _toId &&
            widget.edge?.fromNodeId == widget.fromId &&
            widget.edge?.kind == _kind
        ? widget.edge?.traversalCost
        : null;
    final to = _to;
    String? error;
    if (to == null) {
      error = 'Выберите конечную точку.';
    } else if (distanceText.isNotEmpty &&
        (distance == null ||
            !distance.isFinite ||
            distance < 0 ||
            distance > 100000)) {
      error = 'Длина должна быть конечным неотрицательным числом в метрах.';
    } else if (distance == null && traversalCost == null) {
      error = 'Укажите измеренную длину прохода в метрах.';
    } else if (_from.floorId != to.floorId &&
        !const {
          IndoorEdgeKind.stairs,
          IndoorEdgeKind.elevator,
          IndoorEdgeKind.ramp,
          IndoorEdgeKind.escalator,
          IndoorEdgeKind.outdoor,
        }.contains(_kind)) {
      error = 'Выберите подходящий тип перехода между этажами.';
    } else if ((_kind == IndoorEdgeKind.stairs ||
            _kind == IndoorEdgeKind.escalator) &&
        _accessible) {
      error = 'Ступени не подходят для маршрута на коляске.';
    } else if (!_confirmed) {
      error = 'Подтвердите, что этот проход существует и проверен на месте.';
    }
    if (error != null) {
      setState(() => _error = error);
      return;
    }
    Navigator.pop(context, <String, Object?>{
      'id': widget.id,
      'from_node_id': widget.fromId,
      'to_node_id': _toId,
      'distance_meters': ?distance,
      'traversal_cost': ?traversalCost,
      'duration_seconds':
          ?(widget.edge?.toNodeId == _toId &&
              widget.edge?.fromNodeId == widget.fromId &&
              widget.edge?.distanceMeters == distance &&
              widget.edge?.kind == _kind
          ? widget.edge?.durationSeconds
          : null),
      'kind': _kind.name,
      'bidirectional': _both,
      'wheelchair_accessible': _accessible,
      'closed': _closed,
    });
  }

  @override
  Widget build(BuildContext context) {
    final meters = widget.campus.floorForId(_from.floorId)?.metersPerUnit;
    final to = _to;
    final canMeasure =
        meters != null &&
        meters > 0 &&
        to != null &&
        to.floorId == _from.floorId;
    return _MapEditorDialog(
      title: 'Соединить точки',
      content: SizedBox(
        width: 440,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Откуда: ${_labels.title(_from)}', style: AppText.label),
              const SizedBox(height: 12),
              AppListRow(
                titleMaxLines: 2,
                title: to == null
                    ? 'Выбрать конечную точку'
                    : _labels.title(to),
                subtitle: to == null
                    ? 'Поиск по этажу и помещению'
                    : _labels.subtitle(to),
                trailing: const Icon(Icons.search_rounded),
                onTap: () => unawaited(_chooseTarget()),
              ),
              const SizedBox(height: 12),
              AppSelectField(
                label: 'Тип прохода',
                value: _edgeLabel(_kind),
                onTap: () => unawaited(_chooseKind()),
              ),
              const SizedBox(height: 16),
              AppInputField(
                controller: _distance,
                label: 'Длина прохода, м',
                placeholder: 'Измеренное расстояние',
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
              if (canMeasure)
                AppButton.text(
                  size: AppButtonSize.small,
                  onPressed: () => setState(
                    () => _distance.text =
                        ((Offset(_from.x, _from.y) - Offset(to.x, to.y))
                                    .distance *
                                meters)
                            .toStringAsFixed(2),
                  ),
                  label: 'Рассчитать прямой участок по масштабу',
                ),
              Text(
                widget.edge?.distanceMeters == null &&
                        widget.edge?.traversalCost != null
                    ? 'Длина этого перехода пока неизвестна. '
                          'Его параметры можно сохранить без оценки '
                          'метров и времени.'
                    : canMeasure
                    ? 'Расчёт по масштабу подходит только для прямого участка. '
                          'На поворотах добавляйте отдельные точки.'
                    : 'Масштаб не задан или выбран переход между этажами. '
                          'Нужна измеренная длина реального пути.',
                style: AppText.caption,
              ),
              AppSwitch(
                label: 'В обоих направлениях',
                value: _both,
                onChanged: (value) => setState(() => _both = value),
              ),
              AppSwitch(
                label: 'Доступно на коляске',
                value: _accessible,
                onChanged: (value) => setState(() => _accessible = value),
              ),
              AppSwitch(
                label: 'Проход закрыт',
                value: _closed,
                onChanged: (value) => setState(() => _closed = value),
              ),
              AppCheckbox(
                label:
                    'Проверено на месте: путь существует, '
                    'стены и препятствия учтены',
                value: _confirmed,
                onChanged: (value) => setState(() => _confirmed = value),
              ),
              if (_error != null)
                AppBanner(message: _error!, tone: AppBannerTone.warn),
            ],
          ),
        ),
      ),
      actions: [
        AppButton.text(
          onPressed: () => Navigator.pop(context),
          label: 'Отмена',
        ),
        AppButton.primary(label: 'Сохранить в черновик', onPressed: _save),
      ],
    );
  }
}

Future<T?> _showEditorOptions<T>(
  BuildContext context, {
  required String title,
  required Map<T, String> options,
  required T selected,
}) {
  var query = '';
  return showAppSheet<T>(
    context,
    title: title,
    scrollable: false,
    child: StatefulBuilder(
      builder: (context, update) {
        final entries = options.entries
            .where(
              (entry) => entry.value.toLowerCase().contains(query),
            )
            .toList();
        return SizedBox(
          height: MediaQuery.heightOf(context) * .5,
          child: Column(
            children: [
              if (options.length > 10) ...[
                AppInputField(
                  placeholder: 'Найти помещение',
                  onChanged: (value) =>
                      update(() => query = value.trim().toLowerCase()),
                ),
                const SizedBox(height: AppSpacing.sm),
              ],
              Expanded(
                child: ListView.builder(
                  itemCount: entries.length,
                  itemBuilder: (context, index) {
                    final entry = entries[index];
                    return AppListRow(
                      title: entry.value,
                      titleMaxLines: null,
                      strong: entry.key == selected,
                      showChevron: false,
                      trailing: entry.key == selected
                          ? const AppLineIconWidget(AppLineIcon.check)
                          : null,
                      onTap: () => Navigator.of(
                        context,
                        rootNavigator: true,
                      ).pop(entry.key),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}

String _edgeLabel(IndoorEdgeKind kind) => switch (kind) {
  IndoorEdgeKind.corridor => 'Коридор',
  IndoorEdgeKind.stairs => 'Лестница',
  IndoorEdgeKind.elevator => 'Лифт',
  IndoorEdgeKind.ramp => 'Пандус',
  IndoorEdgeKind.escalator => 'Эскалатор',
  IndoorEdgeKind.door => 'Дверь',
  IndoorEdgeKind.outdoor => 'Улица',
};

String _edgeDistanceLabel(IndoorNavigationEdge edge) =>
    edge.distanceMeters == null
    ? 'длина неизвестна'
    : '${edge.distanceMeters!.toStringAsFixed(1)} м';

Future<bool> showMapEditorReview({
  required BuildContext context,
  required CampusMapData campus,
  required MapDataRepository repository,
  required String entityType,
  required String entityId,
  required Map<String, Object?> patch,
  required String summary,
}) async =>
    await showAppDialog<bool>(
      context,
      barrierDismissible: false,
      builder: (context) => _ReviewDialog(
        campus: campus,
        repository: repository,
        entityType: entityType,
        entityId: entityId,
        patch: patch,
        summary: summary,
      ),
    ) ??
    false;

class _ReviewDialog extends StatefulWidget {
  const _ReviewDialog({
    required this.campus,
    required this.repository,
    required this.entityType,
    required this.entityId,
    required this.patch,
    required this.summary,
  });
  final CampusMapData campus;
  final MapDataRepository repository;
  final String entityType;
  final String entityId;
  final Map<String, Object?> patch;
  final String summary;

  @override
  State<_ReviewDialog> createState() => _ReviewDialogState();
}

class _ReviewDialogState extends State<_ReviewDialog> {
  final _reason = TextEditingController();
  bool _busy = false;
  bool _sent = false;
  String? _error;

  @override
  void dispose() {
    _reason.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_reason.text.trim().length < 10) {
      setState(
        () => _error =
            'Опишите, что изменилось и как вы это проверили: от 10 символов.',
      );
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await widget.repository.submitProposal(
        campusId: widget.campus.campus.id,
        baseRevision: widget.campus.revision,
        entityType: widget.entityType,
        entityId: widget.entityId,
        patch: widget.patch,
        reason: _reason.text.trim(),
      );
      if (mounted) {
        setState(() {
          _sent = true;
          _busy = false;
        });
      }
    } on Object catch (error) {
      if (mounted) {
        setState(() {
          _busy = false;
          _error = mapContributionError(error);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: !_busy && !_sent,
    onPopInvokedWithResult: (didPop, result) {
      if (!didPop && _sent) Navigator.pop(context, true);
    },
    child: _MapEditorDialog(
      title: _sent ? 'Изменения на проверке' : 'Проверка предложения',
      content: SizedBox(
        width: 440,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_sent)
                const Text(
                  'Предложение сохранено. Оно появится на общей карте '
                  'после проверки модератором.',
                )
              else ...[
                Text(widget.summary),
                const SizedBox(height: 16),
                AppInputField.multiline(
                  controller: _reason,
                  label: 'Что изменилось и как проверено',
                  placeholder: 'Осмотрел коридор, измерил проход…',
                  maxLength: 2000,
                  enabled: !_busy,
                ),
                const SizedBox(height: 12),
                const Text(
                  'До проверки модератором общая карта останется прежней.',
                ),
                if (!widget.repository.isAuthenticated)
                  const AppBanner(
                    message: 'Для отправки войдите в аккаунт.',
                    tone: AppBannerTone.warn,
                  ),
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  AppBanner(message: _error!, tone: AppBannerTone.warn),
                ],
              ],
            ],
          ),
        ),
      ),
      actions: _sent
          ? [
              AppButton.primary(
                label: 'Готово',
                onPressed: () => Navigator.pop(context, true),
              ),
            ]
          : [
              AppButton.text(
                onPressed: _busy ? null : () => Navigator.pop(context, false),
                label: 'К редактированию',
              ),
              AppButton.primary(
                label: 'Отправить на проверку',
                loading: _busy,
                onPressed: _busy || !widget.repository.isAuthenticated
                    ? null
                    : () => unawaited(_submit()),
              ),
            ],
    ),
  );
}
