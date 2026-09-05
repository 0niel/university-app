import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rtu_mirea_app/free_rooms/cubit/free_rooms_cubit.dart';
import 'package:rtu_mirea_app/free_rooms/widgets/free_room_sheet.dart';
import 'package:rtu_mirea_app/free_rooms/widgets/free_room_view_model.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/map/bloc/map_bloc.dart';
import 'package:rtu_mirea_app/map/models/models.dart';
import 'package:rtu_mirea_app/map/services/room_key.dart';
import 'package:rtu_mirea_app/map/widgets/widgets.dart';

class MapView extends StatefulWidget {
  const MapView({this.mapController, super.key});

  final SvgInteractiveMapController? mapController;

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  late SvgInteractiveMapController _mapController;
  final _panelController = DraggableScrollableController();
  final _panelExtent = ValueNotifier<double>(0);
  final _mapViewportPadding = ValueNotifier<EdgeInsets>(EdgeInsets.zero);
  final _query = TextEditingController();
  Timer? _clock;
  String? _pendingRoom;
  double _collapsedPanelSize = .3;
  bool _panelFramePending = false;
  double _viewportHeight = 0;
  double _viewportTop = 0;

  @override
  void initState() {
    super.initState();
    _mapController = widget.mapController ?? SvgInteractiveMapController();
    _panelController.addListener(_panelChanged);
    _query.text = context.read<FreeRoomsCubit>().state.query;
    _clock = Timer.periodic(const Duration(minutes: 1), (_) {
      if (!mounted) return;
      setState(() {});
      unawaited(context.read<FreeRoomsCubit>().load());
    });
  }

  @override
  void didUpdateWidget(MapView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.mapController == widget.mapController) return;
    if (oldWidget.mapController == null) _mapController.dispose();
    _mapController = widget.mapController ?? SvgInteractiveMapController();
  }

  @override
  void dispose() {
    _clock?.cancel();
    if (widget.mapController == null) _mapController.dispose();
    _panelController.dispose();
    _panelExtent.dispose();
    _mapViewportPadding.dispose();
    _query.dispose();
    super.dispose();
  }

  void _panelChanged() {
    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      if (_panelFramePending) return;
      _panelFramePending = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _panelFramePending = false;
        if (mounted) _panelChanged();
      });
      return;
    }
    if (_panelController.isAttached) {
      _panelExtent.value = _panelController.size;
      _updateMapViewport(_panelController.size);
    }
  }

  void _updateMapViewport(double panelSize) {
    _mapViewportPadding.value = EdgeInsets.fromLTRB(
      20,
      _viewportTop,
      20,
      _viewportHeight * panelSize + 12,
    );
  }

  void _queryChanged(String value) {
    context.read<FreeRoomsCubit>().queryChanged(value);
    if (value.trim().isNotEmpty && _panelController.isAttached) {
      _panelController.jumpTo(.78);
    }
  }

  void _togglePanel() {
    if (!_panelController.isAttached) return;
    final target = _panelController.size > _collapsedPanelSize + .08
        ? _collapsedPanelSize
        : .78;
    if (MediaQuery.disableAnimationsOf(context) ||
        MediaQuery.accessibleNavigationOf(context)) {
      _panelController.jumpTo(target);
      return;
    }
    unawaited(
      _panelController.animateTo(
        target,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      ),
    );
  }

  void _campus(CampusModel campus) {
    _pendingRoom = null;
    context.read<FreeRoomsCubit>().campusChanged(campus.displayName);
    context.read<MapBloc>().add(MapEvent.campusSelected(campus));
  }

  void _floor(FloorModel floor) {
    final state = context.read<MapBloc>().state;
    final campus = state.selectedCampus;
    if (campus == null) return;
    context.read<FreeRoomsCubit>().floorChanged(floor.number);
    context.read<MapBloc>().add(
      MapEvent.floorSelected(campus: campus, floor: floor),
    );
  }

  void _focusRoom(FreeRoomViewModel room) {
    final state = context.read<MapBloc>().state;
    final campus = state.selectedCampus;
    final floor = campus?.floors
        .where((f) => f.number == room.floor)
        .firstOrNull;
    if (campus == null || floor == null) return;
    _pendingRoom = room.name;
    if (state.selectedFloor?.id == floor.id) {
      _focusPending(state);
    } else {
      _floor(floor);
    }
    if (_panelController.isAttached) {
      _panelController.jumpTo(_collapsedPanelSize);
    }
  }

  void _focusPending(MapState state) {
    if (state.status != MapStatus.loaded || _pendingRoom == null) return;
    final room = state.rooms
        .where(
          (room) => roomKey(room.name) == roomKey(_pendingRoom!),
        )
        .firstOrNull;
    if (room == null) return;
    _pendingRoom = null;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _mapController.focusRoom(room);
    });
  }

  void _openRoom(FreeRoomViewModel room) {
    unawaited(
      showFreeRoomSheet(
        context,
        room,
        onRoute: room.floor == null ? null : () => _focusRoom(room),
      ),
    );
  }

  void _openMappedRoom(RoomModel room) {
    final map = context.read<MapBloc>().state;
    final free = context
        .read<FreeRoomsCubit>()
        .state
        .copyWith(
          campus: map.selectedCampus?.displayName ?? '',
          floor: null,
          query: '',
        )
        .filtered(map.roomFloors)
        .where(
          (candidate) =>
              roomKey(candidate.room) == roomKey(room.name) &&
              (candidate.freeUntil == null ||
                  candidate.freeUntil!.isAfter(DateTime.now())),
        )
        .firstOrNull;
    if (free != null) {
      _openRoom(
        FreeRoomViewModel(
          room: free,
          now: DateTime.now(),
          floor: map.selectedFloor?.number,
          locale: context.l10n.localeName,
        ),
      );
      return;
    }
    unawaited(_showMappedRoom(room));
  }

  Future<void> _showMappedRoom(RoomModel room) async {
    final campus = context.read<MapBloc>().state.selectedCampus?.displayName;
    final search = await showAppSheet<bool>(
      context,
      child: MapRoomSheet(room: room, campus: campus ?? ''),
    );
    if (search != true || !mounted) return;
    unawaited(
      context.push(
        Uri(
          path: '/search',
          queryParameters: {
            'query': room.name.isEmpty ? room.roomId : room.name,
          },
        ).toString(),
      ),
    );
  }

  void _friends() {
    unawaited(
      showAppSheet<void>(
        context,
        title: context.l10n.mapFriendsToggle,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBanner(message: context.l10n.mapFriendsOutdoorHint),
            const SizedBox(height: 16),
            AppButton.primary(
              label: context.l10n.mapFriendsToggle,
              expanded: true,
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
                unawaited(context.push('/services/friends-map'));
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: context.colors.canvas,
    body: BlocConsumer<MapBloc, MapState>(
      listener: (_, state) => _focusPending(state),
      builder: (context, state) {
        if (state.status == MapStatus.failure) {
          return MapFailureCanvas(message: state.errorMessage);
        }
        final floor = state.selectedFloor;
        if (floor == null) return const MapSkeleton();
        final interactive = state.status == MapStatus.loaded;
        return LayoutBuilder(
          builder: (context, constraints) {
            final bottomInset = AppBottomBar.extentOf(context);
            final compactContentExtent =
                MapFreeRoomsPanel.compactContentExtentOf(
                  context,
                  width: constraints.maxWidth,
                  campusName: state.selectedCampus?.displayName ?? '',
                );
            _collapsedPanelSize =
                ((bottomInset + compactContentExtent) / constraints.maxHeight)
                    .clamp(.22, .42);
            _viewportHeight = constraints.maxHeight;
            _viewportTop = MediaQuery.paddingOf(context).top + 166;
            final panelSize = _panelController.isAttached
                ? _panelController.size
                : _query.text.trim().isEmpty
                ? _collapsedPanelSize
                : .78;
            _updateMapViewport(panelSize);
            return Stack(
              fit: StackFit.expand,
              children: [
                RepaintBoundary(
                  child: SvgInteractiveMap(
                    controller: _mapController,
                    svgAssetPath: floor.svgPath,
                    onRoomTap: _openMappedRoom,
                    viewportPadding: _mapViewportPadding.value,
                    viewportPaddingListenable: _mapViewportPadding,
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: MapTopBar(
                    controller: _query,
                    campuses: state.availableCampuses,
                    selectedCampus: state.selectedCampus,
                    onQueryChanged: _queryChanged,
                    onCampusSelected: _campus,
                    onFriends: _friends,
                  ),
                ),
                AnimatedBuilder(
                  animation: _panelExtent,
                  builder: (context, child) {
                    final panelHeight =
                        constraints.maxHeight *
                        (_panelController.isAttached
                            ? _panelController.size
                            : panelSize);
                    final controlsFit =
                        constraints.maxHeight - panelHeight >=
                        _viewportTop +
                            AppControlSize.touchTarget * 3 +
                            AppSpacing.xsm * 2 +
                            AppSpacing.md;
                    if (!controlsFit) return const SizedBox.shrink();
                    return Positioned(
                      right: 20,
                      bottom: panelHeight + 12,
                      child: child!,
                    );
                  },
                  child: MapCanvasControls(
                    onZoomIn: interactive ? _mapController.zoomIn : null,
                    onZoomOut: interactive ? _mapController.zoomOut : null,
                    onFit: interactive ? _mapController.fit : null,
                  ),
                ),
                MapFreeRoomsPanel(
                  controller: _panelController,
                  collapsedSize: _collapsedPanelSize,
                  viewportHeight: constraints.maxHeight,
                  bottomInset: bottomInset,
                  compactContentExtent: compactContentExtent,
                  mapState: state,
                  onRoomTap: _openRoom,
                  onFloor: _floor,
                  onToggle: _togglePanel,
                  onMappedRoomTap: (room) {
                    FocusScope.of(context).unfocus();
                    _mapController.focusRoom(room);
                    _openMappedRoom(room);
                  },
                ),
                if (!interactive)
                  Positioned(
                    top: MediaQuery.paddingOf(context).top + 160,
                    left: 20,
                    child: const MapLoadingPill(),
                  ),
              ],
            );
          },
        );
      },
    ),
  );
}
