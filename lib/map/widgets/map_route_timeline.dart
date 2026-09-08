import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rtu_mirea_app/map/data/map_data_models.dart';
import 'package:rtu_mirea_app/map/navigation/navigation.dart';
import 'package:rtu_mirea_app/map/widgets/map_route_presentation.dart';

class MapRouteTimeline extends StatefulWidget {
  const MapRouteTimeline({
    required this.campus,
    required this.route,
    required this.stepIndex,
    required this.onPreview,
    required this.onCancelPreview,
    this.onSelected,
    this.onNext,
    this.onPrevious,
    super.key,
  });

  final CampusMapData campus;
  final IndoorRoute route;
  final int stepIndex;
  final ValueChanged<int> onPreview;
  final VoidCallback onCancelPreview;
  final ValueChanged<int>? onSelected;
  final VoidCallback? onNext;
  final VoidCallback? onPrevious;

  @override
  State<MapRouteTimeline> createState() => _MapRouteTimelineState();
}

class _MapRouteTimelineState extends State<MapRouteTimeline> {
  final _focus = FocusNode();
  final _scroll = ScrollController();
  final _milestoneKeys = <int, GlobalKey>{};
  bool _focused = false;
  int? _preview;
  int? _pendingSelection;
  int _gestureRevision = 0;
  bool _ignoreCommit = false;
  bool _pointerActive = false;

  @override
  void didUpdateWidget(MapRouteTimeline oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.route, widget.route) ||
        !identical(oldWidget.campus, widget.campus) ||
        oldWidget.onSelected != null && widget.onSelected == null) {
      _gestureRevision++;
      _preview = null;
      _pendingSelection = null;
      if (_pointerActive) _ignoreCommit = true;
      _milestoneKeys.clear();
    }
    if (oldWidget.stepIndex != widget.stepIndex) {
      _pendingSelection = null;
      WidgetsBinding.instance.addPostFrameCallback((_) => _revealMilestone());
    }
  }

  List<int> get _milestones => [
    for (var i = 0; i < widget.route.instructions.length; i++)
      if (i == 0 ||
          i == widget.route.instructions.length - 1 ||
          _connector(widget.route.instructions[i]))
        i,
  ];

  bool _connector(IndoorRouteInstruction step) => switch (step.maneuver) {
    IndoorManeuver.stairs ||
    IndoorManeuver.elevator ||
    IndoorManeuver.ramp ||
    IndoorManeuver.escalator ||
    IndoorManeuver.floorTransition => true,
    _ => step.toNode != null && step.atNode.floorId != step.toNode!.floorId,
  };

  void _revealMilestone() {
    if (!mounted) return;
    final active = _milestones.lastWhere((index) => index <= widget.stepIndex);
    final context = _milestoneKeys[active]?.currentContext;
    final target = context?.findRenderObject();
    if (target != null && _scroll.hasClients) {
      unawaited(_scroll.position.ensureVisible(target, alignment: .5));
    }
  }

  void _previewChanged(double value) {
    if (_pointerActive && _ignoreCommit) return;
    final index = (value.round() - 1).clamp(
      0,
      widget.route.instructions.length - 1,
    );
    if (_preview == index) return;
    _preview = index;
    widget.onPreview(index);
  }

  void _commit(double value) {
    if (_ignoreCommit) return;
    final index = _preview ?? (value.round() - 1);
    _select(index);
  }

  void _select(int index) {
    _preview = null;
    _pendingSelection = index.clamp(0, widget.route.instructions.length - 1);
    _gestureRevision++;
    widget.onSelected?.call(_pendingSelection!);
  }

  void _cancel() {
    _preview = null;
    _gestureRevision++;
    widget.onCancelPreview();
  }

  KeyEventResult _key(FocusNode node, KeyEvent event) {
    if (widget.onSelected == null || event is KeyUpEvent) {
      return KeyEventResult.ignored;
    }
    final last = widget.route.instructions.length - 1;
    final current = _pendingSelection ?? widget.stepIndex;
    final index = switch (event.logicalKey) {
      LogicalKeyboardKey.arrowLeft ||
      LogicalKeyboardKey.arrowDown => current - 1,
      LogicalKeyboardKey.arrowRight ||
      LogicalKeyboardKey.arrowUp => current + 1,
      LogicalKeyboardKey.home => 0,
      LogicalKeyboardKey.end => last,
      _ => null,
    };
    if (index == null) return KeyEventResult.ignored;
    _select(index);
    return KeyEventResult.handled;
  }

  String _milestoneLabel(int index) {
    if (index == 0) return 'Старт';
    if (index == widget.route.instructions.length - 1) return 'Финиш';
    final step = widget.route.instructions[index];
    final from = widget.campus.floorForId(step.atNode.floorId)?.floor.number;
    final to = widget.campus
        .floorForId(step.toNode?.floorId ?? '')
        ?.floor
        .number;
    if (from != null && to != null && from != to) return '$from → $to этаж';
    return switch (step.maneuver) {
      IndoorManeuver.stairs => 'Лестница',
      IndoorManeuver.elevator => 'Лифт',
      IndoorManeuver.ramp => 'Пандус',
      IndoorManeuver.escalator => 'Эскалатор',
      _ => 'Переход',
    };
  }

  @override
  void dispose() {
    _focus.dispose();
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final count = widget.route.instructions.length;
    final instructionLabel = mapRouteInstructionLabel(
      widget.route.instructions[widget.stepIndex],
      widget.campus,
    );
    final milestones = _milestones;
    final active = milestones.lastWhere((index) => index <= widget.stepIndex);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SingleChildScrollView(
          controller: _scroll,
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (final index in milestones) ...[
                if (index != milestones.first)
                  const SizedBox(width: AppSpacing.xs),
                Semantics(
                  label: 'Шаг ${index + 1}. ${_milestoneLabel(index)}',
                  child: AppChip(
                    key: _milestoneKeys.putIfAbsent(index, GlobalKey.new),
                    label: _milestoneLabel(index),
                    leading: Icon(
                      mapRouteInstructionIcon(
                        widget.route.instructions[index].maneuver,
                      ),
                      size: 16,
                    ),
                    selected: active == index,
                    enabled: widget.onSelected != null,
                    onTap: widget.onSelected == null
                        ? null
                        : () => _select(index),
                  ),
                ),
              ],
            ],
          ),
        ),
        Row(
          children: [
            AppIconButton(
              tooltip: 'Предыдущий шаг',
              shape: AppIconButtonShape.circle,
              size: AppIconButtonSize.compact,
              tone: AppIconButtonTone.surface,
              onPressed: widget.onPrevious,
              icon: const Icon(Icons.arrow_back_rounded),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Focus(
                focusNode: _focus,
                canRequestFocus: widget.onSelected != null,
                onFocusChange: (value) => setState(() => _focused = value),
                onKeyEvent: _key,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadius.focusOutline),
                    border: Border.all(
                      color: _focused
                          ? context.colors.accent
                          : Colors.transparent,
                    ),
                  ),
                  child: Listener(
                    onPointerDown: (_) {
                      _pointerActive = true;
                      _gestureRevision++;
                      _preview = null;
                      _ignoreCommit = false;
                      if (widget.onSelected != null) _focus.requestFocus();
                    },
                    onPointerCancel: (_) {
                      _pointerActive = false;
                      _ignoreCommit = true;
                      _cancel();
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) _ignoreCommit = false;
                      });
                    },
                    onPointerUp: (_) {
                      _pointerActive = false;
                      final revision = _gestureRevision;
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted && revision == _gestureRevision) _cancel();
                      });
                    },
                    child: Semantics(
                      slider: true,
                      excludeSemantics: true,
                      enabled: widget.onSelected != null && count > 1,
                      label: 'Просмотр маршрута вручную. $instructionLabel',
                      value: '${widget.stepIndex + 1} из $count',
                      increasedValue: widget.stepIndex < count - 1
                          ? '${widget.stepIndex + 2} из $count'
                          : null,
                      decreasedValue: widget.stepIndex > 0
                          ? '${widget.stepIndex} из $count'
                          : null,
                      onIncrease:
                          widget.onSelected != null &&
                              widget.stepIndex < count - 1
                          ? () => _select(
                              (_pendingSelection ?? widget.stepIndex) + 1,
                            )
                          : null,
                      onDecrease:
                          widget.onSelected != null && widget.stepIndex > 0
                          ? () => _select(
                              (_pendingSelection ?? widget.stepIndex) - 1,
                            )
                          : null,
                      child: AppSlider(
                        value: widget.stepIndex + 1.0,
                        min: 1,
                        max: count.toDouble(),
                        divisions: count > 1 && count <= 100 ? count - 1 : null,
                        enabled: widget.onSelected != null && count > 1,
                        onChanged: widget.onSelected == null
                            ? null
                            : _previewChanged,
                        onChangeEnd: widget.onSelected == null ? null : _commit,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            AppIconButton(
              tooltip: widget.stepIndex == count - 1
                  ? 'Закончить просмотр маршрута'
                  : 'Следующий шаг',
              shape: AppIconButtonShape.circle,
              size: AppIconButtonSize.compact,
              tone: AppIconButtonTone.primary,
              onPressed: widget.onNext,
              icon: Icon(
                widget.stepIndex == count - 1
                    ? Icons.check_rounded
                    : Icons.arrow_forward_rounded,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
