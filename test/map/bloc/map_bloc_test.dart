import 'dart:ui';

import 'package:bloc_test/bloc_test.dart';
import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/map/map.dart';

import 'mock_objects_service.dart';
import 'mock_svg_room_parser.dart';

void main() {
  group('MapBloc', () {
    late ObjectsService objectsService;
    late SvgRoomParser roomsParser;

    const firstFloor = FloorModel(
      id: 'c-1-floor1',
      number: 1,
      svgPath: 'assets/maps/c1_floor1.svg',
    );
    const secondFloor = FloorModel(
      id: 'c-1-floor2',
      number: 2,
      svgPath: 'assets/maps/c1_floor2.svg',
    );
    const campus = CampusModel(
      id: 'c-1',
      displayName: 'C-1',
      floors: [firstFloor, secondFloor],
    );
    const secondCampus = CampusModel(
      id: 'c-2',
      displayName: 'C-2',
      floors: [firstFloor],
    );
    const campusWithoutFloors = CampusModel(
      id: 'empty-campus',
      displayName: 'Empty',
      floors: [],
    );
    const boundingRect = Rect.fromLTWH(0, 0, 100, 100);

    setUp(() {
      objectsService = MockObjectsService();
      roomsParser = MockSvgRoomParser();
      when(
        () => objectsService.loadObjects(),
      ).thenAnswer((_) => Future.value());
      when(() => objectsService.getNameById(any())).thenReturn('A-101');
      when(() => roomsParser.parseSvg(any())).thenAnswer(
        (_) async => (
          [RoomModel(roomId: 'c1__r__101', path: Path())],
          boundingRect,
        ),
      );
    });

    MapBloc buildBloc({List<CampusModel>? availableCampuses}) => .new(
      availableCampuses: availableCampuses ?? [campus, secondCampus],
      objectsService: objectsService,
      roomsParser: roomsParser,
    );

    test('initial state is MapState with MapStatus.initial', () {
      expect(buildBloc().state, equals(const MapState()));
    });

    group('MapInitialized', () {
      blocTest<MapBloc, MapState>(
        'emits [loading, loaded] with the first campus and floor '
        'when loading succeeds',
        build: buildBloc,
        act: (bloc) => bloc.add(const MapEvent.initialized()),
        expect: () => [
          isA<MapState>()
              .having((s) => s.status, 'status', MapStatus.loading)
              .having((s) => s.availableCampuses, 'availableCampuses', [
                campus,
                secondCampus,
              ]),
          isA<MapState>()
              .having((s) => s.status, 'status', MapStatus.loaded)
              .having((s) => s.selectedCampus, 'selectedCampus', campus)
              .having((s) => s.selectedFloor, 'selectedFloor', firstFloor)
              .having(
                (s) => s.rooms.singleOrNull?.name,
                'resolved room name',
                'A-101',
              )
              .having((s) => s.boundingRect, 'boundingRect', boundingRect),
        ],
      );

      blocTest<MapBloc, MapState>(
        'emits [failure] when no campuses are available',
        build: () => buildBloc(availableCampuses: []),
        act: (bloc) => bloc.add(const MapEvent.initialized()),
        expect: () => [
          isA<MapState>().having(
            (s) => s.status,
            'status',
            MapStatus.failure,
          ),
        ],
      );

      blocTest<MapBloc, MapState>(
        'emits [loading, failure] when the first campus has no floors',
        build: () => buildBloc(availableCampuses: [campusWithoutFloors]),
        act: (bloc) => bloc.add(const MapEvent.initialized()),
        expect: () => [
          isA<MapState>().having(
            (state) => state.status,
            'status',
            MapStatus.loading,
          ),
          isA<MapState>().having(
            (state) => state.status,
            'status',
            MapStatus.failure,
          ),
        ],
        errors: () => [isA<FormatException>()],
      );

      blocTest<MapBloc, MapState>(
        'emits [loading, failure] when loadObjects throws',
        setUp: () => when(
          () => objectsService.loadObjects(),
        ).thenThrow(Exception('no manifest')),
        build: buildBloc,
        act: (bloc) => bloc.add(const MapEvent.initialized()),
        expect: () => [
          isA<MapState>().having(
            (s) => s.status,
            'status',
            MapStatus.loading,
          ),
          isA<MapState>()
              .having((s) => s.status, 'status', MapStatus.failure)
              .having((s) => s.errorMessage, 'errorMessage', isNotNull),
        ],
        errors: () => [isA<Exception>()],
      );
    });

    group('CampusSelected', () {
      blocTest<MapBloc, MapState>(
        'does not reload the selected campus',
        build: buildBloc,
        seed: () => const MapState(
          status: .loaded,
          selectedCampus: campus,
          selectedFloor: firstFloor,
        ),
        act: (bloc) => bloc.add(const MapEvent.campusSelected(campus)),
        expect: () => const <MapState>[],
        verify: (_) => verifyNever(() => roomsParser.parseSvg(any())),
      );

      blocTest<MapBloc, MapState>(
        'emits [loading, loaded] with the campus first floor '
        'when parsing succeeds',
        build: buildBloc,
        act: (bloc) => bloc.add(const MapEvent.campusSelected(secondCampus)),
        expect: () => [
          isA<MapState>().having(
            (s) => s.status,
            'status',
            MapStatus.loading,
          ),
          isA<MapState>()
              .having((s) => s.status, 'status', MapStatus.loaded)
              .having(
                (s) => s.selectedCampus,
                'selectedCampus',
                secondCampus,
              )
              .having((s) => s.selectedFloor, 'selectedFloor', firstFloor),
        ],
      );

      blocTest<MapBloc, MapState>(
        'emits [loading, failure] when parseSvg throws',
        setUp: () => when(
          () => roomsParser.parseSvg(any()),
        ).thenThrow(Exception('bad svg')),
        build: buildBloc,
        act: (bloc) => bloc.add(const MapEvent.campusSelected(secondCampus)),
        expect: () => [
          isA<MapState>().having(
            (s) => s.status,
            'status',
            MapStatus.loading,
          ),
          isA<MapState>().having(
            (s) => s.status,
            'status',
            MapStatus.failure,
          ),
        ],
        errors: () => [isA<Exception>()],
      );
    });

    group('FloorSelected', () {
      blocTest<MapBloc, MapState>(
        'does not reload the selected floor',
        build: buildBloc,
        seed: () => const MapState(
          status: .loaded,
          selectedCampus: campus,
          selectedFloor: firstFloor,
        ),
        act: (bloc) => bloc.add(
          const MapEvent.floorSelected(floor: firstFloor, campus: campus),
        ),
        expect: () => const <MapState>[],
        verify: (_) => verifyNever(() => roomsParser.parseSvg(any())),
      );

      blocTest<MapBloc, MapState>(
        'emits [loading, loaded] with the selected floor '
        'when parsing succeeds',
        build: buildBloc,
        act: (bloc) => bloc.add(
          const MapEvent.floorSelected(floor: secondFloor, campus: campus),
        ),
        expect: () => [
          isA<MapState>().having(
            (s) => s.status,
            'status',
            MapStatus.loading,
          ),
          isA<MapState>()
              .having((s) => s.status, 'status', MapStatus.loaded)
              .having((s) => s.selectedCampus, 'selectedCampus', campus)
              .having((s) => s.selectedFloor, 'selectedFloor', secondFloor),
        ],
      );

      blocTest<MapBloc, MapState>(
        'emits [loading, failure] when parseSvg throws',
        setUp: () => when(
          () => roomsParser.parseSvg(any()),
        ).thenThrow(Exception('bad svg')),
        build: buildBloc,
        act: (bloc) => bloc.add(
          const MapEvent.floorSelected(floor: secondFloor, campus: campus),
        ),
        expect: () => [
          isA<MapState>().having(
            (s) => s.status,
            'status',
            MapStatus.loading,
          ),
          isA<MapState>().having(
            (s) => s.status,
            'status',
            MapStatus.failure,
          ),
        ],
        errors: () => [isA<Exception>()],
      );
    });

    group('RoomTapped', () {
      blocTest<MapBloc, MapState>(
        'toggles room selection when the map is loaded',
        build: buildBloc,
        seed: () => MapState(
          status: .loaded,
          selectedCampus: campus,
          selectedFloor: firstFloor,
          rooms: [RoomModel(roomId: 'c1__r__101', path: Path())],
        ),
        act: (bloc) => bloc.add(const MapEvent.roomTapped('c1__r__101')),
        expect: () => [
          isA<MapState>().having(
            (s) => s.rooms.singleOrNull?.isSelected,
            'room isSelected',
            isTrue,
          ),
        ],
      );

      blocTest<MapBloc, MapState>(
        'does nothing when the map is not loaded',
        build: buildBloc,
        act: (bloc) => bloc.add(const MapEvent.roomTapped('c1__r__101')),
        expect: () => <MapState>[],
      );
    });
  });
}
