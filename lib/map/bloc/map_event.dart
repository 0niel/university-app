import 'package:equatable/equatable.dart';
import 'package:rtu_mirea_app/map/models/models.dart';

abstract class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object?> get props => [];
}

class MapInitialized extends MapEvent {}

class CampusSelected extends MapEvent {
  final CampusModel selectedCampus;

  const CampusSelected(this.selectedCampus);

  @override
  List<Object?> get props => [selectedCampus];
}

class FloorSelected extends MapEvent {
  final FloorModel selectedFloor;
  final CampusModel selectedCampus;

  const FloorSelected(this.selectedFloor, this.selectedCampus);

  @override
  List<Object?> get props => [selectedFloor];
}

class RoomTapped extends MapEvent {
  final String roomId;

  const RoomTapped(this.roomId);

  @override
  List<Object?> get props => [roomId];
}
