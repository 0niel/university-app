import 'dart:async';
import 'dart:math' as math;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/map/bloc/map_bloc.dart';
import 'package:rtu_mirea_app/map/data/map_data_models.dart';
import 'package:rtu_mirea_app/map/models/models.dart';
import 'package:rtu_mirea_app/map/services/map_label_hit_index.dart';
import 'package:rtu_mirea_app/map/services/map_navigation_landmarks.dart';
import 'package:rtu_mirea_app/map/services/map_place_anchor.dart';
import 'package:rtu_mirea_app/map/services/map_place_landmarks.dart';
import 'package:rtu_mirea_app/map/widgets/map_floor_canvas.dart';
import 'package:rtu_mirea_app/map/widgets/map_places_explorer.dart';
import 'package:rtu_mirea_app/map/widgets/map_room_sheet.dart';
import 'package:rtu_mirea_app/map/widgets/svg_interactive_map_controller.dart';

class SvgInteractiveMap extends StatefulWidget {
  const SvgInteractiveMap({
    required this.svgAssetPath,
    this.controller,
    this.viewportPadding = EdgeInsets.zero,
    this.viewportPaddingListenable,
    this.onRoomTap,
    this.svgContent,
    this.routeSegments = const [],
    this.places = const [],
    this.showRoomLabels = false,
    this.syntheticRoomIds = const {},
    this.navigationLandmarks = const [],
    this.onNavigationLandmarkTap,
    this.tilted = false,
    this.routeInstructionPoint,
    this.showRouteStart = true,
    this.showRouteDestination = true,
    super.key,
  });

  final String svgAssetPath;
  final SvgInteractiveMapController? controller;
  final EdgeInsets viewportPadding;
  final ValueListenable<EdgeInsets>? viewportPaddingListenable;
  final ValueChanged<RoomModel>? onRoomTap;
  final String? svgContent;
  final List<List<Offset>> routeSegments;
  final List<MapPlaceData> places;
  final bool showRoomLabels;
  final Set<String> syntheticRoomIds;
  final List<MapNavigationLandmark> navigationLandmarks;
  final ValueChanged<MapNavigationLandmark>? onNavigationLandmarkTap;
  final bool tilted;
  final Offset? routeInstructionPoint;
  final bool showRouteStart;
  final bool showRouteDestination;

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
  final _labelHitIndex = MapLabelHitIndex();
  late final AnimationController _zoomController;
  Animation<Matrix4>? _zoomAnimation;
  Timer? _viewportSettled;
  int _viewportRevision = 0;
  BoxConstraints? _lastConstraints;
  Size? _lastViewportSize;
  bool _hasInitialTransform = false;
  bool _hasFittedView = false;
  double _initialScale = 1;
  Offset _doubleTapPosition = Offset.zero;
  String? _selectedRoomId;
  bool _userAdjustedCamera = false;
  Rect? _lastVisibleViewport;

  @override
  void initState() {
    super.initState();
    _zoomController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    )..addListener(_applyZoomAnimation);
    widget.controller?.attach(this);
    widget.viewportPaddingListenable?.addListener(_viewportChanged);
  }

  @override
  void didUpdateWidget(covariant SvgInteractiveMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.detach(this);
      widget.controller?.attach(this);
    }
    if (oldWidget.viewportPaddingListenable !=
        widget.viewportPaddingListenable) {
      oldWidget.viewportPaddingListenable?.removeListener(_viewportChanged);
      widget.viewportPaddingListenable?.addListener(_viewportChanged);
      _viewportChanged();
    }
    if (oldWidget.svgAssetPath != widget.svgAssetPath ||
        oldWidget.svgContent != widget.svgContent) {
      _cancelViewportRefit();
      _zoomController.stop();
      _zoomAnimation = null;
      _selectedRoomId = null;
      _labelHitIndex.clear();
      _hasInitialTransform = false;
      _hasFittedView = false;
      _userAdjustedCamera = false;
      _lastVisibleViewport = null;
    } else if (widget.viewportPaddingListenable == null &&
        oldWidget.viewportPadding != widget.viewportPadding) {
      _viewportChanged();
    }
  }

  void _viewportChanged() {
    _cancelViewportRefit();
    final revision = _viewportRevision;
    _zoomController.stop();
    _zoomAnimation = null;
    void apply() {
      if (mounted && revision == _viewportRevision) _refitViewport();
    }

    if (_reduceMotion) {
      WidgetsBinding.instance.addPostFrameCallback((_) => apply());
      return;
    }
    _viewportSettled = Timer(
      const Duration(milliseconds: 120),
      apply,
    );
  }

  void _cancelViewportRefit() {
    _viewportRevision++;
    _viewportSettled?.cancel();
    _viewportSettled = null;
  }

  void _refitViewport() {
    if (!mounted) return;
    final constraints = _lastConstraints;
    if (_userAdjustedCamera && constraints != null) {
      final viewport = _visibleViewport(constraints);
      final previous = _lastVisibleViewport;
      _lastVisibleViewport = viewport;
      if (previous != null) {
        final delta = viewport.center - previous.center;
        final matrix = _transformationController.value.clone();
        matrix.setTranslationRaw(
          matrix[12] + delta.dx,
          matrix[13] + delta.dy,
          0,
        );
        _animateTo(matrix);
      }
      return;
    }
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
  }

  @override
  void dispose() {
    widget.controller?.detach(this);
    widget.viewportPaddingListenable?.removeListener(_viewportChanged);
    _cancelViewportRefit();
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
            color: widget.showRoomLabels
                ? context.colors.isDark
                      ? AppColors.mapCanvasDark
                      : AppColors.mapCanvasLight
                : context.colors.surface2,
            child: ClipRect(
              child: TweenAnimationBuilder<double>(
                tween: Tween(end: widget.tilted ? .42 : 0),
                duration: _reduceMotion
                    ? Duration.zero
                    : const Duration(milliseconds: 280),
                curve: Curves.easeOutCubic,
                builder: (context, angle, child) => Transform(
                  key: const ValueKey('map-presentation-transform'),
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, .00055)
                    ..rotateX(angle),
                  child: child,
                ),
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
                      _cancelViewportRefit();
                      _userAdjustedCamera = true;
                      _lastVisibleViewport = _visibleViewport(constraints);
                    },
                    child: RepaintBoundary(
                      child: MapFloorCanvas(
                        svgAssetPath: widget.svgAssetPath,
                        canvasSize: Size(bounds.width, bounds.height),
                        rooms: rooms,
                        selectedRoomId: _selectedRoomId,
                        svgContent: widget.svgContent,
                        routeSegments: widget.routeSegments,
                        places: widget.places,
                        transform: _transformationController,
                        showRoomLabels: widget.showRoomLabels,
                        syntheticRoomIds: widget.syntheticRoomIds,
                        navigationLandmarks: widget.navigationLandmarks,
                        labelHitIndex: _labelHitIndex,
                        routeInstructionPoint: widget.routeInstructionPoint,
                        showRouteStart: widget.showRouteStart,
                        showRouteDestination: widget.showRouteDestination,
                      ),
                    ),
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
    if (state.status != .loaded) return;
    final floorId = state.selectedFloor?.id;
    final localPosition = details.localPosition;
    final scenePosition = _transformationController.toScene(localPosition);
    final labelId = _labelHitIndex.hitTest(scenePosition);
    final landmark = widget.navigationLandmarks
        .where((item) => item.place.id == labelId)
        .firstOrNull;
    if (landmark != null && widget.onNavigationLandmarkTap != null) {
      unawaited(HapticFeedback.selectionClick());
      widget.onNavigationLandmarkTap!(landmark);
      return;
    }
    if (state.rooms.isEmpty) return;
    final containing = state.rooms
        .where((room) => room.path.contains(scenePosition))
        .toList();
    if (labelId != null && state.rooms.any((room) => room.roomId == labelId)) {
      containing
        ..clear()
        ..add(state.rooms.firstWhere((room) => room.roomId == labelId));
    } else if (widget.showRoomLabels) {
      final places = {for (final place in widget.places) place.id: place};
      final services = {
        ...widget.syntheticRoomIds,
        for (final place in widget.places)
          if (mapPlaceKindLabel(place.kind) != 'Аудитория') place.id,
      };
      final nearby = <(RoomModel, double)>[];
      final landmarks = {
        for (final place in widget.places)
          if (mapPlaceLandmarkPriority(place.kind) > 0) place.id,
      };
      for (final room in state.rooms.where(
        (room) => services.contains(room.roomId),
      )) {
        final bounds = room.path.getBounds();
        final location = resolveMapPlaceAnchor(
          room.path,
          floorSize: state.boundingRect!.size,
          place: places[room.roomId],
        );
        if (location.detachedService) {
          containing.removeWhere(
            (candidate) => candidate.roomId == room.roomId,
          );
        }
        if (!widget.syntheticRoomIds.contains(room.roomId) &&
            !location.detachedService &&
            !landmarks.contains(room.roomId) &&
            math.max(bounds.width, bounds.height) * currentScale < 16) {
          continue;
        }
        final anchor = location.point;
        if (anchor == null) continue;
        final distance = (anchor - scenePosition).distance * currentScale;
        if (distance <= 22) nearby.add((room, distance));
      }
      if (nearby.isNotEmpty) {
        nearby.sort((a, b) => a.$2.compareTo(b.$2));
        containing
          ..clear()
          ..add(nearby.first.$1);
      }
    }
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
    _cancelViewportRefit();
    _userAdjustedCamera = true;
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
    _cancelViewportRefit();
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
    _lastVisibleViewport = viewport;
    _userAdjustedCamera = false;
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
    _cancelViewportRefit();
    final constraints = _lastConstraints;
    final rect = room.path.getBounds();
    if (constraints == null || rect.isEmpty) return;
    final location = resolveMapPlaceAnchor(
      room.path,
      floorSize: context.read<MapBloc>().state.boundingRect?.size ?? Size.zero,
      place: widget.places
          .where((place) => place.id == room.roomId)
          .firstOrNull,
    );
    final center = location.detachedService ? location.point! : rect.center;
    setState(() => _selectedRoomId = room.roomId);
    final viewport = _visibleViewport(constraints);
    _lastVisibleViewport = viewport;
    _userAdjustedCamera = false;
    final horizontalScale = viewport.width * 0.5 / rect.width;
    final verticalScale = viewport.height * 0.46 / rect.height;
    final minimum = math.min(_initialScale * 1.8, _maxScale);
    final scale = math
        .min(horizontalScale, verticalScale)
        .clamp(minimum, _maxScale);
    final x = viewport.center.dx - center.dx * scale;
    final y = viewport.top + viewport.height * .48 - center.dy * scale;
    final target = Matrix4.identity()
      ..scaleByDouble(scale, scale, 1, 1)
      ..translateByDouble(x / scale, y / scale, 0, 1);
    _animateTo(target);
  }

  @override
  void focusPoints(List<Offset> points) {
    if (!mounted) return;
    final constraints = _lastConstraints;
    final floorBounds = context.read<MapBloc>().state.boundingRect;
    final valid = points
        .where((point) => point.dx.isFinite && point.dy.isFinite)
        .toList();
    if (constraints == null || floorBounds == null || valid.isEmpty) return;
    var bounds = Rect.fromPoints(valid.first, valid.first);
    for (final point in valid.skip(1)) {
      bounds = bounds.expandToInclude(Rect.fromPoints(point, point));
    }
    final minimumExtent = math.max<double>(floorBounds.shortestSide / 12, 1);
    bounds = Rect.fromCenter(
      center: bounds.center,
      width: math.max(bounds.width, minimumExtent),
      height: math.max(bounds.height, minimumExtent),
    );
    final viewport = _visibleViewport(constraints);
    final scale = math
        .min(
          viewport.width * .76 / bounds.width,
          viewport.height * .76 / bounds.height,
        )
        .clamp(_minScale, _maxScale);
    _cancelViewportRefit();
    _lastVisibleViewport = viewport;
    _userAdjustedCamera = true;
    setState(() => _selectedRoomId = null);
    _animateTo(
      Matrix4.identity()
        ..scaleByDouble(scale, scale, 1, 1)
        ..setTranslationRaw(
          viewport.center.dx - bounds.center.dx * scale,
          viewport.center.dy - bounds.center.dy * scale,
          0,
        ),
    );
  }

  void _zoomBy(double factor) {
    if (!mounted) return;
    _cancelViewportRefit();
    final constraints = _lastConstraints;
    if (constraints == null) return;
    final viewport = _visibleViewport(constraints);
    _lastVisibleViewport = viewport;
    _userAdjustedCamera = true;
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
    final padding =
        widget.viewportPaddingListenable?.value ?? widget.viewportPadding;
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
