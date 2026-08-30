import 'package:bloc_test/bloc_test.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/free_rooms/free_rooms.dart';

class MockCampusRepository extends Mock implements CampusRepository {}

void main() {
  group('FreeRoomsCubit', () {
    late CampusRepository campusRepository;

    const roomA = FreeRoom(room: 'А-101', campus: 'mp1');
    const roomB = FreeRoom(room: 'Б-202', campus: 'mp1');
    late List<FreeRoom> rooms;

    setUp(() {
      campusRepository = MockCampusRepository();
      rooms = const [roomA, roomB];
      when(
        () => campusRepository.getFreeRooms(),
      ).thenAnswer((_) async => rooms);
    });

    FreeRoomsCubit buildCubit() =>
        FreeRoomsCubit(campusRepository: campusRepository);

    test('initial state is FreeRoomsState with FreeRoomsStatus.initial', () {
      expect(buildCubit().state, equals(const FreeRoomsState()));
    });

    group('load', () {
      blocTest<FreeRoomsCubit, FreeRoomsState>(
        'emits [loading, populated] when getFreeRooms succeeds',
        build: buildCubit,
        act: (cubit) => cubit.load(),
        expect: () => const <FreeRoomsState>[
          FreeRoomsState(status: FreeRoomsStatus.loading),
          FreeRoomsState(
            status: FreeRoomsStatus.populated,
            rooms: [roomA, roomB],
          ),
        ],
        verify: (_) {
          verify(() => campusRepository.getFreeRooms()).called(1);
        },
      );

      blocTest<FreeRoomsCubit, FreeRoomsState>(
        'emits [loading, failure] and keeps cached rooms when getFreeRooms '
        'throws',
        setUp: () => when(
          () => campusRepository.getFreeRooms(),
        ).thenThrow(Exception('network')),
        build: buildCubit,
        seed: () => const FreeRoomsState(rooms: [roomA]),
        act: (cubit) => cubit.load(),
        expect: () => const <FreeRoomsState>[
          FreeRoomsState(
            status: FreeRoomsStatus.loading,
            rooms: [roomA],
          ),
          FreeRoomsState(
            status: FreeRoomsStatus.failure,
            rooms: [roomA],
          ),
        ],
        errors: () => [isA<Exception>()],
      );
    });

    group('buildingChanged', () {
      blocTest<FreeRoomsCubit, FreeRoomsState>(
        'emits the new building filter',
        build: buildCubit,
        act: (cubit) => cubit.buildingChanged('А'),
        expect: () => const <FreeRoomsState>[FreeRoomsState(building: 'А')],
      );
    });

    group('getters', () {
      test('filteredRooms returns all rooms when building is "all"', () {
        const state = FreeRoomsState(rooms: [roomA, roomB]);
        expect(state.filteredRooms, equals(const [roomA, roomB]));
      });

      test('filteredRooms keeps only rooms in the active building', () {
        const state = FreeRoomsState(rooms: [roomA, roomB], building: 'А');
        expect(state.filteredRooms, equals(const [roomA]));
      });

      test('buildings returns distinct, sorted building codes', () {
        const state = FreeRoomsState(rooms: [roomB, roomA, roomA]);
        expect(state.buildings, equals(const ['А', 'Б']));
      });
    });
  });
}
