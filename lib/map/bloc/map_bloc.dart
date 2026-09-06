import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rtu_mirea_app/map/bloc/map_status.dart';
import 'package:rtu_mirea_app/map/data/map_data_models.dart';
import 'package:rtu_mirea_app/map/data/map_data_repository.dart';
import 'package:rtu_mirea_app/map/models/models.dart';
import 'package:rtu_mirea_app/map/services/services.dart';

export 'package:rtu_mirea_app/map/bloc/map_status.dart';

part 'map_event.dart';
part 'map_state.dart';
part 'map_bloc.freezed.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc({
    required List<CampusModel> availableCampuses,
    required this._objectsService,
    this._roomsParser = const SvgRoomParser(),
    this.repository,
  }) : _availableCampuses = List.unmodifiable(availableCampuses),
       super(const MapState()) {
    on<MapInitialized>(_onMapInitialized, transformer: droppable());
    on<MapRefreshRequested>(_onRefreshRequested, transformer: droppable());
    on<CampusSelected>(_onCampusSelected, transformer: sequential());
    on<FloorSelected>(_onFloorSelected, transformer: sequential());
    on<RoomTapped>(_onRoomTapped);
    on<CampusIndexRequested>(
      _onCampusIndexRequested,
      transformer: restartable(),
    );
  }

  static const _syntheticMarkerRadius = 12.0;

  final List<CampusModel> _availableCampuses;
  final ObjectsService _objectsService;
  final SvgRoomParser _roomsParser;
  final MapDataRepository? repository;
  final _floorCache = <String, (List<RoomModel>, Rect)>{};
  final _syntheticRooms = <String, Set<String>>{};
  Set<String>? _catalogCampusIds;
  var _selectionRevision = 0;

  CampusMapData? get currentCampusData => state.campusData;
  MapFloorData? get currentFloorData =>
      state.campusData?.floorForId(state.selectedFloor?.id ?? '');
  Set<String> get syntheticRoomIds {
    final floorPath = state.selectedFloor?.svgPath;
    final revision = state.campusData?.revision ?? 0;
    return _syntheticRooms['$floorPath:$revision'] ?? const {};
  }

  Future<String> loadSvg(String path) =>
      repository?.loadSvg(path) ?? _roomsParser.onLoadSvg(path);

  Future<void> _onMapInitialized(
    MapInitialized event,
    Emitter<MapState> emit,
  ) async {
    final revision = ++_selectionRevision;
    if (_availableCampuses.isEmpty && repository == null) {
      emit(
        state.copyWith(
          status: .failure,
          errorMessage: 'Нет доступных кампусов.',
        ),
      );
      return;
    }
    emit(
      state.copyWith(
        status: .loading,
        availableCampuses: _availableCampuses,
      ),
    );

    try {
      try {
        await _objectsService.loadObjects();
      } on Exception {
        if (repository == null) rethrow;
      }
      final catalog = await repository?.loadCatalog();
      if (revision != _selectionRevision || emit.isDone) return;
      final catalogCampuses =
          catalog?.entries.map((entry) => entry.campus).toList() ??
          const <CampusModel>[];
      _catalogCampusIds = catalog == null
          ? null
          : {
              for (final campus in catalogCampuses) campus.id,
            };
      final campuses = [
        ...catalogCampuses,
        for (final local in _availableCampuses)
          if (!catalogCampuses.any(
            (campus) =>
                campus.id == local.id ||
                campus.displayName == local.displayName,
          ))
            local,
      ];
      var campus = campuses.firstOrNull;
      if (campus == null) {
        throw const FormatException('Нет доступных планов кампусов.');
      }
      CampusMapData? campusData;
      var warning = catalog?.warning;
      if (catalog?.entries.isNotEmpty == true) {
        try {
          campusData = await repository!.loadCampus(campus.id, refresh: true);
          campus = campusData.campus;
          warning = campusData.warning ?? warning;
        } on Exception {
          final fallback = _localCampusFor(campus!);
          if (fallback == null) rethrow;
          campus = fallback;
          warning = 'План с сервера недоступен. Показана встроенная версия.';
        }
      }
      final floor = _firstFloor(campus);
      final (rooms, rect) = await _parseFloor(floor, campusData: campusData);
      final svgContent = repository == null
          ? null
          : await loadSvg(floor.svgPath);
      if (revision != _selectionRevision || emit.isDone) return;
      emit(
        state.copyWith(
          status: .loaded,
          availableCampuses: [
            for (final item in campuses)
              if (item.id == campus.id) campus else item,
          ],
          selectedCampus: campus,
          selectedFloor: floor,
          rooms: rooms,
          roomFloors: _floorsOf(rooms, floor),
          boundingRect: rect,
          campusData: campusData,
          isOffline:
              catalog != null &&
              (catalog.origin != MapDataOrigin.remote ||
                  campusData?.origin != MapDataOrigin.remote ||
                  repository!.isSvgOffline(floor.svgPath)),
          dataWarning: _svgWarning(floor) ?? warning,
          svgContent: svgContent,
          errorMessage: null,
        ),
      );
      add(MapEvent.campusIndexRequested(campus));
    } on Exception catch (error, stackTrace) {
      if (revision != _selectionRevision || emit.isDone) return;
      emit(
        state.copyWith(
          status: .failure,
          errorMessage: 'Ошибка инициализации карты: $error',
        ),
      );
      addError(error, stackTrace);
    }
  }

  Future<void> _onCampusSelected(
    CampusSelected event,
    Emitter<MapState> emit,
  ) async {
    if (state.status == .loaded &&
        state.selectedCampus?.id == event.campus.id) {
      return;
    }
    final revision = ++_selectionRevision;
    emit(state.copyWith(status: .loading));
    try {
      final campusData = await _resolveCampus(event.campus);
      final campus =
          campusData?.campus ?? _localCampusFor(event.campus) ?? event.campus;
      final floor = _firstFloor(campus);
      final (rooms, rect) = await _parseFloor(floor, campusData: campusData);
      final svgContent = repository == null
          ? null
          : await loadSvg(floor.svgPath);
      if (revision != _selectionRevision || emit.isDone) return;
      emit(
        state.copyWith(
          status: .loaded,
          selectedCampus: campus,
          selectedFloor: floor,
          rooms: rooms,
          roomFloors: _floorsOf(rooms, floor),
          boundingRect: rect,
          campusData: campusData,
          isOffline:
              repository != null &&
              (campusData?.origin != MapDataOrigin.remote ||
                  repository!.isSvgOffline(floor.svgPath)),
          dataWarning:
              _svgWarning(floor) ??
              campusData?.warning ??
              (repository != null && campusData == null
                  ? 'Показаны встроенные планы.'
                  : null),
          svgContent: svgContent,
          errorMessage: null,
        ),
      );
      add(MapEvent.campusIndexRequested(campus));
    } on Exception catch (error, stackTrace) {
      if (revision != _selectionRevision || emit.isDone) return;
      emit(
        state.copyWith(
          status: .failure,
          errorMessage: 'Ошибка загрузки кампуса: $error',
        ),
      );
      addError(error, stackTrace);
    }
  }

  Future<void> _onRefreshRequested(
    MapRefreshRequested event,
    Emitter<MapState> emit,
  ) async {
    final selectedCampus = state.selectedCampus;
    final selectedFloor = state.selectedFloor;
    if (repository == null ||
        selectedCampus == null ||
        state.campusData == null) {
      await _onMapInitialized(
        const MapInitialized(),
        emit,
      );
      return;
    }
    final revision = ++_selectionRevision;
    emit(state.copyWith(status: .loading));
    try {
      final catalog = await repository!.loadCatalog();
      if (revision != _selectionRevision || emit.isDone) return;
      final catalogCampuses = catalog.entries
          .map((entry) => entry.campus)
          .toList();
      _catalogCampusIds = {for (final campus in catalogCampuses) campus.id};
      final available = [
        ...catalogCampuses,
        for (final local in _availableCampuses)
          if (!catalogCampuses.any(
            (campus) =>
                campus.id == local.id ||
                campus.displayName == local.displayName,
          ))
            local,
      ];
      if (available.isEmpty) available.addAll(state.availableCampuses);
      final target =
          available.firstWhereOrNull(
            (campus) => campus.id == selectedCampus.id,
          ) ??
          available.firstOrNull ??
          selectedCampus;
      final campusData = await repository!.refreshCampus(target.id);
      if (revision != _selectionRevision || emit.isDone) return;
      final campus = campusData.campus;
      final floor =
          campus.floors.firstWhereOrNull(
            (floor) => floor.id == selectedFloor?.id,
          ) ??
          _firstFloor(campus);
      _floorCache.clear();
      _syntheticRooms.clear();
      final (rooms, rect) = await _parseFloor(floor, campusData: campusData);
      final svgContent = await loadSvg(floor.svgPath);
      if (revision != _selectionRevision || emit.isDone) return;
      emit(
        state.copyWith(
          status: .loaded,
          availableCampuses: [
            for (final item in available)
              if (item.id == campus.id) campus else item,
          ],
          selectedCampus: campus,
          selectedFloor: floor,
          rooms: rooms,
          roomFloors: _floorsOf(rooms, floor),
          boundingRect: rect,
          campusData: campusData,
          isOffline:
              campusData.origin != MapDataOrigin.remote ||
              repository!.isSvgOffline(floor.svgPath),
          dataWarning: _svgWarning(floor) ?? campusData.warning,
          svgContent: svgContent,
          errorMessage: null,
        ),
      );
      add(MapEvent.campusIndexRequested(campus));
    } on Exception catch (error, stackTrace) {
      if (revision != _selectionRevision || emit.isDone) return;
      emit(
        state.copyWith(
          status: .failure,
          errorMessage: 'Не удалось обновить карту: $error',
        ),
      );
      addError(error, stackTrace);
    }
  }

  Future<void> _onFloorSelected(
    FloorSelected event,
    Emitter<MapState> emit,
  ) async {
    if (state.status == .loaded &&
        state.selectedCampus?.id == event.campus.id &&
        state.selectedFloor?.id == event.floor.id) {
      return;
    }
    final revision = ++_selectionRevision;
    final changedCampus = state.selectedCampus?.id != event.campus.id;
    final resolveCampus = changedCampus || state.status == .loading;
    emit(state.copyWith(status: .loading));
    try {
      final campusData = resolveCampus
          ? await _resolveCampus(event.campus)
          : state.campusData;
      final changedSnapshot = !identical(campusData, state.campusData);
      final campus =
          campusData?.campus ?? _localCampusFor(event.campus) ?? event.campus;
      final floor =
          campus.floors.firstWhereOrNull(
            (floor) => floor.id == event.floor.id,
          ) ??
          _firstFloor(campus);
      final (rooms, rect) = await _parseFloor(floor, campusData: campusData);
      final svgContent = repository == null
          ? null
          : await loadSvg(floor.svgPath);
      if (revision != _selectionRevision || emit.isDone) return;
      emit(
        state.copyWith(
          status: .loaded,
          selectedCampus: campus,
          selectedFloor: floor,
          rooms: rooms,
          roomFloors: {
            if (!changedCampus && !changedSnapshot) ...state.roomFloors,
            ..._floorsOf(rooms, floor),
          },
          boundingRect: rect,
          campusData: campusData,
          isOffline:
              repository != null &&
              (campusData?.origin != MapDataOrigin.remote ||
                  repository!.isSvgOffline(floor.svgPath)),
          dataWarning:
              _svgWarning(floor) ?? campusData?.warning ?? state.dataWarning,
          svgContent: svgContent,
          errorMessage: null,
        ),
      );
      if (changedCampus || changedSnapshot) {
        add(MapEvent.campusIndexRequested(campus));
      }
    } on Exception catch (error, stackTrace) {
      if (revision != _selectionRevision || emit.isDone) return;
      emit(
        state.copyWith(
          status: .failure,
          errorMessage: 'Ошибка загрузки этажа: $error',
        ),
      );
      addError(error, stackTrace);
    }
  }

  void _onRoomTapped(RoomTapped event, Emitter<MapState> emit) {
    if (state.status != .loaded) return;
    final roomId =
        currentCampusData?.placeForId(event.roomId)?.id ?? event.roomId;

    final updatedRooms = [
      for (final room in state.rooms)
        if (room.roomId == roomId)
          room.copyWith(isSelected: !room.isSelected)
        else
          room,
    ];
    emit(state.copyWith(rooms: updatedRooms));
  }

  Future<void> _onCampusIndexRequested(
    CampusIndexRequested event,
    Emitter<MapState> emit,
  ) async {
    final index = <String, int>{...state.roomFloors};
    for (final floor in event.campus.floors) {
      if (emit.isDone) return;
      if (state.selectedCampus?.id != event.campus.id) return;
      final isCurrent = state.selectedFloor?.id == floor.id;
      try {
        final rooms = isCurrent
            ? state.rooms
            : (await _parseFloor(
                floor,
                campusData: state.campusData,
              )).$1;
        if (emit.isDone || state.selectedCampus?.id != event.campus.id) return;
        index.addAll(state.roomFloors);
        for (final entry in _floorsOf(rooms, floor).entries) {
          index.putIfAbsent(entry.key, () => entry.value);
        }
        emit(state.copyWith(roomFloors: Map.unmodifiable(index)));
      } on Exception catch (error, stackTrace) {
        addError(error, stackTrace);
      }
      await Future<void>.delayed(Duration.zero);
    }
  }

  static Map<String, int> _floorsOf(List<RoomModel> rooms, FloorModel floor) {
    return {
      for (final room in rooms)
        if (room.name.isNotEmpty) roomKey(room.name): floor.number,
    };
  }

  Future<(List<RoomModel>, Rect)> _parseFloor(
    FloorModel floor, {
    CampusMapData? campusData,
  }) async {
    final cacheKey = '${floor.svgPath}:${campusData?.revision ?? 0}';
    final cached = _floorCache[cacheKey];
    if (cached != null) return cached;
    final parser = repository == null
        ? _roomsParser
        : SvgRoomParser(onLoadSvg: loadSvg);
    final (parsedRooms, boundingRect) = await parser.parseSvg(
      floor.svgPath,
    );
    final floorData = campusData?.floorForId(floor.id);
    if (floorData != null &&
        ((boundingRect.width - floorData.width).abs() > 0.01 ||
            (boundingRect.height - floorData.height).abs() > 0.01 ||
            boundingRect.left != 0 ||
            boundingRect.top != 0)) {
      throw const FormatException(
        'План этажа и координаты объектов не совпадают.',
      );
    }
    final rooms = [
      for (final room in parsedRooms)
        RoomModel(
          roomId: campusData?.placeForId(room.roomId)?.id ?? room.roomId,
          name:
              campusData?.placeForId(room.roomId)?.label ??
              _resolveRoomName(room),
          path: room.path,
          isSelected: room.isSelected,
        ),
    ];
    final representedIds = {
      for (final room in parsedRooms)
        campusData?.placeForId(room.roomId)?.id ?? room.roomId,
    };
    final syntheticIds = <String>{};
    for (final place in campusData?.rooms ?? const <MapPlaceData>[]) {
      if (place.floorId != floor.id ||
          representedIds.contains(place.id) ||
          !place.raw.containsKey('x') ||
          !place.raw.containsKey('y') ||
          !place.x.isFinite ||
          !place.y.isFinite ||
          place.x < 0 ||
          place.y < 0 ||
          place.x > boundingRect.width ||
          place.y > boundingRect.height) {
        continue;
      }
      final marker = Path()
        ..addOval(
          Rect.fromCircle(
            center: Offset(place.x, place.y),
            radius: _syntheticMarkerRadius,
          ),
        );
      final clip = Path()..addRect(boundingRect);
      rooms.add(
        RoomModel(
          roomId: place.id,
          name: place.label,
          path: Path.combine(PathOperation.intersect, marker, clip),
        ),
      );
      syntheticIds.add(place.id);
    }
    _syntheticRooms[cacheKey] = Set.unmodifiable(syntheticIds);
    final result = (rooms, boundingRect);
    _floorCache[cacheKey] = result;
    if (_floorCache.length > 24) {
      final oldest = _floorCache.keys.first;
      _floorCache.remove(oldest);
      _syntheticRooms.remove(oldest);
    }
    return result;
  }

  Future<CampusMapData?> _resolveCampus(CampusModel campus) async {
    if (repository == null) return null;
    if (_catalogCampusIds != null &&
        !_catalogCampusIds!.contains(campus.id) &&
        _localCampusFor(campus) != null) {
      return null;
    }
    try {
      return await repository!.loadCampus(campus.id);
    } on Exception {
      if (campus.floors.isEmpty && _localCampusFor(campus) == null) rethrow;
      return null;
    }
  }

  CampusModel? _localCampusFor(CampusModel campus) =>
      _availableCampuses.firstWhereOrNull(
        (local) =>
            local.id == campus.id || local.displayName == campus.displayName,
      );

  String _resolveRoomName(RoomModel room) {
    if (room.name.isNotEmpty) return room.name;
    final idParts = room.roomId.split('__r__');
    final id = idParts.elementAtOrNull(1) ?? '';
    return _objectsService.getNameById(id) ?? '';
  }

  String? _svgWarning(FloorModel floor) =>
      repository?.isSvgOffline(floor.svgPath) == true
      ? 'План этажа из офлайн-копии. Актуальность не проверена.'
      : null;

  FloorModel _firstFloor(CampusModel campus) =>
      campus.floors.firstOrNull ??
      (throw FormatException('Campus ${campus.id} has no floor plans'));
}
