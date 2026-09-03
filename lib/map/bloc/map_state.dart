part of 'map_bloc.dart';

@freezed
abstract class MapState with _$MapState {
  const factory MapState({
    @Default(MapStatus.initial) MapStatus status,
    @Default(<CampusModel>[]) List<CampusModel> availableCampuses,
    CampusModel? selectedCampus,
    FloorModel? selectedFloor,
    @Default(<RoomModel>[]) List<RoomModel> rooms,
    @Default(<String, int>{}) Map<String, int> roomFloors,
    Rect? boundingRect,
    String? errorMessage,
  }) = _MapState;
}
