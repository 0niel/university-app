import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/map/bloc/map_bloc.dart';
import 'package:rtu_mirea_app/map/data/map_data_repository.dart';
import 'package:rtu_mirea_app/map/services/objects_service.dart';

class _NoCache implements MapDataCache {
  @override
  Future<String?> read(String key) async => null;

  @override
  Future<void> write(String key, String value) async {}
}

class _MemoryCache implements MapDataCache {
  final _values = <String, String>{};

  @override
  Future<String?> read(String key) async => _values[key];

  @override
  Future<void> write(String key, String value) async => _values[key] = value;
}

Map<String, Object?> _document(
  int revision, {
  bool removeSecondFloor = false,
}) => {
  'id': 'campus',
  'short_title': 'В-78',
  'revision': revision,
  'floors': [
    for (final level in [1, if (!removeSecondFloor) 2])
      {
        'id': 'f$level',
        'level': level,
        'width': 100,
        'height': 100,
        'svg':
            '<svg viewBox="0 0 100 100"><rect data-object="room-$level" '
            'x="${revision * 10}" y="10" width="20" height="20" /></svg>',
      },
  ],
  'rooms': [
    for (final level in [1, if (!removeSecondFloor) 2])
      {'id': 'room-$level', 'floor_id': 'f$level', 'label': '$revision$level'},
  ],
};

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  for (final backgroundFails in [false, true]) {
    test(
      'forced refresh follows pending background (failure: $backgroundFails)',
      () async {
        final backgroundResponse = Completer<Object?>();
        final forcedResponse = Completer<Object?>();
        final forcedStarted = Completer<void>();
        var requests = 0;
        final repository = MapDataRepository(
          organizationId: 'mirea',
          cache: _MemoryCache(),
          rpc: (_, _) async {
            requests++;
            if (requests == 1) return _document(1);
            if (requests == 2) return backgroundResponse.future;
            forcedStarted.complete();
            return forcedResponse.future;
          },
        );
        addTearDown(repository.dispose);
        await repository.loadCampus('campus');
        expect(await repository.loadCachedCampus('campus'), isNotNull);
        final background = repository.refreshCampus('campus');
        expect(repository.refreshCampus('campus'), same(background));
        final forced = repository.refreshCampus('campus', afterPending: true);
        final concurrent = repository.loadCampus('campus');
        expect(concurrent, same(forced));
        expect(requests, 2);
        if (backgroundFails) {
          backgroundResponse.completeError(const MapDataException('offline'));
        } else {
          backgroundResponse.complete(_document(1));
        }
        expect((await background).revision, 1);
        await forcedStarted.future;
        expect(requests, 3);
        expect(repository.loadCampus('campus'), same(forced));
        expect(repository.refreshCampus('campus'), same(forced));
        forcedResponse.complete(_document(2));
        final snapshot = await forced;
        expect(await concurrent, same(snapshot));
        expect(await repository.loadCampus('campus'), same(snapshot));
        expect(snapshot.revision, 2);
        expect(requests, 3);
      },
    );
  }

  test(
    'reads join an ongoing refresh instead of returning the old snapshot',
    () async {
      final response = Completer<Object?>();
      var requests = 0;
      final repository = MapDataRepository(
        organizationId: 'mirea',
        cache: _NoCache(),
        rpc: (_, _) async => ++requests == 1 ? _document(1) : response.future,
      );
      addTearDown(repository.dispose);
      await repository.loadCampus('campus');
      final refreshed = repository.refreshCampus('campus');
      final concurrent = repository.loadCampus('campus');
      response.complete(_document(2));
      final snapshot = await refreshed;
      expect(await concurrent, same(snapshot));
      expect(snapshot.revision, 2);
      expect(requests, 2);
    },
  );

  for (final savedCache in [false, true]) {
    for (final removeSecondFloor in [false, true]) {
      test(
        removeSecondFloor
            ? 'removed floor uses refreshed data (cache: $savedCache)'
            : 'floor switch joins forced refresh (cache: $savedCache)',
        () async {
          var refresh = false;
          final requested = Completer<void>();
          final response = Completer<Object?>();
          final repository = MapDataRepository(
            organizationId: 'mirea',
            cache: savedCache ? _MemoryCache() : _NoCache(),
            rpc: (name, _) async {
              if (name == 'get_map_catalog') {
                return {
                  'campuses': [
                    {'id': 'campus', 'revision': refresh ? 2 : 1},
                  ],
                };
              }
              if (refresh) {
                if (!requested.isCompleted) requested.complete();
                return response.future;
              }
              return _document(1);
            },
          );
          addTearDown(repository.dispose);
          final bloc = MapBloc(
            availableCampuses: [],
            repository: repository,
            objectsService: ObjectsService(
              onLoadObjects: (_) async => '{"objects":[]}',
            ),
          );
          addTearDown(bloc.close);
          final initialized = bloc.stream.firstWhere(
            (state) => state.status == .loaded && state.roomFloors.length == 2,
          );
          bloc.add(const MapEvent.initialized());
          await initialized;
          final originalCampus = bloc.state.selectedCampus!;
          refresh = true;
          bloc.add(const MapEvent.refreshRequested());
          await requested.future;
          final settled = bloc.stream.firstWhere(
            (state) => state.status == .loaded || state.status == .failure,
          );
          bloc.add(
            MapEvent.floorSelected(
              campus: originalCampus,
              floor: originalCampus.floors.last,
            ),
          );
          await Future<void>.delayed(Duration.zero);
          response.complete(_document(2, removeSecondFloor: removeSecondFloor));
          final selected = await settled;
          expect(
            selected.status,
            MapStatus.loaded,
            reason: selected.errorMessage,
          );
          expect(selected.campusData?.revision, 2);
          expect(selected.selectedFloor?.id, removeSecondFloor ? 'f1' : 'f2');
          expect(selected.rooms.single.path.getBounds().left, 20);
          expect(selected.roomFloors.keys, isNot(contains('11')));
          expect(selected.roomFloors.keys, isNot(contains('12')));

          if (!removeSecondFloor) {
            final returned = bloc.stream.firstWhere(
              (state) =>
                  state.status == .failure ||
                  (state.status == .loaded && state.selectedFloor?.id == 'f1'),
            );
            bloc.add(
              MapEvent.floorSelected(
                campus: originalCampus,
                floor: originalCampus.floors.first,
              ),
            );
            final state = await returned;
            expect(state.status, MapStatus.loaded, reason: state.errorMessage);
            expect(state.campusData, same(selected.campusData));
            expect(state.rooms.single.path.getBounds().left, 20);
          }
        },
      );
    }
  }
}
