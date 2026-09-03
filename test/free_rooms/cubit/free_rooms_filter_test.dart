import 'dart:async';

import 'package:campus_repository/campus_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/free_rooms/cubit/free_rooms_cubit.dart';
import 'package:rtu_mirea_app/free_rooms/cubit/free_rooms_filter.dart';

class _Repository extends Mock implements CampusRepository {}

void main() {
  test(
    'campus aliases match without guessing the building from room numbers',
    () {
      const rooms = [
        FreeRoom(room: 'А-999', campus: 'mp1'),
        FreeRoom(room: 'Б-101', campus: 'v78'),
        FreeRoom(room: 'В-101'),
      ];
      expect(filterFreeRooms(rooms, campus: 'МП-1'), [rooms.first]);
      expect(filterFreeRooms(rooms, campus: 'В-78'), [rooms[1]]);
    },
  );

  test('floor filters use only authored room index', () {
    const rooms = [
      FreeRoom(room: 'А-999', campus: 'mp1'),
      FreeRoom(room: 'Б-201', campus: 'mp1'),
    ];
    expect(
      filterFreeRooms(
        rooms,
        campus: 'mp1',
        floor: 2,
        roomFloors: {'А999': 2},
      ),
      [rooms.first],
    );
  });

  test('query is normalized and never inferred as a floor', () {
    const room = FreeRoom(room: 'А-999', campus: 'mp1');
    expect(filterFreeRooms([room], query: 'а 999'), [room]);
    expect(filterFreeRooms([room], query: '2 этаж'), isEmpty);
  });

  test('latest refresh wins over a stale response', () async {
    final repository = _Repository();
    final first = Completer<List<FreeRoom>>();
    final second = Completer<List<FreeRoom>>();
    var calls = 0;
    when(
      repository.getFreeRooms,
    ).thenAnswer((_) => calls++ == 0 ? first.future : second.future);
    final cubit = FreeRoomsCubit(campusRepository: repository);
    addTearDown(cubit.close);
    final oldLoad = cubit.load();
    final newLoad = cubit.load();
    const room = FreeRoom(room: 'А-1');
    second.complete([room]);
    await newLoad;
    first.complete([]);
    await oldLoad;
    expect(cubit.state.rooms, [room]);
  });

  test('closing during refresh is safe', () async {
    final repository = _Repository();
    final pending = Completer<List<FreeRoom>>();
    when(repository.getFreeRooms).thenAnswer((_) => pending.future);
    final cubit = FreeRoomsCubit(campusRepository: repository);
    final load = cubit.load();
    await cubit.close();
    pending.complete([]);
    await expectLater(load, completes);
  });
}
