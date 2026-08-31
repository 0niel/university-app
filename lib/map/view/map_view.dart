import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/map/bloc/map_bloc.dart';
import 'package:rtu_mirea_app/map/models/models.dart';
import 'package:rtu_mirea_app/map/widgets/widgets.dart';

class MapView extends StatefulWidget {
  const MapView({this.mapController, super.key});

  final SvgInteractiveMapController? mapController;

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  late SvgInteractiveMapController _mapController;
  late bool _ownsMapController;
  final _levelController = DraggableScrollableController();

  @override
  void initState() {
    super.initState();
    _ownsMapController = widget.mapController == null;
    _mapController = widget.mapController ?? SvgInteractiveMapController();
  }

  @override
  void didUpdateWidget(MapView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (identical(oldWidget.mapController, widget.mapController)) return;
    if (_ownsMapController) _mapController.dispose();
    _ownsMapController = widget.mapController == null;
    _mapController = widget.mapController ?? SvgInteractiveMapController();
  }

  Future<void> _openRoomFinder(MapState state) async {
    final l10n = context.l10n;
    final room = await showAppSheet<RoomModel>(
      context,
      backgroundColor: context.ninja.canvas,
      title: l10n.mapFindRoom,
      subtitle: l10n.mapFindRoomHint,
      contentPadding: EdgeInsets.zero,
      child: MapRoomFinder(rooms: state.rooms),
    );
    if (!mounted || room == null) return;
    final current = context.read<MapBloc>().state;
    if (current.status != .loaded ||
        current.selectedFloor?.id != state.selectedFloor?.id) {
      return;
    }
    RoomModel? currentRoom;
    for (final candidate in current.rooms) {
      if (candidate.roomId == room.roomId) {
        currentRoom = candidate;
        break;
      }
    }
    if (currentRoom == null) return;
    _mapController.focusRoom(currentRoom);
    unawaited(HapticFeedback.selectionClick());
  }

  void _toggleLevelPanel(double compactExtent, double expandedExtent) {
    if (!_levelController.isAttached) return;
    final target = _levelController.size > compactExtent + .04
        ? compactExtent
        : expandedExtent;
    final reduceMotion =
        MediaQuery.disableAnimationsOf(context) ||
        MediaQuery.accessibleNavigationOf(context);
    if (reduceMotion) {
      _levelController.jumpTo(target);
      return;
    }
    unawaited(
      _levelController.animateTo(
        target,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
      ),
    );
  }

  @override
  void dispose() {
    if (_ownsMapController) _mapController.dispose();
    _levelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return Scaffold(
      backgroundColor: colors.canvas,
      body: BlocBuilder<MapBloc, MapState>(
        buildWhen: (previous, current) =>
            previous.status != current.status ||
            previous.selectedCampus?.id != current.selectedCampus?.id ||
            previous.selectedFloor?.id != current.selectedFloor?.id ||
            !listEquals(
              previous.availableCampuses,
              current.availableCampuses,
            ) ||
            previous.boundingRect != current.boundingRect ||
            previous.errorMessage != current.errorMessage,
        builder: (context, state) => NinjaStateSwitcher(
          alignment: Alignment.center,
          child: _body(context, state),
        ),
      ),
    );
  }

  Widget _body(BuildContext context, MapState state) {
    if (state.status == .failure) {
      return KeyedSubtree(
        key: const ValueKey('map-failure'),
        child: MapFailureCanvas(message: state.errorMessage),
      );
    }

    final campus = state.selectedCampus;
    final floor = state.selectedFloor;
    if (campus == null || floor == null) {
      return const KeyedSubtree(
        key: ValueKey('map-skeleton'),
        child: MapSkeleton(),
      );
    }

    final layout = MapPanelLayout.from(MediaQuery.of(context));
    final interactive = state.status == .loaded;
    return KeyedSubtree(
      key: const ValueKey('map-content'),
      child: Stack(
        fit: StackFit.expand,
        children: [
          RepaintBoundary(
            child: SvgInteractiveMap(
              controller: _mapController,
              svgAssetPath: floor.svgPath,
              viewportPadding: EdgeInsets.fromLTRB(
                NinjaMetrics.screenPadding,
                layout.canvasTopInset,
                NinjaMetrics.screenPadding,
                layout.collapsedPixels + 16,
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: MapTopBar(
              onSearch: interactive
                  ? () => unawaited(_openRoomFinder(state))
                  : null,
            ).animateSectionEntrance(),
          ),
          MapLevelPanel(
            controller: _levelController,
            layout: layout,
            campuses: state.availableCampuses,
            selectedCampus: campus,
            selectedFloor: floor,
            onToggle: _toggleLevelPanel,
          ).animateSectionEntrance(index: 2),
          Positioned(
            right: NinjaMetrics.screenPadding,
            bottom: layout.collapsedPixels + 12,
            child: AnimatedBuilder(
              animation: _levelController,
              builder: (context, child) {
                final size = _levelController.isAttached
                    ? _levelController.size
                    : layout.collapsedExtent;
                final range = layout.expandedExtent - layout.collapsedExtent;
                final progress = range <= 0
                    ? 0.0
                    : ((size - layout.collapsedExtent) / range).clamp(0.0, 1.0);
                final visible = progress < .12;
                return IgnorePointer(
                  ignoring: !visible,
                  child: AnimatedOpacity(
                    opacity: visible ? 1 : 0,
                    duration: NinjaMotion.of(context, NinjaMotion.fast),
                    curve: NinjaMotion.enter,
                    child: child,
                  ),
                );
              },
              child: MapCanvasControls(
                onZoomIn: interactive ? _mapController.zoomIn : null,
                onZoomOut: interactive ? _mapController.zoomOut : null,
                onFit: interactive ? _mapController.fit : null,
              ).animateSectionEntrance(index: 1),
            ),
          ),
          Positioned(
            top: MediaQuery.paddingOf(context).top + 76,
            left: 0,
            right: 0,
            child: Center(
              child: NinjaStateSwitcher(
                child: state.status == .loading
                    ? const MapLoadingPill(key: ValueKey('map-loading-pill'))
                    : const SizedBox.shrink(key: ValueKey('map-idle')),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
