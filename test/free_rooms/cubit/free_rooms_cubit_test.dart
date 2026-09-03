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
    const roomB = FreeRoom(room: 'Б-202', campus: 'v78');
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

    group('campusChanged', () {
      blocTest<FreeRoomsCubit, FreeRoomsState>(
        'emits the new campus filter',
        build: buildCubit,
        act: (cubit) => cubit.campusChanged('mp1'),
        expect: () => const <FreeRoomsState>[FreeRoomsState(campus: 'mp1')],
      );
    });

    group('getters', () {
      test('filtered returns all rooms when no campus is selected', () {
        const state = FreeRoomsState(rooms: [roomA, roomB]);
        expect(state.filtered({}), equals(const [roomA, roomB]));
      });

      test('filtered keeps only rooms in the active campus', () {
        const state = FreeRoomsState(rooms: [roomA, roomB], campus: 'mp1');
        expect(state.filtered({}), equals(const [roomA]));
      });

      test('campuses returns distinct sorted campus codes', () {
        const state = FreeRoomsState(rooms: [roomB, roomA, roomA]);
        expect(state.campuses, equals(const ['mp1', 'v78']));
      });
    });
  });
}
