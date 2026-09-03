part of 'free_rooms_cubit.dart';

@freezed
abstract class FreeRoomsState with _$FreeRoomsState {
  const factory FreeRoomsState({
    @Default(FreeRoomsStatus.initial) FreeRoomsStatus status,
    @Default(<FreeRoom>[]) List<FreeRoom> rooms,
    @Default('') String campus,
    int? floor,
    @Default('') String query,
  }) = _FreeRoomsState;

  const FreeRoomsState._();

  List<FreeRoom> campusRooms(Map<String, int> roomFloors) =>
      filterFreeRooms(rooms, campus: campus, roomFloors: roomFloors);

  List<FreeRoom> filtered(Map<String, int> roomFloors) => filterFreeRooms(
    rooms,
    campus: campus,
    floor: floor,
    query: query,
    roomFloors: roomFloors,
  );

  List<String> get campuses {
    final set = <String>{};
    for (final room in rooms) {
      final campus = room.campus;
      if (campus != null && campus.isNotEmpty) set.add(campus);
    }
    return set.toList()..sort();
  }
}
