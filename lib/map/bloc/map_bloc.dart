import 'package:bloc/bloc.dart';
import 'package:rtu_mirea_app/map/map.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final List<CampusModel> availableCampuses;

  MapBloc({required this.availableCampuses}) : super(MapInitial()) {
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

    emit(MapLoading());

    try {
      final initialCampus = availableCampuses.first;
      final initialFloor = initialCampus.floors.first;
      final rooms = await SvgRoomsParser.parseSvg(initialFloor.svgPath);

      emit(MapLoaded(
        selectedCampus: initialCampus,
        selectedFloor: initialFloor,
        rooms: rooms.$1,
      ));
    } catch (e) {
      emit(MapError('Ошибка инициализации карты: $e'));
    }
  }

  Future<void> _onCampusSelected(CampusSelected event, Emitter<MapState> emit) async {
    emit(MapLoading());

    try {
      final selectedCampus = event.selectedCampus;
      final selectedFloor = selectedCampus.floors.first;
      final rooms = await SvgRoomsParser.parseSvg(selectedFloor.svgPath);

      emit(MapLoaded(
        selectedCampus: selectedCampus,
        selectedFloor: selectedFloor,
        rooms: rooms.$1,
      ));
    } catch (e) {
      emit(MapError('Ошибка загрузки кампуса: $e'));
    }
  }

  Future<void> _onFloorSelected(FloorSelected event, Emitter<MapState> emit) async {
    try {
      final selectedFloor = event.selectedFloor;
      final rooms = await SvgRoomsParser.parseSvg(selectedFloor.svgPath);

      if (state is MapLoaded) {
        final currentState = state as MapLoaded;
        emit(MapLoaded(
          selectedCampus: currentState.selectedCampus,
          selectedFloor: selectedFloor,
          rooms: rooms.$1,
        ));
      } else {
        emit(MapLoaded(
          selectedCampus: const CampusModel(id: 'unknown', displayName: 'Unknown', floors: []),
          selectedFloor: selectedFloor,
          rooms: rooms.$1,
        ));
      }
    } catch (e) {
      emit(MapError('Ошибка загрузки этажа: $e'));
    }
  }

  void _onRoomTapped(RoomTapped event, Emitter<MapState> emit) {
    if (state is MapLoaded) {
      final currentState = state as MapLoaded;
      final updatedRooms = currentState.rooms.map((room) {
        if (room.roomId == event.roomId) {
          return RoomModel(
            roomId: room.roomId,
            path: room.path,
            isSelected: !room.isSelected,
          );
        }
        return room;
      }).toList();

      emit(MapLoaded(
        selectedCampus: currentState.selectedCampus,
        selectedFloor: currentState.selectedFloor,
        rooms: updatedRooms,
      ));
    }
  }
}
