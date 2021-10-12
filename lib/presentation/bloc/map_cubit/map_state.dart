part of 'map_cubit.dart';

abstract class MapState extends Equatable {
  const MapState({required this.floor});

  final int floor;

  @override
  List<Object> get props => [floor];
}

class MapFloorLoaded extends MapState {
  MapFloorLoaded({required this.floor}) : super(floor: floor) {
    MapCubit.currentFloor = floor;
  }

  final int floor;

  @override
  List<Object> get props => [floor];
}

class MapScaleSet extends MapState {
  const MapScaleSet({required this.floor, required this.scale})
      : super(floor: floor);

  final int floor;
  final double scale;

  @override
  List<Object> get props => [floor, scale];
}

class MapSearchFoundUpdated extends MapState {
  const MapSearchFoundUpdated({required this.floor, required this.foundRooms})
      : super(floor: floor);

  final int floor;
  final List<Map<String, dynamic>> foundRooms;

  @override
  List<Object> get props => [floor, foundRooms];
}
