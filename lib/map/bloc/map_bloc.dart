import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:rtu_mirea_app/map/map.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final List<CampusModel> availableCampuses;
  final ObjectsService objectsService;

  MapBloc({required this.availableCampuses, required this.objectsService}) : super(const MapInitial()) {
    on<MapInitialized>(_onMapInitialized);
    on<CampusSelected>(_onCampusSelected);
    on<FloorSelected>(_onFloorSelected);
    on<RoomTapped>(_onRoomTapped);
  }

  Future<void> _onMapInitialized(MapInitialized event, Emitter<MapState> emit) async {
    if (availableCampuses.isEmpty) {
      emit(const MapError('Нет доступных кампусов.'));
      return;
    }
    emit(const MapLoading());

    try {
      await objectsService.loadObjects();
      final campus = availableCampuses.first;
      final floor = campus.floors.first;
      final (rooms, rect) = await _parseFloor(floor);
      emit(MapLoaded(
        selectedCampus: campus,
        selectedFloor: floor,
        rooms: rooms,
        boundingRect: rect,
      ));
    } catch (e) {
      emit(MapError('Ошибка инициализации карты: $e'));
    }
  }

  Future<void> _onCampusSelected(CampusSelected event, Emitter<MapState> emit) async {
    emit(const MapLoading());
    try {
      final floor = event.selectedCampus.floors.first;
      final (rooms, rect) = await _parseFloor(floor);
      emit(MapLoaded(
        selectedCampus: event.selectedCampus,
        selectedFloor: floor,
        rooms: rooms,
        boundingRect: rect,
      ));
    } catch (e) {
      emit(MapError('Ошибка загрузки кампуса: $e'));
    }
  }

  Future<void> _onFloorSelected(FloorSelected event, Emitter<MapState> emit) async {
    emit(const MapLoading());
    try {
      final (rooms, rect) = await _parseFloor(event.selectedFloor);
      emit(MapLoaded(
        selectedCampus: event.selectedCampus,
        selectedFloor: event.selectedFloor,
        rooms: rooms,
        boundingRect: rect,
      ));
    } catch (e) {
      emit(MapError('Ошибка загрузки этажа: $e'));
    }
  }

  void _onRoomTapped(RoomTapped event, Emitter<MapState> emit) {
    if (state is MapLoaded) {
      final currentState = state as MapLoaded;
      final updatedRooms = currentState.rooms.map((room) {
        if (room.roomId == event.roomId) {
          return room.copyWith(isSelected: !room.isSelected);
        }
        return room;
      }).toList();

      emit(currentState.copyWith(rooms: updatedRooms));
    }
  }

  Future<(List<RoomModel>, Rect)> _parseFloor(FloorModel floor) async {
    final (parsedRooms, boundingRect) = await SvgRoomsParser.parseSvg(floor.svgPath);
    final rooms = parsedRooms.map((room) {
      final idParts = room.roomId.split('__r__');
      final id = idParts.length > 1 ? idParts[1] : '';
      final name = room.name.isNotEmpty ? room.name : objectsService.getNameById(id) ?? '';
      return RoomModel(
        roomId: room.roomId,
        name: name,
        path: room.path,
        isSelected: room.isSelected,
      );
    }).toList();
    return (rooms, boundingRect);
  }
}
