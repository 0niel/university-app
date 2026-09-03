import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rtu_mirea_app/map/bloc/map_status.dart';
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
  }) : _availableCampuses = List.unmodifiable(availableCampuses),
       super(const MapState()) {
    on<MapInitialized>(_onMapInitialized, transformer: droppable());
    on<CampusSelected>(_onCampusSelected, transformer: sequential());
    on<FloorSelected>(_onFloorSelected, transformer: sequential());
    on<RoomTapped>(_onRoomTapped);
    on<CampusIndexRequested>(
      _onCampusIndexRequested,
      transformer: restartable(),
    );
  }

  final List<CampusModel> _availableCampuses;
  final ObjectsService _objectsService;
  final SvgRoomParser _roomsParser;
  var _selectionRevision = 0;

  Future<void> _onMapInitialized(
    MapInitialized event,
    Emitter<MapState> emit,
  ) async {
    final revision = ++_selectionRevision;
    if (_availableCampuses.isEmpty) {
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
      await _objectsService.loadObjects();
      final campus = _availableCampuses.firstOrNull;
      if (campus == null) return;
      final floor = _firstFloor(campus);
      final (rooms, rect) = await _parseFloor(floor);
      if (revision != _selectionRevision || emit.isDone) return;
      emit(
        state.copyWith(
          status: .loaded,
          selectedCampus: campus,
          selectedFloor: floor,
          rooms: rooms,
          roomFloors: _floorsOf(rooms, floor),
          boundingRect: rect,
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
      final floor = _firstFloor(event.campus);
      final (rooms, rect) = await _parseFloor(floor);
      if (revision != _selectionRevision || emit.isDone) return;
      emit(
        state.copyWith(
          status: .loaded,
          selectedCampus: event.campus,
          selectedFloor: floor,
          rooms: rooms,
          roomFloors: _floorsOf(rooms, floor),
          boundingRect: rect,
        ),
      );
      add(MapEvent.campusIndexRequested(event.campus));
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
    emit(state.copyWith(status: .loading));
    try {
      final (rooms, rect) = await _parseFloor(event.floor);
      if (revision != _selectionRevision || emit.isDone) return;
      emit(
        state.copyWith(
          status: .loaded,
          selectedCampus: event.campus,
          selectedFloor: event.floor,
          rooms: rooms,
          roomFloors: {
            if (!changedCampus) ...state.roomFloors,
            ..._floorsOf(rooms, event.floor),
          },
          boundingRect: rect,
        ),
      );
      if (changedCampus) add(MapEvent.campusIndexRequested(event.campus));
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

    final updatedRooms = [
      for (final room in state.rooms)
        if (room.roomId == event.roomId)
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
        final rooms = isCurrent ? state.rooms : (await _parseFloor(floor)).$1;
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

  Future<(List<RoomModel>, Rect)> _parseFloor(FloorModel floor) async {
    final (parsedRooms, boundingRect) = await _roomsParser.parseSvg(
      floor.svgPath,
    );
    final rooms = [
      for (final room in parsedRooms)
        RoomModel(
          roomId: room.roomId,
          name: _resolveRoomName(room),
          path: room.path,
          isSelected: room.isSelected,
        ),
    ];
    return (rooms, boundingRect);
  }

  String _resolveRoomName(RoomModel room) {
    if (room.name.isNotEmpty) return room.name;
    final idParts = room.roomId.split('__r__');
    final id = idParts.elementAtOrNull(1) ?? '';
    return _objectsService.getNameById(id) ?? '';
  }

  FloorModel _firstFloor(CampusModel campus) =>
      campus.floors.firstOrNull ??
      (throw FormatException('Campus ${campus.id} has no floor plans'));
}
