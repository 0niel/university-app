import 'dart:async';
import 'dart:math' as math;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:rtu_mirea_app/free_rooms/cubit/free_rooms_cubit.dart';
import 'package:rtu_mirea_app/free_rooms/widgets/free_room_sheet.dart';
import 'package:rtu_mirea_app/free_rooms/widgets/free_room_view_model.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/map/bloc/map_bloc.dart';
import 'package:rtu_mirea_app/map/data/map_data_models.dart';
import 'package:rtu_mirea_app/map/models/models.dart';
import 'package:rtu_mirea_app/map/navigation/navigation.dart';
import 'package:rtu_mirea_app/map/services/map_navigation_landmarks.dart';
import 'package:rtu_mirea_app/map/services/map_navigation_preparation.dart';
import 'package:rtu_mirea_app/map/services/room_key.dart';
import 'package:rtu_mirea_app/map/widgets/map_edit_menu.dart';
import 'package:rtu_mirea_app/map/widgets/map_floor_alignment_page.dart';
import 'package:rtu_mirea_app/map/widgets/map_geographic_view.dart';
import 'package:rtu_mirea_app/map/widgets/map_place_details_sheet.dart'
    hide mapPlaceKindLabel;
import 'package:rtu_mirea_app/map/widgets/map_place_editor_page.dart';
import 'package:rtu_mirea_app/map/widgets/map_places_explorer.dart';
import 'package:rtu_mirea_app/map/widgets/map_route_guidance.dart';
import 'package:rtu_mirea_app/map/widgets/map_route_sheet.dart';
import 'package:rtu_mirea_app/map/widgets/map_saved_places_sheet.dart';
import 'package:rtu_mirea_app/map/widgets/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class MapView extends StatefulWidget {
  const MapView({
    this.mapController,
    this.initialCampusId,
    this.initialRoomId,
    super.key,
  });

  final SvgInteractiveMapController? mapController;
  final String? initialCampusId;
  final String? initialRoomId;

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
  String? _pendingPlaceId;
  String? _routeStartRoomId;
  IndoorRoute? _route;
  int _routeStep = 0;
  CampusMapData? _routeSnapshot;
  int? _manualRefreshRevision;
  bool _is3D = false;
  double _mapBearing = 0;
  CampusMapData? _landmarkSnapshot;
  IndoorNavigationGraph? _landmarkGraph;
  Map<String, List<MapNavigationLandmark>> _floorLandmarks = const {};
  ({CampusMapData snapshot, int revision, String floorId, List<Offset> points})?
  _pendingNavigationFocus;
  int _navigationFocusRevision = 0;
  late bool _incomingTargetPending =
      widget.initialCampusId != null || widget.initialRoomId != null;
  double _collapsedPanelSize = .3;
  bool _panelFramePending = false;
  double _viewportHeight = 0;
  double _viewportTop = 0;
  final GlobalKey _topOverlayKey = GlobalKey();
  double? _measuredTopExtent;
  bool _measurePending = false;

  void _measureTopOverlay() {
    if (_measurePending) return;
    _measurePending = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _measurePending = false;
      if (!mounted) return;
      final box = _topOverlayKey.currentContext?.findRenderObject();
      if (box is RenderBox &&
          box.hasSize &&
          (_measuredTopExtent == null ||
              (_measuredTopExtent! - box.size.height).abs() > .5)) {
        setState(() => _measuredTopExtent = box.size.height);
      }
    });
  }

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
    if (oldWidget.initialCampusId != widget.initialCampusId ||
        oldWidget.initialRoomId != widget.initialRoomId) {
      _incomingTargetPending = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _focusPending(context.read<MapBloc>().state);
      });
    }
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
      AppSpacing.lg,
      _viewportTop + AppSpacing.md,
      AppSpacing.lg + AppControlSize.touchTarget + AppSpacing.xlg,
      _viewportHeight * panelSize +
          (panelSize <= _collapsedPanelSize + .1
              ? AppControlSize.touchTarget + AppSpacing.md + AppSpacing.xlg
              : AppSpacing.md),
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
    _manualRefreshRevision = null;
    _pendingRoom = null;
    _pendingPlaceId = null;
    _pendingNavigationFocus = null;
    setState(() {
      _route = null;
      _discardNavigationFocus();
      _routeSnapshot = null;
      _routeStartRoomId = null;
    });
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
    _discardNavigationFocus();
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
    if (state.status != MapStatus.loaded) return;
    if (_incomingTargetPending) {
      if (widget.initialCampusId != null &&
          widget.initialCampusId != state.selectedCampus?.id) {
        final target = state.availableCampuses
            .where(
              (campus) => campus.id == widget.initialCampusId,
            )
            .firstOrNull;
        if (target != null) {
          context.read<MapBloc>().add(MapEvent.campusSelected(target));
          return;
        }
      }
      _incomingTargetPending = false;
      final place = state.campusData?.placeForId(widget.initialRoomId ?? '');
      if (place != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _openPlace(place);
        });
      } else if (widget.initialRoomId != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          showNinjaToast(
            context,
            message: 'Место по ссылке не найдено в текущей версии карты.',
          );
        });
      }
    }
    if (_route != null && !identical(state.campusData, _routeSnapshot)) {
      setState(() {
        _route = null;
        _discardNavigationFocus();
        _routeSnapshot = null;
      });
    }
    if (_pendingNavigationFocus case final focus?
        when !identical(focus.snapshot, state.campusData)) {
      _discardNavigationFocus();
    }
    final focus = _pendingNavigationFocus;
    if (focus != null && state.selectedFloor?.id == focus.floorId) {
      _pendingNavigationFocus = null;
      final snapshot = state.campusData;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final current = context.read<MapBloc>().state;
        if (current.status == MapStatus.loaded &&
            current.selectedFloor?.id == focus.floorId &&
            identical(snapshot, current.campusData) &&
            focus.revision == _navigationFocusRevision) {
          _mapController.focusPoints(focus.points);
        }
      });
    }
    if (_pendingRoom == null && _pendingPlaceId == null) return;
    final pendingPlaceId = _pendingPlaceId == null
        ? null
        : state.campusData?.placeForId(_pendingPlaceId!)?.id ?? _pendingPlaceId;
    final room = state.rooms
        .where(
          (room) => pendingPlaceId != null
              ? room.roomId == pendingPlaceId ||
                    room.roomId.endsWith('__r__$pendingPlaceId')
              : roomKey(room.name) == roomKey(_pendingRoom!),
        )
        .firstOrNull;
    if (room == null) return;
    _pendingRoom = null;
    _pendingPlaceId = null;
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
    final place = map.campusData?.placeForId(room.roomId);
    if (place != null) {
      _openPlace(place);
      return;
    }
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

  void _openPlace(MapPlaceData place) {
    final bloc = context.read<MapBloc>();
    final campus = bloc.state.campusData;
    final repository = bloc.repository;
    if (campus == null || repository == null) return;
    _pendingPlaceId = place.id;
    final floor = campus.floorForId(place.floorId)?.floor;
    if (floor != null && bloc.state.selectedFloor?.id != floor.id) {
      _floor(floor);
    } else {
      _focusPending(bloc.state);
    }
    unawaited(
      showAppSheet<void>(
        context,
        child: MapPlaceDetailsSheet(
          repository: repository,
          campus: campus,
          room: place,
          onClose: () => Navigator.of(context, rootNavigator: true).pop(),
          onRefreshMap: () {
            Navigator.of(context, rootNavigator: true).pop();
            setState(() {
              _route = null;
              _discardNavigationFocus();
              _routeStartRoomId = null;
              _routeSnapshot = null;
            });
            _pendingRoom = null;
            _pendingPlaceId = place.id;
            bloc.add(const MapEvent.refreshRequested());
          },
          onEditLocation: () {
            Navigator.of(context, rootNavigator: true).pop();
            unawaited(
              Navigator.of(context, rootNavigator: true).push<bool>(
                MaterialPageRoute(
                  builder: (_) => MapPlaceEditorPage(
                    campus: campus,
                    repository: repository,
                    room: place,
                    initialFloorId: place.floorId,
                  ),
                ),
              ),
            );
          },
          onRouteFrom: () {
            Navigator.of(context, rootNavigator: true).pop();
            setState(() => _routeStartRoomId = place.id);
            _planRoute();
          },
          onRouteTo: () {
            Navigator.of(context, rootNavigator: true).pop();
            _planRoute(destinationRoomId: place.id);
          },
        ),
      ),
    );
  }

  void _community() {
    final bloc = context.read<MapBloc>();
    final campus = bloc.state.campusData;
    final repository = bloc.repository;
    if (campus == null || repository == null) return;
    unawaited(
      showMapEditMenu(
        context,
        repository: repository,
        campus: campus,
        floorId: bloc.state.selectedFloor?.id,
      ),
    );
  }

  void _savedPlaces() {
    final repository = context.read<MapBloc>().repository;
    if (repository == null) return;
    unawaited(
      showAppSheet<void>(
        context,
        title: 'Сохранённые места',
        child: MapSavedPlacesSheet(
          repository: repository,
          onOpen: (place) {
            Navigator.of(context, rootNavigator: true).pop();
            context.go(
              Uri(
                path: '/services/map',
                queryParameters: {
                  'campus': place.campusId,
                  'room': place.roomId,
                },
              ).toString(),
            );
          },
        ),
      ),
    );
  }

  void _planRoute({String? destinationRoomId}) {
    final campus = context.read<MapBloc>().state.campusData;
    if (campus == null) return;
    unawaited(
      showAppSheet<void>(
        context,
        child: MapRouteSheet(
          campus: campus,
          navigationGraph: identical(campus, _landmarkSnapshot)
              ? _landmarkGraph
              : null,
          onClose: () => Navigator.of(context, rootNavigator: true).pop(),
          startRoomId: _routeStartRoomId,
          destinationRoomId: destinationRoomId,
          onContribute: _community,
          onApply: (route) {
            if (!mounted) return;
            final current = context.read<MapBloc>().state;
            if (current.status != MapStatus.loaded ||
                !identical(current.campusData, campus)) {
              showNinjaToast(
                context,
                message: 'Карта обновилась. Постройте маршрут заново.',
              );
              return;
            }
            setState(() {
              _route = route;
              _routeStep = 0;
              _routeSnapshot = campus;
              _routeStartRoomId = route.nodes.first.roomId;
            });
            _query.clear();
            context.read<FreeRoomsCubit>().queryChanged('');
            if (_panelController.isAttached) {
              _panelController.jumpTo(_collapsedPanelSize);
            }
            _pendingRoom = null;
            _pendingPlaceId = null;
            final firstFloorId = route.nodes.first.floorId;
            _pendingNavigationFocus = (
              snapshot: campus,
              revision: ++_navigationFocusRevision,
              floorId: firstFloorId,
              points: [
                for (final segment in route.segmentsForFloor(firstFloorId))
                  for (final node in segment.nodes) Offset(node.x, node.y),
              ],
            );
            final floor = campus.floorForId(route.nodes.first.floorId)?.floor;
            if (floor != null &&
                context.read<MapBloc>().state.selectedFloor?.id != floor.id) {
              _floor(floor);
            } else {
              _focusPending(context.read<MapBloc>().state);
            }
          },
        ),
      ),
    );
  }

  List<List<Offset>> _routeSegments(String floorId) {
    final route = _route;
    if (route == null) return const [];
    return [
      for (final segment in route.segmentsForFloor(floorId))
        [for (final node in segment.nodes) Offset(node.x, node.y)],
    ];
  }

  void _more() {
    final state = context.read<MapBloc>().state;
    void open(VoidCallback action) {
      Navigator.of(context, rootNavigator: true).pop();
      action();
    }

    unawaited(
      showAppSheet<void>(
        context,
        title: 'Карта кампуса',
        subtitle: state.selectedCampus?.displayName,
        child: AppListGroup(
          children: [
            if (state.campusData != null) ...[
              AppListRow(
                title: 'На карте города',
                subtitle: 'Здание, входы и план этажа',
                leading: const AppIconTile(icon: AppLineIcon.map),
                onTap: () => open(() => unawaited(_geographic())),
              ),
              AppListRow(
                title: 'Сохранённые места',
                leading: const AppIconTile(icon: AppLineIcon.bookmark),
                onTap: () => open(_savedPlaces),
              ),
              AppListRow(
                title: 'Улучшить карту',
                subtitle: 'Места, планы, проходы и проверка правок',
                leading: const AppIconTile(icon: AppLineIcon.pencil),
                onTap: () => open(_community),
              ),
            ],
            AppListRow(
              title: _is3D ? 'Вид сверху' : 'Объёмный план',
              subtitle: 'Масштаб и выбранный участок сохранятся',
              leading: const AppIconTile(icon: AppLineIcon.map),
              onTap: () => open(() => setState(() => _is3D = !_is3D)),
            ),
            if (_is3D)
              AppListRow(
                title: 'Повернуть план',
                subtitle: 'Двумя пальцами можно вращать и приближать',
                leading: const AppIconTile(icon: AppLineIcon.refresh),
                onTap: () =>
                    open(() => setState(() => _mapBearing += math.pi / 4)),
              ),
            AppListRow(
              title: 'Друзья на карте',
              leading: const AppIconTile(icon: AppLineIcon.people),
              onTap: () => open(_friends),
            ),
            AppListRow(
              title: 'О плане и источнике',
              leading: const AppIconTile(icon: AppLineIcon.info),
              onTap: () => open(_mapInformation),
            ),
          ],
        ),
      ),
    );
  }

  void _mapInformation() {
    final state = context.read<MapBloc>().state;
    final campus = state.campusData;
    final source = Uri.tryParse(campus?.sourceUrl ?? '');
    unawaited(
      showAppSheet<void>(
        context,
        title: 'О плане',
        subtitle: state.selectedCampus?.displayName,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppCard(
              child: Text(switch (campus?.origin) {
                MapDataOrigin.remote =>
                  'План загружен с сервера. '
                      'Версия ${campus!.revision}.',
                MapDataOrigin.cache =>
                  'Показана сохранённая копия плана. '
                      'Она доступна без подключения к интернету.',
                MapDataOrigin.bundled || null =>
                  'План входит в приложение '
                      'и доступен без подключения к интернету.',
              }),
            ),
            if (state.dataWarning != null &&
                campus?.origin == MapDataOrigin.cache) ...[
              const SizedBox(height: AppSpacing.md),
              AppBanner(message: state.dataWarning!, tone: AppBannerTone.warn),
            ],
            const SizedBox(height: AppSpacing.lg),
            if (campus != null) ...[
              Text(
                'Источник планов: ${campus.sourceLabel}',
                style: AppText.body,
              ),
              const SizedBox(height: AppSpacing.sm),
              if (source?.scheme == 'https' &&
                  (source?.host.isNotEmpty ?? false))
                AppButton.secondary(
                  label: 'Открыть источник',
                  expanded: true,
                  onPressed: () async {
                    try {
                      final opened = await launchUrl(
                        source!,
                        mode: LaunchMode.externalApplication,
                      );
                      if (!opened && mounted) {
                        showNinjaToast(
                          context,
                          message: 'Не удалось открыть ссылку',
                        );
                      }
                    } on Object {
                      if (!mounted) return;
                      showNinjaToast(
                        context,
                        message: 'Не удалось открыть ссылку',
                      );
                    }
                  },
                ),
              const SizedBox(height: AppSpacing.lg),
            ],
            AppButton.primary(
              label: 'Проверить обновления',
              expanded: true,
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
                _manualRefreshRevision = campus?.revision ?? 0;
                context.read<MapBloc>().add(const MapEvent.refreshRequested());
              },
            ),
          ],
        ),
      ),
    );
  }

  void _mapStateChanged(MapState state) {
    _focusPending(state);
    final revision = _manualRefreshRevision;
    if (revision == null ||
        (state.status != MapStatus.loaded &&
            state.status != MapStatus.failure)) {
      return;
    }
    _manualRefreshRevision = null;
    final campus = state.campusData;
    final message = state.status == MapStatus.failure
        ? 'Не удалось проверить обновления. Попробуйте ещё раз.'
        : switch (campus?.origin) {
            MapDataOrigin.remote when !state.isOffline =>
              campus!.revision > revision
                  ? 'План обновлён'
                  : 'У вас актуальная версия плана',
            MapDataOrigin.cache =>
              'Сервер недоступен. Показана сохранённая копия плана.',
            MapDataOrigin.remote =>
              'План этажа недоступен. Показана сохранённая копия.',
            MapDataOrigin.bundled ||
            null => 'Сервер недоступен. Показан встроенный план.',
          };
    showNinjaToast(context, message: message);
  }

  void _discardNavigationFocus() {
    _pendingNavigationFocus = null;
    _navigationFocusRevision++;
  }

  void _advanceRoute() => _moveRouteStep(1);

  void _retreatRoute() => _moveRouteStep(-1);

  void _moveRouteStep(int delta) {
    final route = _route;
    final state = context.read<MapBloc>().state;
    final campus = state.campusData;
    if (route == null ||
        campus == null ||
        state.status != MapStatus.loaded ||
        !identical(campus, _routeSnapshot)) {
      return;
    }
    final index = _routeStep + delta;
    if (index < 0) return;
    if (index >= route.instructions.length) {
      setState(() {
        _route = null;
        _discardNavigationFocus();
        _routeSnapshot = null;
      });
      return;
    }
    setState(() => _routeStep = index);
    final step = route.instructions[index];
    final floor = campus.floorForId(step.atNode.floorId)?.floor;
    if (floor == null) return;
    _pendingNavigationFocus = (
      snapshot: campus,
      revision: ++_navigationFocusRevision,
      floorId: floor.id,
      points: [
        Offset(step.atNode.x, step.atNode.y),
        if (step.toNode case final next? when next.floorId == floor.id)
          Offset(next.x, next.y),
      ],
    );
    if (state.selectedFloor?.id == floor.id) {
      _focusPending(state);
    } else {
      _floor(floor);
    }
  }

  List<MapNavigationLandmark> _navigationLandmarks(
    CampusMapData? campus,
    String floorId,
  ) {
    if (!identical(campus, _landmarkSnapshot)) {
      _landmarkSnapshot = campus;
      _landmarkGraph = null;
      _floorLandmarks = {};
      if (campus != null) {
        unawaited(
          prepareMapNavigation(campus).then((prepared) {
            if (!mounted || !identical(campus, _landmarkSnapshot)) return;
            setState(() {
              _landmarkGraph = prepared.graph;
              _floorLandmarks = prepared.byFloor;
            });
          }),
        );
      }
    }
    return _floorLandmarks[floorId] ?? const [];
  }

  void _openNavigationLandmark(MapNavigationLandmark landmark) {
    final current = context.read<MapBloc>().state;
    final campus = current.campusData;
    final graph = _landmarkGraph;
    if (current.status != MapStatus.loaded ||
        campus == null ||
        graph == null ||
        !identical(campus, _landmarkSnapshot) ||
        current.selectedFloor?.id != landmark.place.floorId ||
        !(_floorLandmarks[landmark.place.floorId]?.contains(landmark) ??
            false)) {
      return;
    }
    final floor = campus.floorForId(landmark.place.floorId);
    final targets = campus.floors
        .where((floor) => landmark.outgoingFloorIds.contains(floor.floor.id))
        .toList();
    unawaited(
      showAppSheet<void>(
        context,
        title: landmark.place.label,
        subtitle: floor == null ? null : '${floor.floor.number} этаж',
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Text(
                landmark.closed
                    ? 'Переход отмечен как закрытый.'
                    : targets.isEmpty
                    ? 'Связь с другими этажами не указана в плане.'
                    : 'Переходы на другие этажи',
                style: AppText.body,
              ),
            ),
            for (final target in targets)
              AppListRow(
                title: '${target.floor.number} этаж',
                subtitle: 'Показать переход на плане',
                leading: Icon(mapPlaceKindIcon(landmark.place.kind)),
                onTap: () {
                  Navigator.of(context, rootNavigator: true).pop();
                  final state = context.read<MapBloc>().state;
                  if (state.status != MapStatus.loaded ||
                      !identical(state.campusData, campus)) {
                    return;
                  }
                  IndoorNavigationNode? destination;
                  for (final edge in graph.edges) {
                    if (edge.closed || edge.kind.name != landmark.place.kind) {
                      continue;
                    }
                    final from = graph.nodesById[edge.fromNodeId]!;
                    final to = graph.nodesById[edge.toNodeId]!;
                    if (from.closed || to.closed) continue;
                    if (landmark.nodeIds.contains(from.id) &&
                        to.floorId == target.floor.id) {
                      destination = to;
                    }
                    if (edge.bidirectional &&
                        landmark.nodeIds.contains(to.id) &&
                        from.floorId == target.floor.id) {
                      destination = from;
                    }
                    if (destination != null) break;
                  }
                  if (destination == null) return;
                  _pendingNavigationFocus = (
                    snapshot: campus,
                    revision: ++_navigationFocusRevision,
                    floorId: target.floor.id,
                    points: [Offset(destination.x, destination.y)],
                  );
                  _floor(target.floor);
                },
              ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }

  Future<void> _geographic() async {
    final bloc = context.read<MapBloc>();
    final state = bloc.state;
    final campus = state.campusData;
    if (campus == null) return;
    final floor = campus.floorForId(state.selectedFloor?.id ?? '');
    FloorGeoreference? reference;
    if (floor?.anchors.length == 3) {
      try {
        reference = FloorGeoreference([
          for (final anchor in floor!.anchors)
            FloorGeoAnchor(
              x: anchor.x,
              y: anchor.y,
              latitude: anchor.latitude,
              longitude: anchor.longitude,
            ),
        ]);
      } on FormatException {
        reference = null;
      }
    }
    var center = campus.latitude == null || campus.longitude == null
        ? null
        : LatLng(campus.latitude!, campus.longitude!);
    GeographicFloorPlan? plan;
    final places = <GeographicMapPlace>[];
    final geographicRoute = <List<LatLng>>[];
    try {
      if (reference != null && floor != null && state.svgContent != null) {
        LatLng position(double x, double y) {
          final point = reference!.pixelToGeographic(x, y);
          return LatLng(point.latitude, point.longitude);
        }

        center ??= position(floor.width / 2, floor.height / 2);
        plan = GeographicFloorPlan(
          georeference: floor.georeference,
          svg: state.svgContent!,
          syntheticRoomIds: context.read<MapBloc>().syntheticRoomIds,
          rooms: state.rooms,
          places: campus.rooms
              .where((place) => place.floorId == floor.floor.id)
              .toList(),
          size: Size(floor.width, floor.height),
          topLeft: position(0, 0),
          topRight: position(floor.width, 0),
          bottomLeft: position(0, floor.height),
        );
        for (final place in campus.rooms.where(
          (place) =>
              place.floorId == floor.floor.id &&
              (floor.georeference?.isReliableAt(place.x, place.y) ?? true) &&
              mapPlaceKindLabel(place.kind) != 'Аудитория',
        )) {
          places.add(
            GeographicMapPlace(
              label: place.label,
              position: position(place.x, place.y),
              onTap: () {
                Navigator.of(context, rootNavigator: true).pop();
                _openPlace(place);
              },
            ),
          );
        }
        for (final segment in _routeSegments(floor.floor.id)) {
          if (segment.any(
            (point) =>
                !(floor.georeference?.isReliableAt(point.dx, point.dy) ?? true),
          )) {
            continue;
          }
          geographicRoute.add([
            for (final point in segment) position(point.dx, point.dy),
          ]);
        }
      }
    } on FormatException {
      plan = null;
      places.clear();
      geographicRoute.clear();
    }
    if (!mounted) return;
    if (center == null) {
      await showAppSheet<void>(
        context,
        title: 'Привязка к зданию',
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AppBanner(
              message:
                  'Координаты кампуса и привязка этажей '
                  'пока не проверены. Их можно предложить в редакторе карты.',
            ),
            const SizedBox(height: 12),
            AppButton.primary(
              label: 'Предложить привязку',
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
                final repository = bloc.repository;
                if (repository == null) return;
                unawaited(
                  Navigator.of(context, rootNavigator: true).push<bool>(
                    MaterialPageRoute(
                      builder: (_) => MapFloorAlignmentPage(
                        campus: campus,
                        repository: repository,
                        initialFloorId: floor?.floor.id,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      );
      return;
    }
    await Navigator.of(context, rootNavigator: true).push<void>(
      MaterialPageRoute(
        builder: (_) => MapGeographicView(
          campusName: campus.campus.displayName,
          center: center!,
          floorPlan: plan,
          places: places,
          route: geographicRoute,
        ),
      ),
    );
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
      listener: (_, state) => _mapStateChanged(state),
      builder: (context, state) {
        if (state.status == MapStatus.failure) {
          return MapFailureCanvas(message: state.errorMessage);
        }
        final floor = state.selectedFloor;
        if (floor == null) return const MapSkeleton();
        final interactive = state.status == MapStatus.loaded;
        return LayoutBuilder(
          builder: (context, constraints) {
            final bottomInset =
                context
                    .findAncestorWidgetOfExactType<AppBottomBarViewport>()
                    ?.bottomInset ??
                MediaQuery.paddingOf(context).bottom;
            final compactContentExtent =
                MapFreeRoomsPanel.compactContentExtentOf(
                  context,
                  width: constraints.maxWidth,
                  campusName: state.selectedCampus?.displayName ?? '',
                  discoveryMode: state.campusData != null,
                );
            _collapsedPanelSize =
                ((bottomInset + compactContentExtent) / constraints.maxHeight)
                    .clamp(.06, .42);
            _viewportHeight = constraints.maxHeight;
            _viewportTop =
                _measuredTopExtent ??
                (MediaQuery.paddingOf(context).top +
                    (_route == null ? 116 : 220));
            _measureTopOverlay();
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
                    svgContent: state.svgContent,
                    showRoomLabels: state.campusData != null,
                    syntheticRoomIds: state.campusData == null
                        ? const {}
                        : context.read<MapBloc>().syntheticRoomIds,
                    routeSegments: _routeSegments(floor.id),
                    is3D: _is3D,
                    bearing: _mapBearing,
                    navigationLandmarks: _navigationLandmarks(
                      state.campusData,
                      floor.id,
                    ),
                    onNavigationLandmarkTap: _openNavigationLandmark,
                    showRouteStart: _route?.nodes.first.floorId == floor.id,
                    showRouteDestination:
                        _route?.nodes.last.floorId == floor.id,
                    routeInstructionPoint:
                        _route != null &&
                            _route!.instructions[_routeStep].floorId == floor.id
                        ? Offset(
                            _route!.instructions[_routeStep].atNode.x,
                            _route!.instructions[_routeStep].atNode.y,
                          )
                        : null,
                    places: [
                      for (final place
                          in state.campusData?.rooms ?? <MapPlaceData>[])
                        if (place.floorId == floor.id) place,
                    ],
                    onRoomTap: _openMappedRoom,
                    viewportPadding: _mapViewportPadding.value,
                    viewportPaddingListenable: _mapViewportPadding,
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Column(
                    key: _topOverlayKey,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      MapTopBar(
                        compact: constraints.maxHeight < 650,
                        controller: _query,
                        campuses: state.availableCampuses,
                        selectedCampus: state.selectedCampus,
                        onQueryChanged: _queryChanged,
                        onCampusSelected: _campus,
                        onFriends: _friends,
                      ),
                      if (_route case final route?)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                          child: MapRouteGuidance(
                            campus: state.campusData!,
                            route: route,
                            stepIndex: _routeStep,
                            onNext: interactive ? _advanceRoute : null,
                            onPrevious: interactive ? _retreatRoute : null,
                            onClose: () => setState(() {
                              _route = null;
                              _discardNavigationFocus();
                              _routeSnapshot = null;
                            }),
                          ),
                        ),
                    ],
                  ),
                ),
                AnimatedBuilder(
                  animation: _panelExtent,
                  builder: (context, child) {
                    if (_panelController.isAttached &&
                        _panelController.size > _collapsedPanelSize + .1) {
                      return const SizedBox.shrink();
                    }
                    final panelHeight =
                        constraints.maxHeight *
                        (_panelController.isAttached
                            ? _panelController.size
                            : panelSize);
                    final controlsFit =
                        constraints.maxHeight - panelHeight >=
                        _viewportTop +
                            AppControlSize.touchTarget * (_is3D ? 5 : 4) +
                            AppSpacing.xsm * 2 +
                            AppSpacing.md;
                    if (!controlsFit &&
                        constraints.maxHeight - panelHeight <
                            _viewportTop + AppControlSize.touchTarget + 20) {
                      return const SizedBox.shrink();
                    }
                    return Positioned(
                      right: AppSpacing.lg,
                      bottom: panelHeight + 12,
                      child: controlsFit
                          ? child!
                          : MapCanvasControls(
                              axis: Axis.horizontal,
                              showZoom: false,
                              onZoomIn: interactive
                                  ? _mapController.zoomIn
                                  : null,
                              onZoomOut: interactive
                                  ? _mapController.zoomOut
                                  : null,
                              onFit: interactive ? _mapController.fit : null,
                            ),
                    );
                  },
                  child: MapCanvasControls(
                    is3D: _is3D,
                    onRotate: _is3D && interactive
                        ? () => setState(() => _mapBearing += math.pi / 4)
                        : null,
                    onToggle3D: interactive
                        ? () => setState(() => _is3D = !_is3D)
                        : null,
                    onZoomIn: interactive ? _mapController.zoomIn : null,
                    onZoomOut: interactive ? _mapController.zoomOut : null,
                    onFit: interactive ? _mapController.fit : null,
                  ),
                ),
                AnimatedBuilder(
                  animation: _panelExtent,
                  builder: (context, child) {
                    final extent = _panelController.isAttached
                        ? _panelController.size
                        : panelSize;
                    if (extent > _collapsedPanelSize + .1) {
                      return const SizedBox.shrink();
                    }
                    return Positioned(
                      left: AppSpacing.lg,
                      bottom: constraints.maxHeight * extent + AppSpacing.md,
                      child: child!,
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (state.campusData != null) ...[
                        AppButton.primary(
                          label: 'Маршрут',
                          icon: const Icon(
                            Icons.directions_walk_rounded,
                            size: 20,
                          ),
                          onPressed: interactive ? _planRoute : null,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                      ],
                      AppIconButton(
                        icon: const AppLineIconWidget(AppLineIcon.more),
                        tooltip: 'Действия с картой',
                        shape: AppIconButtonShape.circle,
                        tone: AppIconButtonTone.surface,
                        onPressed: _more,
                      ),
                    ],
                  ),
                ),
                MapFreeRoomsPanel(
                  controller: _panelController,
                  collapsedSize: _collapsedPanelSize,
                  viewportHeight: constraints.maxHeight,
                  bottomInset: bottomInset,
                  compactContentExtent: compactContentExtent,
                  mapState: state,
                  discovery: state.campusData == null
                      ? null
                      : BlocBuilder<FreeRoomsCubit, FreeRoomsState>(
                          buildWhen: (before, after) =>
                              before.query != after.query,
                          builder: (context, free) => MapPlacesExplorer(
                            campus: state.campusData!,
                            currentFloorId: state.selectedFloor?.id,
                            query: free.query,
                            onPlace: _openPlace,
                            onCommunity: _community,
                            onRefresh: () => context.read<MapBloc>().add(
                              const MapEvent.refreshRequested(),
                            ),
                          ),
                        ),
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
                    top: _viewportTop + AppSpacing.sm,
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
