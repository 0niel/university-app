import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/map/data/map_data_models.dart';
import 'package:rtu_mirea_app/map/navigation/navigation.dart';
import 'package:rtu_mirea_app/map/services/room_key.dart';

String mapRouteInstructionLabel(
  IndoorRouteInstruction instruction,
  CampusMapData campus,
) {
  final floor = campus
      .floorForId(
        instruction.toNode?.floorId ?? instruction.atNode.floorId,
      )
      ?.floor
      .number;
  final changesFloor =
      instruction.toNode != null &&
      instruction.toNode!.floorId != instruction.atNode.floorId;
  final floorLabel = floor == null ? 'другой' : '$floor';
  return switch (instruction.maneuver) {
    IndoorManeuver.depart => 'Начните маршрут',
    IndoorManeuver.straight => 'Продолжайте прямо',
    IndoorManeuver.turnLeft => 'Поверните налево',
    IndoorManeuver.turnRight => 'Поверните направо',
    IndoorManeuver.turnBack => 'Развернитесь',
    IndoorManeuver.stairs =>
      changesFloor ? 'По лестнице на $floorLabel этаж' : 'Пройдите по лестнице',
    IndoorManeuver.elevator => 'На лифте на $floorLabel этаж',
    IndoorManeuver.ramp =>
      changesFloor ? 'По пандусу на $floorLabel этаж' : 'Пройдите по пандусу',
    IndoorManeuver.escalator =>
      changesFloor
          ? 'На эскалаторе на $floorLabel этаж'
          : 'Пройдите по эскалатору',
    IndoorManeuver.floorTransition => 'Перейдите на $floorLabel этаж',
    IndoorManeuver.arrive => 'Вы на месте',
  };
}

class MapRouteSheet extends StatefulWidget {
  const MapRouteSheet({
    required this.campus,
    required this.onApply,
    required this.onContribute,
    this.onClose,
    this.startRoomId,
    this.destinationRoomId,
    super.key,
  });

  final CampusMapData campus;
  final String? startRoomId;
  final String? destinationRoomId;
  final ValueChanged<IndoorRoute> onApply;
  final VoidCallback onContribute;
  final VoidCallback? onClose;

  @override
  State<MapRouteSheet> createState() => _MapRouteSheetState();
}

class _MapRouteSheetState extends State<MapRouteSheet> {
  IndoorNavigationGraph? _graph;
  late final IndoorRoutePlanner _planner;
  IndoorNavigationNode? _start;
  IndoorNavigationNode? _destination;
  IndoorRouteResult? _result;
  String? _error;
  bool _stepFree = false;
  bool _wheelchair = false;
  bool _fastest = true;

  @override
  void initState() {
    super.initState();
    try {
      _graph = IndoorNavigationGraph.fromJson(widget.campus.graph);
      _planner = IndoorRoutePlanner(_graph!);
      _fastest = _graph!.hasCompleteDuration;
      _start = _nodeForRoom(widget.startRoomId);
      _destination = _nodeForRoom(widget.destinationRoomId);
      if (_needsNavigationReview(widget.startRoomId) ||
          _needsNavigationReview(widget.destinationRoomId)) {
        _error = 'Место перенесено. Проходы к нему ещё проверяются.';
      } else if (_graph!.nodes.isEmpty || _graph!.edges.isEmpty) {
        _error =
            'Проходы этого кампуса ещё не проверены. '
            'Можно найти помещение на плане и предложить уточнение маршрутов.';
      } else if (widget.destinationRoomId != null && _destination == null) {
        _error = 'Путь ко входу в это помещение ещё не размечен.';
      } else if (widget.startRoomId != null && _start == null) {
        _error = 'Начальная точка пока не соединена с графом проходов.';
      }
      _calculate();
    } on FormatException {
      _error =
          'Данные проходов требуют проверки. '
          'Обновите карту или сообщите об ошибке.';
    }
  }

  String _label(IndoorNavigationNode node) =>
      widget.campus.placeForId(node.roomId ?? '')?.label ??
      node.label ??
      'Точка на плане';

  bool _needsNavigationReview(String? roomId) =>
      widget.campus.placeForId(roomId ?? '')?.raw['navigation_needs_review'] ==
      true;

  IndoorNavigationNode? _nodeForRoom(String? roomId) {
    if (roomId == null || _needsNavigationReview(roomId)) return null;
    final place = widget.campus.placeForId(roomId);
    return _graph!.nodesForRoom(place?.id ?? roomId).firstOrNull;
  }

  void _calculate() {
    final graph = _graph;
    final start = _start;
    final destination = _destination;
    _result = graph == null || start == null || destination == null
        ? null
        : _planner.findRouteBetween(
            startNodeIds: start.roomId == null
                ? [start.id]
                : graph.nodesForRoom(start.roomId!).map((node) => node.id),
            destinationNodeIds: destination.roomId == null
                ? [destination.id]
                : graph
                      .nodesForRoom(destination.roomId!)
                      .map((node) => node.id),
            options: IndoorRouteOptions(
              stepFree: _stepFree,
              wheelchair: _wheelchair,
              metric: _fastest
                  ? IndoorRouteMetric.duration
                  : IndoorRouteMetric.distance,
            ),
          );
  }

  Future<void> _pick({required bool start}) async {
    final graph = _graph;
    if (graph == null) return;
    final node = await showAppSheet<IndoorNavigationNode>(
      context,
      title: start ? 'Откуда идём' : 'Куда идём',
      child: _RouteNodePicker(
        nodes: graph.nodes
            .where(
              (node) =>
                  !node.closed && (node.roomId != null || node.label != null),
            )
            .toList(),
        campus: widget.campus,
        label: _label,
      ),
    );
    if (node == null || !mounted) return;
    setState(() {
      if (start) {
        _start = node;
      } else {
        _destination = node;
      }
      _error = null;
      _calculate();
    });
  }

  @override
  Widget build(BuildContext context) {
    final route = _result?.route;
    final ready = _graph != null && _graph!.edges.isNotEmpty;
    final canEstimateDuration = _graph?.hasCompleteDuration ?? false;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(child: Text('Маршрут', style: AppText.sectionLarge)),
            if (widget.onClose != null)
              AppSheetCloseButton(onTap: widget.onClose),
          ],
        ),
        const SizedBox(height: 6),
        Text(widget.campus.campus.displayName, style: AppText.subtext),
        const SizedBox(height: 16),
        if (_error != null) ...[
          AppBanner(message: _error!),
          const SizedBox(height: 12),
        ],
        AppListGroup(
          children: [
            AppListRow(
              title: _start == null
                  ? 'Выберите начало'
                  : 'Откуда: ${_label(_start!)}',
              titleMaxLines: null,
              onTap: ready ? () => unawaited(_pick(start: true)) : null,
            ),
          ],
        ),
        Align(
          alignment: Alignment.centerRight,
          child: AppIconButton(
            tooltip: 'Поменять местами',
            shape: AppIconButtonShape.circle,
            size: AppIconButtonSize.compact,
            onPressed: _start == null && _destination == null
                ? null
                : () {
                    setState(() {
                      final previous = _start;
                      _start = _destination;
                      _destination = previous;
                      _calculate();
                    });
                  },
            icon: const Icon(Icons.swap_vert_rounded),
          ),
        ),
        AppListGroup(
          children: [
            AppListRow(
              title: _destination == null
                  ? 'Выберите назначение'
                  : 'Куда: ${_label(_destination!)}',
              titleMaxLines: null,
              onTap: ready ? () => unawaited(_pick(start: false)) : null,
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (route != null) ...[
          AppBanner(
            message: [
              if (route.distanceMeters case final distance?)
                '${distance.round()} м',
              if (route.durationSeconds case final duration?)
                duration == 0
                    ? route.legs.isEmpty
                          ? 'Вы на месте'
                          : '<1 мин'
                    : '≈ ${(duration / 60).ceil().clamp(1, 999)} мин',
              '${route.floorIds.length} эт.',
            ].join(' · '),
          ),
          const SizedBox(height: 12),
          AppButton.primary(
            label: 'Показать путь',
            expanded: true,
            onPressed: () {
              Navigator.of(context).pop();
              widget.onApply(route);
            },
          ),
          const SizedBox(height: 12),
        ] else if (_result != null) ...[
          const AppBanner(
            message:
                'Подходящий путь не найден. Возможно, проход закрыт '
                'или доступность маршрута ещё не подтверждена.',
          ),
          const SizedBox(height: 12),
        ],
        if (ready) ...[
          AppListGroup(
            key: const ValueKey('map-route-options'),
            children: [
              AppDisclosure(
                title: 'Параметры маршрута',
                subtitle: _stepFree || _wheelchair
                    ? [
                        if (_stepFree) 'Без лестниц',
                        if (_wheelchair) 'На коляске',
                      ].join(' · ')
                    : 'Лестницы и доступность',
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    AppChip.filter(
                      label: 'Без лестниц',
                      selected: _stepFree,
                      onTap: () => setState(() {
                        _stepFree = !_stepFree;
                        _calculate();
                      }),
                    ),
                    AppChip.filter(
                      label: 'На коляске',
                      selected: _wheelchair,
                      onTap: () => setState(() {
                        _wheelchair = !_wheelchair;
                        _calculate();
                      }),
                    ),
                    if (canEstimateDuration)
                      AppChip.filter(
                        label: _fastest ? 'Быстрее' : 'Короче',
                        selected: _fastest,
                        onTap: () => setState(() {
                          _fastest = !_fastest;
                          _calculate();
                        }),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],
        if (route != null) ...[
          if (!route.hasCompleteDistance || !route.hasCompleteDuration) ...[
            const SizedBox(height: 8),
            const AppBanner(
              message:
                  'Для части маршрута пока нет оценки расстояния или времени.',
            ),
          ],
          const SizedBox(height: 12),
          AppListGroup(
            children: [
              for (final instruction in route.instructions)
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppIconTile(
                        child: Icon(
                          _instructionIcon(instruction.maneuver),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              mapRouteInstructionLabel(
                                instruction,
                                widget.campus,
                              ),
                              style: AppText.bodyStrong,
                            ),
                            if (instruction.distanceMeters case final distance?
                                when distance > 0)
                              Text(
                                '${distance.round()} м',
                                style: AppText.caption,
                              )
                            else if (instruction.maneuver ==
                                    IndoorManeuver.depart ||
                                instruction.maneuver == IndoorManeuver.arrive)
                              Text(
                                _label(instruction.atNode),
                                style: AppText.caption,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          const AppBanner(
            message:
                'Начальная точка задаётся вручную. '
                'Переходы по шагам не определяют ваше местоположение.',
          ),
        ],
        const SizedBox(height: 12),
        AppButton.text(
          label: 'Уточнить проходы',
          onPressed: () {
            Navigator.of(context).pop();
            widget.onContribute();
          },
        ),
      ],
    );
  }
}

class _RouteNodePicker extends StatefulWidget {
  const _RouteNodePicker({
    required this.nodes,
    required this.campus,
    required this.label,
  });

  final List<IndoorNavigationNode> nodes;
  final CampusMapData campus;
  final String Function(IndoorNavigationNode) label;

  @override
  State<_RouteNodePicker> createState() => _RouteNodePickerState();
}

class _RouteNodePickerState extends State<_RouteNodePicker> {
  final _query = TextEditingController();
  late final List<IndoorNavigationNode> _nodes;

  @override
  void initState() {
    super.initState();
    final rooms = <String, IndoorNavigationNode>{};
    for (final node in widget.nodes) {
      if (node.closed) continue;
      final place = widget.campus.placeForId(node.roomId ?? '');
      if (place?.raw['navigation_needs_review'] == true) continue;
      final technical = const {
        'door',
        'stairs',
        'elevator',
        'escalator',
        'corridor',
        'junction',
        'portal',
      }.contains(node.kind);
      if (place == null &&
          ((node.label?.trim().isEmpty ?? true) || technical)) {
        continue;
      }
      rooms.putIfAbsent(
        place?.id ?? node.roomId ?? 'node:${node.id}',
        () => node,
      );
    }
    _nodes = rooms.values.toList()
      ..sort((a, b) {
        final firstFloor = widget.campus.floorForId(a.floorId);
        final secondFloor = widget.campus.floorForId(b.floorId);
        final floorOrder = (firstFloor?.floor.number ?? 0).compareTo(
          secondFloor?.floor.number ?? 0,
        );
        if (floorOrder != 0) return floorOrder;
        final labelOrder = compareNatural(
          firstFloor?.label ?? a.floorId,
          secondFloor?.label ?? b.floorId,
        );
        if (labelOrder != 0) return labelOrder;
        final roomOrder = compareNatural(
          roomKey(widget.label(a)),
          roomKey(widget.label(b)),
        );
        return roomOrder == 0 ? a.id.compareTo(b.id) : roomOrder;
      });
  }

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final nodes = _nodes
        .where(
          (node) => roomKey(widget.label(node)).contains(roomKey(_query.text)),
        )
        .toList();
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppSearchField(
          controller: _query,
          hintText: 'Аудитория, вход или сервис',
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: MediaQuery.sizeOf(context).height * .4,
          child: nodes.isEmpty
              ? const Center(child: Text('Нет проверенных точек'))
              : ListView.builder(
                  itemCount: nodes.length,
                  itemBuilder: (context, index) {
                    final node = nodes[index];
                    final floor = widget.campus.floorForId(node.floorId);
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (index == 0 ||
                            nodes[index - 1].floorId != node.floorId)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12, 16, 12, 4),
                            child: Text(
                              floor?.label.isNotEmpty == true
                                  ? floor!.label
                                  : '${floor?.floor.number ?? '—'} этаж',
                              style: AppText.caption,
                            ),
                          ),
                        AppListRow(
                          title: widget.label(node),
                          titleMaxLines: null,
                          leading: const AppIconTile(
                            child: Icon(Icons.place_outlined, size: 20),
                          ),
                          onTap: () => Navigator.of(context).pop(node),
                        ),
                      ],
                    );
                  },
                ),
        ),
      ],
    );
  }
}

IconData _instructionIcon(IndoorManeuver maneuver) => switch (maneuver) {
  IndoorManeuver.depart => Icons.trip_origin_rounded,
  IndoorManeuver.arrive => Icons.flag_rounded,
  IndoorManeuver.turnLeft => Icons.turn_left_rounded,
  IndoorManeuver.turnRight => Icons.turn_right_rounded,
  IndoorManeuver.turnBack => Icons.u_turn_left_rounded,
  IndoorManeuver.stairs => Icons.stairs_rounded,
  IndoorManeuver.elevator => Icons.elevator_rounded,
  IndoorManeuver.escalator => Icons.escalator_rounded,
  IndoorManeuver.ramp => Icons.accessible_forward_rounded,
  IndoorManeuver.floorTransition => Icons.swap_vert_rounded,
  IndoorManeuver.straight => Icons.straight_rounded,
};
