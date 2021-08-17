part of 'map_cubit.dart';

abstract class MapState extends Equatable {
  const MapState({required this.floor});

  final int floor;

  @override
  List<Object> get props => [floor];
}

class MapFloorLoaded extends MapState {
  MapFloorLoaded({required this.floor}) : super(floor: floor);

  final int floor;

  @override
  List<Object> get props => [floor];
}

class MapSearchFoundUpdated extends MapState {
  MapSearchFoundUpdated({required this.floor, required this.foundRooms})
      : super(floor: floor);

  final int floor;
  final List<Map<String, dynamic>> foundRooms;

  @override
  List<Object> get props => [floor, foundRooms];
}
