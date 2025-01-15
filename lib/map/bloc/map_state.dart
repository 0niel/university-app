import 'package:equatable/equatable.dart';
import 'package:rtu_mirea_app/map/map.dart';

abstract class MapState extends Equatable {
  const MapState();

  @override
  List<Object?> get props => [];
}

class MapInitial extends MapState {}

class MapLoading extends MapState {}

class MapLoaded extends MapState {
  final CampusModel selectedCampus;
  final FloorModel selectedFloor;
  final List<RoomModel> rooms;

  const MapLoaded({
    required this.selectedCampus,
    required this.selectedFloor,
    required this.rooms,
  });

  @override
  List<Object?> get props => [selectedCampus, selectedFloor, rooms];
}

class MapError extends MapState {
  final String message;

  const MapError(this.message);

  @override
  List<Object?> get props => [message];
}
