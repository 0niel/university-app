import 'package:campus_repository/campus_repository.dart';
import 'package:rtu_mirea_app/map/services/room_key.dart';

bool freeRoomMatchesCampus(
  FreeRoom room,
  String campus,
  Map<String, int> roomFloors,
) {
  if (campus.isEmpty) return true;
  final roomCampus = room.campus;
  if (roomCampus == null || roomCampus.isEmpty) {
    return false;
  }
  return campusKey(roomCampus) == campusKey(campus);
}

String campusKey(String campus) => switch (roomKey(campus)) {
  'V78' || 'В78' => 'v78',
  'S20' || 'С20' => 's20',
  'MP1' || 'МП1' => 'mp1',
  final value => value,
};

List<FreeRoom> filterFreeRooms(
  List<FreeRoom> rooms, {
  String campus = '',
  int? floor,
  String query = '',
  Map<String, int> roomFloors = const {},
}) {
  final queryKey = roomKey(query);
  final queryLower = query.trim().toLowerCase();
  return [
    for (final room in rooms)
      if (freeRoomMatchesCampus(room, campus, roomFloors) &&
          (floor == null || roomFloors[roomKey(room.room)] == floor) &&
          (queryKey.isEmpty ||
              roomKey(room.room).contains(queryKey) ||
              room.room.toLowerCase().contains(queryLower)))
        room,
  ];
}
