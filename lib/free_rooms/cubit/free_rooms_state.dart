part of 'free_rooms_cubit.dart';

@freezed
abstract class FreeRoomsState with _$FreeRoomsState {
  const factory FreeRoomsState({
    @Default(FreeRoomsStatus.initial) FreeRoomsStatus status,
    @Default(<FreeRoom>[]) List<FreeRoom> rooms,
    @Default('all') String building,
  }) = _FreeRoomsState;

  const FreeRoomsState._();

  List<FreeRoom> get filteredRooms => [
    for (final room in rooms)
      if (building == 'all' || room.building == building) room,
  ];

  List<String> get buildings {
    final set = <String>{};
    for (final room in rooms) {
      if (room.building.isNotEmpty) set.add(room.building);
    }
    final list = set.toList()..sort();
    return list.take(7).toList();
  }
}
