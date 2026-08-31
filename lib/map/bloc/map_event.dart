part of 'map_bloc.dart';

@freezed
sealed class MapEvent with _$MapEvent {
  const factory MapEvent.initialized() = MapInitialized;

  const factory MapEvent.campusSelected(CampusModel campus) = CampusSelected;

  const factory MapEvent.floorSelected({
    required FloorModel floor,
    required CampusModel campus,
  }) = FloorSelected;

  const factory MapEvent.roomTapped(String roomId) = RoomTapped;
}
