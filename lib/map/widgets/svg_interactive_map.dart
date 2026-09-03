import 'dart:async';
import 'dart:math' as math;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/map/bloc/map_bloc.dart';
import 'package:rtu_mirea_app/map/models/models.dart';
import 'package:rtu_mirea_app/map/widgets/map_floor_canvas.dart';
import 'package:rtu_mirea_app/map/widgets/map_room_sheet.dart';
import 'package:rtu_mirea_app/map/widgets/svg_interactive_map_controller.dart';

class SvgInteractiveMap extends StatefulWidget {
  const SvgInteractiveMap({
    required this.svgAssetPath,
    this.controller,
    this.viewportPadding = EdgeInsets.zero,
    this.onRoomTap,
    super.key,
  });

  final String svgAssetPath;
  final SvgInteractiveMapController? controller;
  final EdgeInsets viewportPadding;
  final ValueChanged<RoomModel>? onRoomTap;

  @override
  State<SvgInteractiveMap> createState() => _SvgInteractiveMapState();
}

class _SvgInteractiveMapState extends State<SvgInteractiveMap>
    with SingleTickerProviderStateMixin
    implements SvgInteractiveMapHandle {
  static const _minScale = 0.1;
  static const _maxScale = 50.0;
  static const _zoomStep = 1.45;

  final _transformationController = TransformationController();
  late final AnimationController _zoomController;
  Animation<Matrix4>? _zoomAnimation;
  BoxConstraints? _lastConstraints;
  Size? _lastViewportSize;
  bool _hasInitialTransform = false;
  bool _hasFittedView = false;
  double _initialScale = 1;
  Offset _doubleTapPosition = Offset.zero;
  String? _selectedRoomId;

  @override
  void initState() {
    super.initState();
    _zoomController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    )..addListener(_applyZoomAnimation);
    widget.controller?.attach(this);
  }

  @override
  void didUpdateWidget(covariant SvgInteractiveMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.detach(this);
      widget.controller?.attach(this);
    }
    if (oldWidget.svgAssetPath != widget.svgAssetPath) {
      _zoomController.stop();
      _zoomAnimation = null;
      _selectedRoomId = null;
      _hasInitialTransform = false;
      _hasFittedView = false;
    } else if (oldWidget.viewportPadding != widget.viewportPadding) {
      _hasFittedView = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final selected = context
            .read<MapBloc>()
            .state
            .rooms
            .where((room) => room.roomId == _selectedRoomId)
            .firstOrNull;
        if (selected == null) {
          fit();
        } else {
          focusRoom(selected);
        }
      });
    }
  }

  @override
  void dispose() {
    widget.controller?.detach(this);
    _zoomController.dispose();
    _transformationController.dispose();
    super.dispose();
  }

  void _applyZoomAnimation() {
    final animation = _zoomAnimation;
    if (animation != null) {
      _transformationController.value = animation.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bounds = context.select<MapBloc, Rect?>(
      (bloc) => bloc.state.boundingRect,
    );
    if (bounds == null || bounds.width <= 0 || bounds.height <= 0) {
      return ColoredBox(
        key: const ValueKey('map-canvas-surface'),
        color: context.colors.surface2,
        child: const Center(child: NinjaSpinner()),
      );
    }
    final rooms = context.select<MapBloc, List<RoomModel>>(
      (bloc) => bloc.state.rooms,
    );
    final interactive = context.select<MapBloc, bool>(
      (bloc) => bloc.state.status == .loaded,
    );
    final l10n = context.l10n;
    return LayoutBuilder(
      builder: (context, constraints) {
        _lastConstraints = constraints;
        final viewportSize = Size(
          constraints.maxWidth,
          constraints.maxHeight,
        );
        final viewportChanged =
            _lastViewportSize != null && _lastViewportSize != viewportSize;
        _lastViewportSize = viewportSize;
        if (viewportChanged) {
          _zoomController.stop();
          _zoomAnimation = null;
          _hasFittedView = false;
          WidgetsBinding.instance.addPostFrameCallback((_) => fit());
        }
        if (!_hasInitialTransform) {
          _hasInitialTransform = true;
          WidgetsBinding.instance.addPostFrameCallback((_) => fit());
        }
        return Semantics(
          container: true,
          label: l10n.mapInteractiveLabel,
          hint: l10n.mapInteractiveHint,
          child: ColoredBox(
            key: const ValueKey('map-canvas-surface'),
            color: context.colors.surface2,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapUp: interactive
                  ? (details) => unawaited(_selectRoom(details))
                  : null,
              onDoubleTapDown: (details) =>
                  _doubleTapPosition = details.localPosition,
              onDoubleTap: _handleDoubleTap,
              child: InteractiveViewer(
                constrained: false,
                boundaryMargin: const EdgeInsets.all(20000),
                minScale: _minScale,
                maxScale: _maxScale,
                transformationController: _transformationController,
                onInteractionStart: (_) {
                  _zoomController.stop();
                },
                child: RepaintBoundary(
                  child: MapFloorCanvas(
                    svgAssetPath: widget.svgAssetPath,
                    canvasSize: Size(bounds.width, bounds.height),
                    rooms: rooms,
                    selectedRoomId: _selectedRoomId,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _selectRoom(TapUpDetails details) async {
    final state = context.read<MapBloc>().state;
    if (state.status != .loaded || state.rooms.isEmpty) return;
    final floorId = state.selectedFloor?.id;
    final localPosition = details.localPosition;
    final scenePosition = _transformationController.toScene(localPosition);
    final containing = state.rooms
        .where((room) => room.path.contains(scenePosition))
        .toList();
    if (containing.isEmpty) return;
    final room = containing.reduce((closest, candidate) {
      final closestDistance =
          (closest.path.getBounds().center - scenePosition).distance;
      final candidateDistance =
          (candidate.path.getBounds().center - scenePosition).distance;
      return candidateDistance < closestDistance ? candidate : closest;
    });
    setState(() => _selectedRoomId = room.roomId);
    context.read<MapBloc>().add(MapEvent.roomTapped(room.roomId));
    unawaited(HapticFeedback.selectionClick());
    if (widget.onRoomTap case final onRoomTap?) {
      onRoomTap(room);
      return;
    }
    final campus = state.selectedCampus?.displayName ?? '';
    final shouldSearch = await showAppSheet<bool>(
      context,
      backgroundColor: context.colors.canvas,
      child: MapRoomSheet(room: room, campus: campus),
    );
    if (shouldSearch == true && mounted) {
      final current = context.read<MapBloc>().state;
      if (current.status != .loaded ||
          current.selectedFloor?.id != floorId ||
          !current.rooms.any((candidate) => candidate.roomId == room.roomId)) {
        return;
      }
      final query = room.name.isEmpty ? room.roomId : room.name;
      unawaited(
        context.push(
          Uri(
            path: '/search',
            queryParameters: {'query': query},
          ).toString(),
        ),
      );
    }
  }

  void _handleDoubleTap() {
    final current = _transformationController.value;
    final scale = _planarScale(current);
    final nextScale = scale < _initialScale * 2.5
        ? math.min(scale * 2, _maxScale)
        : _initialScale;
    final scenePoint = _transformationController.toScene(_doubleTapPosition);
    _animateTo(_clampMatrix(_scaledAround(current, scenePoint, nextScale)));
  }

  bool get _reduceMotion =>
      MediaQuery.disableAnimationsOf(context) ||
      MediaQuery.accessibleNavigationOf(context);

  @override
  double get currentScale => _planarScale(_transformationController.value);

  @override
  void fit() {
    if (!mounted) return;
    final constraints = _lastConstraints;
    final bounds = context.read<MapBloc>().state.boundingRect;
    if (constraints == null ||
        bounds == null ||
        bounds.width <= 0 ||
        bounds.height <= 0 ||
        !constraints.hasBoundedWidth ||
        !constraints.hasBoundedHeight) {
      return;
    }
    final viewport = _visibleViewport(constraints);
    final scale = math
        .min(viewport.width / bounds.width, viewport.height / bounds.height)
        .clamp(_minScale, _maxScale);
    _initialScale = scale;
    final x = viewport.left + (viewport.width - bounds.width * scale) / 2;
    final y = viewport.top + (viewport.height - bounds.height * scale) / 2;
    final target = Matrix4.identity()
      ..scaleByDouble(scale, scale, 1, 1)
      ..translateByDouble(x / scale, y / scale, 0, 1);
    if (_hasFittedView) {
      _animateTo(target);
    } else {
      _hasFittedView = true;
      _transformationController.value = target;
    }
  }

  @override
  void zoomIn() => _zoomBy(_zoomStep);

  @override
  void zoomOut() => _zoomBy(1 / _zoomStep);

  @override
  void focusRoom(RoomModel room) {
    if (!mounted) return;
    final constraints = _lastConstraints;
    final rect = room.path.getBounds();
    if (constraints == null || rect.isEmpty) return;
    setState(() => _selectedRoomId = room.roomId);
    final viewport = _visibleViewport(constraints);
    final horizontalScale = viewport.width * 0.5 / rect.width;
    final verticalScale = viewport.height * 0.46 / rect.height;
    final minimum = math.min(_initialScale * 1.8, _maxScale);
    final scale = math
        .min(horizontalScale, verticalScale)
        .clamp(minimum, _maxScale);
    final x = viewport.center.dx - rect.center.dx * scale;
    final y = viewport.top + viewport.height * .48 - rect.center.dy * scale;
    final target = Matrix4.identity()
      ..scaleByDouble(scale, scale, 1, 1)
      ..translateByDouble(x / scale, y / scale, 0, 1);
    _animateTo(target);
  }

  void _zoomBy(double factor) {
    if (!mounted) return;
    final constraints = _lastConstraints;
    if (constraints == null) return;
    final viewport = _visibleViewport(constraints);
    final current = _transformationController.value;
    final scale = _planarScale(current);
    final minimum = math.min(
      math.max(_initialScale * .72, _minScale),
      _maxScale,
    );
    final nextScale = (scale * factor).clamp(minimum, _maxScale);
    final scenePoint = _transformationController.toScene(viewport.center);
    _animateTo(_clampMatrix(_scaledAround(current, scenePoint, nextScale)));
  }

  Matrix4 _scaledAround(Matrix4 current, Offset scenePoint, double nextScale) {
    final ratio = nextScale / _planarScale(current);
    final incremental = Matrix4.identity()
      ..translateByDouble(scenePoint.dx, scenePoint.dy, 0, 1)
      ..scaleByDouble(ratio, ratio, 1, 1)
      ..translateByDouble(-scenePoint.dx, -scenePoint.dy, 0, 1);
    return current.clone()..multiply(incremental);
  }

  void _animateTo(Matrix4 target) {
    _zoomController.stop();
    if (_reduceMotion) {
      _zoomAnimation = null;
      _transformationController.value = target;
      return;
    }
    _zoomAnimation =
        Matrix4Tween(
          begin: _transformationController.value,
          end: target,
        ).animate(
          CurvedAnimation(parent: _zoomController, curve: Curves.easeOutCubic),
        );
    unawaited(_zoomController.forward(from: 0));
  }

  Rect _visibleViewport(BoxConstraints constraints) {
    final padding = widget.viewportPadding;
    final width = math
        .max(constraints.maxWidth - padding.left - padding.right, 1)
        .toDouble();
    final height = math
        .max(constraints.maxHeight - padding.top - padding.bottom, 1)
        .toDouble();
    return Rect.fromLTWH(padding.left, padding.top, width, height);
  }

  Matrix4 _clampMatrix(Matrix4 matrix) {
    final scale = _planarScale(matrix).clamp(_minScale, _maxScale);
    final x = matrix[12].clamp(-20000.0, 20000.0);
    final y = matrix[13].clamp(-20000.0, 20000.0);
    return Matrix4.identity()
      ..scaleByDouble(scale, scale, 1, 1)
      ..setTranslationRaw(x, y, 0);
  }

  double _planarScale(Matrix4 matrix) {
    final x = math.sqrt(matrix[0] * matrix[0] + matrix[1] * matrix[1]);
    final y = math.sqrt(matrix[4] * matrix[4] + matrix[5] * matrix[5]);
    return math.max(x, y);
  }
}
