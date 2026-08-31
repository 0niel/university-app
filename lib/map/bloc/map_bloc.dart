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
  }

  final List<CampusModel> _availableCampuses;
  final ObjectsService _objectsService;
  final SvgRoomParser _roomsParser;

  Future<void> _onMapInitialized(
    MapInitialized event,
    Emitter<MapState> emit,
  ) async {
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
      emit(
        state.copyWith(
          status: .loaded,
          selectedCampus: campus,
          selectedFloor: floor,
          rooms: rooms,
          boundingRect: rect,
        ),
      );
    } on Exception catch (error, stackTrace) {
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
    emit(state.copyWith(status: .loading));
    try {
      final floor = _firstFloor(event.campus);
      final (rooms, rect) = await _parseFloor(floor);
      emit(
        state.copyWith(
          status: .loaded,
          selectedCampus: event.campus,
          selectedFloor: floor,
          rooms: rooms,
          boundingRect: rect,
        ),
      );
    } on Exception catch (error, stackTrace) {
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
    emit(state.copyWith(status: .loading));
    try {
      final (rooms, rect) = await _parseFloor(event.floor);
      emit(
        state.copyWith(
          status: .loaded,
          selectedCampus: event.campus,
          selectedFloor: event.floor,
          rooms: rooms,
          boundingRect: rect,
        ),
      );
    } on Exception catch (error, stackTrace) {
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
