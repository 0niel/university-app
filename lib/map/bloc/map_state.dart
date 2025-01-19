import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:rtu_mirea_app/map/map.dart';

abstract class MapState extends Equatable {
  const MapState();

  @override
  List<Object?> get props => [];
}

class MapInitial extends MapState {
  const MapInitial();

  MapInitial copyWith() {
    return const MapInitial();
  }
}

class MapLoading extends MapState {
  const MapLoading();

  MapLoading copyWith() {
    return const MapLoading();
  }
}

class MapLoaded extends MapState {
  final CampusModel selectedCampus;
  final FloorModel selectedFloor;
  final List<RoomModel> rooms;
  final Rect? boundingRect;

  const MapLoaded({
    required this.selectedCampus,
    required this.selectedFloor,
    required this.rooms,
    this.boundingRect,
  });

  MapLoaded copyWith({
    CampusModel? selectedCampus,
    FloorModel? selectedFloor,
    List<RoomModel>? rooms,
    Rect? boundingRect,
  }) {
    return MapLoaded(
      selectedCampus: selectedCampus ?? this.selectedCampus,
      selectedFloor: selectedFloor ?? this.selectedFloor,
      rooms: rooms ?? this.rooms,
      boundingRect: boundingRect ?? this.boundingRect,
    );
  }

  @override
  List<Object?> get props => [selectedCampus, selectedFloor, rooms, boundingRect];
}

class MapError extends MapState {
  final String message;

  const MapError(this.message);

  MapError copyWith({String? message}) {
    return MapError(message ?? this.message);
  }

  @override
  List<Object?> get props => [message];
}
